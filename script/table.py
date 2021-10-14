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
            format_msecs(get(r, "ilp-baseline" , "raw", "avg_solve_time")),
            format_msecs(get(r, "ilp-baseline" , "untangled", "avg_solve_time")),
            format_msecs(get(r, "ilp" , "raw", "avg_solve_time")),
            format_msecs(get(r, "ilp" , "pruned", "avg_solve_time")),
            format_msecs(get(r, "ilp" , "untangled", "avg_solve_time"))
            )
  
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

if __name__ == "__main__":
    main()
