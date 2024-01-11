#NUM=$(grep -oP '^version: [.\d]+\+\K\d+' pubspec.yaml)

# Build AAB
flutter build appbundle --release \
  --obfuscate --target-platform android-arm,android-arm64 \
  --split-debug-info=obfuscation_maps \
  --verbose


# Rename AAB for upload
BUILD_DIR="build/app/outputs/bundle/release"
AAB="$BUILD_DIR/com.watchgas.launcher.aab"
mv "$BUILD_DIR/app-release.aab" "$AAB"

open $BUILD_DIR