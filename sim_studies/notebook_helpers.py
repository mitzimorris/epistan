import os
import numpy as np
import pandas as pd
from cmdstanpy import CmdStanModel
from typing import Any, Dict, List, MutableMapping, Optional, TextIO, Union

def set_formats(digits: int, width: int) -> None:
  """ set display precision, output width """
  np.set_printoptions(precision=digits)
  np.set_printoptions(suppress=True)
  np.set_printoptions(threshold=np.inf)
  pd.set_option('display.precision', digits)
  format_string = '{{:.{}f}}'.format(digits)
  pd.options.display.float_format = format_string.format
  pd.set_option('display.max_rows', None)
  pd.set_option('display.max_columns', None)
  pd.set_option('display.width', width)

def summary_by_var(summary_df: pd.DataFrame, varname: str) -> None:
    row_names = list(summary_df.index)
    var_rows = [row_names.index(name) for name in row_names if name.startswith(varname)]
    print(summary_df.iloc[var_rows,:])

def gen_data(
        dgp_path: str,
        indata: Dict[str, Any],
        chains: Optional[int] = 1,
        draws: Optional[int] = 100
        ) -> Dict[str, Any]:
    """ 
    Run data generating program given input data as dict,
    return all draws as dict of Stan variables
    """
    dgp = CmdStanModel(stan_file=dgp_path);
    gen_fit = dgp.sample(data=indata, chains=chains, iter_warmup=0, adapt_engaged=False, iter_sampling=draws, show_console=True, show_progress=False);
    return gen_fit.stan_variables()
    
