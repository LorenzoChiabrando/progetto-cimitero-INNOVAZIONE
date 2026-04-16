import React from 'react';
import Image from 'next/image';
import { Header } from '@/src/components/layout/Header';
import { getOmekaItems, OmekaItem } from '@/src/lib/omeka';
import { ArchiveClient } from './ArchiveClient';

export const dynamic = 'force-dynamic';

export default async function ArchivePage() {
    const items: OmekaItem[] = await getOmekaItems();

    return (
        <div className="flex flex-col min-h-screen bg-[#fdfcfaf0]">
            <Header />

            <div className="relative w-full border-b border-[#d4af37]/20 pt-40 pb-24 px-6 overflow-hidden flex justify-center">
                <Image
                    src="/cimitero.png"
                    alt="Archive Background"
                    fill
                    priority
                    unoptimized
                    className="object-cover object-center"
                />

                <div className="absolute inset-0 bg-gradient-to-r from-[#0a0a0a]/90 via-[#0a0a0a]/70 to-[#0a0a0a]/90 z-10"></div>

                <div className="relative z-20 w-full max-w-[1600px] flex flex-col items-center text-center lg:items-start lg:text-left px-4 md:px-8">
                    <p className="text-[#d4af37] font-bold tracking-[0.2em] uppercase mb-4 text-xs md:text-sm drop-shadow-md">
                        Explore the Collections
                    </p>
                    <h1 className="text-4xl md:text-5xl lg:text-7xl font-serif font-bold text-white tracking-tight drop-shadow-xl mb-4">
                        Digital Archive
                    </h1>
                    <p className="text-gray-300 max-w-2xl font-light leading-relaxed text-sm md:text-lg drop-shadow-md">
                        Discover the historical records, funerary architecture, and the legacy of the prominent figures resting in the Cementerio General.
                    </p>
                </div>
            </div>

            <ArchiveClient initialItems={items} />
        </div>
    );
}