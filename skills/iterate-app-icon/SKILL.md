---
name: iterate-app-icon
disable-model-invocation: true
description: Design and iterate Apple app icons using image-generated concepts, editable SVG layers, Icon Composer materials, and independent visual review. Use when the user explicitly invokes /iterate-app-icon or $iterate-app-icon. Deliver an approved package without reopening design iteration.
---

# Iterate App Icon

Create icons that retain their appeal from the concept through the real Icon
Composer render and into the app. This workflow is self-contained.

## Respect the requested phase

- **Concept exploration:** generate and inspect complete concepts for discussion.
  Explain any material experiments needed to make them attainable. Stop at the
  requested discussion point; production SVGs and app integration are not required.
- **Design and build:** establish the brief, author editable layers, tune a real
  Composer package, and review the result. When autonomous iteration is authorized,
  make routine design decisions and continue without repeated approval requests.
- **Deliver an approved package:** copy and verify the accepted package, then
  perform the requested app integration. Do not regenerate concepts, redesign,
  reopen Composer, or request another design review merely to copy it.

Honor explicit selection checkpoints. Answer side questions and resume the
active phase. Delivery includes routine package promotion, development-variant
regeneration, and integration; a release requires release authorization.

## Establish the brief

Inspect the current icon and supplied references. For a suite, view the family
together, identify any fixed anchor, and distinguish shared traits from each
app's metaphor. Family resemblance can come from scale, contours, lighting,
palette, or materials; it need not repeat a mascot or decoration.

Record the subject, mood, composition, palette, exclusions, and intended
materials. Favor one readable subject with a few meaningful details. Preserve
recognized strengths unless a redesign was requested.

Use the available image-generation tool and its applicable instructions to
make complete reference concepts. Reference actual Composer exports when
available. Aim for attainable shapes, shallow depth, and restrained lighting
and refraction. Avoid making photographic texture, sculpted detail, or
ray-traced reflections essential to a design that SVGs and Composer cannot
reproduce. Test ambitious material behavior early in the real compositor.

Judge the whole icon before decomposing it. Do not generate production layers
independently: perspective and contours will drift. An approved reference fixes
composition and character; it does not prove its materials are achievable.
Show distinct alternatives when requested, and reject an unattainable concept
before treating it as a reconstruction target.

## Author editable artwork

Directly authored SVG paths are the default. Use a shared coordinate system,
semantic filenames, and one asset per independently treated object. Plan a few
back-to-front groups and each asset's material role. Figma and tracing are
optional, appropriate when requested or useful for an authoritative clean mask.

Start with deliberate contours and flat fills. Restrained source gradients may
describe broad surface curvature; let Composer supply specular highlights,
refraction, and cast shadows. A material cannot invent anatomy, thickness, or
an interior volume break: supply that geometry.

Preserve hidden geometry that glass or movement may reveal. Derive split
portions from the same master to avoid gaps and doubled edges. A transparent
opening must pass through every backing shape. For an object passing through
a port, place the rear opening behind it and the foreground lip in front.
Test SVG masks, clipping, filters, and compound paths in Composer before relying
on them; use explicit paths when import changes their appearance.

Inspect the flat composite for silhouette, registration, perspective, seams,
and clutter. It should read without gloss, even when the final material is
needed to convey glass. Use focused checks for actual risks such as missing
assets, misaligned splits, and opaque cutouts. Structural checks cannot prove
visual quality, and fixed layer counts or filenames are not design requirements.

## Tune real Composer materials

Inspect the installed version and its controls. Consult current Apple
documentation when import behavior or capabilities are uncertain:
[Creating your app icon using Icon Composer](https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer).

Keep the working package separate from the app's shipping package. Record both
paths and the editable source location. Preserve Composer-owned settings and
user edits when updating assets. After external changes, close the stale
document without saving and reopen the exact working package.

Use the document fill for the background; do not import a reference background,
rounded icon mask, or template grid as artwork. Choose individual or combined
group treatment according to the intended volume and the installed tool's
limits. Do not apply one material indiscriminately to every layer.

