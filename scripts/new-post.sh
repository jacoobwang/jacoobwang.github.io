#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "" ]; then
  echo "Usage: ./scripts/new-post.sh <slug> [title]"
  exit 1
fi

slug="$1"
title="${2:-$slug}"
file="content/post/${slug}.md"

if [ -e "$file" ]; then
  echo "File already exists: $file"
  exit 1
fi

timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z' | sed 's/\(..\)$/:\1/')"

mkdir -p content/post

cat > "$file" <<EOF
---
title: "$title"
date: $timestamp
draft: false
description: ""
slug: "$slug"
---

EOF

echo "Created $file"
echo "Next:"
echo "1. Edit the post content."
echo "2. Run: hugo --minify"
echo "3. Commit and push master."
