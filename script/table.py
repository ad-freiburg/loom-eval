#!/usr/bin/python3

# (C) 2021 University of Freiburg
# Chair of Algorithms and Data Structures
# Authors: Patrick Brosi (brosi@cs.uni-freiburg.de)

import json
from statistics import median
import sys
import os
import math

DATASET_LABELS = {
    "freiburg": "Freiburg",
    "dallas": "Dallas",
    "chicago": "Chicago",
    "sydney": "Sydney",
    "stuttgart": "Sydney",
    "turin": "Turin",
    "nyc_subway": "New York",
}

DATASET_LABELS_SHORT = {
    "freiburg": "FR",
    "dallas": "DA",
    "chicago": "CG",
    "sydney": "SD",
    "stuttgart": "ST",
    "turin": "TU",
    "nyc_subway": "NY",
}


def read_result(path):
    ret = {}
    try:
        with open(path) as f:
            full = json.load(f)
            ret = full["properties"]["statistics"]
    except BaseException:
        pass

    return ret


def read_results(path):
    # all methods are hardcoded here
    ret = {}

    for root, subdirs, files in os.walk(path):
        for filename in files:
            _, ext = os.path.splitext(filename)
            if ext != ".json":
                continue
            file_path = os.path.join(root, filename)
            rel_path = os.path.relpath(file_path, path)
            comps = rel_path.split(os.sep)

            if not comps[0] in ret:
                ret[comps[0]] = {}

            result = read_result(file_path)
            if result is not None:
                ret[comps[0]][comps[1]] = result

    return ret


def scinot(num):
    if num is None:
        return "---"
    magni = math.floor(math.log(num, 10))
    ret = "\\Hsci{"
    ret += "%.0f" % (num / (math.pow(10, magni)))
    ret += "}{"
    ret += str(magni)
    ret += "}"

    return ret


def get(res, a, b, c):
    if a not in res:
        return None
    if b not in res[a]:
        return None
    if c not in res[a][b]:
        return None
    return res[a][b][c]


def format_int(n):
    if n is None:
        return "---"

    if n < 1000:
        return "%d" % n

    if n < 1000000:
        return "%.1f\\Hk" % (n / 1000)

    if n < 1000000000:
        return "%.1f\\HM" % (n / 1000000)

    return "%.1f\\HB" % (n / 1000000000)


def format_float(n):
    if n is None:
        return "---"
    return "%.1f" % n


def format_secs(s):
    return format_msecs(s * 1000)


def format_msecs(ms):
    if ms is None:
        return "---"

    if ms < 0.1:
        return "$<1$\\Hms"

    if ms < 1:
        return "%.1f\\Hms" % ms

    if ms < 100:
        return "%.0f\\Hms" % ms

    if ms < 1000 * 60:
        return "%.1f\\Hs" % (ms / 1000.0)

    if ms < 1000 * 60 * 60:
        return "%.0f\\Hm" % (ms / (60 * 1000.0))

    return "%.0f\\Hh" % (ms / (60 * 60 * 1000.0))


def format_approxerr(perfect, approx):
    if perfect is None or approx is None:
        return "---"

    return "%.1f" % ((approx - perfect) / perfect)


