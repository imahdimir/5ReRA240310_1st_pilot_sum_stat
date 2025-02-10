"""

    """

import pandas as pd

import sys
from pathlib import Path


##
sys.path.append(Path.cwd().as_posix())

from proj.lib import DIR , FILE , VAR , CONST


##
def fmt_as_hh_mm(s) :
    hours , remainder = divmod(s , 3600)
    minutes , seconds = divmod(remainder , 60)
    if seconds > 30 :
        minutes += 1
    return '{:02}:{:02}'.format(int(hours) , int(minutes))

def fmt_as_mm_ss(s) :
    hours , remainder = divmod(s , 3600)
    minutes , seconds = divmod(remainder , 60)
    return '{:02}:{:02}'.format(int(minutes) , int(seconds))

def format_dft(dft) :
    dft.iloc[: , 2 :] = dft.iloc[: , 2 :].applymap(lambda x : fmt_as_hh_mm(x))
    dft['count'] = dft['count'].astype(int)
    dft = dft.rename(columns = {
            'count'  : VAR.n ,
            VAR.mean : VAR.Mean ,
            'std'    : VAR.Std ,
            'min'    : 'Min' ,
            '25%'    : 'Q1' ,
            '50%'    : 'Median' ,
            '75%'    : 'Q3' ,
            'max'    : 'Max'
            })
    dft = dft.astype('string')
    return dft

def read_page_times_data_filter_and_combine() :
    """
    read in page times keep only final sample from the cleaned data
    assert no duplicates on participant code and page index
    sort by page index
    calculate duration assuming page index is the order of the pages
    """

    ##
    DIR.pgt.glob('*.csv')

    dfpt = pd.DataFrame()
    for fn in DIR.pgt.glob('*.csv') :
        df = pd.read_csv(fn)
        dfpt = pd.concat([dfpt , df])

    ##
    df_c = pd.read_csv(FILE.mahdi_cln_dta)

    msk = dfpt[VAR.pcod].isin(df_c[VAR.eff_s_cod])

    df = dfpt[msk]

    ##
    df = df.drop_duplicates()

    ##
    assert df[[VAR.pcod , VAR.pgi]].duplicated().sum() == 0

    ##
    df = df.sort_values(VAR.pgi)
    df[VAR.dur_s] = df.groupby(VAR.pcod)[VAR.epoch].diff()

    ##
    return df

##



def return_session_code_track_name_map_from_clean_data() :
    """ """

    df_cln = pd.read_csv(FILE.mahdi_cln_dta)

    df = df_cln[[VAR.sc , VAR.scn]]
    df = df.drop_duplicates()
    assert df[VAR.sc].is_unique

    df[VAR.trck] = df[VAR.scn].apply(lambda x : ''.join(filter(str.isupper, x)))

    df = df.set_index(VAR.sc)

    return df

def mark_idle_times() :
    """ """

    dfa = read_page_times_data_filter_and_combine()

    mean = dfa[VAR.dur_s].mean()
    print(mean)
    std = dfa[VAR.dur_s].std()
    print(std)

    msk = (dfa[VAR.dur_s] > mean + 3 * std) | (dfa[VAR.dur_s] < mean - 3 * std)
    dfa[VAR.o3] = msk

    msk = (dfa[VAR.dur_s] > mean + 2 * std) | (dfa[VAR.dur_s] < mean - 2 * std)
    dfa[VAR.o2] = msk

    return dfa

def read_cln_data_cal_dur_add_trck() :
    """ """

    ##

    # read clean data
    df = pd.read_csv(FILE.cln_dta)

    ##
    # convert to datetime
    df[VAR.accpt_t] = pd.to_datetime(df[VAR.accpt_t])
    df[VAR.submit_t] = pd.to_datetime(df[VAR.submit_t])

    ##
    # calculate duration
    df[VAR.dur] = df[VAR.submit_t] - df[VAR.accpt_t]
    df[VAR.dur_s] = df[VAR.dur].dt.total_seconds()

    ##
    # add track abbreviation
    df[VAR.trck] = df[VAR.scn].apply(lambda x : ''.join(filter(str.isupper, x)))

    ##
    return df

