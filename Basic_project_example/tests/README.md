# tests/ 目录说明

本目录用于放置**与主程序分离的测试代码**（单元测试、集成测试或小工具），避免把大量 `assert` 堆在 `main.c` 里。

## 与工程其它部分的关系

- **头文件**：测试若需调用 `utils` 等模块，可 `#include "utils.h"`，包含路径与主程序一致（由顶层 `CMakeLists.txt` 的 `include_directories` 提供）。
- **主程序**：`src/main.c` 只负责正式入口；验证逻辑尽量放在本目录下的独立 `.c` 文件中。
- **完整工程说明**（目录结构、脚本、如何改 CMake、如何调试）：请阅读项目根目录的 **[README.md](../README.md)**。

## 当前状态

尚未接入第三方测试框架；你可以任选一种方式扩展：

1. **最小方式**：`tests/test_utils.c` 内写 `main`，手动调用 `utils_add` 等并用 `assert` 或打印判断；在 `CMakeLists.txt` 里 `add_executable` 指向该文件并把 `src/utils.c` 一起链接。
2. **框架方式**：安装 [Criterion](https://github.com/Snaipe/Criterion)、Unity 等，在本目录编写用例，并用 `ctest` 驱动。

## 构建主工程（与测试无关时的习惯命令）

主可执行文件仍由仓库根目录脚本构建：

```bash
cd /path/to/Basic_project_example
./scripts/build.sh
```

若你为测试增加了独立目标，一般在 `build/` 目录下会多出一个可执行文件（例如 `test_utils`），具体以你在 `CMakeLists.txt` 中的定义为准。
