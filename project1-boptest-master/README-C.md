### BOPTEST（Building Optimization Performance Tests）概述

BOPTEST 是一个用于建筑控制策略仿真性能测试的框架，旨在通过仿真基准测试来评估不同建筑优化方案的表现。它是 IBPSA 项目的一部分，目前正用于多个项目阶段，包括第 1 项目和第 2 项目的开发工作。BOPTEST 提供了 Web 服务架构，并通过 Docker 容器化部署来支持多个测试案例和并行模拟。

---

### 结构说明

1. **/testcases**：包含测试案例，包括文档、模型和配置设置。
2. **/service**：用于将 BOPTEST 框架作为 Web 服务（BOPTEST-Service）进行部署的代码。
3. **/examples**：包含与测试案例交互并运行示例测试的代码，支持 Python (3.9) 和 Julia（版本 1.0.3）的控制器。
4. **/parsing**：解析 Modelica 模型的脚本，输出一个 FMU（功能模型单元）和 KPI JSON 文件。
5. **/testing**：进行单元和功能测试的代码。
6. **/data**：生成并管理与测试案例相关的数据，包括天气、时间表和能源价格等边界条件。
7. **/forecast**：返回边界条件（如天气、时间表和能源价格）预测的代码。
8. **/kpis**：计算关键性能指标（KPI）的代码。
9. **/docs**：设计文档和交付的工作坊内容。
10. **/baselines**：用于基准化测试案例 KPI 的脚本和数据。
11. **/bacnet**：提供 BACnet 接口的代码。

---

### 快速启动：本地部署和使用 BOPTEST

1. **克隆或下载该存储库**。
2. **安装 Docker**。
3. **使用 Docker 构建并运行 BOPTEST**：
   在存储库根目录运行以下命令：

   ```bash
   docker compose up web worker provision
   ```

4. **运行多个测试案例**：
   如果需要同时运行多个测试案例，可以将参数 `--scale worker=n` 附加到上述命令中，其中 `n` 为想要运行的测试案例数。

5. **设置超时期**：
   如果没有请求时，测试案例会自动停止并释放工作器。默认的超时为 15 分钟。如果希望修改此超时期，可以编辑 `.env` 文件中的环境变量 `BOPTEST_TIMEOUT`。

6. **使用 API 与测试交互**：
   在另一个进程中，使用以下 API 来选择测试案例并与其交互：

   ```http
   http://127.0.0.1:80/<request>
   ```

7. **关闭 BOPTEST**：
   运行以下命令关闭 BOPTEST：

   ```bash
   docker compose down
   ```

   这是关闭 BOPTEST 的最佳方式，可以防止重新部署时出现问题。

---

### 使用 BOPTEST 公共 Web 服务

BOPTEST 也可以通过公共 Web 服务使用。访问 API：

```http
https://api.boptest.net/<request>
```

#### RESTful HTTP API

BOPTEST 提供了一系列 RESTful API 来与正在运行的测试案例交互。以下是一些常用的 API 请求：

- **列出所有 BOPTEST 测试案例**：
  ```http
  GET testcases
  ```

- **选择测试案例并开始新的测试**：
  ```http
  POST testcases/{testcase_name}/select
  ```

- **使用控制输入推进仿真并接收测量数据**：
  ```http
  POST advance/{testid} <input_name_u>:<value>
  ```

- **初始化仿真**：
  ```http
  PUT initialize/{testid} start_time=<value> warmup_period=<value>
  ```

- **接收当前测试场景**：
  ```http
  GET scenario/{testid}
  ```

- **获取测试 KPI**：
  ```http
  GET kpi/{testid}
  ```

- **停止一个排队或正在运行的测试**：
  ```http
  PUT stop/{testid}
  ```

---

### BOPTEST-Service 部署架构

BOPTEST-Service 采用 Web 服务架构，支持多个客户端和并发测试。该架构为容器化设计，可在个人计算机上部署，但更适合商业云计算环境（如 AWS）。架构图如下：

```plaintext
   A[API Client] <--> B[Web Frontend]
      subgraph cloud [Cloud Deployment]
              B <--> C[(Message Broker)]
              C <--> D[Worker 1]
              C <--> E[Worker 2]
              C <--> F[Worker N]
          subgraph workers [Worker Pool]
              D
              E
              F
          end
      end
```

---

### BOPTEST 服务的 API

BOPTEST 服务提供一系列 API 来管理测试案例和运行测试，包括授权请求：

- **列出官方测试案例**：
  ```http
  GET testcases
  ```

- **获取特定测试案例的状态**：
  ```http
  GET status/{testid}
  ```

- **选择并开始一个用户的私有测试案例（需要授权）**：
  ```http
  POST users/{username}/testcases/{testcase_name}/select
  ```

- **停止一个测试**：
  ```http
  PUT stop/{testid}
  ```

---

### 开发与贡献

社区开发受到欢迎，可以通过报告问题或提交 Pull Request 来贡献代码。如果提交 PR，请确保首先打开一个问题，并按照约定命名开发分支。

开发者使用 `pre-commit` 工具来确保文件符合格式规范。运行 `pre-commit` 来自动检查文件格式：

```bash
pip install pre-commit
pre-commit run --all-files
```

---

### 其他软件接口

- **OpenAI-Gym 环境接口**：用于 BOPTEST 的 OpenAI-Gym 环境接口实现，详见 [ibpsa/project1-boptest-gym](https://github.com/ibpsa/project1-boptest-gym)。
- **BACnet 接口**：提供 BACnet 接口，见 `/bacnet` 目录的 README 文件。
- **Julia 接口**：用于与 BOPTEST 交互的 Julia 包，见 [BOPTestAPI.jl](https://github.com/ibpsa/project1-boptest-gym)。

---

### 参考文献

BOPTEST 的引用文献：

- D. Blum, J. Arroyo, S. Huang, J. Drgona, F. Jorissen, H.T. Walnum, Y. Chen, K. Benne, D. Vrabie, M. Wetter, and L. Helsen. (2021). "Building optimization testing framework (BOPTEST) for simulation-based benchmarking of control strategies in buildings." *Journal of Building Performance Simulation*, 14(5), 586-610.

--- 

通过这些资源，您可以快速部署 BOPTEST、交互式运行测试、并进行基准测试和优化分析。如果有更多问题或需要详细帮助，可以参考相应的文档和 API 页面。