Use Composer's sidebar opacity for ordinary layer or group opacity, keeping
source colors opaque by default. Liquid Glass translucency is a separate
material control. Match both opacity and material settings across split pieces
of one object. Correct geometry, fill, or material when glass erases contrast;
do not paste a false foreground copy over it.

Tune in the actual GUI. Flat renders, command-line exports, and simulations are
useful comparisons, but label their provenance accurately. If the GUI is
unavailable, continue useful concept or source work and report material
acceptance as unverified.

Before final material review, save, close, and reopen the working package.
Inspect the live render, layer structure, and persisted settings. Capture the
actual window and inspect the icon at 128, 64, and 32 pixels. Check Default,
Dark, and Mono appearances and applicable clear and tinted treatments.
Highlights and transparency must strengthen the subject without erasing it.

Keep reference images, screenshots, rejected candidates, and backups in a
task-specific artifact directory outside app repositories. Record the candidate
path, source revision or package hash, render provenance, verdict, and next
change. An exhaustive iteration ledger is unnecessary.

## Review and iterate

Use a fresh independent reviewer for production candidates when delegation is
available. Provide the brief or approved reference, current-best and challenger
images, small previews, and saved-and-reopened GUI evidence. Omit persuasive
producer commentary and implementation effort. Concept discussion and copying
an approved package do not require this production review.

Have the reviewer judge:

- Immediate readability and silhouette at 64 and 32 pixels.
- Composition, mood, and character against the approved brief.
- Convincing curves, proportions, perspective, and overlaps.
- Unintended seams, gaps, halos, clutter, or ambiguous anatomy.
- Materials that preserve contrast and explain the intended object.
- Deliberate appearance variants and, for suites, family resemblance.

Request a concise PASS or REVISE verdict, visible evidence for the most important
defect, improvement or regression against the current-best, one useful next
experiment, and any unverified evidence. A first candidate needs no imaginary
predecessor. Missing evidence means unverified, not visibly defective.

Fix demonstrated defects with targeted artwork or material changes. A setting
or layer count alone does not prove a visual problem. Compare challengers with
the current-best and retain it when they regress. Respect the user's rejection
even if an earlier reviewer passed. If a defect survives repeated attempts,
change its construction or revisit the concept.

Limit independent review to three rounds, or a stricter host limit. Only
blocking findings warrant another round; revisions do not reset the count.
After the final round, resolve reproducible blockers and report remaining
limitations without claiming acceptance. If reviewers are unavailable, perform
a direct review and disclose that independence remains unverified.

For suite work, separate producers may work on individual apps when authorized.
Serialize ownership of the Composer GUI. Review each icon and the family,
including unchanged anchors; the coordinator must inspect decisive images.

## Deliver the accepted package

For a completed design, identify the editable artwork, accepted working
package, and actual verification. For concepts, show the concepts and material
experiments they imply. Distinguish concept approval, material acceptance,
package validation, and app integration.

When app delivery is authorized:

1. Inspect the repository's icon configuration and build instructions. Preserve
   correct project membership and build settings during routine promotion.
2. Back up the shipping package outside the repository. Copy the accepted
   package as a whole, preserving its settings. Compare recursively, including
   destination-only files; resolve stale files using the backup and accepted
   package. Do not hand-edit package JSON or copy selected assets to promote it.
3. If integration is new or incorrect, place the package beside the asset
   catalog, add it to the app target, and match the App Icon setting to its
   filename without `.icon`. Use the repository's actual project format and
   tooling, and validate any configuration edits. Remove or replace the old
   asset-catalog icon only as required by that configuration.
4. Build through the repository's canonical route and inspect its diagnostics.
   Verify compiled icon metadata and renditions. Package discovery or asset
   symbol generation alone does not prove the app uses the icon.
5. Install the exact tested development build and inspect a fresh home-screen
   capture. Preserve the repository's development identity and signing rules;
   production identity belongs only to its authorized distribution workflow.

A pure asset replacement needs package and rendered-icon evidence, not a new
logic test suite. Run repository-required gates and checks for concrete risks;
do not rebuild unchanged inputs merely to inspect existing diagnostics. Keep
raster evidence and backups outside the repository.

Report exactly what was delivered and what remains unverified. An attractive
reference is not a working Composer icon, and a copied package is not verified
app integration.
