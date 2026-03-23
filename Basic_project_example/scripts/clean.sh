#!/usr/bin/env bash
# 删除 build/ 目录
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
rm -rf "${ROOT}/build"
echo "已清理: ${ROOT}/build"
