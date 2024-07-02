#!/usr/bin/env python
# coding: utf-8

import os
import numpy as np
import pandas as pd
from cmdstanpy import CmdStanModel

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

set_formats(2, 100)

# plotting libs
import matplotlib.pyplot as plt
import plotnine as p9

# suppress plotnine warnings
import warnings
warnings.filterwarnings('ignore')

# setup plotnine look and feel
p9.theme_set(
  p9.theme_grey() + 
  p9.theme(text=p9.element_text(size=10),
        plot_title=p9.element_text(size=14),
        axis_title_x=p9.element_text(size=14),
        axis_title_y=p9.element_text(size=14),
        axis_text_x=p9.element_text(size=12),
        axis_text_y=p9.element_text(size=12)
       )
)
xlabels_90 = p9.theme(axis_text_x = p9.element_text(angle=90, hjust=1))


df_3preds = pd.read_csv("data/data_tests_sex_age_eth.csv")
in_3preds_data = df_3preds.to_dict(orient='list')
in_3preds_data['N_age'] = max(in_3preds_data['age'])
in_3preds_data['N_eth'] = max(in_3preds_data['eth'])
in_3preds_data['N'] = len(in_3preds_data['tests'])
in_3preds_data['sens'] = 0.7
in_3preds_data['spec']=0.995
in_3preds_data['intercept_prior_mean']=-4
in_3preds_data['intercept_prior_scale']=2.5


df_4preds = pd.read_csv("data/data_tests_sex_age_eth_time.csv")
in_4preds_data = df_4preds.to_dict(orient='list')
in_4preds_data['N_age'] = max(in_4preds_data['age'])
in_4preds_data['N_eth'] = max(in_4preds_data['eth'])
in_4preds_data['N_time'] = max(in_4preds_data['time'])
in_4preds_data['N'] = len(in_4preds_data['tests'])
in_4preds_data['sens'] = 0.7
in_4preds_data['spec']=0.995
in_4preds_data['intercept_prior_mean']=-4
in_4preds_data['intercept_prior_scale']=2.5

df_5preds = pd.read_csv("data/data_tests_sex_age_eth_time_zip.csv")
in_5preds_data = df_5preds.to_dict(orient='list')
in_5preds_data['N_age'] = max(in_5preds_data['age'])
in_5preds_data['N_eth'] = max(in_5preds_data['eth'])
in_5preds_data['N_time'] = max(in_5preds_data['time'])
in_5preds_data['N_zip'] = max(in_5preds_data['zip'])
in_5preds_data['N'] = len(in_5preds_data['tests'])
in_5preds_data['sens'] = 0.7
in_5preds_data['spec']=0.995
in_5preds_data['intercept_prior_mean']=-4
in_5preds_data['intercept_prior_scale']=2.5

print("Naive 3 preds: age, sex, eth")
print(f'mean tests per cell: {np.mean(in_3preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_3preds_data["pos_tests"])}')
if max(in_3preds_data['sex']) == 2:
    in_3preds_data['sex'] = [x - 1 for x in in_3preds_data['sex']]
naive_3_mod = CmdStanModel(stan_file="stan/binomial_3preds_naive.stan")
naive_3_path = naive_3_mod.pathfinder(data=in_3preds_data)
path_inits = naive_3_path.create_inits()
naive_3_fit = naive_3_mod.sample(data=in_3preds_data, inits=path_inits, iter_warmup=1500)
n3_summary = naive_3_fit.summary()
print(summary_by_var(n3_summary, "alpha"))
print(summary_by_var(n3_summary, "sigma"))
print(summary_by_var(n3_summary, "beta"))

print("Naive 4 preds: age, sex, eth, time")
print(f'mean tests per cell: {np.mean(in_4preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_4preds_data["pos_tests"])}')
if max(in_4preds_data['sex']) == 2:
    in_4preds_data['sex'] = [x - 1 for x in in_4preds_data['sex']]
naive_4_mod = CmdStanModel(stan_file="stan/binomial_4preds_naive.stan")
naive_4_path = naive_4_mod.pathfinder(data=in_4preds_data)
path_inits = naive_4_path.create_inits()
naive_4_fit = naive_4_mod.sample(data=in_4preds_data, inits=path_inits, iter_warmup=1500)
n4_summary = naive_4_fit.summary()
print(summary_by_var(n4_summary, "alpha"))
print(summary_by_var(n4_summary, "sigma"))
print(summary_by_var(n4_summary, "beta"))

