// src/app/archive/[id]/page.tsx
import React from 'react';
import Link from 'next/link';
import Image from 'next/image';
import { notFound } from 'next/navigation';
import { Header } from '@/src/components/layout/Header';
import {
    getOmekaItem,
    getOmekaItems,
    getCollectionStyle,
    type OmekaItem
} from '@/src/lib/omeka';
import {
    Calendar,
    User,
    FileText,
    Info,
    ArrowRight,
    Map as MapIcon,
    Landmark,
    Users,
    Flame,
    Route,
    FolderOpen
} from 'lucide-react';
import { MediaGallery } from './MediaGallery';
import MapSection from './MapSection';

interface DetailPageProps {
    params: Promise<{ id: string }> | { id: string };
}

const getCollectionIconName = (title: string): 'map' | 'architecture' | 'figures' | 'remembrance' | 'tour' | 'default' => {
    if (!title) return 'default';
    const t = title.toLowerCase();
    if (t.includes('map')) return 'map';
    if (t.includes('architecture')) return 'architecture';
    if (t.includes('figures')) return 'figures';
    if (t.includes('remembrance')) return 'remembrance';
    if (t.includes('tour')) return 'tour';
    return 'default';
};

const renderCollectionIcon = (title: string, className: string) => {
    const iconName = getCollectionIconName(title);

    switch (iconName) {
        case 'map':
            return <MapIcon className={className} />;
        case 'architecture':
            return <Landmark className={className} />;
        case 'figures':
            return <Users className={className} />;
        case 'remembrance':
            return <Flame className={className} />;
        case 'tour':
            return <Route className={className} />;
        default:
            return <FolderOpen className={className} />;
    }
};

const normalizeDisplayDate = (value: unknown): string => {
    if (typeof value !== 'string') return 'Unknown Date';
    const trimmed = value.trim();
    if (!trimmed) return 'Unknown Date';
    return trimmed.length >= 10 ? trimmed.slice(0, 10) : trimmed;
};

