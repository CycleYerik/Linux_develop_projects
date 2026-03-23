# Basic_project_example — 工程说明

本目录是 **Linux C 学习用工程模板**（对应 `quick_guide.md` 中的「项目0：开发环境与工程模板」）。用于熟悉目录组织、CMake、脚本构建与基本调试流程。

---

## 目录结构与各部分作用

```
Basic_project_example/
├── CMakeLists.txt      # CMake 工程配置：标准、警告、可执行目标、包含路径
├── README.md           # 本说明（工程总览与使用方式）
├── .clang-format       # 代码风格（需安装 clang-format 后使用）
├── .gitignore          # 忽略 build/、中间文件等
├── include/            # 公共头文件（.h），供 src/ 内多个 .c 引用
│   └── utils.h
├── src/                # 实现文件（.c）
│   ├── main.c          # 程序入口
│   └── utils.c         # 与 utils.h 对应的实现
├── scripts/            # 一键编译 / 运行 / 清理
│   ├── build.sh
│   ├── run.sh
│   └── clean.sh
├── tests/              # 单元测试或独立测试程序（当前为占位，见 tests/README.md）
│   └── README.md
└── build/              # 由 CMake 生成（勿手改；已在 .gitignore 中忽略）
```

| 部分 | 功能 |
|------|------|
| **CMakeLists.txt** | 定义项目名、C11、默认 `Debug`、`include/` 搜索路径、可执行文件 `basic_project_example` 及其源文件列表。 |
| **include/** | 对外声明的 API；`src/*.c` 通过 `#include "xxx.h"` 使用。避免在多个 `.c` 里重复声明。 |
| **src/** | 具体逻辑实现；`main.c` 只做启动与组装，复杂功能可拆到更多 `.c`。 |
| **scripts/** | 从任意工作目录都能定位到工程根并执行构建，减少手写 `mkdir build && cd build && cmake ..`。 |
| **tests/** | 预留测试代码位置；可与主程序共用 `include/` 或单独 `add_executable`（需改 CMake）。 |
| **build/** | 编译产物与 CMake 缓存；可随时 `./scripts/clean.sh` 删掉重新配置。 |

---

## 如何使用

### 依赖

- `cmake`（≥ 3.10）、`make`、`gcc` 或 `clang`
- 可选：`gdb`、`valgrind`、`strace`、`clang-format`

### 编译

在工程根目录执行（首次需 `chmod +x scripts/*.sh`）：

```bash
./scripts/build.sh          # 默认 Debug
./scripts/build.sh Release  # 发布优化构建
```

等价手动步骤：

```bash
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build . --parallel
```

生成可执行文件：**`build/basic_project_example`**。

### 运行

```bash
./scripts/run.sh
# 或直接
./build/basic_project_example
```

### 清理构建目录

```bash
./scripts/clean.sh
```

### 调试与检查（学习建议）

```bash
# 需先 Debug 构建
gdb --args ./build/basic_project_example

valgrind --leak-check=full ./build/basic_project_example

strace -e trace=write ./build/basic_project_example
```

### IDE / clangd

本工程开启了 `CMAKE_EXPORT_COMPILE_COMMANDS`。构建后可将 `build/compile_commands.json` 复制或链接到工程根，便于 `clangd` 补全与跳转：

```bash
ln -sf build/compile_commands.json compile_commands.json
```

---

## 如何修改与扩展

### 1. 改业务逻辑

- 改 **`src/main.c`**：入口、参数解析、主流程。
- 改 **`src/utils.c` / `include/utils.h`**：示例模块；可复制该对文件新增 `foo.c` / `foo.h`。

### 2. 新增源文件

1. 在 `src/` 增加 `new_module.c`，必要时在 `include/` 增加 `new_module.h`。
2. 编辑 **`CMakeLists.txt`**，在 `add_executable(basic_project_example ...)` 中追加一行：

   ```cmake
   add_executable(basic_project_example
       src/main.c
       src/utils.c
       src/new_module.c
   )
   ```

3. 重新执行 `./scripts/build.sh`。

> 若将来源文件很多，可改用 `file(GLOB ...)` 或拆成静态库 `add_library` + `target_link_libraries`，此处模板保持显式列表，便于初学者看清依赖。

### 3. 修改编译选项或标准

- 在 **`CMakeLists.txt`** 中调整 `CMAKE_C_STANDARD`、`add_compile_options`、或按 `CMAKE_BUILD_TYPE` 分支添加选项。

### 4. 修改可执行文件名

- 将 `add_executable` 的第一个参数从 `basic_project_example` 改为新名字，并同步修改 **`scripts/run.sh`** 中的 `BIN=.../build/新名字`。

### 5. 增加测试目标（可选）

在 **`CMakeLists.txt`** 末尾可增加：

```cmake
enable_testing()
add_executable(test_utils tests/test_utils.c src/utils.c)
target_include_directories(test_utils PRIVATE ${CMAKE_SOURCE_DIR}/include)
add_test(NAME test_utils COMMAND test_utils)
```

然后在 `tests/` 下编写 `test_utils.c`，构建目录中执行 `ctest` 或 `./test_utils`。详见 **`tests/README.md`**。

### 6. 代码风格

安装 `clang-format` 后，在工程根目录：

```bash
clang-format -i src/*.c include/*.h
```

规则见 **`.clang-format`**。

---

## 常见问题

| 现象 | 处理 |
|------|------|
| `run.sh` 提示找不到可执行文件 | 先执行 `./scripts/build.sh`。 |
| 修改了 `CMakeLists.txt` 不生效 | `clean` 后重新 `build`，或删除 `build/` 再配置。 |
| 头文件找不到 | 确认 `#include` 与 `include/` 下文件名一致，且头文件已在 CMake 的包含路径中（本模板已设置 `include_directories`）。 |

---

## 与学习计划的关系

完成本模板后，可将同一套 **`include/` + `src/` + `scripts/` + CMake** 复制到新目录，作为「多线程传感器」「TCP demo」等项目的起点，减少重复搭建环境的时间。
