### **BACnet 接口**

本目录的内容用于在 BOPTEST 测试用例之上部署 BACnet 接口。通过这种方式，BACnet 应用和控制器可以与 BOPTEST 测试用例的测量点和控制点进行通信。

---

### **架构概念**

- BACnet 接口通过创建一个虚拟 BACnet 设备，将测试用例中的测量点和控制点暴露为 BACnet 对象。
- BACnet 应用可以通过这些对象与虚拟设备通信。
- 接口的底层机制通过 BOPTEST 的 HTTP RESTful API 实现：
  - 将 BACnet 接口收到的输入/输出数据，转化为对 BOPTEST 的 API 调用。
  - 模拟环境每 5 秒实时推进一次，同时运行 5 秒的模拟时间，并使用当前写入 BACnet 对象的控制值更新测试用例状态。

#### **对象配置**
- BACnet 对象的配置基于每个测试用例对应的 `.ttl` 文件，存储在测试用例目录中。
- 这些 `.ttl` 文件由 `create_ttl.py` 脚本生成，定义了 BACnet 对象的属性，采用 Brick 语义格式。
- 当前主要用 Brick 来存储 BACnet 对象的配置数据，未来可以进一步扩展其语义表示能力，与 BOPTEST 集成。

---

### **依赖**

- **Python**：Python 3
- **Python 库**：
  - `bacpypes`  
  - `rdflib`

---

### **快速开始**

1. **部署测试用例**  
   启动需要测试的 BOPTEST 测试用例（如 `bestest_air` 或其他用例）。

2. **配置 BACnet 网络地址**  
   编辑 `BACpypes.ini` 文件，定义虚拟 BACnet 设备的网络地址。

3. **运行 BACnet 接口**  
   在终端中运行以下命令，将测试用例暴露为 BACnet 对象：  
   ```bash
   python BopTestProxy.py bestest_air 0 0
   ```
   - 参数说明：
     - `bestest_air`：测试用例的名称（替换为你需要的测试用例）。
     - `0`：起始时间（秒）。
     - `0`：预热时间（秒）。

4. **连接 BACnet 应用**  
   使用 BACnet 应用（如 YABE 或其他 BACnet 浏览器工具）扫描网络上的设备，找到对应的 BACnet 对象，并进行读写操作。

---

### **注意事项**

#### **本地模型调用**
如果仅需在本地调用新增的测试用例（如 `testcase8`），直接通过 RESTful API 与 BOPTEST 交互即可，无需使用 BACnet 接口。

#### **需要使用 BACnet 接口时的额外步骤**
若需要通过 BACnet 接口暴露新测试用例（如 `testcase8`）：
1. **生成 `.ttl` 文件**  
   使用 `create_ttl.py` 为测试用例生成 BACnet 配置文件：  
   ```bash
   python create_ttl.py testcase8
   ```
   该文件将定义测试用例的 BACnet 对象属性。

2. **运行 BACnet 接口**  
   修改运行命令，指定新测试用例：  
   ```bash
   python BopTestProxy.py testcase8 0 0
   ```

3. **配置 `BACpypes.ini` 文件**  
   确保配置文件中的网络地址适用于当前网络环境。

4. **测试集成**  
   使用 BACnet 应用确认 BACnet 设备和对象是否正确显示，并测试其与模拟环境的交互。

---

### **引用与致谢**

- `BopTestProxy.py` 脚本基于 Erik Paulson 的原型代码开发，地址：[https://github.com/epaulson/boptest-bacnet-proxy](https://github.com/epaulson/boptest-bacnet-proxy)。  
- 示例代码 `/example/SimpleReadWrite.py` 和 `BopTestProxy.py` 均基于 `BACpypes` Python 库，分发于 MIT 许可证下。详细信息请参考项目根目录下的 `license.md` 文件。