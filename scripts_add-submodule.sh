#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <course_path> <git_repo_url> [<dest_name>]"
  echo "Example: $0 year-1/semester-1/SOK-1003 https://github.com/owner/repo.git"
  exit 1
fi

COURSE_PATH="$1"
REPO_URL="$2"
DEST_NAME="${3:-$(basename -s .git "$REPO_URL")}"

DEST_DIR="$COURSE_PATH/resources/external/$DEST_NAME"

mkdir -p "$COURSE_PATH/resources/external"
git submodule add "$REPO_URL" "$DEST_DIR"

echo "Submodule added at: $DEST_DIR"
echo "Remember to commit .gitmodules and the submodule directory."