def tbl_overview(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Line graphs used in our experimental evaluation. Under $|{\\cal S}|$ we give the number of station nodes in the graph. Under  $|V|$ we give the numer of nodes (including station nodes). Under $|E|$ we give the number of edges. Under $|{\\cal L}|$ we give the number of lines. $M$ is the maximum number of lines per edge. $D$ is the maximum node degree. $|\\Omega|$ is the line-ordering search space size on the original line graph. \\label{TBL:loom:dataset-overview}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{3pt}\n"

    ret += "  \\begin{tabular*}{0.8\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r c} \\toprule\n       & $|{\\cal S}|$ & $|V|$ & $|E|$ & $|{\\cal L}|$ & $M$ & $D$ & $|\\Omega|$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "    %s & %d & %d & %d & %d & %d & %d & %s\\\\\n" % (DATASET_LABELS[dataset_id] + " (" + DATASET_LABELS_SHORT[dataset_id] + ")",
                                                                    r["greedy"]["raw"]["input_num_stations"],
                                                                    r["greedy"]["raw"]["input_num_nodes"],
                                                                    r["greedy"]["raw"]["input_num_edges"],
                                                                    r["greedy"]["raw"]["input_num_lines"],
                                                                    r["greedy"]["raw"]["input_max_number_lines"],
                                                                    r["greedy"]["raw"]["input_max_deg"],
                                                                    scinot(r["greedy"]["raw"]["input_solution_space_size"]))

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_main_res_time(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Main results for the running times of a selection of our methods on all test datasets. \\TODO{how are they selected?} \\label{TBL:loom:main-res-time}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "  \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r}\n"
    ret += "                   &   \\multicolumn{5}{c}{\\footnotesize heuristic}   & & \\multicolumn{5}{c}{\\footnotesize exact} \\\\\n"
    ret += "             \\cline{2-6} \\cline{8-12}  \\\\[-2ex] \\toprule\n"
    ret += "    \\method\\hspace{-7pt}   & \\GREEDYLAsf  & \\HILsf & \\HILsf  & \\HILsf  & \\ANNsf && \\bILPsf & \\bILPsf & \\iILPsf & \\iILPsf & \\iILPsf    \\\\[-1.5mm]\n"
    ret += "    \\graph\\hspace{-7pt}   & \\basic       & \\basic & \\pruned & \\untang & \\untang && \\basic & \\untang & \\basic   & \\pruned & \\untang    \\\\[0.7mm]\\cmidrule{2-12}\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "%s & %s  & %s &  %s &  %s  &  %s  &&  %s  &  %s  &  %s  &  %s &  %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                                                                                              format_msecs(
                                                                                                  get(r, "greedy-lookahead-sep", "raw", "avg_solve_time")),
                                                                                              format_msecs(
                                                                                                  get(r, "hillc-random-sep", "raw", "avg_solve_time")),
                                                                                              format_msecs(get(r, "hillc-random-sep",
                                                                                                               "pruned", "avg_solve_time")),
                                                                                              format_msecs(get(r, "hillc-random-sep",
                                                                                                               "untangled", "avg_solve_time")),
                                                                                              format_msecs(get(r, "anneal-random-sep",
                                                                                                               "untangled", "avg_solve_time")),
                                                                                              format_msecs(get(r, "ilp-gurobi-baseline",
                                                                                                               "raw", "avg_solve_time")),
                                                                                              format_msecs(get(r, "ilp-gurobi-baseline",
                                                                                                               "untangled", "avg_solve_time")),
                                                                                              format_msecs(
                                                                                                  get(r, "ilp-gurobi", "raw", "avg_solve_time")),
                                                                                              format_msecs(
                                                                                                  get(r, "ilp-gurobi", "pruned", "avg_solve_time")),
                                                                                              format_msecs(
                                                                                                  get(r, "ilp-gurobi", "untangled", "avg_solve_time"))
                                                                                              )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_main_res_approx_error(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Main results for the relative approximation error $\\eta$ ($=\\frac{\\theta_{\\text{approx}}}{\\theta} - 1$) of a selection of our heuristic methods on all test datasets. \\TODO{how are they selected?} \\label{TBL:loom:main-res-approx-error}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "  \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r r}\\toprule\n"
    ret += "    \\method\\hspace{-7pt} & \\GREEDYsf   & \\GREEDYLAsf & \\GREEDYLAsf  & \\HILGRsf & \\HILGRsf  & \\ANNGRsf  & \\ANNGRsf   & \\HILsf  & \\HILsf   & \\ANNsf & \\ANNsf  \\\\[-1.5mm]\n"
    ret += "    \\graph\\hspace{-7pt}   & \\basic & \\basic       & \\untang & \\basic & \\untang & \\basic & \\untang & \\basic & \\untang   & \\basic & \\untang    \\\\[0.7mm]\\cmidrule{2-12}\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    avg = [0] * 11

    for dataset_id in sort:
        r = results[dataset_id]
        optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")

        avg[0] += (get(r, "greedy-sep", "raw", "avg_score") - optim) / optim
        avg[1] += (get(r, "greedy-lookahead-sep",
                       "raw", "avg_score") - optim) / optim
        avg[2] += (get(r, "greedy-lookahead-sep",
                       "raw", "avg_score") - optim) / optim
        avg[3] += (get(r, "hillc-sep", "raw", "avg_score") - optim) / optim
        avg[4] += (get(r, "hillc-sep", "untangled",
                       "avg_score") - optim) / optim
        avg[5] += (get(r, "anneal-sep", "raw", "avg_score") - optim) / optim
        avg[6] += (get(r, "anneal-sep", "untangled",
                       "avg_score") - optim) / optim
        avg[7] += (get(r, "hillc-random-sep", "raw",
                       "avg_score") - optim) / optim
        avg[8] += (get(r, "hillc-random-sep", "untangled",
                       "avg_score") - optim) / optim
        avg[9] += (get(r, "anneal-random-sep", "raw",
                       "avg_score") - optim) / optim
        avg[10] += (get(r, "anneal-random-sep", "untangled",
                        "avg_score") - optim) / optim

        ret += "%s & %s  & %s &  %s &  %s  &  %s  &  %s  &  %s  &  %s  &  %s &  %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "greedy-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "greedy-lookahead-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "greedy-lookahead-sep", "untangled", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "hillc-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "hillc-sep", "untangled", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "anneal-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "anneal-sep", "untangled", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "hillc-random-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "hillc-random-sep", "untangled", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "anneal-random-sep", "raw", "avg_score")),
                                                                                                  format_approxerr(optim, get(
                                                                                                      r, "anneal-random-sep", "untangled", "avg_score"))
                                                                                                  )

    ret += "\\midrule\n"

    mini = avg.index(min(avg))

    ret += "avg & %s  & %s &  %s &  %s  &  %s  & %s  &  %s  &  %s  &  %s & %s & %s\\\\\n" % (bold_if(
        format_float(
            avg[0] / len(sort)),
        mini == 0),
        bold_if(
            format_float(
                avg[1] / len(sort)),
        mini == 1),
        bold_if(
        format_float(
            avg[2] / len(sort)),
        mini == 2),
        bold_if(
        format_float(
            avg[3] / len(sort)),
        mini == 3),
        bold_if(
        format_float(
            avg[4] / len(sort)),
        mini == 4),
        bold_if(
        format_float(
            avg[5] / len(sort)),
        mini == 5),
        bold_if(
        format_float(
            avg[6] / len(sort)),
        mini == 6),
        bold_if(
        format_float(
            avg[7] / len(sort)),
        mini == 7),
        bold_if(
        format_float(
            avg[8] / len(sort)),
        mini == 8),
        bold_if(
        format_float(
            avg[9] / len(sort)),
        mini == 9),
        bold_if(
        format_float(
            avg[10] / len(sort)),
        mini == 10),
    )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def bold(s):
    return "\\textbf{" + s + "}"


