#!/bin/bash
set -euo pipefail

# Update the Homebrew formula for a new release
# Usage: ./update.sh <version> <sha256>
# Example: ./update.sh 0.1.0 abc123...

VERSION=${1:?Version required}
SHA256=${2:?SHA256 required}

sed -i '' "s|url \"https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/.*\"|url \"https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/${VERSION}.tar.gz\"|" Formula/codemark.rb
sed -i '' "s|sha256 \".*\"|sha256 \"${SHA256}\"|" Formula/codemark.rb

echo "Updated Formula/codemark.rb to version ${VERSION}"
cat Formula/codemark.rb | grep -E "(url|sha256)"
