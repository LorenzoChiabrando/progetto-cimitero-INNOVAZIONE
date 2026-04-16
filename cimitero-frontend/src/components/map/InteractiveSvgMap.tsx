// src/components/map/InteractiveSvgMap.tsx
"use client";

import React, { useEffect, useRef, useState } from "react";

type Props = {
    src: string;
    className?: string;
    selectedPointId?: string | null;
    onPointSelect?: (pointId: string) => void;
};

type ViewBoxState = { x: number; y: number; width: number; height: number; };
type Size = { width: number; height: number; };

const MIN_ZOOM_RATIO = 0.03;
const MAX_ZOOM_RATIO = 1.0;

export default function InteractiveSvgMap({
                                              src,
                                              className = "",
                                              selectedPointId = null,
                                              onPointSelect
                                          }: Props) {
    const wrapperRef = useRef<HTMLDivElement | null>(null);
    const svgHostRef = useRef<HTMLDivElement | null>(null);
    const svgRef = useRef<SVGSVGElement | null>(null);
    const originalViewBoxRef = useRef<ViewBoxState | null>(null);
    const currentViewBoxRef = useRef<ViewBoxState | null>(null);
    const pathsRef = useRef<SVGPathElement[]>([]);
    const selectedPathRef = useRef<SVGPathElement | null>(null);

    const [selectedPathId, setSelectedPathId] = useState<string | null>(null);
    const [svgLoaded, setSvgLoaded] = useState(false);
    const [, setWrapperSize] = useState<Size>({ width: 0, height: 0 });

    function styleNonInteractive(el: SVGPathElement) {
        el.style.stroke = "#9ca3af";
        el.style.strokeWidth = "3";
        el.style.fill = "transparent";
        el.style.pointerEvents = "none";
        el.style.vectorEffect = "non-scaling-stroke";
    }

    function styleDefault(el: SVGPathElement) {
        el.style.stroke = "#1f2937";
        el.style.strokeWidth = "3";
        el.style.fill = "rgba(255, 255, 255, 0.4)";
        el.style.cursor = "pointer";
        el.style.pointerEvents = "all";
        el.style.vectorEffect = "non-scaling-stroke";
        el.style.transition = "stroke 120ms ease, fill 120ms ease, stroke-width 120ms ease";
    }

    function styleDimmed(el: SVGPathElement) {
        el.style.stroke = "#9ca3af";
        el.style.strokeWidth = "3";
        el.style.fill = "transparent";
        el.style.cursor = "pointer";
        el.style.pointerEvents = "all";
        el.style.vectorEffect = "non-scaling-stroke";
        el.style.transition = "stroke 120ms ease, fill 120ms ease, stroke-width 120ms ease";
    }

    function styleHover(el: SVGPathElement) {
        el.style.stroke = "#d4af37";
        el.style.strokeWidth = "5";
        el.style.fill = "rgba(212, 175, 55, 0.2)";
    }

    function styleSelected(el: SVGPathElement) {
        el.style.stroke = "#d4af37";
        el.style.strokeWidth = "6";
        el.style.fill = "rgba(255, 215, 0, 0.5)";
    }

    function clearPathSelection() {
        pathsRef.current.forEach(p => styleDefault(p));
        selectedPathRef.current = null;
        setSelectedPathId(null);
    }

    function setViewBox(vb: ViewBoxState) {
        currentViewBoxRef.current = vb;
        if (svgRef.current) {
            svgRef.current.setAttribute("viewBox", `${vb.x} ${vb.y} ${vb.width} ${vb.height}`);
        }
    }

    function clampViewBox(vb: ViewBoxState): ViewBoxState {
        const original = originalViewBoxRef.current;
        if (!original) return vb;
        const minWidth = original.width * MIN_ZOOM_RATIO;
        const minHeight = original.height * MIN_ZOOM_RATIO;
        const maxWidth = original.width * MAX_ZOOM_RATIO;
        const maxHeight = original.height * MAX_ZOOM_RATIO;

        const width = Math.max(minWidth, Math.min(maxWidth, vb.width));
        const height = Math.max(minHeight, Math.min(maxHeight, vb.height));
        const maxX = original.x + original.width - width;
        const maxY = original.y + original.height - height;
        const x = Math.max(original.x, Math.min(maxX, vb.x));
        const y = Math.max(original.y, Math.min(maxY, vb.y));

        return { x, y, width, height };
    }

    function screenToSvgCoords(clientX: number, clientY: number) {
        const wrapper = wrapperRef.current;
        const vb = currentViewBoxRef.current;
        if (!wrapper || !vb) return null;

        const rect = wrapper.getBoundingClientRect();
        if (rect.width === 0 || rect.height === 0) return null;

        const scale = Math.min(rect.width / vb.width, rect.height / vb.height);
        const renderedWidth = vb.width * scale;
        const renderedHeight = vb.height * scale;
        const offsetX = (rect.width - renderedWidth) / 2;
        const offsetY = (rect.height - renderedHeight) / 2;

        const localX = clientX - rect.left;
        const localY = clientY - rect.top;

        return { x: vb.x + (localX - offsetX) / scale, y: vb.y + (localY - offsetY) / scale };
    }

    useEffect(() => {
        if (!wrapperRef.current) return;
        const wrapper = wrapperRef.current;
        const updateSize = () => {
            const rect = wrapper.getBoundingClientRect();
            setWrapperSize({ width: rect.width, height: rect.height });
        };
        updateSize();
        const observer = new ResizeObserver(() => updateSize());
        observer.observe(wrapper);
        return () => observer.disconnect();
    }, []);

    useEffect(() => {
        let mounted = true;
        let cleanupFns: Array<() => void> = [];

        async function loadSvg() {
            try {
                setSvgLoaded(false);
                clearPathSelection();
                const res = await fetch(src);
                if (!res.ok) throw new Error(`Failed to load SVG`);

                const svgText = await res.text();
                if (!mounted || !svgHostRef.current) return;

                svgHostRef.current.innerHTML = svgText;
                const svg = svgHostRef.current.querySelector("svg") as SVGSVGElement | null;
                if (!svg) throw new Error("No <svg> tag found");

                svgRef.current = svg;
                svg.setAttribute("width", "100%");
                svg.setAttribute("height", "100%");
                svg.setAttribute("preserveAspectRatio", "xMidYMid meet");
                svg.style.display = "block";
                svg.style.width = "100%";
                svg.style.height = "100%";

                let initialViewBox: ViewBoxState = { x: 0, y: 0, width: 1000, height: 1000 };
                const vb = svg.getAttribute("viewBox");
                if (vb) {
                    const parts = vb.trim().split(/\s+/).map(Number);
                    if (parts.length === 4) {
                        initialViewBox = { x: parts[0], y: parts[1], width: parts[2], height: parts[3] };
                    }
                }

                originalViewBoxRef.current = initialViewBox;
                currentViewBoxRef.current = { ...initialViewBox };

                const allPaths = Array.from(svg.querySelectorAll("path")) as SVGPathElement[];
                const validIdRegex = /^(\d+[a-zA-Z0-9\-]*|external.*)$/i;
                const interactivePaths: SVGPathElement[] = [];

                allPaths.forEach((el) => {
                    if (el.id && validIdRegex.test(el.id)) {
                        interactivePaths.push(el);
                        styleDefault(el);

                        const handleMouseEnter = () => {
                            if (selectedPathRef.current !== el) styleHover(el);
                        };

                        const handleMouseLeave = () => {
                            if (selectedPathRef.current !== el) {
                                if (selectedPathRef.current) {
                                    styleDimmed(el);
                                } else {
                                    styleDefault(el);
                                }
                            }
                        };

                        const handleClick = (event: MouseEvent) => {
                            event.stopPropagation();
                            if (selectedPathRef.current === el) {
                                clearPathSelection();
                                if (onPointSelect) onPointSelect("");
                                return;
                            }

                            selectedPathRef.current = el;
                            setSelectedPathId(el.id || null);
                            if (onPointSelect) onPointSelect(el.id);

                            pathsRef.current.forEach((p) => {
                                if (p === el) {
                                    styleSelected(p);
                                } else {
                                    styleDimmed(p);
                                }
                            });
                        };

                        el.addEventListener("mouseenter", handleMouseEnter);
                        el.addEventListener("mouseleave", handleMouseLeave);
                        el.addEventListener("click", handleClick);

                        cleanupFns.push(() => {
                            el.removeEventListener("mouseenter", handleMouseEnter);
                            el.removeEventListener("mouseleave", handleMouseLeave);
                            el.removeEventListener("click", handleClick);
                        });
                    } else {
                        styleNonInteractive(el);
                    }
                });

                pathsRef.current = interactivePaths;

                const handleSvgBackgroundClick = (event: MouseEvent) => {
                    const target = event.target as Element | null;
                    if (!target) return;
                    const clickedPath = target.closest("path");
                    if (!clickedPath || !interactivePaths.includes(clickedPath as SVGPathElement)) {
                        clearPathSelection();
                        if (onPointSelect) onPointSelect("");
                    }
                };
                svg.addEventListener("click", handleSvgBackgroundClick);
                cleanupFns.push(() => svg.removeEventListener("click", handleSvgBackgroundClick));

                setSvgLoaded(true);
            } catch (error) {
                console.error("SVG Load Error", error);
            }
        }

        loadSvg();
        return () => {
            mounted = false;
            cleanupFns.forEach((fn) => fn());
            cleanupFns = [];
        };
    }, [src, onPointSelect]);

    useEffect(() => {
        if (!svgLoaded || !originalViewBoxRef.current || !selectedPointId) return;

        const targetEl = pathsRef.current.find((p) => p.id === selectedPointId);
        if (targetEl) {
            selectedPathRef.current = targetEl;
            setSelectedPathId(targetEl.id);

            pathsRef.current.forEach(p => {
                if (p === targetEl) {
                    styleSelected(p);
                } else {
                    styleDimmed(p);
                }
            });

            // ZOOM LOGIC REMOVED FROM HERE

        } else {
            clearPathSelection();
        }
    }, [selectedPointId, svgLoaded]);

    useEffect(() => {
        if (!svgLoaded || !wrapperRef.current || !svgRef.current) return;
        const wrapper = wrapperRef.current;
        let isDragging = false;
        let startClientX = 0;
        let startClientY = 0;
        let startViewBox: ViewBoxState | null = null;

        function zoomAt(clientX: number, clientY: number, factor: number) {
            const current = currentViewBoxRef.current!;
            const point = screenToSvgCoords(clientX, clientY);
            if (!point) return;
            let nextWidth = current.width * factor;
            let nextHeight = current.height * factor;
            const relX = (point.x - current.x) / current.width;
            const relY = (point.y - current.y) / current.height;
            setViewBox(clampViewBox({ x: point.x - relX * nextWidth, y: point.y - relY * nextHeight, width: nextWidth, height: nextHeight }));
        }

        function handleWheel(e: WheelEvent) {
            e.preventDefault();
            zoomAt(e.clientX, e.clientY, e.deltaY > 0 ? 1.12 : 0.88);
        }

        function handlePointerDown(e: PointerEvent) {
            if (e.button !== 0) return;
            isDragging = true;
            startClientX = e.clientX;
            startClientY = e.clientY;
            startViewBox = { ...currentViewBoxRef.current! };
            wrapper.style.cursor = "grabbing";
        }

        function handlePointerMove(e: PointerEvent) {
            if (!isDragging || !startViewBox) return;
            const rect = wrapper.getBoundingClientRect();
            const svgDx = ((e.clientX - startClientX) / rect.width) * startViewBox.width;
            const svgDy = ((e.clientY - startClientY) / rect.height) * startViewBox.height;
            setViewBox(clampViewBox({ x: startViewBox.x - svgDx, y: startViewBox.y - svgDy, width: startViewBox.width, height: startViewBox.height }));
        }

        function handlePointerUp() {
            isDragging = false;
            startViewBox = null;
            wrapper.style.cursor = "default";
        }

        wrapper.addEventListener("wheel", handleWheel, { passive: false });
        wrapper.addEventListener("pointerdown", handlePointerDown);
        window.addEventListener("pointermove", handlePointerMove);
        window.addEventListener("pointerup", handlePointerUp);

        return () => {
            wrapper.removeEventListener("wheel", handleWheel);
            wrapper.removeEventListener("pointerdown", handlePointerDown);
            window.removeEventListener("pointermove", handlePointerMove);
            window.removeEventListener("pointerup", handlePointerUp);
        };
    }, [svgLoaded]);

    function resetView() {
        const original = originalViewBoxRef.current;
        if (!original) return;
        setViewBox({ ...original });
    }

    function zoomCenter(factor: number) {
        const current = currentViewBoxRef.current;
        if (!current) return;
        let nextWidth = current.width * factor;
        let nextHeight = current.height * factor;
        let nextX = (current.x + current.width / 2) - nextWidth / 2;
        let nextY = (current.y + current.height / 2) - nextHeight / 2;
        setViewBox(clampViewBox({ x: nextX, y: nextY, width: nextWidth, height: nextHeight }));
    }

    return (
        <div className={`relative h-full w-full ${className}`}>
            <div ref={wrapperRef} className="absolute inset-0 overflow-hidden bg-[#f7f5f0] touch-none">
                <div ref={svgHostRef} className="absolute inset-0" />
            </div>

            <div className="absolute right-4 top-4 z-20 flex flex-col gap-2">
                <button type="button" onClick={() => zoomCenter(0.8)} className="rounded-lg border border-gray-200 bg-white/95 px-3 py-2 text-xs font-bold uppercase tracking-widest text-gray-700 shadow hover:bg-white">Zoom +</button>
                <button type="button" onClick={() => zoomCenter(1.25)} className="rounded-lg border border-gray-200 bg-white/95 px-3 py-2 text-xs font-bold uppercase tracking-widest text-gray-700 shadow hover:bg-white">Zoom -</button>
                <button type="button" onClick={resetView} className="rounded-lg border border-gray-200 bg-white/95 px-3 py-2 text-xs font-bold uppercase tracking-widest text-gray-700 shadow hover:bg-white">Reset</button>
            </div>

            {selectedPathId && (
                <div className="absolute bottom-4 left-4 z-20 rounded-xl border border-gray-200 bg-white/95 px-4 py-3 shadow-lg pointer-events-none">
                    <div className="text-[10px] font-bold uppercase tracking-widest text-gray-400">Selected Area</div>
                    <div className="text-lg font-bold text-gray-900">{selectedPathId}</div>
                </div>
            )}
        </div>
    );
}