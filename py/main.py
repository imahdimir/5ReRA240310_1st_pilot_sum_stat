"""

    """

import pandas as pd

import sys
from pathlib import Path

sys.path.append(Path.cwd().as_posix())

from prj.lib import d , f , v , c

def fmt_as_hh_mm(s) :
    hours , remainder = divmod(s , 3600)
    minutes , seconds = divmod(remainder , 60)
    return '{:02}:{:02}'.format(int(hours) , int(minutes))

def format_dft(dft) :
    dft.iloc[: , 2 :] = dft.iloc[: , 2 :].applymap(lambda x : fmt_as_hh_mm(x))
    dft['count'] = dft['count'].astype(int)
    dft = dft.rename(columns = {
            'count' : v.n ,
            v.mean  : v.Mean ,
            'std'   : v.Std ,
            'min'   : 'Min' ,
            '25%'   : 'Q1' ,
            '50%'   : 'Median' ,
            '75%'   : 'Q3' ,
            'max'   : 'Max'
            })
    dft = dft.astype('string')
    return dft

def read_in_page_times() :
    """
    read in page times keep only final sample from the cleaned data
    assert no duplicates on participant code and page index
    sort by page index
    calculate duration assuming page index is the order of the pages
    """

    ##
    d.pgt.glob('*.csv')

    dfpt = pd.DataFrame()
    for fn in d.pgt.glob('*.csv') :
        df = pd.read_csv(fn)
        dfpt = pd.concat([dfpt , df])

    ##
    df_c = pd.read_csv(f.mahdi_cln_dta)

    msk = dfpt[v.pcod].isin(df_c[v.eff_s_cod])

    df = dfpt[msk]

    ##
    df = df.drop_duplicates()

    ##
    assert df[[v.pcod , v.pgi]].duplicated().sum() == 0

    ##
    df = df.sort_values(v.pgi)
    df[v.dur_s] = df.groupby(v.pcod)[v.epoch].diff()

    ##
    return df

def return_session_code_track_name_map_from_clean_data() :
    """ """

    df_cln = pd.read_csv(f.mahdi_cln_dta)

    df = df_cln[[v.sc , v.scn]]
    df = df.drop_duplicates()
    assert df[v.sc].is_unique

    df[v.trck] = df[v.scn].apply(lambda x : ''.join(filter(str.isupper , x)))

    df = df.set_index(v.sc)

    return df

def mark_idle_times() :
    """ """

    dfa = read_in_page_times()

    mean = dfa[v.dur_s].mean()
    print(mean)
    std = dfa[v.dur_s].std()
    print(std)

    msk = (dfa[v.dur_s] > mean + 3 * std) | (dfa[v.dur_s] < mean - 3 * std)
    dfa[v.o3] = msk

    msk = (dfa[v.dur_s] > mean + 2 * std) | (dfa[v.dur_s] < mean - 2 * std)
    dfa[v.o2] = msk

    return dfa

def read_cln_data_cal_dur_add_trck() :
    """ """

    ##

    # read clean data
    df = pd.read_csv(f.cln_dta)

    ##
    # convert to datetime
    df[v.start_dt] = pd.to_datetime(df[v.start_dt])
    df[v.end_dt] = pd.to_datetime(df[v.end_dt])

    ##
    # calculate duration
    df[v.dur] = df[v.end_dt] - df[v.start_dt]
    df[v.dur_s] = df[v.dur].dt.total_seconds()

    ##
    # add track abbreviation
    df[v.trck] = df[v.scn].apply(lambda x : ''.join(filter(str.isupper , x)))

    ##
    return df

def cal_dur_by_track_fr_pg_times() :
    """ """

    ##
    df = read_in_page_times()

    ##
    dfa = df.groupby(v.pcod)[v.dur_s].sum()
    dfa = dfa.reset_index()

    ##
    dfc = pd.read_csv(f.mahdi_cln_dta)

    ##
    dfc = dfc[[v.eff_s_cod , v.scn]]

    ##
    dfa = dfa.merge(dfc , left_on = v.pcod , right_on = v.eff_s_cod)

    ##
    dfa[v.trck] = dfa[v.scn].apply(lambda x : ''.join(filter(str.isupper , x)))

    ##
    return dfa

    ##

