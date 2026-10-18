---
name: swift-mvvm-playbook
description: >
  Guides SwiftUI and UIKit MVVM implementation and review. Use when building or
  reviewing view models, feature state, dependency injection, navigation ownership,
  or async effects in a Swift app. Preserves project architecture and avoids
  mandatory state wrappers, display models, routers, and per-component view models.
---

# Swift MVVM Playbook

## Start with the project

- Read project instructions and the affected view, view model, dependencies, and tests.
- Preserve the deployment target, runner, dependency boundaries, and naming style.
- Use Observation where supported; keep established `ObservableObject` code when migration is outside scope.
- Review requested code without changing it unless fixes are authorized. Report concrete problems with file and line references; separate optional improvements.

## Keep these boundaries

| Layer | Owns |
|---|---|
| Model | Domain values, validation, and business rules; no dependency on views or view models. |
| ViewModel | Feature state, derived presentation decisions, user intents, and effect coordination. |
| View | Layout, icons, colors, value formatting, focus, animation, and transient UI state. |
| Services / repositories | Network, filesystem, persistence, and other integration effects. |
| Composition root | Live dependencies and factories for feature view models. |

- Inject dependencies into view models. Reuse existing protocols, use cases, and factories.
- Forward business intents from views to view models. Keep file loading, persistence, and network orchestration behind injected boundaries.
- Keep UI operations such as presenting a file picker, copying displayed text, and dismissing a sheet in the view or a platform adapter. Move them behind an injected boundary when workflow rules or error handling require it.
- Pass domain values directly to views when they already contain what the view needs. Domain independence means the domain does not depend on UI, not that views cannot read domain values.
- Extract display data only for meaningful, reused, or testable mappings. Keep choosing items, ordering, counts, totals, and feature permissions outside views.

## State and ownership

- Mark mutable observable view models `@MainActor`, unless the project provides equivalent default isolation.
- Keep one source of truth. Let an owning SwiftUI view retain its model in private `@State`; pass the same model to children using `@Bindable` or the environment.
- Keep focus, popover visibility, animation progress, and similar local details in the view. Small fields and cells do not need their own view models.
- Expose writable inputs for binding; keep effect results and derived state read-only to callers.
- Use a state enum when it prevents invalid combinations. Use independent properties when they express independent facts. Do not require a separate `FeatureState` file.
- Derive counts and flags instead of maintaining duplicate copies. Preserve prior content during refresh if the feature requires it.

## Async work

- Prefer an async view-model method awaited directly from SwiftUI `.task(id:)` for work tied to visibility or an input value.
- Do not launch another `Task` inside that method unless its lifetime deliberately differs from the caller's. SwiftUI cancellation does not automatically cancel unstructured tasks.
- Check cancellation before publishing an awaited result or error. For replaceable requests that can overlap without cancellation, use a request identity to reject obsolete responses.
- Use a stored task handle only for explicit start/stop, replacement, or work that must outlive a view. Give that work an explicit cancellation owner; do not rely solely on `deinit` while the task retains the model.
- Decide cancellation by operation: a visible activity poll can stop on disappearance; a save or mount operation may need to finish.
- Keep expensive parsing and CPU work at an appropriate service or executor boundary. Do not add detached tasks for small mappings. Detached work needs Sendable inputs and explicit cancellation handling when required.
- Map failures to actionable localized messages. Preserve diagnostic details at the integration boundary; do not expose raw errors indiscriminately or hide useful error context behind a generic message.

## Minimal SwiftUI example

This example reloads when the view appears. The view owns task lifetime; the model owns loading and result state. Add refresh retention, retry controls, or request replacement only when the feature needs them.

```swift
import Foundation
import Observation
import SwiftUI

struct FeedItem: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
}

protocol FeedRepository: Sendable {
    func fetchItems() async throws -> [FeedItem]
}

@MainActor @Observable
final class FeedViewModel {
    enum State: Equatable {
        case idle, loading
        case loaded([FeedItem])
        case failed(String)
    }

    private(set) var state = State.idle
    private let repository: any FeedRepository

    init(repository: any FeedRepository) {
        self.repository = repository
    }

    func load() async {
        state = .loading
        do {
            let items = try await repository.fetchItems()
            try Task.checkCancellation()
            state = .loaded(items)
        } catch {
            guard !Task.isCancelled else { return }
            state = .failed(String(localized: "Could not load items. Try again."))
        }
    }
}

struct FeedView: View {
    @State private var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .loaded(let items):
                List(items) { Text($0.title) }
            case .failed(let message):
                Text(message)
            }
        }
        .task { await viewModel.load() }
    }
}
```

Avoid `.task { viewModel.startLoad() }` when `startLoad()` creates an unstructured task and returns immediately. Await the loading method as above, or explicitly manage the longer-lived task.

## Navigation

- Keep route decisions testable when they contain feature rules. Let views or platform adapters perform presentation.
- Use selection, optional sheet state, or a value-type path according to the existing flow. Keep ownership in the view, view model, or router as appropriate; do not duplicate it.
- Add a coordinator only when shared flows, UIKit hosting, or deep links need one. Inject navigation callbacks into view models rather than UIKit/AppKit controllers.
- Keep view models independent of SwiftUI, UIKit, and AppKit presentation APIs.

## Verify behavior

- Follow the repository's runner and testing conventions. Test the caller-visible outcome, not bindings or private methods.
- Use real domain objects and owned components. Stub integration boundaries only; do not introduce production abstractions solely for mocks.
- Cover success, meaningful failures, cancellation, and stale results where those paths matter. Do not require a fixed number of tests per method.
- Synchronize async tests on request startup and completion. Do not use sleeps or `Task.yield()` as proof that work completed; never silently discard a response before its request exists.
- Compile examples with the supported Swift version and deployment target. Check strict concurrency, localization, and task ownership before recommending a pattern.
