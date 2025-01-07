# -*- coding: utf-8 -*-
# 其他导入和代码

import numpy as np
import matplotlib.pylab as plt

from pymodelica import compile_fmu
from pyfmi import load_fmu

class_name = 'RLC_Circuit'
mofile = 'RLC_Circuit.mo'  # 假设 .mo 文件和 Python 脚本或 Jupyter notebook 在同一文件夹

fmu_name = compile_fmu(class_name, mofile)
rlc = load_fmu(fmu_name)

res = rlc.simulate(final_time=30)

# 提取模拟结果
sine_y = res['sine.y']
resistor_v = res['resistor.v']
inductor1_i = res['inductor1.i']
t = res['time']

# 绘图
fig = plt.figure()
plt.plot(t, sine_y, t, resistor_v, t, inductor1_i)
plt.legend(('sine.y', 'resistor.v', 'inductor1.i'))
plt.show()
