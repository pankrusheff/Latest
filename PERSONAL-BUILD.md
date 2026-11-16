# Latest Personal

Personal Apple Silicon build based on upstream main, with fixes from:

- https://github.com/mangerlahn/Latest/pull/606 — bundle identifier matching and rejection of implausible matches.
- https://github.com/mangerlahn/Latest/pull/607 — in-app updates for casks already managed by Homebrew.
- https://github.com/mangerlahn/Latest/pull/584 — handle empty minimum macOS versions without losing the catalog. Only the focused fix commit is included, not the unrelated development branch.

Original authors and license are preserved in Git history. This is an unofficial build.

## Build

Push the personal-build branch or run Latest Personal in GitHub Actions. The job runs all XCTest tests, builds a Release app for arm64, verifies the ad hoc signature, and uploads Latest-Personal-arm64.zip. Build/test logs are uploaded separately.

The app has bundle identifier com.pankrusheff.Latest and display name Latest Personal so it can coexist with the original. Upstream self-update metadata/controller are removed to avoid replacing the personal build. Other apps still use Sparkle normally.

The app is ad hoc signed, without Apple notarization. It may require approval through macOS Privacy & Security on first launch. The workflow does not run Homebrew upgrades; those run only when the user initiates an update in the app. Apps not managed by Homebrew retain the original external update action.

The build improves supported sources and matching; it does not add integrations for every vendor updater. Updating real installed apps must be checked separately from unit tests and build verification.
