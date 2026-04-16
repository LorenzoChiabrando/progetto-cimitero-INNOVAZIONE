import React from 'react';

interface ServiceCardProps {
    icon: React.ReactNode;
    title: string;
    description: string;
}

export const ServiceCard: React.FC<ServiceCardProps> = ({ icon, title, description }) => {
    return (
        <button className="group flex flex-col items-start p-8 bg-white shadow-sm hover:shadow-2xl border-t-4 border-transparent hover:border-purple-700 transition-all duration-300 min-h-[220px] w-full text-left">
            <div className="text-4xl mb-6 text-gray-700 group-hover:text-purple-700 transition-colors duration-300">
                {icon}
            </div>
            <h3 className="text-lg font-serif font-bold text-gray-900 mb-2 group-hover:text-purple-700 transition-colors duration-300">
                {title}
            </h3>
            <p className="text-sm text-gray-500 leading-relaxed">
                {description}
            </p>
        </button>
    );
};