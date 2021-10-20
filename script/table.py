#!/usr/bin/python3

import json
import sys
import os
import math

DATASET_LABELS={
    "freiburg" : "Freiburg",
    "dallas" : "Dallas",
    "chicago" : "Chicago",
    "sydney" : "Sydney",
    "stuttgart" : "Sydney",
    "turin" : "Turin",
    "nyc_subway" : "New York",
}

DATASET_LABELS_SHORT={
    "freiburg" : "FR",
    "dallas" : "DA",
    "chicago" : "CG",
    "sydney" : "SD",
    "stuttgart" : "ST",
    "turin" : "TU",
    "nyc_subway" : "NY",
}


def read_result(path):
    ret = {}
    with open(path) as f:
        full = json.load(f)
        ret = full["properties"]["statistics"]

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

            with open(file_path, 'rb') as f:
                if not comps[0] in ret:
                    ret[comps[0]] = {}
                ret[comps[0]][comps[1]] = read_result(file_path)

    return ret

def scinot(num):
    if num == None:
        return "---"
    magni = math.floor(math.log(num, 10))
    ret = "\\Hsci{"
    ret += "%.0f" % (num / (math.pow(10,magni)))
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
    if n == None:
        return "---"

    if n < 1000:
        return "%d" % n

    if n < 1000000:
        return "%.1f\Hk" % (n / 1000)

    if n < 1000000000:
        return "%.1f\HM" % (n / 1000000)

    return "%.1f\HB" % (n / 1000000000)

def format_float(n):
    if n == None:
        return "---"
    return "%.1f" % n

def format_secs(s):
    return format_msecs(s * 1000)

def format_msecs(ms):
    if ms == None:
        return "---"

    if ms < 0.1:
        return "$<1$\Hms" % ms

    if ms < 1:
        return "%.1f\Hms" % ms

    if ms < 100:
        return "%.0f\Hms" % ms

    if ms < 1000 * 60:
        return "%.1f\Hs" % (ms / 1000.0)

    if ms < 1000 * 60 * 60:
        return "%.0f\Hm" % (ms / (60 * 1000.0))

    return "%.0f\Hh" % (ms / (60 * 60 * 1000.0))

def format_approxerr(perfect, approx):
    if perfect == None or approx == None:
        return "---"

    return "%.1f" % ((approx - perfect) / perfect)