print("Naive 5 preds: age, sex, eth, time, zip")
print(f'mean tests per cell: {np.mean(in_5preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_5preds_data["pos_tests"])}')
if max(in_5preds_data['sex']) == 2:
    in_5preds_data['sex'] = [x - 1 for x in in_5preds_data['sex']]
naive_5_mod = CmdStanModel(stan_file="stan/binomial_5preds_naive.stan")
naive_5_path = naive_5_mod.pathfinder(data=in_5preds_data)
path_inits = naive_5_path.create_inits()
naive_5_fit = naive_5_mod.sample(data=in_5preds_data, inits=path_inits, iter_warmup=1500)
n5_summary = naive_5_fit.summary()
print(summary_by_var(n5_summary, "alpha"))
print(summary_by_var(n5_summary, "sigma"))
print(summary_by_var(n5_summary, "beta"))

print("Hard s2z 3 preds: age, sex, eth")
print(f'mean tests per cell: {np.mean(in_3preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_3preds_data["pos_tests"])}')
s2z_3_mod = CmdStanModel(stan_file="stan/binomial_3preds_s2zh.stan")
if max(in_3preds_data['sex']) == 1:
    in_3preds_data['sex'] = [x + 1 for x in in_3preds_data['sex']]
s2z_3_path = s2z_3_mod.pathfinder(data=in_3preds_data)
path_inits = s2z_3_path.create_inits()
s2z_3_fit = s2z_3_mod.sample(data=in_3preds_data, inits=path_inits, iter_warmup=1500)
s2z3_summary = s2z_3_fit.summary()
print(summary_by_var(s2z3_summary, "alpha"))
print(summary_by_var(s2z3_summary, "sigma"))
print(summary_by_var(s2z3_summary, "beta_sex["))
print(summary_by_var(s2z3_summary, "beta_age["))
print(summary_by_var(s2z3_summary, "beta_eth["))

print("Hard s2z 4 preds: age, sex, eth, time")
print(f'mean tests per cell: {np.mean(in_4preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_4preds_data["pos_tests"])}')
s2z_4_mod = CmdStanModel(stan_file="stan/binomial_4preds_s2zh.stan")
if max(in_4preds_data['sex']) == 1:
    in_4preds_data['sex'] = [x + 1 for x in in_4preds_data['sex']]
s2z_4_path = s2z_4_mod.pathfinder(data=in_4preds_data)
path_inits = s2z_4_path.create_inits()
s2z_4_fit = s2z_4_mod.sample(data=in_4preds_data, inits=path_inits, iter_warmup=1500)
s2z4_summary = s2z_4_fit.summary()
print(summary_by_var(s2z4_summary, "alpha"))
print(summary_by_var(s2z4_summary, "sigma"))
print(summary_by_var(s2z4_summary, "beta_sex["))
print(summary_by_var(s2z4_summary, "beta_age["))
print(summary_by_var(s2z4_summary, "beta_eth["))
print(summary_by_var(s2z4_summary, "beta_time[")[:10])

print("Hard s2z 5 preds: age, sex, eth, time")
print(f'mean tests per cell: {np.mean(in_5preds_data["tests"])}, mean pos_tests per cell: {np.mean(in_5preds_data["pos_tests"])}')
s2z_5_mod = CmdStanModel(stan_file="stan/binomial_5preds_s2zh.stan")
if max(in_5preds_data['sex']) == 1:
    in_5preds_data['sex'] = [x + 1 for x in in_5preds_data['sex']]
s2z_5_path = s2z_5_mod.pathfinder(data=in_5preds_data)
path_inits = s2z_5_path.create_inits()
s2z_5_fit = s2z_5_mod.sample(data=in_5preds_data, inits=path_inits, iter_warmup=1500)
s2z5_summary = s2z_5_fit.summary()
print(summary_by_var(s2z5_summary, "alpha"))
print(summary_by_var(s2z5_summary, "sigma"))
print(summary_by_var(s2z5_summary, "beta_sex["))
print(summary_by_var(s2z5_summary, "beta_age["))
print(summary_by_var(s2z5_summary, "beta_eth["))
print(summary_by_var(s2z5_summary, "beta_time[")[:10])
print(summary_by_var(s2z5_summary, "beta_zip[")[:10])