def bold_if(s, t):
    if not t:
        return s
    return "\\textbf{" + s + "}"


def tbl_approx_comp(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{\\TODO{caption} \\label{TBL:loom:approx-comp}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\footnotesize\\setlength\\tabcolsep{5pt}\n"

    ret += "    \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l@{\\hskip 2mm} r@{\\hskip 3mm} r r r@{\\hskip 2.5mm} r r r r r@{\\hskip 1.5mm}r@{\\hskip 1mm}r r r r}\n"
    ret += "    && \\multicolumn{6}{c}{\\footnotesize On baseline graph} & & \\multicolumn{6}{c}{\\footnotesize On pruned \\& cut graph} \\\\\n"
    ret += "    \\cline{3-8} \\cline{10-15} \\\\[-2ex] \\toprule\n"
    ret += "    && $|\\Omega|$ & $t$ & $\\times$ & $||$ & $\\theta$ & $\\eta$ & & $|\\Omega|$ & $t$ & $\\times$ & $||$ & $\\theta$ & $\\eta$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        if dataset_id not in {"freiburg", "sydney", "nyc_subway"}:
            continue

        search_space = scinot(
            get(r, "greedy", "raw", "optgraph_solution_space_size"))
        search_space_pruned = scinot(
            get(r, "greedy", "pruned", "optgraph_solution_space_size"))

        first = True
        for a in [
            ("exhaustive",
             "\\EXH"),
            ("greedy",
             "\\GREEDY"),
            ("greedy-lookahead",
             "\\GREEDYLA"),
            ("hillc",
             "+\\HIL"),
            ("anneal",
             "+\\ANN"),
            ("hillc-random",
             "\\HIL"),
            ("anneal-random",
             "\\ANN"),
            ("exhaustive-sep",
             "\\EXHst"),
            ("greedy-sep",
             "\\GREEDYst"),
            ("greedy-lookahead-sep",
             "\\GREEDYLAst"),
            ("hillc-sep",
             "+\\HILst"),
            ("anneal-sep",
             "+\\ANNst"),
            ("hillc-random-sep",
             "\\HILst"),
            ("anneal-random-sep",
             "\\ANNst")]:

            if "sep" in a[0]:
                optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")
            else:
                optim = get(r, "ilp-cbc", "untangled", "avg_score")

            ret += "%s & %s  & %s &  %s &  %s  &  %s  &  %s  & %s  &&  %s  &  %s &  %s & %s  &  %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                                                                                                                  a[1],
                                                                                                                  search_space if a[0] in [
                                                                                                                      "hillc", "hillc-sep"] else "",
                                                                                                                  format_msecs(
                                                                                                                      get(r, a[0], "raw", "avg_solve_time")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "raw", "avg_num_crossings")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "raw", "avg_num_separations")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "raw", "avg_score")),
                                                                                                                  format_approxerr(optim, get(
                                                                                                                      r, a[0], "raw", "avg_score")),
                                                                                                                  search_space_pruned if a[0] in [
                                                                                                                      "hillc", "hillc-sep"] else "",
                                                                                                                  format_msecs(
                                                                                                                      get(r, a[0], "pruned", "avg_solve_time")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "pruned", "avg_num_crossings")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "pruned", "avg_num_separations")),
                                                                                                                  format_float(
                                                                                                                      get(r, a[0], "pruned", "avg_score")),
                                                                                                                  format_approxerr(optim, get(
                                                                                                                      r, a[0], "pruned", "avg_score")),
                                                                                                                  )
            if a[0] == "anneal-random":
                ret += "\\cline{2-15}\n"
            first = False
        if i < len(sort) - 1:
            ret += "\\midrule\n"

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_approx_comp_avg(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Average solution time (t) and relative approximation errors ($\\eta$) of all our heuristic approaches, over all datasets. \\label{TBL:loom:approx-comp-avg}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "    \\begin{tabular*}{0.8\\textwidth}{@{\\extracolsep{\\fill}} l@{\\hskip 2mm} r r r r r r}\n"
    ret += "    && \\multicolumn{2}{c}{\\footnotesize On baseline graph} & & \\multicolumn{2}{c}{\\footnotesize On pruned \\& cut graph} \\\\\n"
    ret += "    \\cline{3-4} \\cline{6-7} \\\\[-2ex] \\toprule\n"
    ret += "    && t & $\\eta$ && t & $\\eta$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    methods = [
        ("greedy",
         "\\GREEDY"),
        ("greedy-lookahead",
         "\\GREEDYLA"),
        ("hillc",
         "+\\HIL"),
        ("anneal",
         "+\\ANN"),
        ("hillc-random",
         "\\HIL"),
        ("anneal-random",
         "\\ANN"),
        ("greedy-sep",
         "\\GREEDYst"),
        ("greedy-lookahead-sep",
         "\\GREEDYLAst"),
        ("hillc-sep",
         "+\\HILst"),
        ("anneal-sep",
         "+\\ANNst"),
        ("hillc-random-sep",
         "\\HILst"),
        ("anneal-random-sep",
         "\\ANNst")]

    avg = {k[0]: 0 for k in methods}
    avg_pruned = {k[0]: 0 for k in methods}

    avg_t = {k[0]: 0 for k in methods}
    avg_t_pruned = {k[0]: 0 for k in methods}

    best_t = 999999999
    best_t_m = None

    best_t_pruned = 999999999
    best_t_m_pruned = None

    best_t_sep = 999999999
    best_t_m_sep = None

    best_t_sep_pruned = 999999999
    best_t_m_sep_pruned = None

    best_score = 999999999
    best_score_m = None

    best_score_pruned = 999999999
    best_score_m_pruned = None

    best_score_sep = 999999999
    best_score_m_sep = None

    best_score_sep_pruned = 999999999
    best_score_m_sep_pruned = None

    for dataset_id in sort:
        r = results[dataset_id]

        for m in methods:
            if "sep" in m[0]:
                optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")
            else:
                optim = get(r, "ilp-cbc", "untangled", "avg_score")

            if avg[m[0]] is None or get(r, m[0], "raw", "avg_score") is None:
                avg[m[0]] = None
            else:
                avg[m[0]] += ((get(r, m[0], "raw", "avg_score") -
                               optim) / optim) / len(sort)

            if avg_pruned[m[0]] is None or get(r, m[0], "pruned", "avg_score") is None:
                avg_pruned[m[0]] = None
            else:
                avg_pruned[m[0]] += ((get(r, m[0], "pruned",
                                          "avg_score") - optim) / optim) / len(sort)

            if avg_t[m[0]] is None or get(r, m[0], "raw", "avg_solve_time") is None:
                avg_t[m[0]] = None
            else:
                t = get(r, m[0], "raw", "avg_solve_time") / len(sort)
                avg_t[m[0]] += t

            if avg_t_pruned[m[0]] is None or get(r, m[0], "pruned", "avg_solve_time") is None:
                avg_t_pruned[m[0]] = None
            else:
                t = get(r, m[0], "pruned", "avg_solve_time") / len(sort)
                avg_t_pruned[m[0]] += t

    for m in methods: 
        if "sep" in m[0]:
            t = avg_t[m[0]]                     
            if t < best_t_sep:
                best_t_sep = t
                best_t_m_sep = m[0]
            t = avg_t_pruned[m[0]]                     
            if t < best_t_sep_pruned:
                best_t_sep_pruned = t
                best_t_m_sep_pruned = m[0]
        else:
            t = avg_t[m[0]]                     
            if t < best_t:
                best_t = t
                best_t_m = m[0]
            t = avg_t_pruned[m[0]]                     
            if t < best_t_pruned:
                best_t_pruned = t
                best_t_m_pruned = m[0]

        if "sep" in m[0]:
            t = avg[m[0]]                     
            if t < best_score_sep:
                best_score_sep = t
                best_score_m_sep = m[0]
            t = avg_pruned[m[0]]                     
            if t < best_score_sep_pruned:
                best_score_sep_pruned = t
                best_score_m_sep_pruned = m[0]
        else:
            t = avg[m[0]]                     
            if t < best_score:
                best_score = t
                best_score_m = m[0]
            t = avg_pruned[m[0]]                     
            if t < best_score_pruned:
                best_score_pruned = t
                best_score_m_pruned = m[0]


    for a in methods:
        if "sep" in a[0]:
            optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")
        else:
            optim = get(r, "ilp-cbc", "untangled", "avg_score")

        ret += "%s && %s & %s  && %s & %s  \\\\\n" % (a[1],
                                           bold_if(format_msecs(avg_t[a[0]]), ("sep" in a[0] and best_t_m_sep== a[0]) or ("sep" not in a[0] and best_t_m== a[0])),
                                           bold_if(format_float(avg[a[0]]), ("sep" in a[0] and best_score_m_sep== a[0]) or ("sep" not in a[0] and best_score_m== a[0])),
                                           bold_if(format_msecs(avg_t_pruned[a[0]]),  ("sep" in a[0] and best_t_m_sep_pruned== a[0]) or ("sep" not in a[0] and best_t_m_pruned== a[0])),
                                           bold_if(format_float(avg_pruned[a[0]]), ("sep" in a[0] and best_score_m_sep_pruned== a[0]) or ("sep" not in a[0] and best_score_m_pruned== a[0])),
                                           )

        if a[0] == "anneal-random":
            ret += "\\cline{2-7}\n"
        first = False

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_ilp_comp(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{ILP Dimensions (given as rows$\\times$ cols) and solution times for all our ILP variants on the raw input graph and on the pruned \\& cut input graph. If a graph had multiple components, we optimized them separately, and the dimensions for the largest component are given, but solution times are always cumulative. We only measured the time to solve the ILP, not the ILP construction time or the time it took to extract the line ordering from the ILP solution (which were both negligible) or the time required to set up the solver environment. \\label{TBL:loom:ilp-comp}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\footnotesize\\setlength\\tabcolsep{2pt}\n"

    ret += "    \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l@{\\hskip 1.2mm} r r r r@{\\hskip 2.5mm} r r r r r@{\\hskip 1.5mm}r@{\\hskip 1mm}r r r}\n"
    ret += "    && \\multicolumn{4}{c}{\\footnotesize On raw graph} & & \\multicolumn{4}{c}{\\footnotesize On pruned graph} \\\\\n"
    ret += "    \\cline{3-6} \\cline{8-11} \\\\[-2ex] \\toprule\n"
    ret += "    && \\Hdimh & \\Htglpk & \\Htcbc & \\Htgo &  & \\Hdimh & \\Htglpk & \\Htcbc & \\Htgo & $\\times$ & $||$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        first = True
        for a in [("ilp-baseline", "\\bILP"), ("ilp-baseline-sep", "\\bILPst"),
                  ("ilp", "\\iILP"), ("ilp-sep", "\\iILPst")]:
            ret += "%s  & {%s}   & \\Hdim{%s}{%s}  &  %s & %s & %s & &  \\Hdim{%s}{%s} & %s & %s & %s &  %s & %s \\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                                                                                                                            a[1],
                                                                                                                            format_int(get(r, a[0] + "-cbc", "raw",
                                                                                                                                           "max_num_rows_in_comp")),
                                                                                                                            format_int(get(r, a[0] + "-cbc", "raw",
                                                                                                                                           "max_num_cols_in_comp")),
                                                                                                                            format_msecs(
                                                                                                                                get(r, a[0] + "-glpk", "raw", "avg_solve_time")),
                                                                                                                            format_msecs(
                                                                                                                                get(r, a[0] + "-cbc", "raw", "avg_solve_time")),
                                                                                                                            format_msecs(
                                                                                                                                get(r, a[0] + "-gurobi", "raw", "avg_solve_time")),
                                                                                                                            format_int(get(r, a[0] + "-cbc", "pruned",
                                                                                                                                           "max_num_rows_in_comp")),
                                                                                                                            format_int(get(r, a[0] + "-cbc", "pruned",
                                                                                                                                           "max_num_cols_in_comp")),
                                                                                                                            format_msecs(
                get(r, a[0] + "-glpk", "pruned", "avg_solve_time")),
                format_msecs(get(r, a[0] + "-cbc", "pruned", "avg_solve_time")),
                format_msecs(
                    get(r, a[0] + "-gurobi", "pruned", "avg_solve_time")),
                format_int(
                    get(r, a[0] + "-cbc", "pruned", "avg_num_crossings")),
                format_int(
                    get(r, a[0] + "-cbc", "pruned", "avg_num_separations"))
            )
            first = False
        if i < len(sort) - 1:
            ret += "\\midrule\n"

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_untangling_graph_size(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Effects of full line graph simplification on line graph dimensions. $|V|$ is the number of nodes, $|E|$ is the number of edges, $M$ is the maximum number of lines per edge, $|\\Omega|$ is the search space size (sum of the search space sizes of the graph components), $C$ is the number of nontrivial (more than 2 nodes) graph components, $C^1$ is the number of nontrivial graph components with a search space size of 1 (not requiring further optimization).\\label{TBL:loom:untangling-graph-size}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{2pt}\n"

    ret += "    \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r r r r r r r r r r r r}\n"
    ret += "    && \\multicolumn{6}{c}{\\footnotesize Raw input graph} && \\multicolumn{6}{c}{\\footnotesize Pruned \\& cut graph}  && \\multicolumn{6}{c}{\\footnotesize Fully simplified graph} \\\\\n"
    ret += "    \\cline{3-8} \\cline{10-15} \\cline{17-22}  \\\\[-2ex] \\toprule\n"
    ret += "    && $|V|$ & $|E|$ & $M$ & $|\\Omega|$ & $C$ & $C^1$ && $|V|$ & $|E|$ & $M$ & $|\\Omega|$ & $C$ & $C^1$ && $|V|$ & $|E|$ & $M$ &  $|\\Omega|$  & $C$ & $C^1$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    pruned_red = []
    untangled_red = []

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        rawsize = get(r, "greedy-sep", "raw", "optgraph_solution_space_size")
        prunedsize = get(r, "greedy-sep", "pruned", "optgraph_solution_space_size")
        untangledsize = get(r, "greedy-sep", "untangled", "optgraph_solution_space_size")

        pruned_red.append((rawsize / prunedsize))
        untangled_red.append((rawsize / untangledsize))

        ret += "%s && %s  & %s  & %s &  %s  &   %s  &  %s  &&  %s  &  %s  &  %s &  %s &  %s   &  %s  &&  %s &  %s &  %s &  %s &  %s &  %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                                                                                                                                                    format_int(
                                                                                                                                                        get(r, "greedy-sep", "raw", "optgraph_num_nodes")),
                                                                                                                                                    format_int(
                                                                                                                                                        get(r, "greedy-sep", "raw", "optgraph_num_edges")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "raw",
                                                                                                                                                                   "optgraph_max_number_lines")),
                                                                                                                                                    scinot(
                                                                                                                                                        get(r, "greedy-sep", "raw", "optgraph_solution_space_size")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "raw",
                                                                                                                                                                   "optgraph_nontrivial_comps")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "raw",
                                                                                                                                                                   "optgraph_nontrivial_comps_searchspace_one")),
                                                                                                                                                    format_int(
                                                                                                                                                        get(r, "greedy-sep", "pruned", "optgraph_num_nodes")),
                                                                                                                                                    format_int(
                                                                                                                                                        get(r, "greedy-sep", "pruned", "optgraph_num_edges")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "pruned",
                                                                                                                                                                   "optgraph_max_number_lines")),
                                                                                                                                                    scinot(get(r, "greedy-sep", "pruned",
                                                                                                                                                               "optgraph_solution_space_size")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "pruned",
                                                                                                                                                                   "optgraph_nontrivial_comps")),
                                                                                                                                                    format_int(get(r, "greedy-sep", "pruned",
                                                                                                                                                                   "optgraph_nontrivial_comps_searchspace_one")),
                                                                                                                                                    format_int(
            get(r, "greedy-sep", "untangled", "optgraph_num_nodes")),
            format_int(
                get(r, "greedy-sep", "untangled", "optgraph_num_edges")),
            format_int(get(r, "greedy-sep", "untangled",
                           "optgraph_max_number_lines")),
            scinot(get(r, "greedy-sep", "untangled",
                       "optgraph_solution_space_size")),
            format_int(get(r, "greedy-sep", "untangled",
                           "optgraph_nontrivial_comps")),
            format_int(get(r, "greedy-sep", "untangled",
                           "optgraph_nontrivial_comps_searchspace_one")),
        )

    ret += "\\midrule\n"

    ret += "\\begin{tabular}{@{}l@{}}med\\\\[-5pt]red\\end{tabular} &&  &  & &   &    &   &&   &   &  &  %s &   &   &&  &  &  &  %s & &  \\\\\n" % (scinot(median(pruned_red)), scinot(median(untangled_red)))

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_untangling_ilp(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Impact of full simplification on ILP sizes and solution times. We only measured the time to solve the ILP, not the ILP construction time or the time it took to extract the line ordering from the ILP solution (which were both negligible) or the time required to set up the solver environment.\\label{TBL:loom:untangling-ilp} }\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{2pt}\n"

    ret += "    \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r r r r}\n"
    ret += "    & & \\multicolumn{4}{ c }{\\footnotesize Pruned graph} & & \\multicolumn{4}{ c }{\\footnotesize Fully simplified graph} \\\\\n"
    ret += "    \\cline{3-6} \\cline{8-11} \\\\[-2ex] \\toprule\\noalign{\\smallskip}\n"
    ret += "    & & \\Hdimh & GLPK & CBC & GU & & \\Hdimh$_{max}$ & GLPK & CBC & GU \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        first = True
        for a in [("ilp", "\\iILP"), ("ilp-sep", "\\iILPst")]:
            ret += "%s  & {%s}   & \\Hdim{%s}{%s}       &  %s &  %s & %s & & \\Hdim{%s}{%s} & %s & %s & %s \\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                                                                                                                      a[1],
                                                                                                                      format_int(get(r, a[0] + "-cbc", "pruned",
                                                                                                                                     "max_num_rows_in_comp")),
                                                                                                                      format_int(get(r, a[0] + "-cbc", "pruned",
                                                                                                                                     "max_num_cols_in_comp")),
                                                                                                                      format_msecs(
                get(r, a[0] + "-glpk", "pruned", "avg_solve_time")),
                format_msecs(get(r, a[0] + "-cbc", "pruned", "avg_solve_time")),
                format_msecs(
                    get(r, a[0] + "-gurobi", "pruned", "avg_solve_time")),
                format_int(
                    get(r, a[0] + "-cbc", "untangled", "max_num_rows_in_comp")),
                format_int(
                    get(r, a[0] + "-cbc", "untangled", "max_num_cols_in_comp")),
                format_msecs(
                    get(r, a[0] + "-glpk", "untangled", "avg_solve_time")),
                format_msecs(
                    get(r, a[0] + "-cbc", "untangled", "avg_solve_time")),
                format_msecs(
                    get(r, a[0] + "-gurobi", "untangled", "avg_solve_time"))
            )
            first = False
        if i < len(sort) - 1:
            ret += "\\midrule\n"

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret
    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_untangling_approx(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Impact of full simplification on selected baseline heuristic solution times and objective function values. \\label{TBL:loom:untangling-approx}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{2pt}\n"

    ret += "    \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r r}\n"
    ret += "    & & \\multicolumn{5}{ c }{\\footnotesize Pruned graph} & & \\multicolumn{5}{ c }{\\footnotesize Fully simplified graph} \\\\\n"
    ret += "    \\cline{3-7} \\cline{9-13} \\\\[-2ex] \\toprule\\noalign{\\smallskip}\n"
    ret += "    & & $t$ & $\\times$ & $||$ & $\\theta$ & $\\eta$ & & $t$ & $\\times$ & $\\eta$ & $||$ & $\\theta$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")

        if dataset_id not in {"freiburg", "sydney", "nyc_subway"}:
            continue

        first = True
        for a in [("exhaustive-sep", "\\EXHst"), ("greedy-lookahead-sep", "\\GREEDYLAst"), ("hillc-sep", "+\\HILst"),
                  ("anneal-sep", "+\\ANNst"), ("hillc-random-sep", "\\HILst"), ("anneal-random-sep", "\\ANNst")]:
            ret += "%s  & {%s} & %s & %s & %s & %s & %s & & %s & %s & %s & %s & %s \\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                                                                                              a[1],
                                                                                              format_msecs(
                                                                                                  get(r, a[0], "pruned", "avg_solve_time")),
                                                                                              format_float(
                                                                                                  get(r, a[0], "pruned", "avg_num_crossings")),
                                                                                              format_float(
                                                                                                  get(r, a[0], "pruned", "avg_num_separations")),
                                                                                              format_float(
                                                                                                  get(r, a[0], "pruned", "avg_score")),
                                                                                              format_approxerr(optim, get(
                                                                                                  r, a[0], "pruned", "avg_score")),
                                                                                              format_msecs(
                                                                                                  get(r, a[0], "untangled", "avg_solve_time")),
                                                                                              format_float(
                                                                                                  get(r, a[0], "untangled", "avg_num_crossings")),
                                                                                              format_float(
                get(r, a[0], "untangled", "avg_num_separations")),
                format_float(get(r, a[0], "untangled", "avg_score")),
                format_approxerr(optim, get(r, a[0], "untangled", "avg_score"))
            )
            first = False

        ret += "\\midrule\n"

    methods_full_avg = [("greedy-lookahead-sep", "\\GREEDYLAst"), ("hillc-sep", "+\\HILst"),
                        ("anneal-sep", "+\\ANNst"), ("hillc-random-sep", "\\HILst"), ("anneal-random-sep", "\\ANNst")]

    avg_pruned = {k[0]: 0 for k in methods_full_avg}
    avg_untangled = {k[0]: 0 for k in methods_full_avg}

    for dataset_id in sort:
        r = results[dataset_id]

        for m in methods_full_avg:
            if "sep" in m[0]:
                optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")
            else:
                optim = get(r, "ilp-cbc", "untangled", "avg_score")

            if avg_untangled[m[0]] is None or get(r, m[0], "untangled", "avg_score") is None:
                avg_untangled[m[0]] = None
            else:
                avg_untangled[m[0]] += ((get(r, m[0], "untangled",
                                             "avg_score") - optim) / optim) / len(sort)

            if avg_pruned[m[0]] is None or get(r, m[0], "pruned", "avg_score") is None:
                avg_pruned[m[0]] = None
            else:
                avg_pruned[m[0]] += ((get(r, m[0], "pruned",
                                          "avg_score") - optim) / optim) / len(sort)

    first = True

    for a in methods_full_avg:
        if "sep" in a[0]:
            optim = get(r, "ilp-sep-cbc", "untangled", "avg_score")
        else:
            optim = get(r, "ilp-cbc", "untangled", "avg_score")

        ret += "%s  & {%s} & %s & %s & %s & %s & %s & & %s & %s & %s & %s & %s \\\\\n" % ("avg" if first else "",
                                                                                          a[1],
                                                                                          "",
                                                                                          "",
                                                                                          "",
                                                                                          "",
                                                                                          format_float(
                                                                                              avg_pruned[a[0]]),
                                                                                          "",
                                                                                          "",
                                                                                          "",
                                                                                          "",
                                                                                          format_float(
                                                                                              avg_untangled[a[0]])
                                                                                          )

        if a[0] == "anneal-random":
            ret += "\\cline{2-5}\n"
        first = False

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def main():
    if len(sys.argv) < 3:
        print("Generates .tex files for result tables\n")
        print("  Usage: " + sys.argv[0] + " <table> <dataset results paths>")
        print(
            "\n  where <table> is one of {overview, main-res-time, main-res-approx-error, approx-comp, ilp-comp, untangling-graph-size, untangling-ilp, untangling-approx, approx-comp-avg}")
        sys.exit(1)

    results = {}

    for d in sys.argv[2:]:
        results[os.path.basename(os.path.normpath(d))] = read_results(d)

    if sys.argv[1] == "overview":
        print(tbl_overview(results))

    if sys.argv[1] == "main-res-time":
        print(tbl_main_res_time(results))

    if sys.argv[1] == "main-res-approx-error":
        print(tbl_main_res_approx_error(results))

    if sys.argv[1] == "approx-comp":
        print(tbl_approx_comp(results))

    if sys.argv[1] == "ilp-comp":
        print(tbl_ilp_comp(results))

    if sys.argv[1] == "untangling-graph-size":
        print(tbl_untangling_graph_size(results))

    if sys.argv[1] == "untangling-ilp":
        print(tbl_untangling_ilp(results))

    if sys.argv[1] == "untangling-approx":
        print(tbl_untangling_approx(results))

    if sys.argv[1] == "approx-comp-avg":
        print(tbl_approx_comp_avg(results))


if __name__ == "__main__":
    main()
