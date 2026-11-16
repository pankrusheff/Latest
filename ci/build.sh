#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p build dist
xcodebuild -version
common=(-project Latest.xcodeproj -scheme Latest -derivedDataPath build/DerivedData
  -destination 'platform=macOS,arch=arm64' ARCHS=arm64 ONLY_ACTIVE_ARCH=NO
  CODE_SIGN_IDENTITY=- CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM=)
xcodebuild "${common[@]}" -resolvePackageDependencies 2>&1 | tee build/dependencies.log
xcodebuild "${common[@]}" -configuration Debug -parallel-testing-enabled NO   -resultBundlePath build/Tests.xcresult test 2>&1 | tee build/tests.log
xcodebuild "${common[@]}" -configuration Release   MARKETING_VERSION=0.11.1 CURRENT_PROJECT_VERSION="${GITHUB_RUN_NUMBER:-1}"   build 2>&1 | tee build/release.log
app='dist/Latest Personal.app'
ditto build/DerivedData/Build/Products/Release/Latest.app "$app"
codesign --force --deep --sign - "$app"
codesign --verify --deep --strict --verbose=2 "$app"
lipo -verify_arch arm64 "$app/Contents/MacOS/Latest"
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Contents/Info.plist"
ditto -c -k --sequesterRsrc --keepParent "$app" dist/Latest-Personal-arm64.zip
shasum -a 256 dist/Latest-Personal-arm64.zip > dist/SHA256SUMS
if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  { echo 'Latest Personal: tests passed and arm64 release built.'; cat dist/SHA256SUMS; } >> "$GITHUB_STEP_SUMMARY"
fi