def track_times_table_fr_pg_times() :
    """ """

    ##
    df = cal_dur_by_track_fr_pg_times()

    ##
    # All tracks sum stat
    dfa = df[v.dur_s].describe().to_frame().T
    dfa = dfa.reset_index(drop = True)
    dfa[v.trck] = c.a

    ##
    dfb = df.groupby(v.trck)[v.dur_s].describe()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(v.trck)

    ##
    dfa = pd.concat([dfb , dfa])

    ##
    dfa = format_dft(dfa)

    ##
    dfa.to_latex(f.t_all , index = False)

    ##

def track_times_dist_data_fr_pg_times() :
    """ """

    ##
    df = cal_dur_by_track_fr_pg_times()

    ##
    df[v.dur_m] = df[v.dur_s] / 60

    df = df[[v.dur_m]]

    ##
    df.to_excel(f.s_dist , index = False)

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
    dfa = df[v.dur_s].describe().to_frame().T
    dfa = dfa.reset_index(drop = True)
    dfa[v.trck] = k.a

    dfb = df.groupby(v.trck)[v.dur_s].describe()
    dfb = dfb.reset_index()
    dfb = dfb.sort_values(v.trck)

    dfa = pd.concat([dfb , dfa])

    ##
    dfa = format_dft(dfa)

    ##
    dfa = make_hh_mm(dfa , 2)

    ##
    dfa.to_latex(f.t_all , index = False)

    ##

def time_distribution() :
    """ """

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    # for plots in R, all durations hist
    df[v.dur_m] = df[v.dur_s] / 60

    df = df[[v.dur_m]]

    ##
    df[v.dur_m].to_excel(f.s_dist , index = False)

    ##