def cal_response_time_fr_pg_times() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    dfa = df.groupby(VAR.pcod)[VAR.dur_s].sum()
    dfa = dfa.reset_index()

    ##
    dfc = pd.read_csv(FILE.mahdi_cln_dta)

    ##
    dfc = dfc[[VAR.eff_s_cod , VAR.scn]]

    ##
    dfa = dfa.merge(dfc, left_on = VAR.pcod, right_on = VAR.eff_s_cod)

    ##
    dfa[VAR.trck] = dfa[VAR.scn].apply(lambda x : ''.join(filter(str.isupper, x)))

    ##
    return dfa

    ##

def track_times_table_fr_pg_times() :
    """ """

    ##
    df = cal_response_time_fr_pg_times()

    ##
    # All tracks sum stat
    dfa = df[VAR.dur_s].describe().to_frame().T
    dfa = dfa.reset_index(drop = True)
    dfa[VAR.trck] = CONST.a

    ##
    dfb = df.groupby(VAR.trck)[VAR.dur_s].describe()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfa = pd.concat([dfb , dfa])

    ##
    dfa = format_dft(dfa)

    ##
    dfa.to_latex(FILE.t_all, index = False)

    ##

def track_times_dist_data_fr_pg_times() :
    """ """

    ##
    df = cal_response_time_fr_pg_times()

    ##
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    df = df[[VAR.dur_m]]

    ##
    df.to_excel(FILE.s_dist, index = False)

    ##

##
def make_hh_mm(df , start_col) :
    sc = start_col
    _f = lambda x : ':'.join(x.split(':')[:2])
    df.iloc[: , sc :] = df.iloc[: , sc :].applymap(_f)
    return df

def track_times_table() :
    pass

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    # summary statistics - up to minutes
    dfa = df[VAR.dur_s].describe().to_frame().T
    dfa = dfa.reset_index(drop = True)
    dfa[VAR.trck] = CONST.a

    dfb = df.groupby(VAR.trck)[VAR.dur_s].describe()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    dfa = pd.concat([dfb , dfa])

    ##
    dfa = format_dft(dfa)

    ##
    dfa.to_latex(FILE.t_tot_mturk, index = False)

    ##

##
def time_distribution() :
    """ """

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    # for plots in R, all durations hist
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    df = df[[VAR.dur_m]]

    ##
    df[VAR.dur_m].to_excel(FILE.x_tot_dist, index = False)

    ##

def save_mean_std_time_by_track() :
    """ """

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    df1 = df[VAR.dur_s].describe().to_frame().T

    ##
    # R Plot, all durations by track
    c2k = {
            0 : VAR.mean ,
            1 : VAR.std ,
            2 : VAR.n50 ,
            }

    df1 = df1[c2k.values()]
    df1[VAR.trck] = CONST.a

    ##
    df2 = df.groupby(VAR.trck)[VAR.dur_s].describe()
    df2 = df2[c2k.values()]
    df2 = df2.reset_index()
    df2 = df2.sort_values(VAR.trck)

    ##
    dfa = pd.concat([df2 , df1])

    ##
    dfa.iloc[: , 1 :] = dfa.iloc[: , 1 :] / 60

    ##
    _cn = {
            VAR.idx  : VAR.trck ,
            VAR.mean : VAR.Mean ,
            VAR.std  : VAR.Std ,
            VAR.n50  : VAR.csf_med ,
            }
    dfa = dfa.rename(columns = _cn)

    ##
    dfc = dfa[[VAR.trck]]
    dfc[VAR.y] = dfa[VAR.Mean]
    dfc[VAR.std] = dfa[VAR.Std]
    dfc[VAR.ytype] = VAR.Mean

    ##
    dfd = dfa[[VAR.trck]]
    dfd[VAR.y] = dfa[VAR.csf_med]
    dfd[VAR.ytype] = VAR.csf_med

    ##
    dfe = pd.concat([dfc , dfd])

    ##
    dfe.to_excel(FILE.x_tot_by_trck, index = False)

    ##

