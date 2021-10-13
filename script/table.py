#!/usr/bin/python3

import json
import sys
import os
import math

DATASET_LABELS={
        "freiburg" : "Freiburg (FR)",
        "dallas" : "Dallas (DA)",
        "chicago" : "Chicago (CG)",
        "sydney" : "Sydney (SD)",
        "stuttgart" : "Sydney (ST)",
        "turin" : "Turin (TU)",
        "nyc_subway" : "New York (NY)",
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

def tbl_overview(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption{TODO}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\setlength\\tabcolsep{3pt}\n"

    ret +="  \\begin{tabular*}{0.8\\textwidth}{@{\extracolsep{\\fill}} l r r r r r r r c} \\toprule\n       & $|{\cal S}|$ & $|V|$ & $|E|$ & $|{\cal L}|$ & $M$ & $D$ & $|\Omega|$ \\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(sort, key=lambda d : results[d]["greedy"]["raw"]["input_num_edges"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "    %s & %d & %d & %d & %d & %d & %d & %s\\\\\n" % (DATASET_LABELS[dataset_id], r["greedy"]["raw"]["input_num_stations"], r["greedy"]["raw"]["input_num_nodes"], r["greedy"]["raw"]["input_num_edges"], r["greedy"]["raw"]["input_num_lines"], r["greedy"]["raw"]["input_max_number_lines"], r["greedy"]["raw"]["input_max_deg"],  scinot(r["greedy"]["raw"]["input_solution_space_size"]))
    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def main():
    if len(sys.argv) < 2:
        print("Usage: " + sys.argv[0] + " <dataset results paths>")
        sys.exit(1)

    results = {}

    for d in sys.argv[1:]:
       results[os.path.basename(os.path.normpath(d))] = read_results(d)

    print(tbl_overview(results))

if __name__ == "__main__":
    main()
