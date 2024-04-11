from pathlib import Path

PROJ = 'ReRA-first-pilot-sum-stat-20240310'

class Dir :
    sf = '/Users/mmir/Library/CloudStorage/Dropbox/D1-P/A1-GIT-SF/ReRA-first-pilot-sum-stat-20240310-sf'
    sf = Path(sf)
    inp = sf / 'inp'
    med = sf / 'med'
    out = sf / 'out'
    pgt = inp / 'PageTimes'

d = Dir()

class Files :
    cln_dta = d.inp / 'clean_riskprefs_2024-02-20.csv'
    mahdi_cln_dta = d.med / 'mahdi-cln-data-2024-02-20.csv'

    # out
    t_tot_mturk = d.out / 't_tot_mturk.tex'
    t_all = d.out / 't_all.tex'
    t_trcks = d.out / 't_trcks.tex'
    t_pt = d.out / 't_pagetimes.tex'
    t_ins = d.out / 't_ins.tex'
    t_pay = d.out / 't_pay.tex'
    t_idle = d.out / 't_idle.tex'
    tot_idl = d.out / 'total_idle.tex'
    t_exc_l_t = d.out / 't_exc_lt.tex'
    t_idxmax = d.out / 't_idxmax.tex'
    t_ins_sum = d.out / 't_ins_sum.tex'
    t_trck_n_pg = d.out / 't_trck_n_pg.tex'

    s_dist = d.out / 'survey_dist.xlsx'
    st_trck = d.out / 'survey_time_by_track.xlsx'
    x_tot_dist = d.out / 'x_tot_dist.xlsx'
    x_tot_by_trck = d.out / 'x_tot_by_trck.xlsx'

    pgt_dist = d.out / 'page_times_dist.xlsx'
    pgt_mean = d.out / 'page_times_mean.xlsx'
    ins_dist = d.out / 'ins_times_dist.xlsx'
    ins_mean = d.out / 'ins_mean.xlsx'
    itr = 'ins_time_ratio.tex'
    idl_time_pct = d.out / 'idle_time_pct.xlsx'

f = Files()

class Vars :
    start_dt = 'AcceptTime'
    end_dt = 'SubmitTime'
    id = 'workerNum'
    scn = 'session.config.name'

    dur = 'duration'
    dur_m = 'duration_m'
    dur_s = 'duration_s'
    trck = 'Track'

    pcod = 'participant_code'
    eff_s_cod = 'effective_surveycode'
    pgi = 'page_index'
    epoch = 'epoch_time_completed'
    s_c = 'session_code'
    sc = 'session.code'

    o2 = '2 * \sigma Outliers'
    o2_pct = '2 * \sigma Ratio (\%)'

    o3 = '3 * \sigma Outliers'
    o3_pct = '3 * \sigma Ratio (\%)'

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

v = Vars()

class Constants :
    a = 'All'
    ins = 'Instructions'

c = Constants()