def save_mean_std_time_by_track() :
    """ """

    ##
    df = read_cln_data_cal_dur_add_trck()

    ##
    df1 = df[v.dur_s].describe().to_frame().T

    ##
    # R Plot, all durations by track
    c2k = {
            0 : v.mean ,
            1 : v.std ,
            }

    df1 = df1[c2k.values()]
    df1.index = [k.a]

    ##
    df2 = df.groupby(v.trck)[v.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    dfa = pd.concat([df2 , df1])

    ##
    dfa = dfa / 60

    ##
    dfa = dfa.reset_index()

    _cn = {
            v.idx  : v.trck ,
            v.mean : v.Mean ,
            v.std  : v.Std ,
            }
    dfa = dfa.rename(columns = _cn)

    ##
    dfa.to_excel(f.st_trck)

    ##

def cal_page_dur_save_dist_data() :
    """ """

    ##
    df = read_in_page_times()

    ##
    df = df.dropna(subset = [v.dur_s])

    ##
    df[v.dur_m] = df[v.dur_s] / 60

    ##
    df = df[[v.dur_m]]

    ##
    df.to_excel(f.pgt_dist , index = False)

    ##

def page_time_by_track() :
    pass

    ##
    dfa = read_in_page_times()

    ##
    df1 = dfa[v.dur_s].describe().to_frame().T

    df1 = df1.reset_index(drop = True)
    df1[v.trck] = k.a

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[v.trck] = dfa[v.s_c].map(dfm[v.trck])

    ##
    df2 = dfa.groupby(v.trck)[v.dur_s].describe()
    df2 = df2.reset_index()
    df2 = df2.sort_values(v.trck)

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3 = format_dft(df3)

    ##
    df3.iloc[: , 2 :] = df3.iloc[: , 2 :].applymap(lambda x : ':'.join(x.split(
            ':')[1 :]))

    ##
    df3.to_latex(f.t_pt , index = False)

    ##

def mean_page_times_by_track() :
    """ """

    ##
    dfa = read_in_page_times()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[v.trck] = dfa[v.s_c].map(dfm[v.trck])

    ##
    # R Plot, all durations by track
    c2k = {
            0 : 'mean' ,
            1 : 'std' ,
            }

    df1 = dfa[v.dur_s].describe().to_frame().T
    df1 = df1[c2k.values()]
    df1.index = [k.a]

    df2 = dfa.groupby(v.trck)[v.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3 = df3 / 60

    ##
    df3.to_excel(f.pgt_mean)

##

def instruction_page_times() :
    """ """

    ##
    df = read_in_page_times()

    ##
    df[v.is_ins_pg] = df[v.page_name].str.contains(k.ins , case = False)

    ##
    df = df[df[v.is_ins_pg]]

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    df[v.trck] = df[v.s_c].map(dfm[v.trck])

    ##
    dfa = df[v.dur_s].describe().to_frame().T

    ##
    dfa = dfa.reset_index(drop = True)
    dfa[v.trck] = k.a

    ##
    dfb = df.groupby(v.trck)[v.dur_s].describe()

    dfb = dfb.reset_index()
    dfb = dfb.sort_values(v.trck)

    ##
    dfc = pd.concat([dfb , dfa])

    ##
    dfc = format_dft(dfc)

    ##
    dfc.iloc[: , 2 :] = dfc.iloc[: , 2 :].applymap(lambda x : ':'.join(x.split(
            ':')[1 :]))

    ##
    dfc.to_latex(f.t_ins , index = False)

    ##
    df[v.dur_m] = df[v.dur_s] / 60

    ##
    df[v.dur_m].to_excel(f.ins_dist , index = False)

    ##
    # R Plot, all durations by track
    c2k = {
            0 : 'mean' ,
            1 : 'std' ,
            }

    df1 = df[v.dur_s].describe().to_frame().T
    df1 = df1[c2k.values()]
    df1.index = [k.a]

    df2 = df.groupby(v.trck)[v.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df3 = df3 / 60

    ##
    df3.to_excel(f.ins_mean)

    ##
    dfp = pd.read_excel(f.pgt_mean)

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
    df3.to_latex(f.itr , index = True)

##


##
def idle_time_detection() :
    pass

    ##
    dfa = mark_idle_times()

    ##
    df1 = pd.DataFrame(columns = {
            v.o2 : None ,
            v.o3 : None
            } , index = [k.a])

    ##
    df1[v.o2] = dfa[v.o2].sum()
    df1[v.o3] = dfa[v.o3].sum()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[v.trck] = dfa[v.s_c].map(dfm[v.trck])

    ##
    df2 = dfa.groupby(dfa[v.trck])[v.o2].sum()
    df3 = dfa.groupby(dfa[v.trck])[v.o3].sum()

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
    dfc['N'] = dfa.groupby(dfa[v.trck])[v.dur_s].count()

    ##
    dfd = pd.concat([dfc , dfb])

    ##
    df2['N'] = dfd['N']

    ##
    df2[v.o3_pct] = df2[v.o3] / df2['N'] * 100
    df2[v.o2_pct] = df2[v.o2] / df2['N'] * 100

    ##
    df2 = df2.reset_index()

    ##
    df2 = df2.rename(columns = {
            'index' : v.trck
            })

    ##
    cord = {
            v.trck   : 0 ,
            v.n      : 1 ,
            v.o2     : 2 ,
            v.o2_pct : 4 ,
            v.o3     : 3 ,
            v.o3_pct : 5
            }

    df2 = df2[cord.keys()]

    ##
    cols = [v.o2_pct , v.o3_pct]
    for c in cols :
        df2[c] = df2[c].apply(lambda x : f'{x:.1f}')

    ##
    df2.to_latex(f.t_idle , index = False)

    ##

def total_idle_time_ratio() :
    """ """
    ##
    dfa = mark_idle_times()

    ##
    dfm = return_session_code_track_name_map_from_clean_data()
    dfa[v.trck] = dfa[v.s_c].map(dfm[v.trck])

    ##
    df1 = pd.DataFrame(index = [k.a])

    ##
    df1[v.tot_t] = dfa[v.dur_s].sum()
    df1[v.trck] = k.a

    ##
    msk = dfa[v.o2]
    dfb = dfa[msk]

    ##
    df1[v.o2] = dfb[v.dur_s].sum()

    ##
    msk = dfa[v.o3]
    dfc = dfa[msk]

    ##
    df1[v.o3] = dfc[v.dur_s].sum()

    ##
    df2 = dfa.groupby(v.trck)[v.dur_s].sum()
    df2 = df2.reset_index()
    df2 = df2.rename(columns = {
            v.dur_s : v.tot_t
            })

    ##
    df3 = dfb.groupby(v.trck)[v.dur_s].sum()
    df3 = df3.reset_index()
    df3 = df3.rename(columns = {
            v.dur_s : v.o2
            })

    ##
    df4 = dfc.groupby(v.trck)[v.dur_s].sum()
    df4 = df4.reset_index()
    df4 = df4.rename(columns = {
            v.dur_s : v.o3
            })

    ##
    df2 = df2.merge(df3 , on = v.trck , how = 'left')
    df2 = df2.merge(df4 , on = v.trck , how = 'left')

    df2 = df2.fillna(0)

    ##
    df5 = pd.concat([df2 , df1])

    ##
    df5[v.o2_pct] = df5[v.o2] / df5[v.tot_t] * 100
    df5[v.o3_pct] = df5[v.o3] / df5[v.tot_t] * 100

    ##
    cols = {
            v.trck   : None ,
            v.o2_pct : None ,
            v.o3_pct : None ,
            }

    df6 = df5[list(cols.keys())]

    ##
    df6.to_excel(f.idl_time_pct , index = False)

    ##

    ##

    ##
    for c in range(1 , 4) :
        df5.iloc[: , c] = df5.iloc[: , c].apply(fmt_as_hh_mm)

    ##
    cols = [v.o2_pct , v.o3_pct]
    for c in cols :
        df5[c] = df5[c].apply(lambda x : f'{x:.1f}')

    ##
    cord = {
            v.trck   : 0 ,
            v.tot_t  : 1 ,
            v.o2     : 2 ,
            v.o2_pct : 3 ,
            v.o3     : 4 ,
            v.o3_pct : 5
            }

    df5 = df5[list(cord.keys())]

    ##
    df5.to_latex(f.tot_idl , index = False)

    ##

    ##

    ##

def payments() :
    """ """
    ##
    df = pd.read_csv(f.cln_dta)

    ##
    df[v.trck] = df[v.scn].apply(lambda x : ''.join(filter(str.isupper , x)))

    ##
    df = df[[v.trck , v.tot_pay]]

    ##
    df1 = df[v.tot_pay].describe().to_frame().T
    df1[v.trck] = k.a

    ##
    df2 = df.groupby(v.trck)[v.tot_pay].describe()
    df2 = df2.reset_index()
    df2 = df2.sort_values(v.trck)

    ##
    df3 = pd.concat([df2 , df1])

    ##
    df1 = df.groupby(v.trck)[v.tot_pay].sum()
    df1 = df1.reset_index()
    df1 = df1.rename(columns = {
            v.tot_pay : v.total_pay
            })
    ##
    df1.loc[6] = [k.a , df[v.tot_pay].sum()]

    ##
    df3 = df3.merge(df1 , on = v.trck , how = 'left')

    ##
    cols = {
            v.trck      : None ,
            'count'     : None ,
            'mean'      : None ,
            'std'       : None ,
            'min'       : None ,
            'max'       : None ,
            v.total_pay : None ,
            }

    df3 = df3[list(cols.keys())]

    ##
    cols = {
            'count'     : 'N' ,
            'mean'      : 'Mean' ,
            'std'       : 'STD' ,
            'min'       : 'Min' ,
            'max'       : 'Max' ,
            v.total_pay : v.total_pay
            }

    df3 = df3.rename(columns = cols)

    ##
    for c in list(cols.values())[1 :] :
        df3[c] = df3[c].apply(lambda x : f'{x:.2f}')

    ##
    df3[v.n] = df3[v.n].astype(int).astype(str)

    ##
    df3.to_latex(f.t_pay , index = False)

    ##

    ##
