"""

    """

import pandas as pd
from matplotlib import pyplot as plt
from path import Path

class Dirs :
    sf = Path(
            '/Users/mmir/Library/CloudStorage/Dropbox/3-MBP/0-sf-git-MBP/ReRA-first-pilot-sum-stat-20240310-sf')
    inpt = sf / 'in'
    out = sf / 'out'
    pgt = inpt / 'PageTimes'

dyr = Dirs()

class Files :
    cln_dta = dyr.inpt / 'clean_riskprefs_2024-02-20.csv'

    # out
    t_all = dyr.out / 't_all.tex'
    t_trcks = dyr.out / 't_trcks.tex'

fp = Files()

class Vars :
    start_dt = 'AcceptTime'
    end_dt = 'SubmitTime'
    id = 'workerNum'
    scn = 'session.config.name'

    dur = 'duration'
    dur_m = 'duration_m'
    dur_s = 'duration_s'
    trck = 'track'

v = Vars()

def format_seconds(s) :
    hours , remainder = divmod(s , 3600)
    minutes , seconds = divmod(remainder , 60)
    return '{:02}:{:02}'.format(int(hours) , int(minutes))

def format_dft(dft) :
    dft.iloc[: , 1 :] = dft.iloc[: , 1 :].applymap(lambda x : format_seconds(x))
    dft['count'] = dft['count'].astype(int)
    dft = dft.rename(columns = {
            'count' : 'N' ,
            'mean'  : 'Mean' ,
            'std'   : 'STD' ,
            'min'   : 'Min' ,
            '25%'   : 'Q1' ,
            '50%'   : 'Median' ,
            '75%'   : 'Q3' ,
            'max'   : 'Max'
            })
    dft = dft.astype('string')
    return dft

def main() :
    pass

    ##
    df = pd.read_csv(fp.cln_dta)

    ##
    df[v.start_dt] = pd.to_datetime(df[v.start_dt])
    df[v.end_dt] = pd.to_datetime(df[v.end_dt])

    ##
    df[v.dur] = df[v.end_dt] - df[v.start_dt]
    df[v.dur_s] = df[v.dur].dt.total_seconds()

    ##
    df[v.trck] = df[v.scn].apply(lambda x : ''.join(filter(str.isupper , x)))

    ##
    dft = df[v.dur_s].describe().to_frame().T
    dft = format_dft(dft)
    dft.to_latex(fp.t_all)

    ##
    dft = df.groupby(v.trck)[v.dur_s].describe()
    dft = format_dft(dft)
    dft.to_latex(fp.t_trcks)

    ##
    df[v.dur_m] = df[v.dur_s] / 60

    ##
    df[v.dur_m].to_excel(dyr.out / 'dur_m.xlsx', index = False)

    ##
    df[v.dur_m].hist(bins = len(df))

    ##
    plt.hist(df[v.dur_m] , bins = len(df))

    ##
    c2k = {
            0 : 'mean',
            1 : 'std',
            }

    df1 = df[v.dur_s].describe().to_frame().T
    df1 = df1[c2k.values()]
    df1.index = ['All']

    df2 = df.groupby(v.trck)[v.dur_s].describe()
    df2 = df2[c2k.values()]

    ##
    dfa = pd.concat([df2 , df1])

    ##
    dfa = dfa / 60

    ##
    dfa.to_excel(dyr.out / 'mean.xlsx')

    ##
    dyr.pgt.glob('*.csv')

    dfpt = pd.DataFrame()
    for f in dyr.pgt.glob('*.csv') :
        df = pd.read_csv(f)
        dfpt = pd.concat([dfpt , df])

    dfpt

    ##
    

    ##








    ##

    ##



    ##



    ##



    ##



    ##




    ##

    ##
    dft1 = df.groupby(v.trck)[v.dur_s].describe()

    ##
    dfb = dfa.groupby()[v.dur_s].describe()

    ##
    dfa['1'] = dfa[v.dur_s].apply(lambda x : format_seconds(x))

    ##
    plt.show()

    ##
    df1 = dfa.groupby[][v.dur_s].describe()
    df1

    ##
    df1.to_latex('/Users/mmir/Desktop/df1.tex')

    ##
    print(df[v.dur].describe())

    ##

    ##

    ##

if __name__ == '__main__' :
    main()

##
