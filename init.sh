#!/usr/bin/env bash

set -e  

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename "$0") <path_to_downloaded_jar>"
  exit 1
fi

JAR_PATH="$1"

if [[ ! -f "$JAR_PATH" ]]; then
  echo "ERROR: File not found at '$JAR_PATH'"
  exit 1
fi

mkdir -p author publish logs dispatcher

cp "$JAR_PATH" ./author/aem-author-p4502.jar
cp "$JAR_PATH" ./publish/aem-publish-p4503.jar

rm -f "$JAR_PATH"

echo "Setup completed successfully."
echo "JAR copied to:"
echo "  → ./author/aem-author-p4502.jar"
echo "  → ./publish/aem-publish-p4503.jar"
echo "Original file deleted."

if [[ -d ".git" ]]; then
  echo "Removing Git information to make this instance standalone..."
  rm -rf .git
fi
