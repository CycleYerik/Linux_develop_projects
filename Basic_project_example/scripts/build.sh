#!/usr/bin/env bash
# 用法: ./scripts/build.sh [Debug|Release]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_TYPE="${1:-Debug}"

if [[ "${BUILD_TYPE}" != "Debug" && "${BUILD_TYPE}" != "Release" ]]; then
    echo "用法: $0 [Debug|Release]" >&2
    exit 1
fi

mkdir -p "${ROOT}/build"
cd "${ROOT}/build"
cmake .. -DCMAKE_BUILD_TYPE="${BUILD_TYPE}"
cmake --build . --parallel

echo "构建完成: ${ROOT}/build/basic_project_example (${BUILD_TYPE})"
