"use client";

import React from "react";

interface CheckboxProps {
    label: string;
    checked?: boolean;
    onChange?: (checked: boolean) => void;
}

export const Checkbox: React.FC<CheckboxProps> = ({ label, checked = false, onChange }) => {
    return (
        <label className="flex items-center space-x-3 cursor-pointer group py-1">
            <div className={`relative flex items-center justify-center w-5 h-5 rounded border transition-all duration-200 ${checked ? 'border-[#6a306c] bg-[#6a306c]' : 'border-gray-300 bg-white group-hover:border-[#6a306c]'}`}>
                <input
                    type="checkbox"
                    checked={checked}
                    onChange={(e) => onChange && onChange(e.target.checked)}
                    className="peer sr-only"
                />
                {checked && (
                    <svg className="w-3.5 h-3.5 text-white stroke-[3]" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                    </svg>
                )}
            </div>
            <span className={`text-sm transition-colors font-medium ${checked ? 'text-gray-900 font-bold' : 'text-gray-600 group-hover:text-gray-900'}`}>
                {label}
            </span>
        </label>
    );
};