export default async function ItemDetailPage({ params }: DetailPageProps) {
    const resolvedParams = await params;

    const [item, allItems] = await Promise.all([
        getOmekaItem(resolvedParams.id),
        getOmekaItems()
    ]);

    if (!item) {
        notFound();
    }

    const childItems: OmekaItem[] = item.isCollectionEntity
        ? allItems.filter(
            (i: OmekaItem) =>
                i.itemSet.toLowerCase() === item.title.toLowerCase() &&
                String(i.id) !== String(item.id)
        )
        : [];

    const parentCollection: OmekaItem | null =
        !item.isCollectionEntity && item.itemSet && item.itemSet !== 'Uncategorized'
            ? allItems.find(
            (i: OmekaItem) =>
                i.isCollectionEntity &&
                i.title.toLowerCase() === item.itemSet.toLowerCase()
        ) || null
            : null;

    let displayDescription = item.description || '';
    let locationText: string | null = null;
    let mapIdToSelect: string | null = null;

    const locationRegex = /Location:\s*(.*)/i;
    const match = displayDescription.match(locationRegex);

    if (match) {
        locationText = match[1].trim();
        displayDescription = displayDescription.replace(locationRegex, '').trim();

        const externalMatch = locationText.match(/(external[a-zA-Z0-9\-]*)/i);

        if (externalMatch) {
            mapIdToSelect = externalMatch[1];
        } else {
            const numberMatches = locationText.match(/\d+[a-zA-Z0-9\-]*/g);

            if (numberMatches && numberMatches.length > 0) {
                const rawId = numberMatches[numberMatches.length - 1];
                mapIdToSelect = rawId.replace(/^0+(?=\d)/, '');
            }
        }
    }

    const displayDate = normalizeDisplayDate(item.date);

    return (
        <div className="flex flex-col min-h-screen bg-[#fdfcfaf0]">
            <Header />

            <main className="flex-grow w-full max-w-[1500px] mx-auto px-6 md:px-8 pt-32 pb-24">
                <div className="bg-white rounded-[2.5rem] shadow-[0_8px_40px_rgb(0,0,0,0.03)] border border-gray-100 overflow-hidden flex flex-col xl:flex-row min-h-[600px] mb-8">
                    <div className="w-full xl:w-1/2 flex flex-col justify-start bg-gray-50/50">
                        <div className="w-full h-fit">
                            <MediaGallery
                                media={item.media}
                                fallbackTitle={item.title}
                                isCollectionEntity={item.isCollectionEntity}
                            />
                        </div>
                    </div>

                    <div className="w-full xl:w-1/2 p-10 lg:p-16 flex flex-col">
                        <div className="flex flex-wrap items-center gap-3 mb-6">
                            {item.isCollectionEntity && (
                                <span className="inline-flex w-fit px-3 py-1.5 rounded-lg bg-[#d4af37] text-white text-[10px] font-bold uppercase tracking-[0.2em] shadow-sm">
                  Thematic Collection
                </span>
                            )}

                            {item.itemSet && !item.isCollectionEntity && (
                                parentCollection ? (
                                    <Link
                                        href={`/archive/${parentCollection.id}`}
                                        className={`inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-[10px] font-bold uppercase tracking-[0.2em] border shadow-sm hover:shadow-md hover:-translate-y-0.5 transition-all cursor-pointer ${getCollectionStyle(item.itemSet)}`}
                                        title="View full collection"
                                    >
                                        {renderCollectionIcon(item.itemSet, 'h-3.5 w-3.5 shrink-0')}
                                        {item.itemSet}
                                    </Link>
                                ) : (
                                    <span
                                        className={`inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-[10px] font-bold uppercase tracking-[0.2em] border ${getCollectionStyle(item.itemSet)}`}
                                    >
                    {renderCollectionIcon(item.itemSet, 'h-3.5 w-3.5 shrink-0')}
                                        {item.itemSet}
                  </span>
                                )
                            )}
                        </div>

                        <h1 className="text-4xl md:text-5xl lg:text-[3.5rem] font-serif font-bold text-gray-900 leading-[1.1] mb-10 tracking-tight">
                            {item.title}
                        </h1>

                        <div className="flex flex-col mb-12">
                            <h3 className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-[0.2em] text-gray-400 mb-6">
                                <FileText className="h-4 w-4 text-[#d4af37]" />
                                Historical Context &amp; Description
                            </h3>

                            <div className="prose prose-lg prose-gray text-gray-600 leading-relaxed max-w-none">
                                {displayDescription ? (
                                    <div className="space-y-6 text-[1.05rem]">
                                        {displayDescription.split('\n').map((paragraph: string, idx: number) => {
                                            if (!paragraph.trim()) return null;

                                            if (idx === 0) {
                                                return (
                                                    <p
                                                        key={idx}
                                                        className="text-gray-800 font-medium leading-relaxed first-letter:text-6xl first-letter:font-serif first-letter:font-bold first-letter:text-[#6a306c] first-letter:mr-2 first-letter:float-left first-letter:leading-[0.8] first-line:tracking-wide"
                                                    >
                                                        {paragraph}
                                                    </p>
                                                );
                                            }

                                            return (
                                                <p key={idx} className="text-gray-600">
                                                    {paragraph}
                                                </p>
                                            );
                                        })}
                                    </div>
                                ) : (
                                    <div className="flex items-start gap-4 bg-gray-50 p-6 rounded-2xl border border-gray-100 text-gray-500">
                                        <Info className="h-5 w-5 shrink-0 text-gray-400 mt-0.5" />
                                        <p className="text-sm m-0 italic">
                                            No additional historical description or context has been provided for this specific archive record.
                                        </p>
                                    </div>
                                )}
                            </div>
                        </div>

                        <div className="flex flex-col gap-6 pt-10 border-t border-gray-100 mt-auto">
                            {locationText && mapIdToSelect && (
                                <MapSection locationText={locationText} mapIdToSelect={mapIdToSelect} />
                            )}

                            {!item.isCollectionEntity && (
                                <div className="flex flex-col sm:flex-row gap-5">
                                    <div className="flex items-center gap-4 bg-gray-50/80 hover:bg-gray-50 px-6 py-5 rounded-2xl border border-gray-100 flex-grow transition-colors">
                                        <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-white text-[#d4af37] shadow-sm border border-gray-100">
                                            <User className="h-5 w-5" />
                                        </div>
                                        <div className="flex flex-col">
                      <span className="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">
                        Creator / Author
                      </span>
                                            <span className="text-base font-serif font-bold text-gray-900">
                        {item.creator || 'Unknown'}
                      </span>
                                        </div>
                                    </div>

                                    <div className="flex items-center gap-4 bg-gray-50/80 hover:bg-gray-50 px-6 py-5 rounded-2xl border border-gray-100 flex-grow transition-colors">
                                        <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-white text-[#6a306c] shadow-sm border border-gray-100">
                                            <Calendar className="h-5 w-5" />
                                        </div>
                                        <div className="flex flex-col">
                      <span className="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">
                        Date Created
                      </span>
                                            <span className="text-base font-serif font-bold text-gray-900">
                        {displayDate}
                      </span>
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {item.isCollectionEntity && childItems.length > 0 && (
                    <div className="flex flex-col mt-16 pt-8">
                        <div className="flex items-center gap-3 mb-8">
                            {renderCollectionIcon(item.title, 'h-6 w-6 text-[#d4af37]')}
                            <h2 className="text-3xl font-serif font-bold text-gray-900">
                                Items in this Collection
                            </h2>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                            {childItems.map((child: OmekaItem) => (
                                <Link
                                    href={`/archive/${child.id}`}
                                    key={child.id}
                                    className="group bg-white rounded-3xl overflow-hidden shadow-[0_4px_20px_rgb(0,0,0,0.03)] hover:shadow-[0_10px_40px_rgb(212,175,55,0.15)] border border-gray-100 hover:border-[#d4af37]/40 transition-all duration-500 flex flex-col hover:-translate-y-1.5 cursor-pointer"
                                >
                                    <div className="relative h-48 w-full overflow-hidden bg-gray-50 flex items-center justify-center border-b border-gray-100">
                                        {!child.isDocument && child.imageUrl ? (
                                            <Image
                                                src={child.imageUrl}
                                                alt={child.title}
                                                fill
                                                unoptimized
                                                sizes="(max-width: 768px) 100vw, 33vw"
                                                className="object-cover transition-transform duration-700 group-hover:scale-105"
                                            />
                                        ) : (
                                            <FileText
                                                strokeWidth={1.5}
                                                className="h-12 w-12 text-gray-300 group-hover:text-[#6a306c] transition-colors duration-500"
                                            />
                                        )}
                                    </div>

                                    <div className="p-6 flex flex-col flex-grow">
                                        <h3 className="text-lg font-serif font-bold text-gray-900 mb-3 group-hover:text-[#6a306c] transition-colors leading-tight line-clamp-2">
                                            {child.title}
                                        </h3>

                                        <div className="mt-auto pt-4 flex justify-between items-center border-t border-gray-100">
                                            <div className="flex flex-col">
                        <span className="text-[10px] text-gray-400 uppercase tracking-widest mb-0.5">
                          Creator
                        </span>
                                                <span className="text-xs font-medium text-gray-900 truncate max-w-[120px]">
                          {child.creator}
                        </span>
                                            </div>

                                            <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gray-50 text-[#d4af37] group-hover:bg-[#d4af37] group-hover:text-white transition-all duration-300 shadow-sm">
                                                <ArrowRight className="h-4 w-4" />
                                            </div>
                                        </div>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    </div>
                )}
            </main>
        </div>
    );
}