# -*- coding: utf-8 -*-
"""
This module compiles the defined test case model into an FMU using the
overwrite block parser.

The following libraries must be on the MODELICAPATH:

- Modelica IBPSA

"""
import os
print(os.environ['JAVA_HOME'])
from parsing import parser


def compile_fmu():
    '''Compile the fmu.

    Returns
    -------
    fmupath : str
        Path to compiled fmu.

    '''

    # DEFINE MODEL
    # ------------
    mopath = 'SimpleRC.mo';
    modelpath = 'SimpleRC'
    # ------------

    # COMPILE FMU
    # -----------
    fmupath = parser.export_fmu(modelpath, [mopath])
    print("FMU path: {}".format(fmupath))

    # -----------
    # 检查文件路径是否存在
    if not os.path.isfile(fmupath):
        print("Error: FMU file does not exist at the expected path.")
        return None

    return fmupath

if __name__ == "__main__":
    fmupath = compile_fmu()



