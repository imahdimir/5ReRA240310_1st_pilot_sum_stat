""" project wide specific constants and paths. """

from pathlib import Path

PROJ = 'ReRA-first-pilot-sum-stat-20240310'

class Dir :
    git_dir = '/Users/mmir/Library/CloudStorage/Dropbox/git'
    git_dir = Path(git_dir)

    # code small files repo name
    csf_name = '4ReRA240310_csf_ReRA_1st_pilot_sum_stat'
    csf = git_dir / csf_name

    csf_inp = csf / 'inp'
    csf_med = csf / 'med'
    csf_out = csf / 'out'

    pgt = csf_inp / 'PageTimes'

DIR = Dir()

class File :
    d = DIR
    med = d.csf_med

    cln_dta = d.csf_inp / 'clean_riskprefs_2024-02-20.csv'

    mahdi_cln_dta = d.csf_med / 'mahdi-cln-data-2024-02-20.csv'
    pages_shown_by_track = d.csf_med / 'pages_shown_by_track.xlsx'
    before_after = d.csf_med / 'before_after.xlsx'

    # out
    t_tot_mturk = d.csf_out / 't_tot_mturk.tex'
    t_all = d.csf_out / 't_all.tex'
    t_trcks = d.csf_out / 't_trcks.tex'
    t_pt = d.csf_out / 't_pagetimes.tex'
    t_ins = d.csf_out / 't_ins.tex'
    t_pay = d.csf_out / 't_pay.tex'
    t_idle = d.csf_out / 't_idle.tex'
    tot_idl = d.csf_out / 'total_idle.tex'
    t_exc_l_t = d.csf_out / 't_exc_lt.tex'
    t_idxmax = d.csf_out / 't_idxmax.tex'
    t_ins_sum = d.csf_out / 't_ins_sum.tex'
    t_trck_n_pg = d.csf_out / 't_trck_n_pg.tex'

    s_dist = d.csf_out / 'survey_dist.xlsx'
    st_trck = d.csf_out / 'survey_time_by_track.xlsx'
    x_tot_dist = d.csf_out / 'x_tot_dist.xlsx'
    x_tot_by_trck = d.csf_out / 'x_tot_by_trck.xlsx'

    pgt_dist = d.csf_out / 'page_times_dist.xlsx'
    pgt_mean = d.csf_out / 'page_times_mean.xlsx'
    ins_dist = d.csf_out / 'ins_times_dist.xlsx'
    ins_mean = d.csf_out / 'ins_mean.xlsx'
    itr = 'ins_time_ratio.tex'
    idl_time_pct = d.csf_out / 'idle_time_pct.xlsx'



FILE = File()

class Var :
    eff_s_cod = 'effective_surveycode'

    accpt_t = 'AcceptTime'
    submit_t = 'SubmitTime'
    first_page_epoch = 'first_page_epoch'
    last_page_epoch = 'last_page_epoch'
    epoch = 'epoch_time_completed'
    first_page_t = 'first_page_time'
    last_page_t = 'last_page_time'
    t_spent_before_first_page = 'time_spent_before_first_page'
    t_spent_after_last_page = 'time_spent_after_last_page'


    id = 'workerNum'
    scn = 'session.config.name'

    dur = 'duration'
    dur_m = 'duration_m'
    dur_s = 'duration_s'
    trck = 'Track'

    pcod = 'participant_code'
    pgi = 'page_index'
    app_name = 'app_name'
    page_name = 'page_name'
    s_c = 'session_code'
    sc = 'session.code'

    # o2 = '2 * \sigma Outliers'

    # o2_pct = '2 * \sigma Ratio (\%)'

    # o3 = '3 * \sigma Outliers'
    # o3_pct = '3 * \sigma Ratio (\%)'

    is_ins_pg = 'is_instruction_page'
    page_name = 'page_name'
    tot_pay = 'total_payment'
    total_pay = 'Total Payment'

    n = 'N'

    tot_t = 'Total Time'
    mean = 'mean'
    med = 'Medain'
    std = 'std'
    idx = 'index'
    Mean = 'Mean'
    Std = 'STD'

    n50 = '50%'
    y = 'y'
    ytype = 'ytype'

    lt5 = 'lt5'
    lt10 = 'lt10'

VAR = Var()

class Constant :
    a = 'All'
    ins = 'Instructions'

CONST = Constant()
