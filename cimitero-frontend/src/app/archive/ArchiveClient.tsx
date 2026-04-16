"use client";

import React, { useState, useMemo, useEffect, useRef } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
    Search, SlidersHorizontal, ArrowRight, RotateCcw,
    LayoutGrid, List, FileText, ChevronLeft, ChevronRight,
    ChevronDown, ChevronUp, X, Filter, FolderOpen,
    Map as MapIcon, Landmark, Users, Flame, Route
} from 'lucide-react';
import { Checkbox } from '@/src/components/ui/Checkbox';
import { CustomSelect } from '@/src/components/ui/CustomSelect';
import { OmekaItem, getCollectionStyle } from '@/src/lib/omeka';

interface ArchiveClientProps {
    initialItems: OmekaItem[];
}

const ITEMS_PER_PAGE = 12;

const getCollectionIcon = (title: string) => {
    const t = title.toLowerCase();
    if (t.includes('map')) return MapIcon;
    if (t.includes('architecture')) return Landmark;
    if (t.includes('figures')) return Users;
    if (t.includes('remembrance')) return Flame;
    if (t.includes('tour')) return Route;
    return FolderOpen;
};

export const ArchiveClient: React.FC<ArchiveClientProps> = ({ initialItems }) => {
    const router = useRouter();
    const resultsRef = useRef<HTMLDivElement>(null);

    const categoryItems = useMemo(() => initialItems.filter(i => i.isCollectionEntity), [initialItems]);
    const regularItems = useMemo(() => initialItems.filter(i => !i.isCollectionEntity), [initialItems]);

    const [searchQuery, setSearchQuery] = useState("");
    const [sortOrder, setSortOrder] = useState("recent");
    const [viewMode, setViewMode] = useState<"grid" | "list">("list");
    const [currentPage, setCurrentPage] = useState(1);

    const [selectedCreators, setSelectedCreators] = useState<string[]>([]);
    const [selectedCollections, setSelectedCollections] = useState<string[]>([]);

    const [isCollectionsOpen, setIsCollectionsOpen] = useState(true);
    const [isCreatorsOpen, setIsCreatorsOpen] = useState(true);

    const hasActiveFilters = searchQuery !== "" || selectedCreators.length > 0 || selectedCollections.length > 0;

    useEffect(() => {
        setCurrentPage(1);
    }, [searchQuery, sortOrder, selectedCreators, selectedCollections, viewMode]);

    const { creators, collections } = useMemo(() => {
        const creatorCounts: Record<string, number> = {};
        const collectionCounts: Record<string, number> = {};

        regularItems.forEach(item => {
            const creator = item.creator || "Unknown";
            const collection = item.itemSet || "Uncategorized";

            creatorCounts[creator] = (creatorCounts[creator] || 0) + 1;
            collectionCounts[collection] = (collectionCounts[collection] || 0) + 1;
        });

        return {
            creators: Object.entries(creatorCounts).sort((a, b) => b[1] - a[1]),
            collections: Object.entries(collectionCounts).sort((a, b) => b[1] - a[1])
        };
    }, [regularItems]);

    const sortOptions = [
        { value: "recent", label: "Most Recent" },
        { value: "oldest", label: "Oldest First" },
        { value: "az", label: "Alphabetical (A-Z)" },
        { value: "za", label: "Alphabetical (Z-A)" }
    ];

    const filteredAndSortedItems = useMemo(() => {
        let result = [...regularItems];

        if (searchQuery.trim() !== "") {
            const query = searchQuery.toLowerCase();
            result = result.filter(item =>
                item.title.toLowerCase().includes(query) ||
                item.description.toLowerCase().includes(query) ||
                (item.creator && item.creator.toLowerCase().includes(query))
            );
        }

        if (selectedCreators.length > 0) {
            result = result.filter(item => selectedCreators.includes(item.creator || "Unknown"));
        }

        if (selectedCollections.length > 0) {
            result = result.filter(item => selectedCollections.includes(item.itemSet || "Uncategorized"));
        }

        result.sort((a, b) => {
            switch (sortOrder) {
                case "az": return a.title.localeCompare(b.title);
                case "za": return b.title.localeCompare(a.title);
                case "oldest": return new Date(a.date).getTime() - new Date(b.date).getTime();
                case "recent":
                default: return new Date(b.date).getTime() - new Date(a.date).getTime();
            }
        });

        return result;
    }, [regularItems, searchQuery, sortOrder, selectedCreators, selectedCollections]);

    const totalItems = filteredAndSortedItems.length;
    const totalPages = Math.ceil(totalItems / ITEMS_PER_PAGE);
    const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
    const paginatedItems = filteredAndSortedItems.slice(startIndex, Math.min(startIndex + ITEMS_PER_PAGE, totalItems));

    const getPageNumbers = () => {
        const pages = [];
        const maxVisiblePages = 5;
        let start = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        let end = Math.min(totalPages, start + maxVisiblePages - 1);

        if (end - start + 1 < maxVisiblePages) {
            start = Math.max(1, end - maxVisiblePages + 1);
        }

        for (let i = start; i <= end; i++) {
            pages.push(i);
        }
        return pages;
    };

    const scrollToResults = () => {
        if (resultsRef.current) {
            const y = resultsRef.current.getBoundingClientRect().top + window.scrollY - 120;
            window.scrollTo({ top: y, behavior: 'smooth' });
        }
    };

    const handlePageChange = (page: number) => {
        setCurrentPage(page);
        scrollToResults();
    };

    const handleReset = () => {
        setSearchQuery("");
        setSortOrder("recent");
        setSelectedCreators([]);
        setSelectedCollections([]);
        setCurrentPage(1);
        scrollToResults();
    };

    const toggleFilter = (setState: React.Dispatch<React.SetStateAction<string[]>>, value: string) => {
        setState(prev => prev.includes(value) ? prev.filter(v => v !== value) : [...prev, value]);
        scrollToResults();
    };

    const handleSortChange = (val: string) => {
        setSortOrder(val);
        scrollToResults();
    };

    const handleViewModeChange = (mode: "grid" | "list") => {
        setViewMode(mode);
        scrollToResults();
    };

    return (
        <main className="flex-grow w-full max-w-[1600px] mx-auto px-6 md:px-8 py-12 flex flex-col gap-16">

            {categoryItems.length > 0 && (
                <section className="w-full flex flex-col gap-6 border-b border-gray-200 pb-12">
                    <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-3">
                            <FolderOpen className="h-6 w-6 text-[#d4af37]" />
                            <h2 className="text-xl lg:text-2xl font-serif font-bold text-gray-900">Thematic Collections</h2>
                        </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5 gap-4">
                        {categoryItems.map(item => {
                            const Icon = getCollectionIcon(item.title);
                            return (
                                <Link
                                    href={`/archive/${item.id}`}
                                    key={item.id}
                                    className="group flex flex-col items-start p-6 bg-white rounded-[2rem] border border-gray-100 shadow-[0_4px_20px_rgb(0,0,0,0.02)] hover:shadow-[0_10px_40px_rgb(212,175,55,0.12)] hover:border-[#d4af37]/40 transition-all duration-300 hover:-translate-y-1"
                                >
                                    <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#6a306c]/5 text-[#6a306c] group-hover:bg-[#d4af37] group-hover:text-white transition-colors duration-300 mb-5">
                                        <Icon className="h-7 w-7" strokeWidth={1.5} />
                                    </div>
                                    <h3 className="text-sm font-bold uppercase tracking-widest text-gray-900 mb-3 group-hover:text-[#6a306c] transition-colors leading-snug pr-4">
                                        {item.title}
                                    </h3>
                                    <div className="mt-auto flex items-center gap-1.5 text-[10px] font-bold text-gray-400 uppercase tracking-widest group-hover:text-[#d4af37] transition-colors pt-3">
                                        Explore <ArrowRight className="h-3.5 w-3.5 group-hover:translate-x-1 transition-transform" />
                                    </div>
                                </Link>
                            );
                        })}
                    </div>
                </section>
            )}

            <div className="flex flex-col lg:flex-row gap-8 lg:gap-12">
                {/* --- SIDEBAR FILTRI --- */}
                <aside className="w-full lg:w-80 shrink-0 flex flex-col gap-6">
                    <div className="bg-white rounded-3xl p-6 lg:p-7 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-gray-100 flex flex-col gap-6 sticky top-32">

                        <div className="flex items-center justify-between pb-4 border-b border-gray-100">
                            <div className="flex items-center gap-2 text-gray-900 font-serif font-bold text-xl">
                                <Filter className="h-5 w-5 text-[#d4af37]" />
                                <h2>Refine Search</h2>
                            </div>
                            <button
                                onClick={handleReset}
                                disabled={!hasActiveFilters}
                                className={`flex items-center gap-1.5 text-xs font-bold uppercase tracking-widest transition-all ${hasActiveFilters ? 'text-gray-500 hover:text-[#6a306c]' : 'text-gray-300 cursor-not-allowed'}`}
                            >
                                <RotateCcw className="h-3.5 w-3.5" />
                                Reset
                            </button>
                        </div>

                        {/* Barra di Ricerca */}
                        <div className="flex flex-col gap-2">
                            <label className="text-[10px] font-bold uppercase tracking-[0.2em] text-gray-400 ml-1">Keywords</label>
                            <div className="relative flex items-center group">
                                <Search className="absolute left-4 h-4 w-4 text-gray-400 group-focus-within:text-[#d4af37] transition-colors z-10" />
                                <input
                                    type="text"
                                    value={searchQuery}
                                    onChange={(e) => setSearchQuery(e.target.value)}
                                    placeholder="Search titles, authors..."
                                    className="w-full pl-10 pr-4 py-3.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#d4af37]/50 focus:border-[#d4af37] text-sm transition-all shadow-sm"
                                />
                                {searchQuery && (
                                    <button onClick={() => setSearchQuery("")} className="absolute right-4 text-gray-400 hover:text-gray-600">
                                        <X className="h-4 w-4" />
                                    </button>
                                )}
                            </div>
                        </div>

                        {/* Tag Filtri Attivi (Pills) */}
                        {(selectedCollections.length > 0 || selectedCreators.length > 0) && (
                            <div className="flex flex-wrap gap-2 pt-2">
                                {selectedCollections.map(col => (
                                    <span key={col} className={`inline-flex items-center gap-1.5 px-3 py-2 rounded-xl text-[9px] font-bold uppercase tracking-widest leading-tight border ${getCollectionStyle(col)}`}>
                                        {col}
                                        <button onClick={() => toggleFilter(setSelectedCollections, col)} className="hover:opacity-60 rounded-full p-0.5 transition-opacity shrink-0">
                                            <X className="h-3 w-3" />
                                        </button>
                                    </span>
                                ))}
                                {selectedCreators.map(creator => (
                                    <span key={creator} className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-gray-100 text-gray-600 text-[9px] font-bold uppercase tracking-widest leading-tight border border-gray-200">
                                        {creator}
                                        <button onClick={() => toggleFilter(setSelectedCreators, creator)} className="hover:bg-gray-200 rounded-full p-0.5 transition-colors shrink-0">
                                            <X className="h-3 w-3" />
                                        </button>
                                    </span>
                                ))}
                            </div>
                        )}

                        <div className="h-px w-full bg-gray-100" />

                        {/* Accordion: Collections */}
                        <div className="flex flex-col">
                            <button
                                onClick={() => setIsCollectionsOpen(!isCollectionsOpen)}
                                className="flex items-center justify-between w-full py-2 group"
                            >
                                <div className="flex items-center gap-2">
                                    <h3 className="text-xs font-bold uppercase tracking-[0.2em] text-[#d4af37]">Collections</h3>
                                    {selectedCollections.length > 0 && (
                                        <span className="flex h-5 w-5 items-center justify-center rounded-full bg-[#d4af37] text-[10px] font-bold text-white">
                                            {selectedCollections.length}
                                        </span>
                                    )}
                                </div>
                                {isCollectionsOpen ? <ChevronUp className="h-4 w-4 text-gray-400 group-hover:text-gray-900 transition-colors" /> : <ChevronDown className="h-4 w-4 text-gray-400 group-hover:text-gray-900 transition-colors" />}
                            </button>

                            <div className={`transition-all duration-300 overflow-hidden ${isCollectionsOpen ? 'max-h-[300px] opacity-100 mt-3' : 'max-h-0 opacity-0'}`}>
                                <div className="flex flex-col gap-1 overflow-y-auto pr-2 custom-scrollbar max-h-[250px]">
                                    {collections.map(([collection, count]) => (
                                        <div key={collection} className="flex justify-between items-center group px-2 py-1.5 rounded-lg hover:bg-gray-50 transition-colors">
                                            <Checkbox
                                                label={collection}
                                                checked={selectedCollections.includes(collection)}
                                                onChange={() => toggleFilter(setSelectedCollections, collection)}
                                            />
                                            <span className="inline-flex items-center justify-center px-2 py-0.5 rounded-full bg-gray-100 text-gray-500 text-[10px] font-bold group-hover:bg-white group-hover:shadow-sm transition-all">
                                                {count}
                                            </span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>

                        <div className="h-px w-full bg-gray-50" />

                        {/* Accordion: Creators */}
                        <div className="flex flex-col">
                            <button
                                onClick={() => setIsCreatorsOpen(!isCreatorsOpen)}
                                className="flex items-center justify-between w-full py-2 group"
                            >
                                <div className="flex items-center gap-2">
                                    <h3 className="text-xs font-bold uppercase tracking-[0.2em] text-[#d4af37]">Creators</h3>
                                    {selectedCreators.length > 0 && (
                                        <span className="flex h-5 w-5 items-center justify-center rounded-full bg-[#d4af37] text-[10px] font-bold text-white">
                                            {selectedCreators.length}
                                        </span>
                                    )}
                                </div>
                                {isCreatorsOpen ? <ChevronUp className="h-4 w-4 text-gray-400 group-hover:text-gray-900 transition-colors" /> : <ChevronDown className="h-4 w-4 text-gray-400 group-hover:text-gray-900 transition-colors" />}
                            </button>

                            <div className={`transition-all duration-300 overflow-hidden ${isCreatorsOpen ? 'max-h-[300px] opacity-100 mt-3' : 'max-h-0 opacity-0'}`}>
                                <div className="flex flex-col gap-1 overflow-y-auto pr-2 custom-scrollbar max-h-[250px]">
                                    {creators.map(([creator, count]) => (
                                        <div key={creator} className="flex justify-between items-center group px-2 py-1.5 rounded-lg hover:bg-gray-50 transition-colors">
                                            <Checkbox
                                                label={creator}
                                                checked={selectedCreators.includes(creator)}
                                                onChange={() => toggleFilter(setSelectedCreators, creator)}
                                            />
                                            <span className="inline-flex items-center justify-center px-2 py-0.5 rounded-full bg-gray-100 text-gray-500 text-[10px] font-bold group-hover:bg-white group-hover:shadow-sm transition-all">
                                                {count}
                                            </span>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>

                    </div>
                </aside>

                <div ref={resultsRef} className="w-full flex-grow flex flex-col min-w-0 scroll-mt-32">

                    <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4 bg-white p-3 px-5 rounded-2xl shadow-[0_2px_10px_rgb(0,0,0,0.02)] border border-gray-200">
                        <p className="text-sm text-gray-500 font-medium">
                            Found <span className="font-bold text-gray-900 text-base mx-1">{totalItems}</span> records
                        </p>

                        <div className="flex items-center gap-4">
                            <div className="flex items-center bg-gray-100 p-1 rounded-lg border border-gray-200">
                                <button
                                    onClick={() => handleViewModeChange("list")}
                                    className={`p-1.5 rounded-md transition-all ${viewMode === "list" ? "bg-white shadow-sm text-[#d4af37]" : "text-gray-400 hover:text-gray-600"}`}
                                    title="List View"
                                >
                                    <List size={18} />
                                </button>
                                <button
                                    onClick={() => handleViewModeChange("grid")}
                                    className={`p-1.5 rounded-md transition-all ${viewMode === "grid" ? "bg-white shadow-sm text-[#d4af37]" : "text-gray-400 hover:text-gray-600"}`}
                                    title="Grid View"
                                >
                                    <LayoutGrid size={18} />
                                </button>
                            </div>

                            <div className="h-6 w-px bg-gray-200 hidden sm:block"></div>

                            <div className="flex items-center gap-3">
                                <span className="text-[10px] font-bold uppercase tracking-[0.2em] text-gray-400 hidden sm:block">Sort by</span>
                                <CustomSelect
                                    options={sortOptions}
                                    defaultValue={sortOrder}
                                    onChange={(val) => handleSortChange(val)}
                                />
                            </div>
                        </div>
                    </div>

                    {totalItems === 0 ? (
                        <div className="bg-white p-16 rounded-[2rem] border border-gray-100 text-center shadow-sm flex flex-col items-center mt-2">
                            <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mb-4 border border-gray-100">
                                <Search className="h-8 w-8 text-gray-300" />
                            </div>
                            <h3 className="text-xl font-serif font-bold text-gray-900 mb-2">No records found</h3>
                            <p className="text-gray-500 max-w-md">Adjust your search parameters or clear filters to view the database content.</p>
                            <button onClick={handleReset} className="mt-6 text-[#d4af37] font-bold text-sm uppercase tracking-widest hover:underline">
                                Clear all filters
                            </button>
                        </div>
                    ) : (
                        <>
                            {viewMode === "grid" && (
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 gap-6">
                                    {paginatedItems.map((item) => {
                                        const CollectionIcon = item.itemSet ? getCollectionIcon(item.itemSet) : null;

                                        return (
                                            <Link href={`/archive/${item.id}`} key={item.id} className="group bg-white rounded-3xl overflow-hidden shadow-[0_4px_20px_rgb(0,0,0,0.03)] hover:shadow-[0_10px_40px_rgb(212,175,55,0.15)] border border-gray-100 hover:border-[#d4af37]/40 transition-all duration-500 flex flex-col hover:-translate-y-1.5 cursor-pointer">
                                                <div className="relative h-56 w-full overflow-hidden bg-gray-50 flex items-center justify-center border-b border-gray-100">
                                                    {!item.isDocument && item.imageUrl ? (
                                                        <Image
                                                            src={item.imageUrl}
                                                            alt={item.title}
                                                            fill
                                                            unoptimized
                                                            sizes="(max-width: 768px) 100vw, 33vw"
                                                            className="object-cover transition-transform duration-700 group-hover:scale-105"
                                                        />
                                                    ) : (
                                                        <div className="flex flex-col items-center justify-center text-gray-300 group-hover:text-[#6a306c] transition-colors duration-500">
                                                            <FileText strokeWidth={1.5} className="h-16 w-16 mb-3" />
                                                            <span className="text-[10px] uppercase tracking-widest font-bold">Document / PDF</span>
                                                        </div>
                                                    )}
                                                </div>
                                                <div className="p-6 flex flex-col flex-grow">

                                                    {item.itemSet && (
                                                        <div className="mb-4">
                                                            <span className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-[9px] font-bold uppercase tracking-[0.2em] leading-tight border shadow-sm ${getCollectionStyle(item.itemSet)}`}>
                                                                {CollectionIcon && <CollectionIcon className="h-3 w-3 shrink-0" />}
                                                                <span>{item.itemSet}</span>
                                                            </span>
                                                        </div>
                                                    )}

                                                    <h2 className="text-xl font-serif font-bold text-gray-900 mb-3 group-hover:text-[#6a306c] transition-colors leading-tight line-clamp-2">
                                                        {item.title}
                                                    </h2>
                                                    <p className="text-sm text-gray-500 leading-relaxed mb-6 line-clamp-3">
                                                        {item.description}
                                                    </p>
                                                    <div className="mt-auto pt-5 flex justify-between items-center border-t border-gray-100">
                                                        <div className="flex flex-col">
                                                            <span className="text-[10px] text-gray-400 uppercase tracking-widest mb-1">Creator</span>
                                                            <span className="text-xs font-medium text-gray-900 truncate max-w-[120px]">{item.creator}</span>
                                                        </div>
                                                        <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gray-50 text-[#d4af37] group-hover:bg-[#d4af37] group-hover:text-white transition-all duration-300 shadow-sm">
                                                            <ArrowRight className="h-4 w-4" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </Link>
                                        );
                                    })}
                                </div>
                            )}

                            {viewMode === "list" && (
                                <div className="bg-white rounded-3xl shadow-[0_4px_20px_rgb(0,0,0,0.03)] border border-gray-100 overflow-hidden">
                                    <div className="overflow-x-auto">
                                        <table className="w-full text-left border-collapse">
                                            <thead>
                                            <tr className="bg-gray-50/50 border-b border-gray-100 text-[10px] uppercase tracking-[0.2em] text-gray-400">
                                                <th className="py-4 px-8 font-bold w-32">Preview</th>
                                                <th className="py-4 px-6 font-bold">Record Details</th>
                                                <th className="py-4 px-6 font-bold w-48 lg:w-56">Collection</th>
                                                <th className="py-4 px-8 font-bold text-right w-40">Action</th>
                                            </tr>
                                            </thead>
                                            <tbody className="divide-y divide-gray-100">
                                            {paginatedItems.map((item) => {
                                                const CollectionIcon = item.itemSet ? getCollectionIcon(item.itemSet) : null;

                                                return (
                                                    <tr
                                                        key={item.id}
                                                        onClick={() => router.push(`/archive/${item.id}`)}
                                                        className="hover:bg-gray-50/80 transition-colors group cursor-pointer"
                                                    >
                                                        <td className="py-6 px-8 align-top">
                                                            <div className="relative h-20 w-28 rounded-xl overflow-hidden border border-gray-200 bg-white flex items-center justify-center shadow-sm group-hover:border-[#d4af37]/40 transition-colors">
                                                                {!item.isDocument && item.imageUrl ? (
                                                                    <Image src={item.imageUrl} alt={item.title} fill unoptimized className="object-cover" />
                                                                ) : (
                                                                    <FileText className="h-8 w-8 text-gray-300 group-hover:text-[#6a306c] transition-colors" />
                                                                )}
                                                            </div>
                                                        </td>
                                                        <td className="py-6 px-6 align-top">
                                                            <h3 className="text-lg font-serif font-bold text-gray-900 group-hover:text-[#6a306c] transition-colors mb-2 line-clamp-1">
                                                                {item.title}
                                                            </h3>
                                                            <p className="text-sm text-gray-500 line-clamp-2 pr-8 mb-3 leading-relaxed">
                                                                {item.description}
                                                            </p>
                                                        </td>

                                                        <td className="py-6 px-6 align-middle">
                                                            {item.itemSet && (
                                                                <div className={`inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-[10px] font-bold uppercase tracking-widest leading-tight border shadow-sm ${getCollectionStyle(item.itemSet)}`}>
                                                                    {CollectionIcon && <CollectionIcon className="h-3.5 w-3.5 shrink-0" />}
                                                                    <span>{item.itemSet}</span>
                                                                </div>
                                                            )}
                                                        </td>

                                                        <td className="py-6 px-8 align-middle text-right">
                                                            <div className="inline-flex items-center justify-center gap-2 text-[10px] font-bold uppercase tracking-[0.2em] text-[#d4af37] bg-white group-hover:bg-[#d4af37] group-hover:text-white px-5 py-3 rounded-xl transition-all border border-gray-200 group-hover:border-[#d4af37] shadow-sm group-hover:shadow-md">
                                                                View
                                                                <ArrowRight className="h-3 w-3" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                );
                                            })}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            )}

                            {/* --- CONTROLLI PAGINAZIONE --- */}
                            {totalPages > 1 && (
                                <div className="mt-10 flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-gray-200 pt-6 px-2">
                                    <div className="text-sm text-gray-500">
                                        Showing <span className="font-bold text-gray-900">{startIndex + 1}</span> to <span className="font-bold text-gray-900">{Math.min(startIndex + ITEMS_PER_PAGE, totalItems)}</span> of <span className="font-bold text-gray-900">{totalItems}</span>
                                    </div>

                                    <div className="flex items-center gap-2">
                                        <button
                                            onClick={() => handlePageChange(Math.max(1, currentPage - 1))}
                                            disabled={currentPage === 1}
                                            className="flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 bg-white text-gray-500 hover:bg-gray-50 hover:text-gray-900 disabled:opacity-50 disabled:pointer-events-none transition-all shadow-sm"
                                        >
                                            <ChevronLeft className="h-4 w-4" />
                                        </button>

                                        <div className="flex items-center gap-1">
                                            {getPageNumbers().map(num => (
                                                <button
                                                    key={num}
                                                    onClick={() => handlePageChange(num)}
                                                    className={`flex h-10 w-10 items-center justify-center rounded-xl text-sm font-bold transition-all ${
                                                        currentPage === num
                                                            ? "bg-[#6a306c] text-white shadow-md border border-[#6a306c]"
                                                            : "bg-white border border-gray-200 text-gray-600 hover:bg-gray-50 hover:text-gray-900 shadow-sm"
                                                    }`}
                                                >
                                                    {num}
                                                </button>
                                            ))}
                                        </div>

                                        <button
                                            onClick={() => handlePageChange(Math.min(totalPages, currentPage + 1))}
                                            disabled={currentPage === totalPages}
                                            className="flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 bg-white text-gray-500 hover:bg-gray-50 hover:text-gray-900 disabled:opacity-50 disabled:pointer-events-none transition-all shadow-sm"
                                        >
                                            <ChevronRight className="h-4 w-4" />
                                        </button>
                                    </div>
                                </div>
                            )}
                        </>
                    )}
                </div>
            </div>
        </main>
    );
};