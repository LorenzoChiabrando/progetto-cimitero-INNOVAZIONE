import type { Metadata } from 'next';
import './globals.css';
import { Footer } from '@/src/components/layout/Footer';

export const metadata: Metadata = {
    title: 'Cementerio General | Portale Servizi',
    description: 'Archivio digitale e servizi cimiteriali online',
};

export default function RootLayout({
                                       children,
                                   }: {
    children: React.ReactNode;
}) {
    return (
        <html lang="it">
        <body className="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">
        <div className="grow">
            {children}
        </div>
        <Footer />
        </body>
        </html>
    );
}