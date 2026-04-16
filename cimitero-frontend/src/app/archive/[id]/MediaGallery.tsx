"use client";

import React, { useState, useEffect } from 'react';
import Image from 'next/image';
import {
    FileText, Download, ExternalLink, Image as ImageIcon, Eye, X,
    Map as MapIcon, Landmark, Users, Flame, Route, FolderOpen
} from 'lucide-react';
import { OmekaMedia } from '@/src/lib/omeka';

interface MediaGalleryProps {
    media: OmekaMedia[];
    fallbackTitle: string;
    isCollectionEntity?: boolean;
}

const getCollectionIcon = (title: string) => {
    const t = title.toLowerCase();
    if (t.includes('map')) return MapIcon;
    if (t.includes('architecture')) return Landmark;
    if (t.includes('figures')) return Users;
    if (t.includes('remembrance')) return Flame;
    if (t.includes('tour')) return Route;
    return FolderOpen;
};

export const MediaGallery: React.FC<MediaGalleryProps> = ({ media, fallbackTitle, isCollectionEntity }) => {
    const [activeIndex, setActiveIndex] = useState(0);
    const [showPdf, setShowPdf] = useState(false);

    useEffect(() => {
        setShowPdf(false);
    }, [activeIndex]);

    if (!media || media.length === 0) {
        if (isCollectionEntity) {
            const Icon = getCollectionIcon(fallbackTitle);
            return (
                <div className="w-full h-full min-h-[500px] md:min-h-full flex flex-col items-center justify-center bg-[#0a0a0a] relative overflow-hidden p-8">
                    <div className="absolute inset-0 bg-gradient-to-br from-[#0a0a0a] via-[#1a1a1a] to-[#2a132b] opacity-90"></div>
                    <div className="relative z-10 w-32 h-32 bg-white/5 backdrop-blur-sm rounded-full flex items-center justify-center mb-8 border border-white/10 shadow-[0_0_40px_rgb(212,175,55,0.15)] transition-transform duration-700">
                        <Icon strokeWidth={1} className="h-16 w-16 text-[#d4af37]" />
                    </div>
                    <h2 className="relative z-10 text-3xl text-center font-serif font-bold text-white mb-3 max-w-sm">
                        {fallbackTitle}
                    </h2>
                    <p className="relative z-10 text-[10px] text-white/50 uppercase tracking-[0.2em] font-bold">
                        Thematic Collection
                    </p>
                </div>
            );
        }

        return (
            <div className="w-full h-full min-h-[500px] flex flex-col items-center justify-center bg-transparent p-8">
                <div className="w-24 h-24 bg-white rounded-[2rem] shadow-[0_2px_15px_rgb(0,0,0,0.04)] flex items-center justify-center mb-4 border border-gray-100">
                    <ImageIcon strokeWidth={1} className="h-10 w-10 text-gray-300" />
                </div>
                <p className="text-sm text-gray-400 font-medium">No media files available for this record.</p>
            </div>
        );
    }

    const activeMedia = media[activeIndex];
    const isPdf = activeMedia.mimeType === 'application/pdf';

    const imageUrl = activeMedia.originalUrl || activeMedia.thumbnailUrl || activeMedia.squareUrl;
    const isImage = !activeMedia.isDocument && imageUrl;

    const renderMainMedia = () => {
        if (isImage) {
            return (
                <div className="relative w-full flex-grow bg-white p-3 sm:p-4 rounded-[2.5rem] shadow-[0_10px_40px_rgb(0,0,0,0.05)] border border-gray-100 group flex flex-col">
                    <div className="relative w-full flex-grow min-h-[350px] md:min-h-[400px] rounded-[1.5rem] overflow-hidden bg-gray-50/50">
                        <Image
                            src={imageUrl as string}
                            alt={activeMedia.title || fallbackTitle}
                            fill
                            unoptimized
                            className="object-contain transition-transform duration-700 group-hover:scale-[1.02]"
                        />
                    </div>

                    {activeMedia.originalUrl && (
                        <a
                            href={activeMedia.originalUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="absolute bottom-8 right-8 bg-white/90 hover:bg-[#6a306c] text-gray-700 hover:text-white backdrop-blur-md p-3.5 rounded-2xl shadow-lg transition-all duration-300 opacity-0 group-hover:opacity-100 translate-y-2 group-hover:translate-y-0"
                            title="View Full Resolution"
                        >
                            <ExternalLink className="w-5 h-5" />
                        </a>
                    )}
                </div>
            );
        }

        if (isPdf) {
            if (showPdf) {
                return (
                    <div className="relative w-full flex-grow rounded-[2.5rem] overflow-hidden shadow-[0_10px_40px_rgb(0,0,0,0.05)] border border-gray-100 bg-white flex flex-col animate-in fade-in zoom-in-95 duration-300">
                        <div className="bg-gray-50 border-b border-gray-100 p-4 px-6 flex justify-between items-center z-10">
              <span className="text-xs font-bold uppercase tracking-widest text-gray-500 truncate pr-4">
                {activeMedia.title || "PDF Document"}
              </span>
                            <div className="flex items-center gap-4">
                                <a
                                    href={activeMedia.originalUrl}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="text-gray-400 hover:text-[#d4af37] transition-colors"
                                    title="Open in new tab"
                                >
                                    <ExternalLink className="w-4 h-4" />
                                </a>
                                <div className="w-px h-4 bg-gray-200"></div>
                                <button
                                    onClick={() => setShowPdf(false)}
                                    className="text-gray-400 hover:text-red-500 transition-colors flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-wider"
                                >
                                    <X className="w-4 h-4" />
                                    Close
                                </button>
                            </div>
                        </div>
                        <iframe
                            src={`${activeMedia.originalUrl}#view=FitH`}
                            title={activeMedia.title || "PDF Document"}
                            className="w-full flex-grow border-none bg-gray-100/50"
                        />
                    </div>
                );
            }

            return (
                <div className="flex flex-col items-center justify-center text-center w-full max-w-md bg-white p-12 rounded-[3rem] shadow-[0_10px_40px_rgb(0,0,0,0.03)] border border-gray-100 m-auto animate-in fade-in duration-300">
                    <div className="w-28 h-28 bg-gray-50 rounded-[2rem] border border-gray-100 flex items-center justify-center mb-6 relative overflow-hidden">
                        <FileText strokeWidth={1} className="h-12 w-12 text-[#6a306c]/40 transition-all duration-500" />
                    </div>
                    <span className="text-[10px] font-bold uppercase tracking-widest text-[#d4af37] mb-3">PDF Document</span>
                    <h3 className="text-2xl font-serif font-bold text-gray-900 mb-4 truncate w-full">
                        {activeMedia.title || "Document File"}
                    </h3>
                    <p className="text-sm text-gray-500 mb-10 leading-relaxed">
                        This record contains a PDF document. You can preview it directly here or download it to your device.
                    </p>
                    <div className="flex flex-col w-full gap-3">
                        <button
                            onClick={() => setShowPdf(true)}
                            className="w-full flex items-center justify-center gap-2 bg-[#6a306c] hover:bg-[#5a285b] text-white px-6 py-4 rounded-2xl font-bold text-xs uppercase tracking-widest transition-all shadow-md hover:shadow-lg hover:-translate-y-0.5"
                        >
                            <Eye className="w-4 h-4" />
                            Preview PDF
                        </button>
                        <a
                            href={activeMedia.originalUrl}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="w-full flex items-center justify-center gap-2 bg-white border border-gray-200 hover:border-[#d4af37] text-gray-600 hover:text-[#d4af37] px-6 py-4 rounded-2xl font-bold text-xs uppercase tracking-widest transition-all shadow-sm hover:shadow"
                        >
                            <Download className="w-4 h-4" />
                            Download
                        </a>
                    </div>
                </div>
            );
        }

        return (
            <div className="flex flex-col items-center justify-center text-center w-full max-w-md bg-white p-12 rounded-[3rem] shadow-[0_10px_40px_rgb(0,0,0,0.03)] border border-gray-100 m-auto">
                <div className="w-28 h-28 bg-gray-50 rounded-[2rem] border border-gray-100 flex items-center justify-center mb-6 relative overflow-hidden">
                    <FileText strokeWidth={1} className="h-12 w-12 text-gray-300 transition-all duration-500" />
                </div>
                <span className="text-[10px] font-bold uppercase tracking-widest text-[#d4af37] mb-3">{activeMedia.mimeType}</span>
                <h3 className="text-2xl font-serif font-bold text-gray-900 mb-3 truncate w-full">
                    {activeMedia.title || "Document File"}
                </h3>
                <p className="text-sm text-gray-500 mb-10 leading-relaxed">
                    This file format requires an external application to be viewed properly.
                </p>
                <a
                    href={activeMedia.originalUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="w-full flex items-center justify-center gap-2 bg-[#6a306c] hover:bg-[#5a285b] text-white px-6 py-4 rounded-2xl font-bold text-xs uppercase tracking-widest transition-all shadow-md hover:shadow-lg hover:-translate-y-0.5"
                >
                    <Download className="w-4 h-4" />
                    Download File
                </a>
            </div>
        );
    };

    return (
        <div className="w-full flex flex-col h-fit bg-transparent">
            <div className={`relative w-full flex flex-col p-8 lg:p-12 transition-all duration-500 ${showPdf ? 'min-h-[600px] lg:min-h-[800px]' : 'min-h-[500px]'}`}>
                {renderMainMedia()}
            </div>

            {media.length > 1 && (
                <div className="w-full px-8 lg:px-12 pb-10 mt-auto">
                    <p className="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-4 ml-1">
                        Gallery ({media.length} files)
                    </p>
                    <div className="flex gap-4 overflow-x-auto pb-4 custom-scrollbar">
                        {media.map((m, idx) => {
                            const isActive = activeIndex === idx;
                            return (
                                <button
                                    key={m.id || idx}
                                    onClick={() => setActiveIndex(idx)}
                                    className={`relative shrink-0 w-24 h-24 rounded-2xl overflow-hidden transition-all duration-300 ${
                                        isActive
                                            ? 'border-[3px] border-[#6a306c] shadow-[0_4px_15px_rgb(106,48,108,0.2)] scale-100'
                                            : 'border-2 border-transparent bg-white shadow-sm hover:border-[#d4af37]/50 hover:shadow-md scale-95 opacity-80 hover:opacity-100'
                                    }`}
                                >
                                    {!m.isDocument && (m.squareUrl || m.thumbnailUrl) ? (
                                        <Image
                                            src={m.squareUrl || m.thumbnailUrl!}
                                            alt={`Thumbnail ${idx + 1}`}
                                            fill
                                            unoptimized
                                            className="object-cover"
                                        />
                                    ) : (
                                        <div className="w-full h-full flex flex-col items-center justify-center bg-gray-50 text-[#6a306c]/40">
                                            <FileText className="w-6 h-6 mb-1.5" />
                                            <span className="text-[9px] font-bold uppercase tracking-wider">
                        {m.mimeType === 'application/pdf' ? 'PDF' : 'DOC'}
                      </span>
                                        </div>
                                    )}

                                    {!isActive && (
                                        <div className="absolute inset-0 bg-black/5 hover:bg-transparent transition-colors" />
                                    )}
                                </button>
                            );
                        })}
                    </div>
                </div>
            )}
        </div>
    );
};