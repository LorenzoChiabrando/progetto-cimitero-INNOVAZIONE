"use client";

import { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { Menu, X, User } from "lucide-react";

const NAV_ITEMS = [
    { href: "/archive", label: "Digital Archive" },
    { href: "/map", label: "Interactive Map" },
];

export const Header = () => {
    const [isMobileOpen, setIsMobileOpen] = useState(false);
    const [isVisible, setIsVisible] = useState(true);
    const lastScrollY = useRef(0);

    useEffect(() => {
        const handleScroll = () => {
            const currentScrollY = window.scrollY;

            if (currentScrollY > lastScrollY.current && currentScrollY > 80) {
                setIsVisible(false);
            } else {
                setIsVisible(true);
            }

            lastScrollY.current = currentScrollY;
        };

        window.addEventListener("scroll", handleScroll, { passive: true });
        return () => window.removeEventListener("scroll", handleScroll);
    }, []);

    return (
        <>
            <header
                className={`fixed top-0 z-50 w-full bg-[#0a0a0a] border-b border-[#d4af37]/20 shadow-md transition-transform duration-300 ease-in-out ${
                    isVisible ? "translate-y-0" : "-translate-y-full"
                }`}
            >
                <div className="flex w-full items-center justify-between px-6 lg:px-12 max-w-7xl mx-auto py-3">

                    <Link href="/" className="flex items-center gap-3 lg:gap-4 group shrink-0">
                        <img
                            src="/icona_cemetero.png"
                            alt="Logo Cementerio General"
                            className="w-12 md:w-14 h-auto object-contain transition-transform group-hover:scale-105"
                        />
                        <div className="flex flex-col text-white">
                            <span className="font-serif text-lg md:text-xl tracking-[0.15em] uppercase whitespace-nowrap">
                                Cementerio General
                            </span>
                        </div>
                    </Link>

                    <nav className="hidden lg:flex items-center gap-6">
                        {NAV_ITEMS.map((item) => (
                            <Link
                                key={item.href}
                                href={item.href}
                                className="text-xs font-bold tracking-[0.1em] uppercase text-white/80 hover:text-[#d4af37] transition-colors whitespace-nowrap"
                            >
                                {item.label}
                            </Link>
                        ))}

                        <div className="h-5 w-px bg-white/10 mx-1" />

                        <button className="group flex items-center gap-2 border border-[#d4af37]/50 text-[#d4af37] px-5 py-1.5 rounded-full hover:bg-[#d4af37] hover:text-black hover:border-[#d4af37] transition-all duration-300 uppercase tracking-widest text-xs font-bold whitespace-nowrap">
                            <User size={14} />
                            <span>Sign In</span>
                        </button>
                    </nav>

                    <button
                        className="lg:hidden p-1.5 text-white/80 hover:text-[#d4af37] transition-colors"
                        onClick={() => setIsMobileOpen(!isMobileOpen)}
                        aria-label={isMobileOpen ? "Chiudi menu" : "Apri menu"}
                    >
                        {isMobileOpen ? <X size={24} /> : <Menu size={24} />}
                    </button>
                </div>

                <div
                    className={`lg:hidden absolute top-full left-0 w-full bg-[#0a0a0a] border-b border-[#d4af37]/10 transition-all duration-300 overflow-hidden ${
                        isMobileOpen ? "max-h-80 opacity-100" : "max-h-0 opacity-0"
                    }`}
                >
                    <div className="flex flex-col px-6 py-5 space-y-5">
                        {NAV_ITEMS.map((item) => (
                            <Link
                                key={item.href}
                                href={item.href}
                                className="block text-base font-serif text-white/90 hover:text-[#d4af37]"
                                onClick={() => setIsMobileOpen(false)}
                            >
                                {item.label}
                            </Link>
                        ))}
                        <div className="pt-5 border-t border-white/10">
                            <button className="w-full flex justify-center items-center gap-2.5 bg-[#d4af37] text-black px-5 py-2.5 rounded-full uppercase tracking-widest text-xs font-bold hover:bg-[#c4a030] transition-colors">
                                <User size={16} />
                                <span>Sign In / Register</span>
                            </button>
                        </div>
                    </div>
                </div>
            </header>
        </>
    );
};