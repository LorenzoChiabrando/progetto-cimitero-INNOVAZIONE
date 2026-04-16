import Link from "next/link";
import Image from "next/image";

export const Footer = () => {
    return (
        <footer className="bg-[#0a0a0a] text-white border-t border-white/10">
            <div className="max-w-7xl mx-auto px-6 py-16 lg:py-20">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-12 lg:gap-8">
                    <div className="flex flex-col items-start">
                        <div className="relative mb-6 h-16 w-16 flex items-center justify-center">
                            <Image
                                src="/icona_cemetero.png"
                                alt="Logo Cementerio General"
                                fill
                                unoptimized
                                className="object-contain"
                            />
                        </div>

                        <h3 className="font-serif text-2xl mb-4">Cementerio General</h3>

                        <p className="text-sm text-white/60 leading-relaxed max-w-xs">
                            Preserving the tangible and intangible assets inherited from the past.
                            A digital innovation project for the renovation and reuse of historical spaces.
                        </p>
                    </div>

                    <div className="flex flex-col items-start lg:items-center">
                        <h4 className="text-[#d4af37] uppercase tracking-widest text-xs font-bold mb-6">
                            Explore
                        </h4>

                        <nav className="flex flex-col space-y-4">
                            <Link
                                href="/archive"
                                className="text-white/70 hover:text-white transition-colors text-sm uppercase tracking-wider"
                            >
                                Digital Archive
                            </Link>

                            <Link
                                href="#map"
                                className="text-white/70 hover:text-white transition-colors text-sm uppercase tracking-wider"
                            >
                                Interactive Map
                            </Link>

                            <Link
                                href="#visit"
                                className="text-white/70 hover:text-white transition-colors text-sm uppercase tracking-wider"
                            >
                                Plan Your Visit
                            </Link>

                            <Link
                                href="#contact"
                                className="text-white/70 hover:text-white transition-colors text-sm uppercase tracking-wider"
                            >
                                Support & Contact
                            </Link>
                        </nav>
                    </div>

                    <div className="flex flex-col items-start lg:items-end">
                        <h4 className="text-[#d4af37] uppercase tracking-widest text-xs font-bold mb-6 lg:text-right">
                            Project Partners
                        </h4>

                        <div className="flex flex-wrap gap-4 sm:gap-6 items-center lg:justify-end">
                            <div className="relative h-20 w-40 sm:h-24 sm:w-48 bg-white/5 rounded-xl p-3 border border-white/10 hover:bg-white/10 transition-colors">
                                <Image
                                    src="/logo_unito.svg"
                                    alt="Università di Torino"
                                    fill
                                    unoptimized
                                    sizes="(max-width: 768px) 160px, 192px"
                                    className="object-contain p-2"
                                />
                            </div>

                            <div className="relative h-20 w-40 sm:h-24 sm:w-48 bg-white/5 rounded-xl p-3 border border-white/10 hover:bg-white/10 transition-colors">
                                <Image
                                    src="/logo_cile.png"
                                    alt="USACH - Universidad de Santiago de Chile"
                                    fill
                                    unoptimized
                                    sizes="(max-width: 768px) 160px, 192px"
                                    className="object-contain p-2"
                                />
                            </div>
                        </div>

                        <p className="text-[10px] text-white/40 uppercase tracking-[0.2em] mt-6 lg:text-right max-w-[250px]">
                            Digital Innovation in the Living Spaces Research Group
                        </p>
                    </div>
                </div>

                <div className="mt-16 pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center gap-4">
                    <p className="text-xs text-white/40 uppercase tracking-widest">
                        © {new Date().getFullYear()} Cementerio General. All rights reserved.
                    </p>

                    <div className="flex gap-6">
                        <Link
                            href="/privacy"
                            className="text-xs text-white/40 hover:text-white uppercase tracking-widest"
                        >
                            Privacy Policy
                        </Link>

                        <Link
                            href="/terms"
                            className="text-xs text-white/40 hover:text-white uppercase tracking-widest"
                        >
                            Terms of Use
                        </Link>
                    </div>
                </div>
            </div>
        </footer>
    );
};