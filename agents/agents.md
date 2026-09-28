## Writing code
* Do NOT add comments to code unless instructed
* Be succinct. Sacrifice grammar for brevity
* When opening a PR, follow these rules:
    - stick to ASD-STE100 for simple english
    - explain the what and why this change is being introduced
    - don't say "it makes it faster", prove with numbers (e.g. 30% less allocations)
    - keep it short: sections Description, Changes, Notes; try to keep it under 200 words
    - talk like a human:
      -- prefer e.g. "Added a new feature that allows...because..." instead "* Adds new feature"
    - describe the change for a reviewer; leave out how it was debugged or which files changed
* Use the library or framework. Do not reimplement what it already does
* Stick to YAGNI principles
* Write the simplest code that does the whole job. Extract when the same shape repeats, not in anticipation
* One-liners only when a reader can parse them at a glance
* Design so the next change is cheap. Do not build unused extension points or accept a hack that must be replaced immediately
* When deleting code, leave no vestigial traces, whale legs, or references to the old implementation
* Avoid defensive programming
  - Do not add redundant safety checks just to suppress potential errors
  - Validate and sanitize only at integration/system boundaries. Trust internal contracts

## Reviewing code
* NEVER reply to GitHub comments unless explicitly told to do so
* Questions need to be validated: if you don't know the answer, create a throwaway test case to confirm or reject the review

## Writing tests
* Test the outcome the caller sees, not how internals are wired
* Default to a feature test that hits the real stack: request/controller in Rails, route/handler or API in TypeScript
* Unit-test domain rules and pure functions against real objects. Do not mock what you own
* Stub only at the edge: HTTP, mail, payments, clock, filesystem
* Do not change production design just to inject mocks
* Browser/system tests only for a few critical smoke paths
* Name the test after the behavior. One behavior per test
* Do not test the framework, generated types, or private methods
* Follow the repo's runner and style
