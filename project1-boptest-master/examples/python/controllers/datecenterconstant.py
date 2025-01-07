# -*- coding: utf-8 -*-
"""
This module implements a constant controller of custom data center cooling system specifically.

"""


def compute_control(y, forecasts=None):

    u = {
        'oveChiTset_u': 293.15,
        'oveChiTset_activate': 1,
        'ovepumCHW_u': 53360,
        'ovepumCHW_activate': 1,
        'oveVal1_u': 0,
        'oveVal1_activate': 1,
        'oveVal3_u': 1,
        'oveVal3_activate': 1,
        'oveValByp_u': 0,
        'oveValByp_activate': 1,
        'oveVal2_u': 0,
        'oveVal2_activate': 1,
        'oveVal6_u': 1,
        'oveVal6_activate': 1,
        'ovemFanFlo_u': 33.2,
        'ovemFanFlo_activate': 1,
        'oveval_u': 1,
        'oveval_activate': 1,
        'oveVal4_u': 1,
        'oveVal4_activate': 1,
        'ovepumCW_u': 20,
        'ovepumCW_activate': 1,
        'pumCWWSE_u': 20,
        'pumCWWSE_activate': 1,
        'ovepumCT_u': 40,
        'ovepumCT_activate': 1,
        'fauChiTset_activate': 0,
        'fauval_activate': 0,

    }

    return u


def initialize():
    """Initialize the control input u.

    Parameters
    ----------
    None

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    """

    u = {
        'oveChiTset_u': 293.15,
        'oveChiTset_activate': 1,
        'ovepumCHW_u': 53360,
        'ovepumCHW_activate': 1,
        'oveVal1_u': 0,
        'oveVal1_activate': 1,
        'oveVal3_u': 1,
        'oveVal3_activate': 1,
        'oveValByp_u': 0,
        'oveValByp_activate': 1,
        'oveVal2_u': 0,
        'oveVal2_activate': 1,
        'oveVal6_u': 1,
        'oveVal6_activate': 1,
        'ovemFanFlo_u': 33.2,
        'ovemFanFlo_activate': 1,
        'oveval_u': 1,
        'oveval_activate': 1,
        'oveVal4_u': 1,
        'oveVal4_activate': 1,
        'ovepumCW_u': 20,
        'ovepumCW_activate': 1,
        'pumCWWSE_u': 20,
        'pumCWWSE_activate': 1,
        'ovepumCT_u': 40,
        'ovepumCT_activate': 1,


    }

    return u
