### **自定义KPI计算**

此目录包含在模拟过程中计算自定义KPI（关键绩效指标）的文件，并提供了相关使用示例。

---

### **结构**

- **`/custom_kpi_calculator.py`**  
  一个通用的Python类，用于设置和启用运行时的自定义KPI计算。该类会基于特定应用的配置文件进行实例化。

- **`/custom_kpis_example.config`**  
  一个自定义KPI配置文件示例。它定义了每个自定义KPI所需的数据点、KPI计算类以及计算设置。

- **`/custom_kpis_example.py`**  
  一个Python文件示例，其中包含定义处理模拟数据和计算自定义KPI的类的详细过程。

---

### **运行自定义KPI计算**

1. **定义自定义KPI信息**  
   在配置文件（例如 `custom_kpis_example.config`）中定义所需的自定义KPI信息。必需的输入信息包括：

   - **`name`**：KPI的名称。
   - **`kpi_class`**：用于执行KPI计算的Python类名，通常该类定义在 `kpi_file` 中。
   - **`kpi_file`**：包含 `kpi_class` 的Python文件。
   - **`data_points`**：一个字典，映射模拟输出数据到KPI计算所需的输入数据。可以根据需要在可选键下定义其他依赖于案例的信息。

2. **部署KPI计算**  
   通过在运行控制器脚本（例如 `szvav_sup.py` 和 `twoday_p.py`）时，设置 `custom_kpi` 参数为配置文件路径（例如 `custom_kpi/custom_kpis.config`）来启动自定义KPI计算。

---

通过这种方式，您可以根据模拟结果定制和计算所需的KPI，并为每个具体应用场景提供专门的计算逻辑。