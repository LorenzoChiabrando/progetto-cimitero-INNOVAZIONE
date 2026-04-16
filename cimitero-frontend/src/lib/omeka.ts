const INTERNAL_API_URL =
    process.env.OMEKA_INTERNAL_API_URL ||
    process.env.NEXT_PUBLIC_OMEKA_API_URL ||
    "http://localhost:8080/api";

const PUBLIC_OMEKA_URL =
    process.env.NEXT_PUBLIC_OMEKA_PUBLIC_URL ||
    INTERNAL_API_URL.replace(/\/api\/?$/, "");

const KEY_ID = process.env.OMEKA_KEY_ID || "";
const KEY_SECRET = process.env.OMEKA_KEY_SECRET || "";

export interface OmekaMedia {
    id: number | string;
    title: string;
    mimeType: string;
    isDocument: boolean;
    originalUrl: string;
    thumbnailUrl: string | null;
    squareUrl: string | null;
}

export interface OmekaItem {
    id: number | string;
    title: string;
    description: string;
    creator: string;
    date: string;
    imageUrl: string | null;
    itemSet: string;
    isDocument: boolean;
    media: OmekaMedia[];
    isCollectionEntity: boolean;
}

type OmekaValueObject = {
    "@value"?: string;
    "@literal"?: string;
};

type OmekaGenericObject = {
    "@value"?: unknown;
    "@literal"?: unknown;
    [key: string]: unknown;
};

type OmekaItemSetRef = {
    "o:id"?: number | string;
};

type OmekaThumbnailUrls = {
    large?: string;
    square?: string;
};

type OmekaItemSetApi = {
    "o:id"?: number | string;
    "o:title"?: string;
};

type OmekaMediaApi = {
    "o:id"?: number | string;
    "o:title"?: string;
    "o:media_type"?: string;
    "o:original_url"?: string;
    thumbnail_display_urls?: OmekaThumbnailUrls;
};

type OmekaItemApi = {
    "o:id"?: number | string;
    "o:title"?: string;
    "o:item_set"?: OmekaItemSetRef[];
    "o:created"?: string | OmekaValueObject[] | OmekaGenericObject;
    "dcterms:description"?: string | OmekaValueObject[] | OmekaGenericObject;
    "dcterms:creator"?: string | OmekaValueObject[] | OmekaGenericObject;
    "dcterms:date"?: string | OmekaValueObject[] | OmekaGenericObject;
    thumbnail_display_urls?: OmekaThumbnailUrls;
};

const COLLECTION_ENTITIES = [
    "map",
    "funeral architecture",
    "historical figures",
    "places of remembrance",
    "architectural tour"
];

const normalizePublicUrl = (url: string | null | undefined): string | null => {
    if (!url) return null;

    try {
        const parsed = new URL(url);
        const publicBase = new URL(PUBLIC_OMEKA_URL);

        parsed.protocol = publicBase.protocol;
        parsed.host = publicBase.host;

        return parsed.toString();
    } catch {
        if (url.startsWith("/")) {
            return `${PUBLIC_OMEKA_URL}${url}`;
        }
        return url;
    }
};

const extractValue = (
    field: string | OmekaValueObject[] | OmekaGenericObject | undefined
): string => {
    if (!field) return "";

    if (typeof field === "string") return field;

    if (Array.isArray(field)) {
        if (field.length === 0) return "";
        const first = field[0];
        if (typeof first?.["@value"] === "string") return first["@value"];
        if (typeof first?.["@literal"] === "string") return first["@literal"];
        return "";
    }

    if (typeof field === "object") {
        if (typeof field["@value"] === "string") return field["@value"];
        if (typeof field["@literal"] === "string") return field["@literal"];
    }

    return "";
};

const normalizeDate = (
    ...values: Array<string | OmekaValueObject[] | OmekaGenericObject | undefined>
): string => {
    for (const value of values) {
        const extracted = extractValue(value);
        if (typeof extracted === "string" && extracted.trim() !== "") {
            return extracted.trim();
        }
    }
    return "Unknown Date";
};

const buildAuthenticatedUrl = (path: string): string => {
    const url = new URL(path, `${INTERNAL_API_URL}/`);
    if (KEY_ID) url.searchParams.set("key_identity", KEY_ID);
    if (KEY_SECRET) url.searchParams.set("key_credential", KEY_SECRET);
    return url.toString();
};

const fetchOmekaJson = async <T>(path: string): Promise<T> => {
    const url = buildAuthenticatedUrl(path);

    const res = await fetch(url, {
        cache: "no-store",
        headers: {
            Accept: "application/json, application/ld+json",
        },
    });

    if (!res.ok) {
        const text = await res.text();
        throw new Error(`Omeka HTTP ${res.status} for ${url}: ${text.slice(0, 200)}`);
    }

    const text = await res.text();
    const trimmed = text.trim();

    const contentType = (res.headers.get("content-type") || "").toLowerCase();
    const looksLikeJson = trimmed.startsWith("{") || trimmed.startsWith("[");
    const isJsonContentType =
        contentType.includes("application/json") ||
        contentType.includes("application/ld+json");

    if (!isJsonContentType && !looksLikeJson) {
        throw new Error(`Omeka returned non-JSON for ${url}: ${text.slice(0, 200)}`);
    }

    try {
        return JSON.parse(text) as T;
    } catch {
        throw new Error(`Failed to parse Omeka JSON for ${url}: ${text.slice(0, 200)}`);
    }
};

