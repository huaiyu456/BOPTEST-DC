### 测试运行

#### 运行所有测试
- **命令**：`$ make test_all`
- 完成后，测试报告会显示，并记录在 `testing_report.txt` 文件中。

#### 运行特定测试用例 `<testcase>`
1. **检查 Docker 镜像**：
   - 首先检查是否存在名为 `jm` 的 Docker 镜像。如果没有，使用命令：`$ make build_jm_image` 构建镜像。
   
2. **运行测试**：
   - 使用命令：`$ make test_<testcase>` 运行测试。
   - 流程：
     - 编译模型。
     - 构建测试用例镜像。
     - 部署测试用例容器（以 detached 模式）。
     - 运行 Julia 控制器示例。
     - 运行 `test_<testcase>.py` 测试文件。
     - 停止测试用例容器。
     - 删除测试用例镜像。

#### 运行解析器测试
1. **检查 Docker 镜像**：
   - 首先检查是否存在名为 `jm` 的 Docker 镜像。如果没有，使用命令：`$ make build_jm_image` 构建镜像。
   
2. **运行测试**：
   - 使用命令：`$ make test_parser` 运行解析器测试。
   - 流程：
     - 运行 `test_parser.py` 测试文件。

#### 运行数据测试
1. **检查 Docker 镜像**：
   - 首先检查是否存在名为 `jm` 的 Docker 镜像。如果没有，使用命令：`$ make build_jm_image` 构建镜像。

2. **运行测试**：
   - 使用命令：`$ make test_data` 运行数据测试。
   - 流程：
     - 编译 `testcase2` 和 `testcase3` 模型。
     - 将 `/data`、`/forecast` 和 `/kpis` 目录以及 `testcases/testcase2` 和 `testcases/testcase3` 目录复制到 `jm` Docker 容器中。
     - 在 `jm` Docker 容器中运行 `test_data.py` 测试文件。
     - 复制参考结果和测试日志，之后停止 `jm` Docker 容器。

#### 运行预测器测试
1. **检查 Docker 镜像**：
   - 首先检查是否存在名为 `jm` 的 Docker 镜像。如果没有，使用命令：`$ make build_jm_image` 构建镜像。

2. **运行测试**：
   - 使用命令：`$ make test_forecast` 运行预测器测试。
   - 流程：
     - 编译 `testcase2` 和 `testcase3` 模型。
     - 将 `/data`、`/forecast` 和 `/kpis` 目录以及 `testcases/testcase2` 和 `testcases/testcase3` 目录复制到 `jm` Docker 容器中。
     - 在 `jm` Docker 容器中运行 `test_forecast.py` 测试文件。
     - 复制参考结果和测试日志，之后停止 `jm` Docker 容器。

#### 运行 KPI 计算器测试
1. **检查 Docker 镜像**：
   - 首先检查是否存在名为 `jm` 的 Docker 镜像。如果没有，使用命令：`$ make build_jm_image` 构建镜像。

2. **运行测试**：
   - 使用命令：`$ make test_kpis` 运行 KPI 计算器测试。
   - 流程：
     - 编译 `testcase2` 和 `testcase3` 模型。
     - 将 `/data`、`/forecast` 和 `/kpis` 目录以及 `testcases/testcase2` 和 `testcases/testcase3` 目录复制到 `jm` Docker 容器中。
     - 在 `jm` Docker 容器中运行 `test_kpis.py` 测试文件。
     - 复制参考结果和测试日志，之后停止 `jm` Docker 容器。

#### 运行 README 命令测试
- **命令**：`$ make test_readme_commands`
- 该测试构建并运行 `testcase2`，然后执行 `../README.md` 文件中展示的 API 调用。

### 其他说明
- **`utilities.py`**：提供常见的测试功能，供 Python 测试用例使用。
- 每个测试在 `makefile` 中都会生成一个日志文件，格式为 `<test_name>.log`。如果使用 `$ make test_all` 运行所有测试，则 `report.py` 会读取并总结所有测试日志，最终将总结结果写入 `testing_report.txt` 文件。
- 测试环境的 Python 包版本可以在 `../.travis.yml` 文件中的 `python: 3.9` 配置项中找到。
- 额外的 `make` 目标 `test_python2` 会在 Python 2.7 环境中运行 `../examples/python` 中为 `testcase1`、`testcase2` 和 `testcase3` 实现的控制器示例。