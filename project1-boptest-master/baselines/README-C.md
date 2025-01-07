### Baseline Testing（基线测试）

本文件夹包含用于对不同测试用例的基线控制器进行测试的示例和结果。

---

### **基线控制器与测试用例的实现**

- `root/examples/python/controllers/baseline.py` 模块文件用于执行每个测试用例的基线控制。  
  **简化方式**：设置控制输入 `u={}`。

- 测试脚本 `run_baselines.py` 用于运行基线测试。运行时需提供配置文件 `config.json` 和测试用例名称作为命令行参数。

---

### **配置文件说明**

配置文件 `config.json` 用于设置基线仿真的运行参数，主要包括以下功能：

#### **功能选项**
1. **预定义场景：**  
   - 包含所有测试用例的代表性场景，涵盖不同的电价和时间段组合。  
   - 详细场景说明见 `root/Testcases/README.md` 或测试用例的网页文档。

2. **保存 KPI 结果：**  
   - 选项：`save_kpi_results`（布尔值，`true/false`）。  
   - 说明：保存计算的关键绩效指标（KPI）结果至目录 `root/baselines/result`。若目录不存在，会自动创建。

3. **保存测量值：**  
   - 选项：`save_measurements`（布尔值，`true/false`）。  
   - 说明：保存测量输出至目录 `root/baselines/result`。

4. **运行用户自定义测试：**  
   - 选项：`run_user_defined_test`（布尔值，`true/false`）。  
   - 说明：启用用户自定义的测试场景。

#### **用户自定义测试参数**
- **electricity_price：** 电价类型。  
- **start_time：** 仿真起始时间。  
- **warmup_period：** 仿真预热时间。  
- **length：** 仿真持续时长。

---

### **运行基线测试示例**

1. 针对特定测试用例运行测试：  
   ```bash
   make run_baseline_<TestCase>
   ```

2. 运行所有基线测试用例：  
   ```bash
   make run_baseline_all
   ```

---

### **基线测试结果**

- **最近更新版本：** BOPTEST v0.6.0。

#### **结果分析目标**
展示不同时间段和三种电价方案下的各种 KPI 的参考范围。  
1. 比较代表性场景的结果与全年平均结果（第 15-358 天）或供暖季平均结果（若测试用例仅含供暖系统，第 15-45 天和第 297-358 天）。  
2. 仿真采用滚动窗口（两周）。

#### **存储位置**
- KPI 结果：`root/baselines/csv`。  
- 结果复现：  
  使用脚本 `root/baselines/csv/run_all_scenarios.py`，并提供所需测试用例名称作为命令行参数。

---

### **模拟总览**

- 共模拟 3180 个场景，涵盖不同时间段和三种电价方案。
- 注意：**基线控制器不使用价格信号信息**，因此 KPI 结果在不同电价方案下是相同的（除了总成本和控制器计算时间比值）。

---

### **结果分析工具**

- **Jupyter Notebook：**  
  - 文件：`root/baselines/baseline_control.ipynb`。  
  - 功能：高层次统计分析与详细结果可视化。

- **按测试用例结果说明：**
  - **全年数据（第 15-358 天）：**
    - `bestest_air`  
    - `multizone_office_simple_air`  
  - **供暖季数据（第 15-45 天和第 297-358 天）：**
    - `bestest_hydronic`  
    - `bestest_hydronic_heat_pump`  
    - `multizone_residential_hydronic`  
    - `twozone_apartment_hydronic`  
    - `singlezone_commercial_hydronic`  

此文档描述了基线测试的运行步骤、配置选项及其结果分析的工具与方法。