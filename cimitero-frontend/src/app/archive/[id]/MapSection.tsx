// src/app/archive/[id]/MapSection.tsx
"use client";

import React, { useState } from 'react';
import { MapPin, ChevronDown, ChevronUp } from 'lucide-react';
import DetailSvgMap from '@/src/components/map/DetailSvgMap';

interface MapSectionProps {
    locationText: string;
    mapIdToSelect: string;
}

export default function MapSection({ locationText, mapIdToSelect }: MapSectionProps) {
    const [isMapVisible, setIsMapVisible] = useState(false);

    return (
        <div className="flex flex-col bg-white border border-gray-200 rounded-2xl shadow-sm overflow-hidden w-full transition-all duration-300">
            {/* TOGGLE BUTTON */}
            <button
                onClick={() => setIsMapVisible(!isMapVisible)}
                className={`group flex flex-col sm:flex-row items-start sm:items-center justify-between hover:bg-gray-50 px-6 py-5 w-full text-left transition-colors ${
                    isMapVisible ? 'bg-gray-50 border-b border-gray-100' : 'bg-white'
                }`}
            >
                <div className="flex items-center gap-4">
                    <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-full bg-white text-[#d4af37] border border-gray-200 group-hover:scale-110 transition-transform shadow-sm">
                        <MapPin className="h-5 w-5" />
                    </div>
                    <div className="flex flex-col">
                        <span className="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Cemetery Location</span>
                        <span className="text-base font-serif font-bold text-gray-900">{locationText}</span>
                    </div>
                </div>
                <div className="flex items-center gap-2 text-[10px] font-bold uppercase tracking-widest text-[#d4af37] mt-3 sm:mt-0 sm:ml-auto">
                    {isMapVisible ? "Hide Map" : "View on Map"}
                    {isMapVisible ? (
                        <ChevronUp className="h-4 w-4 transition-transform" />
                    ) : (
                        <ChevronDown className="h-4 w-4 transition-transform" />
                    )}
                </div>
            </button>

            {/* MAP CONTAINER */}
            {isMapVisible && (
                <div className="relative flex flex-col w-full animate-in fade-in slide-in-from-top-2 duration-300">
                    <div className="relative w-full h-[450px] bg-[#f7f5f0]">
                        <DetailSvgMap
                            src="/cemetero-map.svg"
                            selectedPointId={mapIdToSelect}
                            className="absolute inset-0"
                        />
                    </div>
                </div>
            )}
        </div>
    );
}