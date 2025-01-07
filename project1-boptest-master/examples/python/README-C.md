### **基于Python的示例**

此目录包含用于使用Python进行控制测试的示例模块。

---

### **结构**

- **`interface.py`**  
  主要示例脚本，用于通过 BOPTEST API 配置和运行控制器测试。

- **`testcase1_scenario.py`**  
  使用预定义场景配置并运行一个名为“testcase1”的原型测试用例。它使用了在 `interface.py` 中实现的测试接口，并使用了在 `controllers/pid.py` 中实现的具体控制器。

- **`testcase1.py`**  
  使用自定义的测试开始时间和长度参数配置并运行一个名为“testcase1”的原型测试用例。它同样使用 `interface.py` 中实现的测试接口，并使用 `controllers/pid.py` 中实现的具体控制器。

- **`testcase2.py`**  
  使用自定义的测试开始时间和长度参数配置并运行一个名为“testcase2”的原型测试用例。它使用了 `interface.py` 中的测试接口，并使用了在 `controllers/sup.py` 中实现的具体控制器。

- **`testcase3.py`**  
  使用自定义的测试开始时间和长度参数以及预测数据配置并运行一个名为“testcase3”的原型测试用例。它使用了 `interface.py` 中的测试接口，并使用了 `controllers/pidTwoZones.py` 中实现的具体控制器。

- **`/controllers`**  
  包含一个通用控制器类 `controller.py`，它实例化了在 `pid.py`、`pidTwoZones.py` 和 `sup.py` 中定义的具体控制器方法。

- **`/custom_kpi`**  
  提供了一个代码库，用于根据 BOPTEST 测试结果实现自定义 KPI（关键绩效指标）计算。

---

### **运行示例测试**

1. 首先，按照上述说明部署与所选示例对应的测试用例（部署指南见根目录 `README.md` 文件）。
2. 然后，使用以下命令运行示例测试（根据选择的示例模块）：
   ```bash
   $ python testcase<...>.py
   ```

---

### **快速入门：测试您的控制器**

这些示例模块可以作为模板，帮助您测试自己的控制器，步骤如下：

1. **实现待测试的控制器**  
   编写一个名为 `controller_module.py` 的模块，该模块至少应包含两个函数：
   - **`initialize`**：此函数计算初始的控制输入。
   - **`compute_control`**：此函数基于最新的测量结果和（如有需要）预测数据来更新 BOPTEST 测试用例中的控制输入。如果控制器需要使用预测数据，还应该在控制器模块中实现一个 **`update_forecasts`** 函数。
   
   控制模块的示例可以在 `/controllers` 目录中找到。

2. **开发测试脚本**  
   编写一个测试脚本，用于执行控制测试。在脚本中，实例化 `interface.py` 中实现的接口类，指定要使用的 `controller_module.py`，以及模拟的开始时间、热身期和时长，或选择一个预定义的测试用例场景。  
   可选地，用户还可以提供自定义 KPI 的配置，并指定控制器是否使用预测信息。

---

通过这些步骤，您可以测试并验证自己的控制器与 BOPTEST 测试用例的配合效果。