# Swift MVVM Playbook Maintenance

## Scope

Provide compact MVVM guidance for SwiftUI and UIKit implementation and review.
Preserve project conventions; do not impose a new architecture, state wrapper,
router, test framework, or view model for every component.

## Runtime shape

Use inline guidance in `SKILL.md`. It contains boundaries, ownership decisions,
async lifetime rules, one compiling modern example, and behavioral verification.
No bundled references or scripts are required.

## Evidence and maintenance

Use current Swift/Apple documentation, compiler checks, and concrete project
behavior when changing concurrency or ownership advice. Validate examples rather
than assuming that plausible Swift compiles.

Keep exceptions for view-local state, domain values rendered directly, and UI
operations. Keep visibility-bound async work separate from operations that must
finish after a view disappears. Do not rely on deinitialization to cancel work
that retains its owner.

Add optional reference files only when a recurring use case cannot fit clearly
in the main guidance; route each reference directly from `SKILL.md`.

## Validation

- Validate skill frontmatter and bundled file references.
- Compile the Swift example with Swift 6 strict concurrency and macOS 15 or iOS 17.
- Check trigger examples: review MVVM boundaries, implement an async view model,
  choose navigation ownership, and fix stale presentation results.
- Exclude layout-only styling, backend persistence implementation, and unrelated
  language/framework tasks from automatic activation.
- Check that guidance preserves one source of truth and tests observable behavior.
