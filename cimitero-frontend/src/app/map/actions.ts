// src/app/map/actions.ts
"use server";

import { getOmekaItems } from "@/src/lib/omeka";

// Helper function synced EXACTLY with the archive detail page logic
function extractMapId(description: string | null | undefined): string | null {
    if (!description) return null;

    const locationRegex = /Location:\s*(.*)/i;
    const match = description.match(locationRegex);

    if (match) {
        let locationText = match[1].trim();

        // Strip out any accidental HTML tags Omeka might have sent (e.g. "102</p>" -> "102")
        locationText = locationText.replace(/<\/?[^>]+(>|$)/g, "");

        const externalMatch = locationText.match(/(external[a-zA-Z0-9\-]*)/i);
        if (externalMatch) {
            return externalMatch[1];
        } else {
            const numberMatches = locationText.match(/\d+[a-zA-Z0-9\-]*/g);
            if (numberMatches && numberMatches.length > 0) {
                const rawId = numberMatches[numberMatches.length - 1];
                return rawId.replace(/^0+(?=\d)/, '');
            }
        }
    }
    return null;
}

export async function getItemsByArea(areaId: string) {
    if (!areaId) return [];

    try {
        const allItems = await getOmekaItems();

        const filteredItems = allItems.filter((item: any) => {
            const extractedId = extractMapId(item.description);
            // Log for deep debugging if needed (uncomment to see every ID extraction)
            // console.log(`Item: ${item.title} -> Extracted ID: ${extractedId} | Looking for: ${areaId}`);

            return extractedId === String(areaId);
        });

        console.log(`[Map Search] Area: ${areaId} | Found ${filteredItems.length} items (Total fetched: ${allItems.length})`);

        return filteredItems;
    } catch (error) {
        console.error("Error fetching items for map:", error);
        return [];
    }
}