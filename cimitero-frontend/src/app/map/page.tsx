// src/app/map/page.tsx
"use client";

import React, { useState, useEffect } from "react";
import Image from "next/image";
import Link from "next/link";
import { MapPin, Search, FileText, Loader2, ChevronLeft, ChevronRight, ArrowRight, FolderOpen } from "lucide-react";
import { Header } from "@/src/components/layout/Header";
import InteractiveSvgMap from "@/src/components/map/InteractiveSvgMap";
import { getItemsByArea } from "./actions";

const ITEMS_PER_PAGE = 4;

export default function MapPage() {
    const [selectedPointId, setSelectedPointId] = useState<string | null>(null);

    const [areaItems, setAreaItems] = useState<any[]>([]);
    const [isLoadingItems, setIsLoadingItems] = useState(false);
    const [currentPage, setCurrentPage] = useState(1);

    useEffect(() => {
        if (!selectedPointId) {
            setAreaItems([]);
            return;
        }

        let isMounted = true;
        setIsLoadingItems(true);
        setCurrentPage(1);

        getItemsByArea(selectedPointId).then((items) => {
            if (isMounted) {
                setAreaItems(items);
                setIsLoadingItems(false);
            }
        }).catch(() => {
            if (isMounted) setIsLoadingItems(false);
        });

        return () => { isMounted = false; };
    }, [selectedPointId]);

    const totalPages = Math.ceil(areaItems.length / ITEMS_PER_PAGE);
    const paginatedItems = areaItems.slice(
        (currentPage - 1) * ITEMS_PER_PAGE,
        currentPage * ITEMS_PER_PAGE
    );

    return (
        <div className="flex flex-col min-h-screen bg-[#fdfcfaf0]">
            <Header />

            {/* --- TOP BANNER --- */}
            <div className="relative w-full border-b border-[#d4af37]/20 pt-40 pb-24 px-6 overflow-hidden flex justify-center">
                <Image
                    src="/cimitero.png"
                    alt="Map Background"
                    fill
                    priority
                    className="object-cover object-center"
                />
                <div className="absolute inset-0 bg-gradient-to-r from-[#0a0a0a]/90 via-[#0a0a0a]/70 to-[#0a0a0a]/90 z-10"></div>
                <div className="relative z-20 w-full max-w-[1600px] flex flex-col items-center text-center lg:items-start lg:text-left px-4 md:px-8">
                    <p className="text-[#d4af37] font-bold tracking-[0.2em] uppercase mb-4 text-xs md:text-sm drop-shadow-md">
                        Explore the Grounds
                    </p>
                    <h1 className="text-4xl md:text-5xl lg:text-7xl font-serif font-bold text-white tracking-tight drop-shadow-xl mb-4">
                        Digital Map Explorer
                    </h1>
                    <p className="text-gray-300 max-w-2xl font-light leading-relaxed text-sm md:text-lg drop-shadow-md">
                        Interactively explore the cemetery floor plan. Click on the highlighted areas to discover details, courtyards, and points of historical interest.
                    </p>
                </div>
            </div>

            {/* --- MAIN CONTENT --- */}
            <main className="flex-grow w-full max-w-[1500px] mx-auto px-6 md:px-8 py-12 flex flex-col lg:flex-row gap-8">

                {/* SIDE PANEL */}
                <aside className="w-full lg:w-[400px] xl:w-[450px] shrink-0 flex flex-col overflow-hidden">
                    <div className="bg-white rounded-[2rem] shadow-[0_8px_40px_rgb(0,0,0,0.04)] border border-gray-100 overflow-hidden flex flex-col flex-grow min-h-[550px] lg:max-h-[800px] lg:h-full transition-all duration-300">

                        <div className="bg-gray-50/80 border-b border-gray-100 p-6 flex items-center gap-4 shrink-0">
                            <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-white text-[#d4af37] shadow-sm border border-gray-100">
                                <MapPin className="h-5 w-5" />
                            </div>
                            <h2 className="text-2xl font-serif font-bold text-gray-900">
                                Area Details
                            </h2>
                        </div>

                        <div className="p-6 lg:p-8 flex flex-col flex-grow overflow-hidden">
                            {selectedPointId ? (
                                <div className="flex flex-col h-full animate-in fade-in slide-in-from-bottom-4 duration-500 overflow-hidden">
                                    <div className="mb-6 shrink-0">
                                        <span className="text-[10px] font-bold uppercase tracking-widest text-[#d4af37] mb-2 block">
                                            Selected Area
                                        </span>
                                        <h3 className="text-4xl font-serif font-bold text-gray-900 truncate">
                                            {selectedPointId.toLowerCase().includes('courtyard')
                                                ? selectedPointId
                                                : `Courtyard ${selectedPointId}`}
                                        </h3>
                                    </div>

                                    <div className="w-full h-px bg-gray-100 mb-6 shrink-0"></div>

                                    {/* DYNAMIC ITEMS LIST / PLACHOLDER AREA */}
                                    <div className="flex flex-col flex-grow overflow-y-auto custom-scrollbar pr-2 pb-2">
                                        {isLoadingItems ? (
                                            <div className="flex flex-col items-center justify-center h-full text-[#d4af37] opacity-60 py-12">
                                                <Loader2 className="h-8 w-8 animate-spin mb-4" />
                                                <span className="text-xs font-bold uppercase tracking-widest text-gray-400">Loading records...</span>
                                            </div>
                                        ) : areaItems.length > 0 ? (
                                            <div className="flex flex-col gap-4">
                                                <p className="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">
                                                    {areaItems.length} {areaItems.length === 1 ? 'Record' : 'Records'} Found
                                                </p>
                                                {paginatedItems.map((item) => (
                                                    <Link
                                                        href={`/archive/${item.id}`}
                                                        key={item.id}
                                                        className="group bg-white rounded-3xl overflow-hidden shadow-[0_4px_20px_rgb(0,0,0,0.03)] hover:shadow-[0_10px_40px_rgb(212,175,55,0.15)] border border-gray-100 hover:border-[#d4af37]/40 transition-all duration-500 flex hover:-translate-y-1.5 cursor-pointer min-h-[120px]"
                                                    >
                                                        <div className="relative w-1/3 min-w-[110px] bg-gray-50 flex items-center justify-center border-r border-gray-100 overflow-hidden shrink-0">
                                                            {!item.isDocument && item.imageUrl ? (
                                                                <Image src={item.imageUrl} alt={item.title} fill unoptimized className="object-cover transition-transform duration-700 group-hover:scale-105" />
                                                            ) : (
                                                                <FileText strokeWidth={1.5} className="h-8 w-8 text-gray-300 group-hover:text-[#6a306c] transition-colors duration-500" />
                                                            )}
                                                        </div>
                                                        <div className="p-5 flex flex-col flex-grow justify-between min-w-0">
                                                            <h4 className="text-base font-serif font-bold text-gray-900 group-hover:text-[#6a306c] transition-colors leading-tight line-clamp-3 mb-3">
                                                                {item.title}
                                                            </h4>
                                                            <div className="mt-auto flex justify-end">
                                                                <div className="flex h-8 w-8 items-center justify-center rounded-full bg-gray-50 text-[#d4af37] group-hover:bg-[#d4af37] group-hover:text-white transition-all duration-300 shadow-sm">
                                                                    <ArrowRight className="h-4 w-4" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </Link>
                                                ))}
                                            </div>
                                        ) : (
                                            <div className="flex flex-col items-center justify-center text-center bg-gray-50/50 rounded-3xl border border-gray-100 p-10 h-full animate-in fade-in duration-700">
                                                <div className="relative w-24 h-24 flex items-center justify-center mb-8">
                                                    <div className="absolute inset-0 bg-white rounded-full shadow-inner border border-gray-100"></div>
                                                    <div className="absolute inset-3 bg-gradient-to-br from-[#6a306c]/10 to-[#d4af37]/10 rounded-full"></div>
                                                    <FolderOpen strokeWidth={1} className="relative h-12 w-12 text-[#6a306c]/70" />
                                                </div>

                                                <span className="text-[10px] font-bold uppercase tracking-widest text-[#d4af37] mb-3">
                                                    Digital Archive
                                                </span>
                                                <h4 className="text-xl font-serif font-bold text-gray-900 mb-4 leading-tight max-w-xs">
                                                    No records associated here
                                                </h4>
                                                <p className="text-sm text-gray-500 leading-relaxed max-w-xs">
                                                    We couldn't find any historical documents, photos, or figures currently linked to Area <strong className="text-gray-700">{selectedPointId}</strong>.
                                                </p>
                                            </div>
                                        )}
                                    </div>

                                    {/* PAGINATION CONTROLS */}
                                    {totalPages > 1 && !isLoadingItems && (
                                        <div className="flex items-center justify-between pt-5 mt-auto border-t border-gray-100 shrink-0">
                                            <button
                                                onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                                                disabled={currentPage === 1}
                                                className={`flex items-center justify-center h-10 w-10 rounded-full border ${currentPage === 1 ? 'border-gray-100 text-gray-300' : 'border-gray-200 text-gray-600 hover:border-[#d4af37] hover:text-[#d4af37] hover:bg-white shadow-sm'} transition-all`}
                                            >
                                                <ChevronLeft className="h-5 w-5" />
                                            </button>
                                            <span className="text-[10px] font-bold uppercase tracking-widest text-gray-400">
                                                Page {currentPage} of {totalPages}
                                            </span>
                                            <button
                                                onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                                                disabled={currentPage === totalPages}
                                                className={`flex items-center justify-center h-10 w-10 rounded-full border ${currentPage === totalPages ? 'border-gray-100 text-gray-300' : 'border-gray-200 text-gray-600 hover:border-[#d4af37] hover:text-[#d4af37] hover:bg-white shadow-sm'} transition-all`}
                                            >
                                                <ChevronRight className="h-5 w-5" />
                                            </button>
                                        </div>
                                    )}

                                </div>
                            ) : (
                                <div className="flex flex-col items-center justify-center text-center h-full text-gray-400 py-12">
                                    <div className="w-24 h-24 bg-gray-50 rounded-full flex items-center justify-center border border-gray-100 mb-6 group-hover:scale-110 transition-transform duration-500 shadow-inner">
                                        <MapPin strokeWidth={1.5} className="h-10 w-10 text-gray-300" />
                                    </div>
                                    <h3 className="text-xl font-serif font-bold text-gray-900 mb-3">Explore the Map</h3>
                                    <p className="text-sm max-w-[280px] leading-relaxed">
                                        Navigate the map and click on a highlighted area to view its historical records and details.
                                    </p>
                                </div>
                            )}
                        </div>
                    </div>
                </aside>

                {/* MAP CONTAINER */}
                <div className="flex-grow h-[600px] lg:h-[800px] bg-white rounded-[2.5rem] shadow-[0_8px_40px_rgb(0,0,0,0.03)] border border-gray-100 overflow-hidden relative p-4 flex flex-col">
                    <div className="relative w-full h-full rounded-[2rem] overflow-hidden bg-[#e8e6e1]">
                        <InteractiveSvgMap
                            src="/cemetero-map.svg"
                            className="absolute inset-0"
                            selectedPointId={selectedPointId}
                            onPointSelect={setSelectedPointId}
                        />
                    </div>
                </div>
            </main>
        </div>
    );
}