def get_mean_med_time_by_trck_fr_pg_times() :
    """ """

    ##
    df = cal_response_time_fr_pg_times()

    ##
    dfa = df[VAR.dur_s].describe().to_frame().T

    ##
    # R Plot, all durations by track
    c2k = {
            0 : VAR.mean ,
            1 : VAR.std ,
            2 : VAR.n50 ,
            }

    dfa = dfa[c2k.values()]
    dfa = dfa.reset_index(drop = True)
    dfa[VAR.trck] = CONST.a

    ##
    dfb = df.groupby(VAR.trck)[VAR.dur_s].describe()
    dfb = dfb[c2k.values()]
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfa = pd.concat([dfb , dfa])

    ##
    dfa.iloc[: , 1 :] = dfa.iloc[: , 1 :] / 60

    ##
    _cn = {
            VAR.idx  : VAR.trck ,
            VAR.mean : VAR.Mean ,
            VAR.std  : VAR.Std ,
            VAR.n50  : VAR.csf_med ,
            }

    dfa = dfa.rename(columns = _cn)

    ##
    dfc = dfa[[VAR.trck]]
    dfc[VAR.y] = dfa[VAR.Mean]
    dfc[VAR.std] = dfa[VAR.Std]
    dfc[VAR.ytype] = VAR.Mean

    ##
    dfd = dfa[[VAR.trck]]
    dfd[VAR.y] = dfa[VAR.csf_med]
    dfd[VAR.ytype] = VAR.csf_med

    ##
    dfe = pd.concat([dfc , dfd])

    ##
    dfe.to_excel(FILE.st_trck, index = False)

    ##

def cal_page_dur_save_dist_data() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    df = df.dropna(subset = [VAR.dur_s])

    ##
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    ##
    df = df[[VAR.dur_m]]

    ##
    df.to_excel(FILE.pgt_dist, index = False)

    ##

def page_time_by_track() :
    pass

    ##
    dfa = read_page_times_data_filter_and_combine()

    ##
    df1 = dfa[VAR.dur_s].describe().to_frame().T

    df1 = df1.reset_index(drop = True)
    df1[VAR.trck] = CONST.a

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[VAR.trck] = dfa[VAR.s_c].map(dfm[VAR.trck])

    ##
    df2 = dfa.groupby(VAR.trck)[VAR.dur_s].describe()
    df2 = df2.reset_index()
    df2 = df2.sort_values(VAR.trck)

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3.iloc[: , 2 :] = df3.iloc[: , 2 :].applymap(fmt_as_mm_ss)
    df3['count'] = df3['count'].astype(int)
    df3 = df3.astype('string')

    ##
    df3.to_latex(FILE.t_pt, index = False)

    ##

def page_time_idxmax() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    df[VAR.trck] = df[VAR.s_c].map(dfm[VAR.trck])

    ##
    df = df.reset_index(drop = True)
    idx = df.groupby(VAR.trck)[VAR.dur_s].idxmax()

    ##
    dfb = df.loc[idx]
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfb = dfb[[VAR.trck , VAR.page_name , VAR.pgi]]

    ##
    dfb.to_latex(FILE.t_idxmax, index = False)

    ##

    ##