def tbl_overview(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Line graphs used in our experimental evaluation. Under $|{\cal S}|$ we give the number of station nodes in the graph. Under  $|V|$ we give the numer of nodes (including station nodes). Under $|E|$ we give the number of edges. Under $|{\cal L}|$ we give the number of lines. $M$ is the maximum number of lines per edge. $D$ is the maximum node degree. $|\Omega|$ is the line-ordering search space size on the original line graph. \label{TBL:datasets}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\setlength\\tabcolsep{3pt}\n"

    ret +="  \\begin{tabular*}{0.8\\textwidth}{@{\extracolsep{\\fill}} l r r r r r r r c} \\toprule\n       & $|{\cal S}|$ & $|V|$ & $|E|$ & $|{\cal L}|$ & $M$ & $D$ & $|\Omega|$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "    %s & %d & %d & %d & %d & %d & %d & %s\\\\\n" % (DATASET_LABELS[dataset_id] + " (" + DATASET_LABELS_SHORT[dataset_id] + ")", r["greedy"]["raw"]["input_num_stations"], r["greedy"]["raw"]["input_num_nodes"], r["greedy"]["raw"]["input_num_edges"], r["greedy"]["raw"]["input_num_lines"], r["greedy"]["raw"]["input_max_number_lines"], r["greedy"]["raw"]["input_max_deg"],  scinot(r["greedy"]["raw"]["input_solution_space_size"]))

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_main_res_time(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Main results for the running times of a selection of our methods on all test datasets. \TODO{how are they selected?} \label{TBL:main_results_time}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\setlength\\tabcolsep{5pt}\n"

    ret +="  \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r}\n"
    ret +="                   &   \\multicolumn{5}{c}{\\footnotesize heuristic}   & & \\multicolumn{5}{c}{\\footnotesize exact} \\\\\n"
    ret +="             \\cline{2-6} \\cline{8-12}  \\\\[-2ex] \\toprule\n"
    ret +="    \\method\\hspace{-7pt}   & \\GREEDYLAsf  & \\HILsf & \\HILsf  & \\HILsf  & \\ANNsf && \\bILPsf & \\bILPsf & \\iILPsf & \\iILPsf & \\iILPsf    \\\\[-1.5mm]\n"
    ret +="    \\graph\\hspace{-7pt}   & \\basic       & \\basic & \\pruned & \\untang & \\untang && \\basic & \\untang & \\basic   & \\pruned & \\untang    \\\\[0.7mm]\\cmidrule{2-12}\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "%s & %s  & %s &  %s &  %s  &  %s  &&  %s  &  %s  &  %s  &  %s &  %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
            format_msecs(get(r, "greedy-lookahead-sep" , "raw", "avg_solve_time")),
            format_msecs(get(r, "hillc-random-sep" , "raw", "avg_solve_time")),
            format_msecs(get(r, "hillc-random-sep" , "pruned", "avg_solve_time")),
            format_msecs(get(r, "hillc-random-sep" , "untangled", "avg_solve_time")),
            format_msecs(get(r, "anneal-random-sep" , "untangled", "avg_solve_time")),
            format_msecs(get(r, "ilp-gurobi-baseline" , "raw", "avg_solve_time")),
            format_msecs(get(r, "ilp-gurobi-baseline" , "untangled", "avg_solve_time")),
            format_msecs(get(r, "ilp-gurobi" , "raw", "avg_solve_time")),
            format_msecs(get(r, "ilp-gurobi" , "pruned", "avg_solve_time")),
            format_msecs(get(r, "ilp-gurobi" , "untangled", "avg_solve_time"))
            )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_main_res_approx_error(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Main results for the approximation errors of a selection of our heuristic methods on all test datasets. \TODO{how are they selected?} \label{TBL:main_results_approx}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\setlength\\tabcolsep{5pt}\n"

    ret +="  \\begin{tabular*}{1\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r r r r r r r r}\\toprule\n"
    ret +="    \\method\\hspace{-7pt} & \\GREEDYsf   & \\GREEDYLAsf & \\GREEDYLAsf  & \\HILGRsf & \\HILGRsf  & \\ANNGRsf  & \\ANNGRsf   & \\HILsf  & \\HILsf   & \\ANNsf & \\ANNsf  \\\\[-1.5mm]\n"
    ret +="    \\graph\\hspace{-7pt}   & \\basic & \\basic       & \\untang & \\basic & \\untang & \\basic & \\untang & \\basic & \\untang   & \\basic & \\untang    \\\\[0.7mm]\\cmidrule{2-12}\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        optim = get(r, "ilp-gurobi-sep" , "untangled", "avg_score")

        ret += "%s & %s  & %s &  %s &  %s  &  %s  &  %s  &  %s  &  %s  &  %s &  %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
            format_approxerr(optim, get(r, "greedy-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "greedy-lookahead-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "greedy-lookahead-sep" , "untangled", "avg_score")),
            format_approxerr(optim, get(r, "hillc-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "hillc-sep" , "untangled", "avg_score")),
            format_approxerr(optim, get(r, "anneal-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "anneal-sep" , "untangled", "avg_score")),
            format_approxerr(optim, get(r, "hillc-random-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "hillc-random-sep" , "untangled", "avg_score")),
            format_approxerr(optim, get(r, "anneal-random-sep" , "raw", "avg_score")),
            format_approxerr(optim, get(r, "anneal-random-sep" , "untangled", "avg_score"))
            )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def tbl_approx_comp(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{\TODO{caption} \label{TBL:approx_comp}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\footnotesize\setlength\\tabcolsep{5pt}\n"

    ret +="    \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l@{\\hskip 2mm} r@{\\hskip 3mm} r r r@{\\hskip 2.5mm} r r r r r@{\\hskip 1.5mm}r@{\\hskip 1mm}r r r r}\n"
    ret +="    && \\multicolumn{6}{c}{\\footnotesize On baseline graph} & & \\multicolumn{6}{c}{\\footnotesize On pruned \\& cut graph} \\\\\n"
    ret +="    \\cline{3-8} \\cline{10-15} \\\\[-2ex] \\toprule\n"
    ret +="    && $|\\Omega|$ & $t$ & iters & $\\times$ & $||$ & $\\theta$ & & $|\\Omega|$ & $t$ & iters & $\\times$ & $||$ & $\\theta$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        if dataset_id not in {"freiburg", "chicago", "nyc_subway"}:
            continue

        search_space = scinot(get(r, "greedy", "raw", "optgraph_solution_space_size"))

        first = True
        for a in [("exhaustive", "\\EXH"), ("greedy", "\\GREEDY"), ("greedy-lookahead", "\\GREEDYLA"), ("hillc", "+\\HIL"), ("ann", "+\\ANN"), ("hillc-random", "\\HIL"), ("ann-random", "\\ANN"),("exhaustive-sep", "\\EXHst"), ("greedy", "\\GREEDYst"), ("greedy-lookahead-sep", "\\GREEDYLAst"), ("hillc-sep", "+\\HILst"), ("ann-sep", "+\\ANNst"), ("hillc-random-sep", "\\HILst"), ("ann-random-sep", "\\ANNst")]:
            ret += "%s & %s  & %s &  %s &  %s  &  %s  &  %s  & %s  &&  %s  &  %s &  %s & %s  &  %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                a[1],
                search_space if a[0] in ["hillc", "hillc-sep"] else "",
                format_msecs(get(r,  a[0], "raw", "avg_solve_time")),
                format_float(get(r,  a[0], "raw", "avg_iterations")),
                format_float(get(r, a[0], "raw", "avg_num_crossings")),
                format_float(get(r, a[0], "raw", "avg_num_separations")),
                format_float(get(r, a[0], "raw", "avg_score")),
                scinot(get(r, a[0], "pruned", "optgraph_solution_space_size")),
                format_msecs(get(r, a[0], "pruned", "avg_solve_time")),
                format_float(get(r, a[0], "pruned", "avg_iterations")),
                format_float(get(r, a[0], "pruned", "avg_num_crossings")),
                format_float(get(r, a[0], "pruned", "avg_num_separations")),
                format_float(get(r, a[0], "pruned", "avg_score")),
            )
            if a[0] == "ann-random":
                ret += "\\cline{2-15}\n"
            first = False
        if i < len(sort) -1:
            ret += "\\midrule\n"

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_ilp_comp(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{\TODO{caption} \label{TBL:ilp_comp}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\footnotesize\setlength\\tabcolsep{2pt}\n"

    ret +="    \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l@{\\hskip 1.2mm} r r r r@{\\hskip 2.5mm} r r r r r@{\\hskip 1.5mm}r@{\\hskip 1mm}r r r}\n"
    ret +="    && \\multicolumn{4}{c}{\\footnotesize On baseline graph} & & \\multicolumn{4}{c}{\\footnotesize On pruned graph} \\\\\n"
    ret +="    \\cline{3-6} \\cline{8-11} \\\\[-2ex] \\toprule\n"
    ret +="    && \\Hdimh & \\Htglpk & \\Htcbc & \\Htgo &  & \\Hdimh & \\Htglpk & \\Htcbc & \\Htgo & $\\times$ & $||$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy-lookahead-sep"]["raw"]["input_num_edges"])

    for i, dataset_id in enumerate(sort):
        r = results[dataset_id]

        first = True
        for a in [("ilp-baseline", "\\bILP"), ("ilp-baseline-sep", "\\bILPst"), ("ilp", "\\iILP"), ("ilp-sep", "\\iILPst")]:
            ret += "%s  & {%s}   & \\Hdim{%s}{%s}  &  %s & %s & %s & &  \\Hdim{%s}{%s} & %s & %s & %s &  %s & %s \\\\\n" % (DATASET_LABELS_SHORT[dataset_id] if first else "",
                a[1],
                format_int(get(r,  a[0]+"-cbc", "raw", "max_num_rows_in_comp")),
                format_int(get(r,  a[0]+"-cbc", "raw", "max_num_cols_in_comp")),
                format_msecs(get(r,  a[0]+"-glpk", "raw", "avg_solve_time")),
                format_msecs(get(r,  a[0]+"-cbc", "raw", "avg_solve_time")),
                format_msecs(get(r,  a[0]+"-gurobi", "raw", "avg_solve_time")),
                format_int(get(r,  a[0]+"-cbc", "pruned", "max_num_rows_in_comp")),
                format_int(get(r,  a[0]+"-cbc", "pruned", "max_num_cols_in_comp")),
                format_msecs(get(r,  a[0]+"-glpk", "pruned", "avg_solve_time")),
                format_msecs(get(r,  a[0]+"-cbc", "pruned", "avg_solve_time")),
                format_msecs(get(r,  a[0]+"-gurobi", "pruned", "avg_solve_time")),
                format_int(get(r,  a[0]+"-cbc", "pruned", "avg_num_crossings")),
                format_int(get(r,  a[0]+"-cbc", "pruned", "avg_num_separations"))
            )
            first = False
        if i < len(sort) -1:
            ret += "\\midrule\n"

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def main():
    if len(sys.argv) < 3:
        print("Usage: " + sys.argv[0] + " <table> <dataset results paths>")
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

if __name__ == "__main__":
    main()
