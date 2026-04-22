#!/bin/bash
# chmod +x scripts/MACOS/iOS/clean_adn_build_iOS.sh

echo "🐦 Build flutter project..."
echo " "

echo "🧹 Cleaning up previous build..."
echo " "
flutter clean

echo "📦 Get pub packages..."
echo " "
flutter pub get

echo "🖋️ Format dart file..."
echo " "
dart format .

echo "🛠️ Running build..."
echo " "
flutter build ios