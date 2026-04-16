import Image from 'next/image';
import { Header } from '@/src/components/layout/Header';
import { FeaturesSection } from '@/src/components/home/FeatureSection';

export default function Home() {
    return (
        <div className="flex flex-col min-h-screen bg-white">
            <Header />

            <section className="relative w-full h-[calc(100vh-80px)] mt-[80px] flex flex-col justify-center items-center text-center px-4 overflow-hidden bg-black">
                <Image
                    src="/cimitero.jpg"
                    alt="Cementerio General Header"
                    fill
                    priority
                    quality={100}
                    className="object-contain md:object-cover object-center md:object-[center_30%]"
                />

                <div className="absolute inset-0 bg-black/50 z-10"></div>

                <div className="relative z-20 max-w-4xl">
                    <p className="text-[#d4af37] font-bold tracking-[0.3em] uppercase mb-4 text-sm md:text-base drop-shadow-md">
                        Founded in 1821
                    </p>

                    <h1 className="text-5xl md:text-7xl lg:text-8xl font-serif font-bold text-white mb-6 leading-tight drop-shadow-2xl">
                        Cementerio <span className="text-[#d4af37]">General</span>
                    </h1>

                    <p className="text-lg md:text-xl lg:text-2xl text-gray-100 font-light max-w-2xl mx-auto leading-relaxed drop-shadow-lg">
                        Preserving History, Embracing the Future.
                    </p>
                </div>

                <a
                    href="#main-content"
                    className="absolute bottom-10 left-1/2 transform -translate-x-1/2 z-20 animate-bounce flex flex-col items-center opacity-80 hover:opacity-100 transition-opacity"
                    aria-label="Scroll down to main content"
                >
          <span className="text-white text-xs uppercase tracking-widest mb-2 font-medium">
            Scroll
          </span>
                    <svg
                        className="w-6 h-6 text-white"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            strokeWidth={2}
                            d="M19 14l-7 7m0 0l-7-7m7 7V3"
                        />
                    </svg>
                </a>
            </section>

            <main id="main-content" className="relative z-20 bg-white w-full">
                <FeaturesSection />
            </main>
        </div>
    );
}