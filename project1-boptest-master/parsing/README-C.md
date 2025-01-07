### 翻译与解释：

`parser.py` 用于解析 Modelica 模型中的信号交换块（signal exchange blocks），并编译出一个测试案例的 FMU（Functional Mock-up Unit），该 FMU 将顶层输入和输出连接到模型中适当的模块。它还解析与每个输出相关的 KPI（关键绩效指标），并将位于测试案例的 `Resources` 目录中的任何数据移动到生成的 FMU 的资源目录中。最终生成的测试案例 FMU 被命名为 `wrapped.fmu`，而 KPI 数据则被存储在名为 `kpis.json` 的文件中。信号交换块包含在 `IBPSA.Utilities.IO.SignalExchange` 包中。

### 步骤解释：
1. **解析 Modelica 模型**：
   - `parser.py` 会解析一个 Modelica 模型文件，提取其中的信号交换块并编译生成 FMU 文件。FMU 文件是 Modelica 模型的封装，方便与外部控制系统或仿真软件进行交互。
   - 在解析的过程中，`parser.py` 会连接顶层输入和输出到模型中的相应模块。

2. **生成 KPI 数据**：
   - `parser.py` 还会解析与每个输出相关的 KPI（关键绩效指标），并将其存储在一个名为 `kpis.json` 的文件中，供后续使用。

3. **移动资源文件**：
   - 测试案例的 `Resources` 目录中的数据会被移动到生成的 FMU 的资源目录中，这样这些资源可以在仿真过程中使用。

4. **信号交换块**：
   - `IBPSA.Utilities.IO.SignalExchange` 是一个包，包含用于信号交换的模块。这些模块用于模型中不同部分之间的数据交互。

### 如何运行示例：
1. 确保 Modelica 的 IBPSA 库已经添加到 `MODELICAPATH` 中。
   
   **命令：**
   ```bash
   export MODELICAPATH=path/to/IBPSA
   ```
   这会将 IBPSA 库添加到 Modelica 环境中，以便在解析过程中使用。

2. **运行 `parser.py`**：
   - 运行 `parser.py` 来解析并导出一个 Modelica 模型文件（如 `SimpleRC.mo`）和 KPI 配置文件（`kpis.json`）。
   
   **命令：**
   ```bash
   $ python parser.py
   ```
   这将处理 Modelica 文件并生成 `wrapped.fmu` 和 `kpis.json` 文件。

3. **运行 `simulate.py`**：
   - 使用 `simulate.py` 来模拟生成的 `wrapped.fmu` 文件。此命令的执行将模拟 FMU，并提供不同的覆盖选项：
     - **不覆盖**：初次运行时不会覆盖已有的 setpoint 或 actuator（执行第一次仿真）。
     - **覆盖 setpoint**：在后续仿真中，覆盖 setpoint 的值。
     - **覆盖 actuator**：最后，覆盖 actuator 的值进行仿真。

   **命令：**
   ```bash
   $ python simulate.py
   ```
   这将启动仿真，并根据设置覆盖相关的输入或输出。

### 总结：
`parser.py` 和 `simulate.py` 是一对脚本，前者用于处理 Modelica 模型，生成测试案例的 FMU 和 KPI 数据，后者用于执行仿真。通过这些步骤，用户可以轻松地解析 Modelica 模型并进行仿真，结合 KPI 数据进行性能评估。