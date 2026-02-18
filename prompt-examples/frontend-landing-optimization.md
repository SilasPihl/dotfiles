I am redesigning the marketing landing page for "Lix One" — a fintech platform providing AI-driven payment rails for the agentic era. Lix One enables autonomous AI agents and businesses to manage payments, invoices, and working capital finance seamlessly.

Core products:
    •    Invoice Purchase (IP) — 100% non-recourse invoice purchasing
    •    Invoice Finance (IF) — Flexible financing with up to 90% advance rates
    •    Supply Chain Finance (SCF) — Early supplier payment with extended buyer terms
    •    Trade Credit Insurance (TC) — Receivables protection against insolvency
    •    Electronic Documents (ED) — Digital document workflow automation
    •    FX SWAP — Foreign exchange risk management

The platform serves banks, insurers, suppliers, and enterprise clients through dedicated portals.

Brand identity:
    •    Color palette: Hot pink (#F72585) → purple (#7209B7) → deep blue (#3A0CA3)
    •    Dark-themed, enterprise-grade aesthetic
    •    Logo: Plover bird (minimalist, elegant)
    •    Trusted partners: Allianz, Atradius, Howden
    •    Tagline: "Payment rails for the AI agentic era"

## Current implementation problems

The existing landing page has performance and architecture issues that must be fixed in this redesign:

1. **Spline 3D scenes are too heavy** — Two `.splinecode` files (195KB + 114KB) load via `@splinetool/react-spline`. They require WebGL, have no error boundary, and no fallback for devices that can't render them. Consider replacing Spline with lightweight alternatives: CSS 3D transforms, Three.js with minimal geometry, animated SVGs, or Lottie. If you use Spline, it must be truly lazy-loaded with a static fallback visible immediately.

2. **The entire page is client-rendered** — The root `page.tsx` is marked `"use client"` (636 lines). This kills SSR/SSG benefits, hurts SEO, and forces heavy JS parsing before anything renders. The redesign must use Server Components by default, with `"use client"` only on interactive islands (dropdowns, carousels, animations).

3. **ReactFlow bundled on the homepage** — A 1,125-line workflow demo component imports the full ReactFlow library (~150KB) just for one visual section. Either replace this with a lightweight SVG/CSS animation of the payment flow, or move it to a dedicated `/demo` route.

4. **Scroll listener for opacity** — A continuous scroll event listener recalculates Spline opacity on every frame. Replace with Intersection Observer for threshold-based visibility toggling.

5. **Unoptimized images** — Partner logos use raw `<img>` tags instead of Next.js `<Image>`. No lazy loading, no responsive sizing, no format optimization.

6. **Navigation state management** — 4 separate `useState` booleans with manual `setTimeout` for hover delays. Should use Radix UI DropdownMenu or NavigationMenu instead.

7. **Inline CSS animations** — The loading screen has ~150 lines of inline keyframe CSS. Should use Tailwind's animation utilities or Motion library (which is already a dependency but unused on the landing page).

## Tech stack

Initialize the project with:
    •    Next.js 15 (with Turbopack)
    •    Tailwind CSS
    •    React 19
    •    TypeScript
    •    Bun
    •    Radix UI (NavigationMenu, Dialog, DropdownMenu — for accessible interactive components)
    •    Motion (for animations — use it instead of inline CSS keyframes)

Performance requirements:
    •    Server Components by default. Only use `"use client"` for genuinely interactive elements.
    •    All images via Next.js `<Image>` with proper sizing and lazy loading.
    •    No heavy 3D libraries unless truly lazy-loaded with a static-first fallback.
    •    Intersection Observer instead of scroll event listeners.
    •    Total JS bundle for above-the-fold content should be minimal — hero must render server-side.

## Task

Build FIVE variations of the landing page. All five should share the same brand identity, product information, and general page structure (hero → product showcase → trust/partners → CTA). The differences should be in how the sections are designed and animated — not in what content they contain.

Variations (hosted on /1 through /5):

1. **Gradient mesh hero** — Animated CSS gradient mesh background (no WebGL). Products shown as a horizontal scroll strip with gradient-bordered cards. Payment flow visualized as an animated SVG pipeline. Subtle Motion entrance animations on scroll.

2. **Typography-forward** — Oversized variable-weight type as the primary visual element in the hero. Products displayed in a tight 2×3 grid with monochrome icons that colorize on hover. Animated counters for key metrics (transactions processed, currencies supported). Clean, high-contrast.

3. **Layered cards** — Hero with stacked, overlapping product cards that fan out on scroll (using Motion layout animations). Each card reveals its product detail. Below, a step-by-step flow showing how a payment moves through the system, animated with Intersection Observer triggers.

4. **Split-screen** — Left side: bold copy and CTA. Right side: animated product visualization that morphs between products as user scrolls. Below the fold: bento-grid layout with feature highlights, partner logos, and a security section. Smooth but minimal animations.

5. **Video-loop hero** — Short looping background video (or animated gradient canvas) with overlay text. Products presented in a vertical accordion that expands with smooth Motion transitions. Interactive product comparison table at the bottom. Most editorial/storytelling feel of the five.

Use your frontend design skill to make these designs exceptional. They should feel like a premium fintech product — trustworthy, modern, and polished.

Use the following port for the dev server: 4000.
