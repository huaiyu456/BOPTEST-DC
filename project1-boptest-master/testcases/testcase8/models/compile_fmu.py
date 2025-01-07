# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA

"""

import os
import subprocess


def compile_fmu():
    '''使用OpenModelica编译FMU。

    Returns
    -------
    fmupath : str
        编译后的FMU文件路径。
    '''

    # 定义模型
    mopath = r'C:\Users\ASUS\Desktop\FDD\git_Boptest\project1-boptest-master\testcases\testcase1\models\SimpleRC.mo'
    mopath = mopath.replace('\\', '/')
    modelpath = 'SimpleRC'
    # OpenModelica路径
    omc_path = r'D:\openmodelica\bin\omc.exe'

    with open('buildModel.mos', 'w', encoding='utf-8') as f:

        f.write('setCommandLineOptions("-d=initialization,NLSanalyticJacobian");\n')  # 设置编译选项
        f.write('loadModel(Modelica);\n')  # 加载标准库
        f.write('installPackage(Buildings, "11.0.0", exactMatch=false);\n')  # 安装Buildings库
        f.write('getErrorString();\n')
        f.write('loadModel(Buildings);\n')  # 加载Buildings库
        f.write('getErrorString();\n')
        # 然后加载和编译模型
        f.write(f'loadFile("{mopath}");\n')
        f.write('getErrorString();\n')  # 获取可能的错误信息
        f.write(f'buildModelFMU({modelpath}, version="2.0", fmuType="cs", fileNamePrefix="{modelpath}");\n')
        f.write('getErrorString();\n')  # 获取编译过程中的错误信息
        f.write('quit();\n')

    # 执行编译命令
    cmd = f'"{omc_path}" buildModel.mos'
    print(f"执行命令: {cmd}")
    print(f"使用的模型文件路径: {mopath}")

    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True, encoding='utf-8')
        print("编译输出:")
        print(result.stdout)
        if result.stderr:
            print("错误输出:")
            print(result.stderr)
    except subprocess.CalledProcessError as e:
        print(f"编译失败，错误码: {e.returncode}")
        if hasattr(e, 'stdout') and e.stdout:
            print(f"标准输出: {e.stdout}")
        if hasattr(e, 'stderr') and e.stderr:
            print(f"错误输出: {e.stderr}")
        raise

    # FMU文件路径
    fmupath = f"{modelpath}.fmu"

    # 检查FMU是否生成
    if not os.path.exists(fmupath):
        raise Exception("FMU生成失败，请检查模型文件是否存在且语法正确")
    else:
        print(f"FMU文件已成功生成在: {os.path.abspath(fmupath)}")

    return fmupath


if __name__ == "__main__":
    try:
        fmupath = compile_fmu()
        print(f"FMU已成功生成: {fmupath}")
    except Exception as e:
        print(f"错误: {str(e)}")
