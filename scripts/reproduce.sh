#!/usr/bin/env bash
set -euo pipefail
stage_dir=${1:?Usage: reproduce.sh /path/to/new-checkout}
package_dir=$(cd "$(dirname "$0")/.." && pwd)
test ! -e "$stage_dir"
git clone https://github.com/mailtotanvir/AI-Engineering-Visual-Guide.git "$stage_dir"
git -C "$stage_dir" checkout c8c5e2b6195e8f725f0ccba86b2b3d29c16514df
git -C "$stage_dir" apply --check "$package_dir/integration/webmcp.patch"
git -C "$stage_dir" apply "$package_dir/integration/webmcp.patch"
printf 'Prepared %s\nRun npm ci, npm test, npm run build, and npm run dev in that directory.\n' "$stage_dir"
