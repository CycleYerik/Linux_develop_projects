#!/usr/bin/env bash
# 在项目根目录下运行已编译的可执行文件（需先执行 build.sh）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${ROOT}/build/basic_project_example"

if [[ ! -x "${BIN}" ]]; then
    echo "未找到可执行文件: ${BIN}" >&2
    echo "请先运行: ${ROOT}/scripts/build.sh" >&2
    exit 1
fi

exec "${BIN}" "$@"
