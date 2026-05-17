# Design System Document: The Biological Precision Framework

## 1. Overview & Creative North Star: "The Digital Greenhouse"
The Creative North Star for this design system is **The Digital Greenhouse**. In high-stakes agricultural technology, the UI must act as a clear, high-fidelity lens through which the user views their crops. We are moving away from the "industrial utility" of standard ag-tech and toward an **Editorial Tech-Forward** aesthetic. 

This system rejects the rigid, boxy constraints of traditional Material Design in favor of **Organic Fluidity**. By leveraging intentional asymmetry, oversized editorial typography, and layered glass surfaces, we create an environment that feels as alive as the plants it monitors, while maintaining the clinical precision of a laboratory.

---

## 2. Colors & Surface Philosophy
The palette is rooted in a "Chlorophyll & Silica" concept—combining the organic vitality of `primary` (#006418) with the sterile, premium feel of `surface` (#f8faf8).

### The "No-Line" Rule
Traditional 1px borders are strictly prohibited for sectioning. They create visual noise and "trap" the eye. Instead, define boundaries through:
*   **Tonal Shifts:** Place a `surface_container_low` card on a `surface` background.
*   **Negative Space:** Use the spacing scale to create distinct "islands" of information.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the `surface_container` tiers to create "nested" depth:
*   **Base Layer:** `surface` (#f8faf8).
*   **Mid-Level Content:** `surface_container_low` for secondary groupings.
*   **Interactive Focus:** `surface_container_lowest` (#ffffff) for primary cards to create a "pop" against the off-white background.

### The "Glass & Gradient" Rule
To achieve a signature high-end feel, use Glassmorphism for floating overlays (e.g., scan results, navigation bars).
*   **Glass Recipe:** `surface_container_lowest` at 70% opacity + `backdrop-filter: blur(20px)`.
*   **Gradients:** Use a subtle linear gradient from `primary` (#006418) to `primary_container` (#267e2e) on main action buttons to provide a sense of organic depth and "lustre."

---

## 3. Typography: The Editorial Authority
We utilize a pairing of **Manrope** (Display/Headlines) and **Inter** (Body/Labels) to balance tech-forward character with clinical legibility.

*   **Display (Manrope):** Used for data-heavy hero moments (e.g., "98% Healthy"). The high x-height conveys confidence.
*   **Headline (Manrope):** Used for screen titles. Utilize `headline-lg` with slight negative letter-spacing (-0.02em) for a high-end editorial look.
*   **Body (Inter):** Used for diagnostic descriptions. The neutral geometry of Inter ensures readability even in harsh outdoor sunlight.
*   **Labels (Inter):** All-caps with +0.05em tracking for secondary metadata (e.g., "TIMESTAMP," "GPS COORDS") to provide an authoritative, technical feel.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are replaced by **Ambient Occlusion** and **Tonal Lift**.

*   **The Layering Principle:** Depth is achieved by stacking. A `surface_container_highest` element should only exist atop a `surface_container_low` base. This creates a natural hierarchy of importance without the clutter of shadows.
*   **Ambient Shadows:** When a "floating" effect is mandatory (e.g., a "Capture" FAB), use a large 32px blur with 6% opacity of the `on_surface` color. The shadow should feel like a soft glow, not a dark edge.
*   **The "Ghost Border":** For high-density data tables where separation is critical, use `outline_variant` (#bfcaba) at **15% opacity**. It should be felt, not seen.

---

## 5. Components & Interface Elements

### Buttons (The "Leaf" Interaction)
*   **Primary:** Gradient of `primary` to `primary_container`. `xl` (1.5rem) corner radius. No border.
*   **Secondary:** `surface_container_highest` background with `primary` text. Provides a soft, integrated look.
*   **Tertiary:** Transparent background, `on_surface_variant` text, used for low-emphasis actions like "Cancel."

### Diagnostic Cards
*   **Style:** Forbid divider lines. Use `surface_container_lowest` (#ffffff) for the card body.
*   **Header:** Use `title-md` for the crop name, paired with a `label-sm` for the status.
*   **Asymmetry:** Place the "Disease Confidence" percentage in a floating glass tag overlapping the top-right corner of the card’s image.

### Input Fields
*   **Style:** No bottom-line-only inputs. Use a "Pill" shape (`full` radius) with `surface_container_low` background. 
*   **States:** On focus, the background shifts to `surface_container_lowest` with a 1px `primary` ghost border (20% opacity).

### Specialized App Components
*   **The Scanning Reticle:** A minimalist, four-corner bracket using `primary_fixed`. The brackets should pulse slightly using a 2s ease-in-out animation.
*   **Health Score Gauge:** A semi-circular arc using `primary` for the "healthy" range and `error` for "infected" zones, utilizing a `surface_variant` track.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use overlapping elements. Let a diagnostic chip partially "break" the container of a crop image to create depth.
*   **Do** prioritize "Breathing Room." Increase vertical margins by 1.5x the standard Material spacing to emphasize the premium vibe.
*   **Do** use `primary_fixed_dim` for icons in secondary navigation to keep them soft but legible.

### Don’t
*   **Don’t** use pure black (#000000). Use `on_background` (#191c1b) to maintain the charcoal editorial feel.
*   **Don’t** use hard-edged squares. Every interactive element must have at least a `DEFAULT` (0.5rem) radius to feel organic.
*   **Don’t** use 100% opaque borders. They interrupt the "Digital Greenhouse" flow and make the app feel like a generic template.