export async function getOmekaItems(): Promise<OmekaItem[]> {
    try {
        const [rawData, setsData] = await Promise.all([
            fetchOmekaJson<OmekaItemApi[]>("items"),
            fetchOmekaJson<OmekaItemSetApi[]>("item_sets"),
        ]);

        const itemSetsMap: Record<string, string> = {};
        setsData.forEach((s) => {
            const id = s["o:id"];
            if (id !== undefined) {
                itemSetsMap[String(id)] = s["o:title"] || "Unnamed Collection";
            }
        });

        return rawData.map((item): OmekaItem => {
            const rawThumb = item.thumbnail_display_urls?.large || null;
            const thumbUrl = normalizePublicUrl(rawThumb);

            let collectionName = "Uncategorized";
            if (item["o:item_set"] && item["o:item_set"].length > 0) {
                const setId = item["o:item_set"][0]?.["o:id"];
                if (setId !== undefined) {
                    collectionName = itemSetsMap[String(setId)] || "Collection";
                }
            }

            const title = item["o:title"] || "Untitled Archive Item";
            const isCollection = COLLECTION_ENTITIES.includes(title.toLowerCase().trim());

            return {
                id: item["o:id"] || "unknown",
                title,
                description:
                    extractValue(item["dcterms:description"]) ||
                    "No description available for this historical record.",
                creator: extractValue(item["dcterms:creator"]) || "Unknown Creator",
                date: normalizeDate(item["dcterms:date"], item["o:created"]),
                imageUrl: thumbUrl,
                itemSet: collectionName,
                isDocument: !thumbUrl,
                media: [],
                isCollectionEntity: isCollection,
            };
        });
    } catch (error) {
        console.error("Connection error to Omeka S:", error);
        return [];
    }
}

export async function getOmekaItem(id: string | number): Promise<OmekaItem | null> {
    try {
        const [item, mediaData, setsData] = await Promise.all([
            fetchOmekaJson<OmekaItemApi>(`items/${id}`),
            fetchOmekaJson<OmekaMediaApi[]>(`media?item_id=${id}`),
            fetchOmekaJson<OmekaItemSetApi[]>("item_sets"),
        ]);

        const itemSetsMap: Record<string, string> = {};
        setsData.forEach((s) => {
            const setId = s["o:id"];
            if (setId !== undefined) {
                itemSetsMap[String(setId)] = s["o:title"] || "Unnamed Collection";
            }
        });

        const rawThumb = item.thumbnail_display_urls?.large || null;
        const thumbUrl = normalizePublicUrl(rawThumb);

        const mappedMedia: OmekaMedia[] = mediaData.map((m) => {
            const mimeType = m["o:media_type"] || "unknown";
            return {
                id: m["o:id"] || "unknown",
                title: m["o:title"] || "Media File",
                mimeType,
                isDocument: !mimeType.startsWith("image/"),
                originalUrl: normalizePublicUrl(m["o:original_url"]) || "",
                thumbnailUrl: normalizePublicUrl(m.thumbnail_display_urls?.large) || null,
                squareUrl: normalizePublicUrl(m.thumbnail_display_urls?.square) || null,
            };
        });

        let collectionName = "Uncategorized";
        if (item["o:item_set"] && item["o:item_set"].length > 0) {
            const setId = item["o:item_set"][0]?.["o:id"];
            if (setId !== undefined) {
                collectionName = itemSetsMap[String(setId)] || "Collection";
            }
        }

        const title = item["o:title"] || "Untitled Archive Item";
        const isCollection = COLLECTION_ENTITIES.includes(title.toLowerCase().trim());

        return {
            id: item["o:id"] || "unknown",
            title,
            description:
                extractValue(item["dcterms:description"]) ||
                "No description available for this historical record.",
            creator: extractValue(item["dcterms:creator"]) || "Unknown Creator",
            date: normalizeDate(item["dcterms:date"], item["o:created"]),
            imageUrl: thumbUrl,
            itemSet: collectionName,
            isDocument: !thumbUrl,
            media: mappedMedia,
            isCollectionEntity: isCollection,
        };
    } catch (error) {
        console.error(`Connection error fetching item ${id}:`, error);
        return null;
    }
}

export const getCollectionStyle = (collection: string) => {
    const name = collection.toLowerCase();
    if (name.includes("historical")) return "bg-blue-50/80 text-blue-700 border-blue-200/60";
    if (name.includes("architecture")) return "bg-amber-50/80 text-amber-700 border-amber-200/60";
    if (name.includes("remembrance")) return "bg-rose-50/80 text-rose-700 border-rose-200/60";
    if (name.includes("tour")) return "bg-emerald-50/80 text-emerald-700 border-emerald-200/60";
    return "bg-[#6a306c]/5 text-[#6a306c] border-[#6a306c]/20";
};