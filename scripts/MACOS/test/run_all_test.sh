#!/bin/bash
# chmod +x scripts/MACOS/test/run_all_test.sh

echo -e "\n🚀 Executing all tests...\n"

echo "🧹 Cleaning up previous coverage..."
rm -rf coverage

echo -e "\n🧪 Running unit tests with coverage...\n"
flutter test test/ --coverage
UNIT_EXIT_CODE=$?

# Save unit coverage
cp coverage/lcov.info coverage/lcov_unit.info

if [ $UNIT_EXIT_CODE -ne 0 ]; then
  echo -e "\n❌ There are errors\n"
  exit 1
else
  echo -e "\n✅ All tests work fine\n"
fi

# Check genhtml (lcov)
if ! command -v genhtml &> /dev/null; then
  echo -e "\n❌ genhtml not installed. Please install: brew install lcov\n"
  exit 1
fi

echo -e "\n📊 Generating HTML coverage...\n"
genhtml coverage/lcov_unit.info -o coverage/html

# Open report
if [ -f coverage/html/index.html ]; then
  open coverage/html/index.html
else
  echo -e "\n❌ Failed to generate coverage/html/index.html\n"
fi