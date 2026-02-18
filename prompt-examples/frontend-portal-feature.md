<!--
  INSTRUCTIONS: Fill in the Feature Brief section below with your requirements.
  Everything after the brief is a reusable template — do not modify it.
-->

## Feature brief

<!-- Replace this section with your feature requirements before using the prompt. -->

**Portal**: [admin / bank / insurance / supplier]
**Feature name**: [e.g. "Invoice approval workflow"]
**Description**: [What the feature does, who uses it, and why]
**Key user flows**:
• [Flow 1]
• [Flow 2]
• [Flow 3]
**Acceptance criteria**:
• [Criterion 1]
• [Criterion 2]
**Relevant existing pages/components**: [List any pages or components this feature touches or extends]
**Mockups/references**: [Links or descriptions of any design references, if available]

---

## Tech stack & constraints

This feature lives inside an existing Next.js 15 monorepo. You must work within these constraints:

    •    **Next.js 15** with Turbopack and the App Router
    •    **React 19** — use Server Components by default, `"use client"` only for interactive elements
    •    **TypeScript** — strict mode, no `any` types
    •    **Tailwind CSS** — use utility classes, follow existing color/spacing conventions
    •    **Radix UI** — use Radix primitives for all interactive components (dialogs, dropdowns, popovers, tooltips, tabs, etc.). Do not build custom implementations of components that Radix already provides.
    •    **@repo/ui** — shared component library and global CSS. Check for existing components before creating new ones. If a component doesn't exist, create it in the shared library so other portals can reuse it.
    •    **@repo/trpc** — tRPC for all API calls. Do not use raw `fetch` for backend communication. For mutations, always use `useMutation` with its built-in `onSuccess`, `onError`, and `onSettled` callbacks for handling results. Do not wrap mutations in try/catch blocks or use standalone async callbacks — let the mutation hook manage the lifecycle.
    •    **@repo/lib** — shared types used by both `@repo/ui` and `@repo/trpc`. Types that both packages need must live here to avoid circular dependencies (UI depends on TRPC, so TRPC cannot import from UI).

## Design system

Use the CSS variables defined in `@repo/ui`'s global stylesheet. Do not hardcode color values. As long as you use the design token variables, dark/light theming is handled automatically.

    •    **Colors**: Always use the CSS variable names (e.g. `bg-primary`, `text-muted-foreground`). Never hardcode hex values like `#F72585` — use the corresponding variable instead.
    •    **Typography**: Use the project's configured font stack. Maintain the existing heading/body hierarchy.
    •    **Spacing**: Follow Tailwind's default spacing scale. Be consistent with the padding/margin patterns used in adjacent pages.
    •    **Components**: Match the visual style of existing portal pages. If the portal already has tables, cards, forms, or modals — match their patterns exactly.

## Quality requirements

    •    **Accessibility**: All interactive elements must be keyboard-navigable. Use proper ARIA labels. Form fields need visible labels. Error states must be announced to screen readers.
    •    **Responsive**: Must work on desktop (1280px+) and tablet (768px+). Mobile is not required for portal features but should not break.
    •    **Loading states**: Show skeleton loaders or spinners for async content. Never show a blank screen while data loads.
    •    **Error handling**: All API calls must have error states. Show user-friendly messages, not raw errors. Failed mutations should not lose user input.
    •    **Empty states**: Handle zero-data scenarios with helpful messaging and clear CTAs.

## Task

Implement the feature described in the brief above. Use the frontend design skill to ensure the implementation is polished and visually consistent with the rest of the portal.

Before writing code: 1. Read the existing pages adjacent to where this feature will live, so you match their patterns. 2. Check @repo/ui for reusable UI components. 3. Check @repo/lib for shared types relevant to this feature. 4. Plan the component tree and data flow before implementing.

Build the feature as a complete, working implementation — not a stub or mockup. It should be ready for code review.

Use the following port for the dev server: 4000.
