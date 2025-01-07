# -*- coding: utf-8 -*-
"""
This script demonstrates a minimalistic example of testing a feedback controller
with the prototype test case called "testcase11".  It uses the testing
interface implemented in interface.py and the concrete controller implemented
in controllers/pid.py.

"""

# GENERAL PACKAGE IMPORT
# ----------------------
import sys
import os
import json
sys.path.insert(0, '/'.join((os.path.dirname(os.path.abspath(__file__))).split('/')[:-2]))
from examples.python.interface import control_test


def run(plot=False):
    """Run controller test.

    Parameters
    ----------
    plot : bool, optional
        True to plot timeseries results.
        Default is False.

    Returns
    -------
    kpi : dict
        Dictionary of core KPI names and values.
        {kpi_name : value}
    res : dict
        Dictionary of trajectories of inputs and outputs.
    custom_kpi_result: dict
        Dictionary of tracked custom KPI calculations.
        Empty if no customized KPI calculations defined.

    """

    print("开始运行测试...")

    # 直接指定测试用例路径
    testcase_path = r'C:\Users\ASUS\Desktop\FDD\git_Boptest\project1-boptest-master\testcases\testcase12'
    models_path = os.path.join(testcase_path, 'models')

    print(f"\n检查路径和文件:")
    print(f"测试用例路径: {testcase_path}")
    print(f"模型目录路径: {models_path}")

    # 检查文件
    print("\n检查模型文件:")
    print("-" * 50)
    if os.path.exists(os.path.join(models_path, 'SimpleRC.mo')):
        print(f"找到 .mo 文件: SimpleRC.mo")
        mo_time = os.path.getmtime(os.path.join(models_path, 'SimpleRC.mo'))
        print(f".mo 文件修改时间: {mo_time}")

    if os.path.exists(os.path.join(models_path, 'wrapped.fmu')):
        print(f"找到 .fmu 文件: wrapped.fmu")
        fmu_time = os.path.getmtime(os.path.join(models_path, 'wrapped.fmu'))
        print(f".fmu 文件修改时间: {fmu_time}")

    # 检查配置
    config_path = os.path.join(models_path, 'config.json')
    if os.path.exists(config_path):
        with open(config_path, 'r') as f:
            config = json.load(f)
            print(f"\n配置文件内容:")
            print(f"测试用例名称: {config.get('name')}")
    print("-" * 50 + "\n")

    # CONFIGURATION FOR THE CONTROL TEST
    # ---------------------------------------
    control_module = 'examples.python.controllers.pid'
    start_time = 0
    warmup_period = 0
    length = 48*3600
    step = 300
    customized_kpi_dir_path = os.path.dirname(os.path.realpath(__file__))
    customized_kpi_config = os.path.join(customized_kpi_dir_path, 'custom_kpi', 'custom_kpis_example.config')
    # ---------------------------------------

    print("开始控制测试...")
    # RUN THE CONTROL TEST
    # --------------------
    try:
        kpi, df_res, custom_kpi_result, forecasts = control_test('testcase12',
                                                                control_module,
                                                                start_time=start_time,
                                                                warmup_period=warmup_period,
                                                                length=length,
                                                                step=step,
                                                                customized_kpi_config=customized_kpi_config)
        print("控制测试完成")
    except Exception as e:
        print(f"控制测试出错: {str(e)}")
        raise

    print("开始处理结果...")
    # POST-PROCESS RESULTS
    # --------------------
    try:
        time = df_res.index.values/3600  # convert s --> hr
        zone_temperature = df_res['TRooAir_y'].values - 273.15  # convert K --> C
        heating_power = df_res['PHea_y'].values
        print("结果处理完成")
    except Exception as e:
        print(f"结果处理出错: {str(e)}")
        raise

    # Plot results if needed
    if plot:
        print("开始绘图...")
        try:
            from matplotlib import pyplot as plt
            import numpy as np
            plt.figure(1)
            plt.title('Zone Temperature')
            plt.plot(time, zone_temperature)
            plt.plot(time, 20*np.ones(len(time)), '--')
            plt.plot(time, 23*np.ones(len(time)), '--')
            plt.ylabel('Temperature [C]')
            plt.xlabel('Time [hr]')
            plt.figure(2)
            plt.title('Heater Power')
            plt.plot(time, heating_power)
            plt.ylabel('Electrical Power [W]')
            plt.xlabel('Time [hr]')
            plt.show()
            print("绘图完成")
        except ImportError:
            print("Cannot import numpy or matplotlib for plot generation")
        except Exception as e:
            print(f"绘图出错: {str(e)}")
    # --------------------

    return kpi, df_res, custom_kpi_result


if __name__ == "__main__":
    try:
        print("程序开始执行...")
        kpi, df_res, custom_kpi_result = run(plot=True)
        print("程序执行完成")
    except Exception as e:
        print(f"程序执行出错: {str(e)}")