def mean_page_times_by_track() :
    """ """

    ##
    dfa = read_page_times_data_filter_and_combine()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[VAR.trck] = dfa[VAR.s_c].map(dfm[VAR.trck])

    ##
    # R Plot, all durations by track
    c2k = {
            0 : 'mean' ,
            1 : 'std' ,
            }

    df1 = dfa[VAR.dur_s].describe().to_frame().T
    df1 = df1[c2k.values()]
    df1.index = [k.a]

    df2 = dfa.groupby(VAR.trck)[VAR.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3 = df3 / 60

    ##
    df3.to_excel(FILE.pgt_mean)

##

def instruction_page_times() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    df[VAR.is_ins_pg] = df[VAR.page_name].str.contains(CONST.ins, case = False)

    ##
    df = df[df[VAR.is_ins_pg]]

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    df[VAR.trck] = df[VAR.s_c].map(dfm[VAR.trck])

    ##
    dfa = df[VAR.dur_s].describe().to_frame().T

    ##
    dfa = dfa.reset_index(drop = True)
    dfa[VAR.trck] = CONST.a

    ##
    dfb = df.groupby(VAR.trck)[VAR.dur_s].describe()

    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfc = pd.concat([dfb , dfa])

    ##
    dfc = format_dft(dfc)

    ##
    dfc.iloc[: , 2 :] = dfc.iloc[: , 2 :].applymap(lambda x : ':'.join(x.split(
            ':')[1 :]))

    ##
    dfc.to_latex(FILE.t_ins, index = False)

    ##
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    ##
    df[VAR.dur_m].to_excel(FILE.ins_dist, index = False)

    ##
    # R Plot, all durations by track
    c2k = {
            0 : 'mean' ,
            1 : 'std' ,
            }

    df1 = df[VAR.dur_s].describe().to_frame().T
    df1 = df1[c2k.values()]
    df1.index = [k.a]

    df2 = df.groupby(VAR.trck)[VAR.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3 = df3 / 60

    ##
    df3.to_excel(FILE.ins_mean)

    ##
    dfp = pd.read_excel(FILE.pgt_mean)

    ##
    dfp = dfp.set_index('Unnamed: 0')

    ##
    df3['Mean Ratio'] = df3['mean'] / dfp['mean'] * 100
    df3['STD Ratio'] = df3['std'] / dfp['std'] * 100

    ##
    df3 = df3[['Mean Ratio' , 'STD Ratio']]

    ##
    df3 = df3.applymap(lambda x : f'{x:.1f}')

    ##
    df3.to_latex(FILE.itr, index = True)

##


##
def idle_time_detection() :
    pass

    ##
    dfa = mark_idle_times()

    ##
    df1 = pd.DataFrame(columns = {
            VAR.o2 : None ,
            VAR.o3 : None
            } , index = [k.a])

    ##
    df1[VAR.o2] = dfa[VAR.o2].sum()
    df1[VAR.o3] = dfa[VAR.o3].sum()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[VAR.trck] = dfa[VAR.s_c].map(dfm[VAR.trck])

    ##
    df2 = dfa.groupby(dfa[VAR.trck])[VAR.o2].sum()
    df3 = dfa.groupby(dfa[VAR.trck])[VAR.o3].sum()

    ##
    df2 = pd.concat([df2 , df3] , axis = 1)

    ##
    df2 = pd.concat([df2 , df1])

    ##
    dfb = pd.DataFrame(columns = {
            'N' : None
            } , index = [k.a])
    dfb['N'] = dfa.shape[0]

    ##
    dfc = pd.DataFrame()
    dfc['N'] = dfa.groupby(dfa[VAR.trck])[VAR.dur_s].count()

    ##
    dfd = pd.concat([dfc , dfb])

    ##
    df2['N'] = dfd['N']

    ##
    df2[VAR.o3_pct] = df2[VAR.o3] / df2['N'] * 100
    df2[VAR.o2_pct] = df2[VAR.o2] / df2['N'] * 100

    ##
    df2 = df2.reset_index()

    ##
    df2 = df2.rename(columns = {
            'index' : VAR.trck
            })

    ##
    cord = {
            VAR.trck   : 0 ,
            VAR.n      : 1 ,
            VAR.o2     : 2 ,
            VAR.o2_pct : 4 ,
            VAR.o3     : 3 ,
            VAR.o3_pct : 5
            }

    df2 = df2[cord.keys()]

    ##
    cols = [VAR.o2_pct , VAR.o3_pct]
    for c in cols :
        df2[c] = df2[c].apply(lambda x : f'{x:.1f}')

    ##
    df2.to_latex(FILE.t_idle, index = False)

    ##

def total_idle_time_ratio() :
    """ """
    ##
    dfa = mark_idle_times()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[VAR.trck] = dfa[VAR.s_c].map(dfm[VAR.trck])

    ##
    df1 = pd.DataFrame(index = [k.a])

    ##
    df1[VAR.tot_t] = dfa[VAR.dur_s].sum()
    df1[VAR.trck] = k.a

    ##
    msk = dfa[VAR.o2]
    dfb = dfa[msk]

    ##
    df1[VAR.o2] = dfb[VAR.dur_s].sum()

    ##
    msk = dfa[VAR.o3]
    dfc = dfa[msk]

    ##
    df1[VAR.o3] = dfc[VAR.dur_s].sum()

    ##
    df2 = dfa.groupby(VAR.trck)[VAR.dur_s].sum()
    df2 = df2.reset_index()
    df2 = df2.rename(columns = {
            VAR.dur_s : VAR.tot_t
            })

    ##
    df3 = dfb.groupby(VAR.trck)[VAR.dur_s].sum()
    df3 = df3.reset_index()
    df3 = df3.rename(columns = {
            VAR.dur_s : VAR.o2
            })

    ##
    df4 = dfc.groupby(VAR.trck)[VAR.dur_s].sum()
    df4 = df4.reset_index()
    df4 = df4.rename(columns = {
            VAR.dur_s : VAR.o3
            })

    ##
    df2 = df2.merge(df3, on = VAR.trck, how = 'left')
    df2 = df2.merge(df4, on = VAR.trck, how = 'left')

    df2 = df2.fillna(0)

    ##
    df5 = pd.concat([df2 , df1])

    ##
    df5[VAR.o2_pct] = df5[VAR.o2] / df5[VAR.tot_t] * 100
    df5[VAR.o3_pct] = df5[VAR.o3] / df5[VAR.tot_t] * 100

    ##
    cols = {
            VAR.trck   : None ,
            VAR.o2_pct : None ,
            VAR.o3_pct : None ,
            }

    df6 = df5[list(cols.keys())]

    ##
    df6.to_excel(FILE.idl_time_pct, index = False)

    ##

    ##

    ##
    for c in range(1 , 4) :
        df5.iloc[: , c] = df5.iloc[: , c].apply(fmt_as_hh_mm)

    ##
    cols = [VAR.o2_pct , VAR.o3_pct]
    for c in cols :
        df5[c] = df5[c].apply(lambda x : f'{x:.1f}')

    ##
    cord = {
            VAR.trck   : 0 ,
            VAR.tot_t  : 1 ,
            VAR.o2     : 2 ,
            VAR.o2_pct : 3 ,
            VAR.o3     : 4 ,
            VAR.o3_pct : 5
            }

    df5 = df5[list(cord.keys())]

    ##
    df5.to_latex(FILE.tot_idl, index = False)

    ##

##
def consent_page_times() :
    """ """

    ##
    dfa = read_cln_data_cal_dur_add_trck()
    dfa = dfa

    ##

    ##

##

def payments() :
    """ """

    ##
    df = pd.read_csv(FILE.cln_dta)

    ##
    df[VAR.trck] = df[VAR.scn].apply(lambda x : ''.join(filter(str.isupper, x)))

    ##
    df = df[[VAR.trck , VAR.tot_pay]]

    ##
    df1 = df[VAR.tot_pay].describe().to_frame().T
    df1[VAR.trck] = k.a

    ##
    df2 = df.groupby(VAR.trck)[VAR.tot_pay].describe()
    df2 = df2.reset_index()
    df2 = df2.sort_values(VAR.trck)

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df1 = df.groupby(VAR.trck)[VAR.tot_pay].sum()
    df1 = df1.reset_index()
    df1 = df1.rename(columns = {
            VAR.tot_pay : VAR.total_pay
            })
    ##
    df1.loc[6] = [k.a , df[VAR.tot_pay].sum()]

    ##
    df3 = df3.merge(df1, on = VAR.trck, how = 'left')

    ##
    cols = {
            VAR.trck      : None ,
            'count'       : None ,
            'mean'        : None ,
            'std'         : None ,
            'min'         : None ,
            'max'         : None ,
            VAR.total_pay : None ,
            }

    df3 = df3[list(cols.keys())]

    ##
    cols = {
            'count'     : 'N' ,
            'mean'      : 'Mean' ,
            'std'       : 'STD' ,
            'min'       : 'Min' ,
            'max'       : 'Max' ,
            VAR.total_pay : VAR.total_pay
            }

    df3 = df3.rename(columns = cols)

    ##
    for c in list(cols.values())[1 :] :
        df3[c] = df3[c].apply(lambda x : f'{x:.2f}')

    ##
    df3[VAR.n] = df3[VAR.n].astype(int).astype(str)

    ##
    df3.to_latex(FILE.t_pay, index = False)

    ##

    ##

def find_extremely_low_response_times() :
    """ """

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    ##
    df[VAR.lt5] = df[VAR.dur_m].lt(5)

    ##
    df[VAR.lt10] = df[VAR.dur_m].lt(10)

    ##
    dfa = df[[VAR.lt5 , VAR.lt10]].sum().to_frame().T
    dfa[VAR.trck] = CONST.a

    ##
    dfb = df.groupby(VAR.trck)[[VAR.lt5 , VAR.lt10]].sum()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfc = pd.concat([dfb , dfa])

    ##
    dfc.to_latex(FILE.t_exc_l_t, index = False)

    ##

def find_extremely_low_response_times_otree() :
    """ """

    ##
    df = cal_response_time_fr_pg_times()

    ##
    df[VAR.dur_m] = df[VAR.dur_s] / 60

    ##
    df[VAR.lt5] = df[VAR.dur_m].lt(5)

    ##
    df[VAR.lt10] = df[VAR.dur_m].lt(10)

    ##
    dfa = df[[VAR.lt5 , VAR.lt10]].sum().to_frame().T
    dfa[VAR.trck] = CONST.a

    ##
    dfb = df.groupby(VAR.trck)[[VAR.lt5 , VAR.lt10]].sum()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(VAR.trck)

    ##
    dfc = pd.concat([dfb , dfa])

    ##
    dfc.to_latex(FILE.t_exc_l_t, index = False)

    ##

def sum_instruction_pages() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    df[VAR.is_ins_pg] = df[VAR.page_name].str.contains(CONST.ins, case = False)

    ##
    df = df[df[VAR.is_ins_pg]]

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    df[VAR.trck] = df[VAR.s_c].map(dfm[VAR.trck])

    ##
    dfa = df.groupby(VAR.pcod)[VAR.dur_s].sum()
    dfa = dfa.reset_index()

    ##
    dfz = df.drop_duplicates(subset = [VAR.pcod , VAR.trck])
    dfz = dfz[[VAR.pcod , VAR.trck]]

    ##
    dfa[VAR.trck] = dfa[VAR.pcod].map(dfz.set_index(VAR.pcod)[VAR.trck])

    ##
    dfb = dfa[[VAR.dur_s]].describe().T
    dfb[VAR.trck] = CONST.a

    ##
    dfc = dfa.groupby(VAR.trck)[VAR.dur_s].describe()
    dfc = dfc.reset_index()
    dfc = dfc.sort_values(VAR.trck)

    ##
    dfd = pd.concat([dfc , dfb])

    ##
    dfd = format_dft(dfd)

    ##
    dfd.to_latex(FILE.t_ins_sum, index = False)

    ##

    ##

def pages_count_by_track() :
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    df1 = pd.read_csv(FILE.mahdi_cln_dta)
    df1 = df1[[VAR.eff_s_cod , VAR.scn]]

    ##
    df = df.merge(df1, left_on = VAR.pcod, right_on = VAR.eff_s_cod)

    ##
    df[VAR.trck] = df[VAR.scn].apply(lambda x : ''.join(filter(str.isupper, x)))

    ##
    dfa = df.groupby(VAR.trck).count()
    dfa['# Pages'] = dfa[VAR.pcod]
    dfa = dfa[['# Pages']]

    ##
    dfb = df.groupby(VAR.trck)[VAR.pcod].nunique()
    dfb = dfb.to_frame()

    ##
    dfc = dfa.merge(dfb , left_index = True , right_index = True)

    ##
    dfc['mean # pages'] = dfc['# Pages'] / dfc[VAR.pcod]

    ##
    dfc['mean # pages'] = dfc['mean # pages'].round()
    dfc = dfc.astype(int)

    ##
    dfc.to_latex(FILE.t_trck_n_pg)

    ##





    ##





    ##
