"use client";

import React from "react";
import Link from "next/link";
import { ArrowRight, BookOpen, Map, Cuboid, Compass } from "lucide-react";

const FEATURES = [
    {
        step: "01",
        title: "Digital Archive",
        description: "Search deceased records and explore the rich heritage of funerary architecture through our catalog.",
        icon: BookOpen,
        href: "/archive",
        bgGradient: "from-white to-[#fdfbf2]",
        accentBg: "bg-[#d4af37]",
        accentText: "text-[#b8860b]",
        glowEffect: "group-hover:shadow-[0_15px_40px_rgba(212,175,55,0.15)]",
        borderColor: "border-gray-200 hover:border-[#d4af37]/50",
    },
    {
        step: "02",
        title: "Interactive Map",
        description: "Navigate the grounds with digital visitor maps and thematic mobile guides directly on your device.",
        icon: Map,
        href: "/map",
        bgGradient: "from-white to-[#fdfbf2]",
        accentBg: "bg-[#d4af37]",
        accentText: "text-[#b8860b]",
        glowEffect: "group-hover:shadow-[0_15px_40px_rgba(212,175,55,0.15)]",
        borderColor: "border-gray-200 hover:border-[#d4af37]/50",
    },
    {
        step: "03",
        title: "Digital Twin",
        description: "Experience high-fidelity 3D models and digital reconstructions of historical monuments and graves.",
        icon: Cuboid,
        href: "/digital-twin",
        bgGradient: "from-white to-[#fdfbf2]",
        accentBg: "bg-[#d4af37]",
        accentText: "text-[#b8860b]",
        glowEffect: "group-hover:shadow-[0_15px_40px_rgba(212,175,55,0.15)]",
        borderColor: "border-gray-200 hover:border-[#d4af37]/50",
    },
    {
        step: "04",
        title: "Cultural Tours",
        description: "Discover city tourism network integrations, QR code information, and carefully curated itineraries.",
        icon: Compass,
        href: "/tours",
        bgGradient: "from-white to-[#fdfbf2]",
        accentBg: "bg-[#d4af37]",
        accentText: "text-[#b8860b]",
        glowEffect: "group-hover:shadow-[0_15px_40px_rgba(212,175,55,0.15)]",
        borderColor: "border-gray-200 hover:border-[#d4af37]/50",
    }
];

export const FeaturesSection = () => {
    return (
        <section className="relative py-24 bg-gray-50 z-10 overflow-hidden">
            <div className="mx-auto max-w-7xl px-6 lg:px-8">

                <div className="mb-24 flex flex-col items-center text-center relative z-10">
                    <p className="text-[#b8860b] font-bold tracking-[0.2em] uppercase mb-4 text-sm">
                        Digital Innovation
                    </p>
                    <h2 className="text-4xl md:text-5xl font-serif font-bold tracking-tight mb-6 text-gray-900">
                        Heritage Valorization
                    </h2>
                    <div className="w-16 h-1 bg-[#d4af37] mx-auto mb-6"></div>
                    <p className="max-w-2xl text-lg text-gray-600 leading-relaxed">
                        Integrating contemporary tourist strategies to preserve the tangible and intangible assets inherited from the past.
                    </p>
                </div>

                <div className="grid gap-x-12 gap-y-24 lg:grid-cols-2 max-w-5xl mx-auto relative z-10 pb-8 mt-12">
                    {FEATURES.map((item, idx) => {
                        const IconComponent = item.icon;
                        return (
                            <Link
                                key={idx}
                                href={item.href}
                                className={`group relative flex flex-col rounded-[2.5rem] border bg-gradient-to-br ${item.bgGradient} p-8 lg:p-10 shadow-lg transition-all duration-700 hover:-translate-y-3 cursor-pointer ${item.borderColor} ${item.glowEffect}`}
                            >
                                <div className="absolute inset-0 rounded-[2.5rem] overflow-hidden pointer-events-none">
                                    <div className="absolute -right-4 top-8 select-none font-serif text-[10rem] font-bold leading-none text-black/[0.03] transition-all duration-700 group-hover:text-black/[0.06] group-hover:scale-110 group-hover:-translate-x-4">
                                        {item.step}
                                    </div>
                                    <div className={`absolute top-20 left-0 w-1.5 h-24 transition-all duration-700 origin-top scale-y-0 group-hover:scale-y-100 ${item.accentBg} opacity-80`} />
                                </div>

                                <div className={`absolute -top-12 left-8 h-24 w-24 rounded-2xl bg-white border border-gray-100 p-6 shadow-md transition-all duration-500 group-hover:scale-110 group-hover:rotate-6 z-20 flex items-center justify-center`}>
                                    <IconComponent className={`w-full h-full ${item.accentText}`} strokeWidth={1.5} />
                                </div>

                                <div className="h-12 w-full shrink-0" />

                                <div className="relative z-10 flex flex-col grow mt-4">
                                    <h3 className="mb-4 text-2xl lg:text-3xl font-serif font-bold text-gray-900 uppercase tracking-wide">
                                        {item.title}
                                    </h3>

                                    <p className="text-base text-gray-600 leading-relaxed mb-10 transition-colors duration-500 group-hover:text-gray-900">
                                        {item.description}
                                    </p>

                                    <div className="mt-auto flex items-center gap-4 opacity-0 -translate-x-5 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-500 delay-100">
                                        <span className={`text-xs font-bold uppercase tracking-widest ${item.accentText}`}>
                                            Explore Details
                                        </span>
                                        <div className="flex h-10 w-10 items-center justify-center rounded-full bg-gray-50 border border-gray-200 text-gray-400 transition-all duration-300 group-hover:bg-[#d4af37] group-hover:border-[#d4af37] group-hover:text-white group-hover:scale-110">
                                            <ArrowRight className="h-5 w-5" />
                                        </div>
                                    </div>
                                </div>
                            </Link>
                        );
                    })}
                </div>
            </div>
        </section>
    );
};