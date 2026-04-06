#!/bin/bash
set -euo pipefail

# Update the Homebrew formula for a new release
# Usage: ./update.sh <version> <sha256>
# Example: ./update.sh 0.1.0 abc123...

VERSION=${1:?Version required}
SHA256=${2:?SHA256 required}

FORMULA="Formula/codemark.rb"

# Get current checksum from the formula
CURRENT_SHA256=$(grep 'sha256' "${FORMULA}" | sed 's/.*sha256 "\(.*\)".*/\1/')

echo "Current formula checksum: ${CURRENT_SHA256}"
echo "New checksum:             ${SHA256}"

if [ "${CURRENT_SHA256}" = "${SHA256}" ]; then
  echo "WARNING: Checksum is the same as current formula!"
  echo "This might indicate:"
  echo "  - The archive didn't download correctly (cached 404 response)"
  echo "  - The same archive is being used for a new version"
  echo ""
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

# Update the formula
sed -i '' "s|url \"https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/.*\"|url \"https://github.com/DanielCardonaRojas/codemark/archive/refs/tags/${VERSION}.tar.gz\"|" "${FORMULA}"
sed -i '' "s|sha256 \".*\"|sha256 \"${SHA256}\"|" "${FORMULA}"

echo ""
echo "Updated ${FORMULA} to version ${VERSION}"
echo ""
cat "${FORMULA}" | grep -E "(url|sha256)"
echo ""
echo "Review the changes with: git diff ${FORMULA}"
echo "Then commit and push:"
echo "  git add ${FORMULA}"
echo "  git commit -m 'Update codemark to ${VERSION}'"
echo "  git push"
