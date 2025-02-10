"""

    """

import pandas as pd

import sys
from pathlib import Path


##
sys.path.append(Path.cwd().as_posix())

from proj.lib import DIR, VAR, FILE
from py.main import read_page_times_data_filter_and_combine

##

##
def check_before_and_after_otree_time_spent():
    """ """

    ##
    df = read_page_times_data_filter_and_combine()

    ##
    df = df.reset_index(drop=True)

    ##
    # keep only first & last page based on page index
    msk1 = df.groupby(VAR.pcod)[VAR.pgi].idxmin()

    assert len(msk1) == 25

    df1 = df.loc[msk1]

    ##
    msk2 = df.groupby(VAR.pcod)[VAR.pgi].idxmax()

    assert len(msk2) == 25

    df2 = df.loc[msk2]

    ##
    df_cln = pd.read_csv(FILE.mahdi_cln_dta)

    ##
    cols_2_keep = {
            VAR.eff_s_cod : None,
            VAR.accpt_t : None,
            VAR.submit_t : None,
            }

    df_cln = df_cln[list(cols_2_keep.keys())]

    ##
    df1 = df1.set_index(VAR.pcod)
    df2 = df2.set_index(VAR.pcod)

    ##
    df_cln[VAR.first_page_epoch] = df_cln[VAR.eff_s_cod].map(df1[VAR.epoch])
    df_cln[VAR.last_page_epoch] = df_cln[VAR.eff_s_cod].map(df2[VAR.epoch])

    ##
    df_cln[VAR.first_page_t] = pd.to_datetime(df_cln[VAR.first_page_epoch], unit='s')
    df_cln[VAR.last_page_t] = pd.to_datetime(df_cln[VAR.last_page_epoch], unit='s')

    ##
    df_cln[VAR.t_spent_before_first_page] = df_cln[VAR.first_page_t] - pd.to_datetime(df_cln[VAR.accpt_t])
    df_cln[VAR.t_spent_after_last_page] = pd.to_datetime(df_cln[VAR.submit_t]) - df_cln[VAR.last_page_t]

    ##
    df3 = df_cln.describe()

    # before time mean: 7.5 min and median: 22 seconds
    # after time mean: 1.5 min and median: 47 seconds

    ##
    df_cln_1 = df_cln[df_cln[VAR.t_spent_before_first_page] < pd.Timedelta(10, 'm')]

    ##
    c2k = {
            VAR.t_spent_before_first_page : None,
            }

    df_cln_1 = df_cln_1[list(c2k.keys())]

    ##
    df_cln_1 = df_cln_1.map(lambda x: x.total_seconds())

    ##
    df4 = df_cln_1.describe()

    # after removing outliesrs above 10 mins
    # before time mean: 43 seconds and median: 13 seconds

    ##
    df_cln_2 = df_cln[df_cln[VAR.t_spent_after_last_page] < pd.Timedelta(10, 'm')]

    ##
    c2k = {
            VAR.t_spent_after_last_page : None,
            }

    df_cln_2 = df_cln_2[list(c2k.keys())]

    ##
    df_cln_2 = df_cln_2.map(lambda x: x.total_seconds())

    ##
    df5 = df_cln_2.describe()

    ##
    df6 = df4.join(df5)

    ##
    df6.to_excel(FILE.before_after)

    # after removing outliesrs above 10 mins
    # after time mean: 1:11 seconds and median 46 seconds

    ##


    ##

    # so now I should check wheter people see the consent page inside the Otree or not

##

##
def are_people_in_the_same_track_get_equal_number_of_pages():
    """ """

    ##
    df = read_page_times_data_filter_and_combine()
    df = df.reset_index(drop=True)

    ##
    df_page_count = df.groupby([VAR.pcod])[VAR.pgi].count()

    ##
    df_cln = pd.read_csv(FILE.mahdi_cln_dta)

    cols_2_keep = {
            VAR.eff_s_cod : None,
            VAR.scn : None,
            }

    df_cln = df_cln[list(cols_2_keep.keys())]

    ##
    df_cln = df_cln.set_index(VAR.eff_s_cod)

    ##
    df_page_count = df_page_count.to_frame()

    ##
    df_page_count = df_page_count.join(df_cln)

    ##
    df1 = df_page_count.groupby([VAR.scn]).describe()

    ##
    # include this table in the report and say it is not the same,
    # Itamar should comment about this is not necessarily is a problem


def make_pages_data_wide():
    """ """
    ##
    df = read_page_times_data_filter_and_combine()

    ##
    # keep only participant code, page index, app_name, page_name
    df = df[[VAR.pcod, VAR.pgi, VAR.app_name, VAR.page_name]]

    ##
    df_cln = pd.read_csv(FILE.mahdi_cln_dta)

    ##
    df_cln = df_cln[[VAR.eff_s_cod, VAR.scn]]

    ##
    df_a = pd.merge(df, df_cln, how='left', left_on=VAR.pcod, right_on=VAR.eff_s_cod)

    ##
    df_a = df_a.drop(columns=[VAR.eff_s_cod])

    ##
    df_a = df_a.sort_values([VAR.scn, VAR.pcod, VAR.pgi])

    ##
    # goupby participant code and save sub dataframes wide in a dataframe
    df_wide = df_a.groupby([VAR.scn, VAR.pcod])[VAR.page_name].apply(lambda x: x.reset_index(drop=True)).unstack()

    ##
    df_wide.to_excel(FILE.pages_shown_by_track)

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

##



##
