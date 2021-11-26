# (C) 2021 University of Freiburg
# Chair of Algorithms and Data Structures
# Authors: Patrick Brosi (brosi@cs.uni-freiburg.de)

LOOM := loom

RESULTS_DIR := results
TABLES_DIR := tables

OVERALL_TIMEOUT := 21600 # = 6 hours, timeout after which we abort and do not write a solution, in seconds

ILP_TIMEOUT := $(OVERALL_TIMEOUT)
ILP_CACHE_DIR := /tmp

GLOB_ARGS = --ilp-time-limit=$(ILP_TIMEOUT) --output-stats=1 --in-station-crossing-penalty-factor-same-seg=12 --in-station-crossing-penalty-factor-diff-seg=3 --diff-seg-cross-penalty-factor=1 --same-seg-cross-penalty-factor=4

GLOB_ARGS_NOSEP = --separation-penalty-factor=0 --in-station-separation-penalty-factor=0

GLOB_ARGS_SEP = --separation-penalty-factor=3 --in-station-separation-penalty-factor=9

GLOB_ARGS_RAW = --prune=0 --untangle=0

GLOB_ARGS_PRUNED = --prune=1 --untangle=0

GLOB_ARGS_UNTANGLED = --prune=0 --untangle=1

DATASETS := $(basename $(notdir $(wildcard datasets/*.json)))

EVAL_EXH := $(patsubst %, $(RESULTS_DIR)/%/exhaustive/raw/res.json, $(DATASETS))
EVAL_EXH_SEP := $(patsubst %, $(RESULTS_DIR)/%/exhaustive-sep/raw/res.json, $(DATASETS))
EVAL_EXH_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/exhaustive/pruned/res.json, $(DATASETS))
EVAL_EXH_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/exhaustive-sep/pruned/res.json, $(DATASETS))
EVAL_EXH_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/exhaustive/untangled/res.json, $(DATASETS))
EVAL_EXH_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/exhaustive-sep/untangled/res.json, $(DATASETS))

EVAL_ILP_GLPK_BASELINE := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-glpk/raw/res.json, $(DATASETS))
EVAL_ILP_GLPK_BASELINE_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-glpk/raw/res.json, $(DATASETS))
EVAL_ILP_GLPK_BASELINE_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-glpk/pruned/res.json, $(DATASETS))
EVAL_ILP_GLPK_BASELINE_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-glpk/pruned/res.json, $(DATASETS))
EVAL_ILP_GLPK_BASELINE_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-glpk/untangled/res.json, $(DATASETS))
EVAL_ILP_GLPK_BASELINE_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-glpk/untangled/res.json, $(DATASETS))

EVAL_ILP_GLPK := $(patsubst %, $(RESULTS_DIR)/%/ilp-glpk/raw/res.json, $(DATASETS))
EVAL_ILP_GLPK_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-glpk/raw/res.json, $(DATASETS))
EVAL_ILP_GLPK_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-glpk/pruned/res.json, $(DATASETS))
EVAL_ILP_GLPK_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-glpk/pruned/res.json, $(DATASETS))
EVAL_ILP_GLPK_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-glpk/untangled/res.json, $(DATASETS))
EVAL_ILP_GLPK_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-glpk/untangled/res.json, $(DATASETS))

EVAL_ILP_CBC_BASELINE := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-cbc/raw/res.json, $(DATASETS))
EVAL_ILP_CBC_BASELINE_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-cbc/raw/res.json, $(DATASETS))
EVAL_ILP_CBC_BASELINE_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-cbc/pruned/res.json, $(DATASETS))
EVAL_ILP_CBC_BASELINE_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-cbc/pruned/res.json, $(DATASETS))
EVAL_ILP_CBC_BASELINE_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-cbc/untangled/res.json, $(DATASETS))
EVAL_ILP_CBC_BASELINE_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-cbc/untangled/res.json, $(DATASETS))

EVAL_ILP_CBC := $(patsubst %, $(RESULTS_DIR)/%/ilp-cbc/raw/res.json, $(DATASETS))
EVAL_ILP_CBC_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-cbc/raw/res.json, $(DATASETS))
EVAL_ILP_CBC_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-cbc/pruned/res.json, $(DATASETS))
EVAL_ILP_CBC_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-cbc/pruned/res.json, $(DATASETS))
EVAL_ILP_CBC_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-cbc/untangled/res.json, $(DATASETS))
EVAL_ILP_CBC_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-cbc/untangled/res.json, $(DATASETS))

EVAL_ILP_GUROBI_BASELINE := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-gurobi/raw/res.json, $(DATASETS))
EVAL_ILP_GUROBI_BASELINE_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/raw/res.json, $(DATASETS))
EVAL_ILP_GUROBI_BASELINE_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-gurobi/pruned/res.json, $(DATASETS))
EVAL_ILP_GUROBI_BASELINE_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/pruned/res.json, $(DATASETS))
EVAL_ILP_GUROBI_BASELINE_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-gurobi/untangled/res.json, $(DATASETS))
EVAL_ILP_GUROBI_BASELINE_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/untangled/res.json, $(DATASETS))

EVAL_ILP_GUROBI := $(patsubst %, $(RESULTS_DIR)/%/ilp-gurobi/raw/res.json, $(DATASETS))
EVAL_ILP_GUROBI_SEP := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-gurobi/raw/res.json, $(DATASETS))
EVAL_ILP_GUROBI_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-gurobi/pruned/res.json, $(DATASETS))
EVAL_ILP_GUROBI_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-gurobi/pruned/res.json, $(DATASETS))
EVAL_ILP_GUROBI_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-gurobi/untangled/res.json, $(DATASETS))
EVAL_ILP_GUROBI_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/ilp-sep-gurobi/untangled/res.json, $(DATASETS))

EVAL_ILP_BASELINE := $(EVAL_ILP_GLPK_BASELINE) $(EVAL_ILP_CBC_BASELINE) $(EVAL_ILP_GUROBI_BASELINE)
EVAL_ILP_BASELINE_SEP := $(EVAL_ILP_GLPK_BASELINE_SEP) $(EVAL_ILP_CBC_BASELINE_SEP) $(EVAL_ILP_GUROBI_BASELINE_SEP)
EVAL_ILP_BASELINE_PRUNED := $(EVAL_ILP_GLPK_BASELINE_PRUNED) $(EVAL_ILP_CBC_BASELINE_PRUNED) $(EVAL_ILP_GUROBI_BASELINE_PRUNED)
EVAL_ILP_BASELINE_SEP_PRUNED := $(EVAL_ILP_GLPK_BASELINE_SEP_PRUNED) $(EVAL_ILP_CBC_BASELINE_SEP_PRUNED) $(EVAL_ILP_GUROBI_BASELINE_SEP_PRUNED)
EVAL_ILP_BASELINE_UNTANGLED := $(EVAL_ILP_GLPK_BASELINE_UNTANGLED) $(EVAL_ILP_CBC_BASELINE_UNTANGLED) $(EVAL_ILP_GUROBI_BASELINE_UNTANGLED)
EVAL_ILP_BASELINE_SEP_UNTANGLED := $(EVAL_ILP_GLPK_BASELINE_SEP_UNTANGLED) $(EVAL_ILP_CBC_BASELINE_SEP_UNTANGLED) $(EVAL_ILP_GUROBI_BASELINE_SEP_UNTANGLED)

EVAL_ILP := $(EVAL_ILP_GLPK) $(EVAL_ILP_CBC) $(EVAL_ILP_GUROBI)
EVAL_ILP_SEP := $(EVAL_ILP_GLPK_SEP) $(EVAL_ILP_CBC_SEP) $(EVAL_ILP_GUROBI_SEP)
EVAL_ILP_PRUNED := $(EVAL_ILP_GLPK_PRUNED) $(EVAL_ILP_CBC_PRUNED) $(EVAL_ILP_GUROBI_PRUNED)
EVAL_ILP_SEP_PRUNED := $(EVAL_ILP_GLPK_SEP_PRUNED) $(EVAL_ILP_CBC_SEP_PRUNED) $(EVAL_ILP_GUROBI_SEP_PRUNED)
EVAL_ILP_UNTANGLED := $(EVAL_ILP_GLPK_UNTANGLED) $(EVAL_ILP_CBC_UNTANGLED) $(EVAL_ILP_GUROBI_UNTANGLED)
EVAL_ILP_SEP_UNTANGLED := $(EVAL_ILP_GLPK_SEP_UNTANGLED) $(EVAL_ILP_CBC_SEP_UNTANGLED) $(EVAL_ILP_GUROBI_SEP_UNTANGLED)

EVAL_GREEDY := $(patsubst %, $(RESULTS_DIR)/%/greedy/raw/res.json, $(DATASETS))
EVAL_GREEDY_SEP := $(patsubst %, $(RESULTS_DIR)/%/greedy-sep/raw/res.json, $(DATASETS))
EVAL_GREEDY_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/greedy/pruned/res.json, $(DATASETS))
EVAL_GREEDY_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/greedy-sep/pruned/res.json, $(DATASETS))
EVAL_GREEDY_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/greedy/untangled/res.json, $(DATASETS))
EVAL_GREEDY_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/greedy-sep/untangled/res.json, $(DATASETS))

EVAL_GREEDY_LOOKAHEAD := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead/raw/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead-sep/raw/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead/pruned/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead-sep/pruned/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead/untangled/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/greedy-lookahead-sep/untangled/res.json, $(DATASETS))

EVAL_HILLC := $(patsubst %, $(RESULTS_DIR)/%/hillc/raw/res.json, $(DATASETS))
EVAL_HILLC_SEP := $(patsubst %, $(RESULTS_DIR)/%/hillc-sep/raw/res.json, $(DATASETS))
EVAL_HILLC_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/hillc/pruned/res.json, $(DATASETS))
EVAL_HILLC_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/hillc-sep/pruned/res.json, $(DATASETS))
EVAL_HILLC_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/hillc/untangled/res.json, $(DATASETS))
EVAL_HILLC_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/hillc-sep/untangled/res.json, $(DATASETS))

EVAL_ANNEAL := $(patsubst %, $(RESULTS_DIR)/%/anneal/raw/res.json, $(DATASETS))
EVAL_ANNEAL_SEP := $(patsubst %, $(RESULTS_DIR)/%/anneal-sep/raw/res.json, $(DATASETS))
EVAL_ANNEAL_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/anneal/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/anneal-sep/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/anneal/untangled/res.json, $(DATASETS))
EVAL_ANNEAL_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/anneal-sep/untangled/res.json, $(DATASETS))

EVAL_HILLC_RANDOM := $(patsubst %, $(RESULTS_DIR)/%/hillc-random/raw/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP := $(patsubst %, $(RESULTS_DIR)/%/hillc-random-sep/raw/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/hillc-random/pruned/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/hillc-random-sep/pruned/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/hillc-random/untangled/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/hillc-random-sep/untangled/res.json, $(DATASETS))

EVAL_ANNEAL_RANDOM := $(patsubst %, $(RESULTS_DIR)/%/anneal-random/raw/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP := $(patsubst %, $(RESULTS_DIR)/%/anneal-random-sep/raw/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/anneal-random/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP_PRUNED := $(patsubst %, $(RESULTS_DIR)/%/anneal-random-sep/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/anneal-random/untangled/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP_UNTANGLED := $(patsubst %, $(RESULTS_DIR)/%/anneal-random-sep/untangled/res.json, $(DATASETS))

.PHONY: tables ilp-baseline ilp greedy greedy-lookahead hillc anneal hillc-random anneal-random help clean

.SECONDARY:

tables: $(TABLES_DIR)/tbl-approx-comp-avg.pdf $(TABLES_DIR)/tbl-untangling-approx.pdf $(TABLES_DIR)/tbl-untangling-ilp.pdf $(TABLES_DIR)/tbl-untangling-graph-size.pdf $(TABLES_DIR)/tbl-ilp-comp.pdf $(TABLES_DIR)/tbl-approx-comp.pdf $(TABLES_DIR)/tbl-main-res-approx-error.pdf $(TABLES_DIR)/tbl-main-res-time.pdf $(TABLES_DIR)/tbl-dataset-overview.pdf

#### BASELINE ILP

### on raw graph
$(RESULTS_DIR)/%/ilp-baseline-glpk/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-baseline-sep-glpk/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-baseline-glpk/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-glpk/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-baseline-glpk/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-glpk/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using GLPK with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

######

### on raw graph
$(RESULTS_DIR)/%/ilp-baseline-cbc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-baseline-sep-cbc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-baseline-cbc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-cbc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-baseline-cbc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-cbc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using CBC with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

######

### on raw graph
$(RESULTS_DIR)/%/ilp-baseline-gurobi/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-baseline-gurobi/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-baseline-gurobi/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-baseline-sep-gurobi/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP using gurobi with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### IMPROVED ILP

### on raw graph
$(RESULTS_DIR)/%/ilp-glpk/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-sep-glpk/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-glpk/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-glpk/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-glpk/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-glpk/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using GLPK with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=glpk! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

###

#### IMPROVED ILP

### on raw graph
$(RESULTS_DIR)/%/ilp-cbc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-sep-cbc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-cbc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-cbc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-cbc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-cbc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using CBC with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=cbc! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

#### IMPROVED ILP

### on raw graph
$(RESULTS_DIR)/%/ilp-gurobi/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/ilp-sep-gurobi/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/ilp-gurobi/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-gurobi/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/ilp-gurobi/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/ilp-sep-gurobi/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP using gurobi with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --ilp-solver=gurobi! --optim-method=ilp < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### EXHAUSTIVE

### on raw graph
$(RESULTS_DIR)/%/exhaustive/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/exhaustive-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/exhaustive/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/exhaustive-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/exhaustive/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/exhaustive-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for exhaustive with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=exhaust < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### GREEDY

### on raw graph
$(RESULTS_DIR)/%/greedy/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/greedy-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/greedy/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/greedy-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/greedy/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/greedy-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### GREEDY+LOOKAHEAD

### on raw graph
$(RESULTS_DIR)/%/greedy-lookahead/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/greedy-lookahead-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/greedy-lookahead/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/greedy-lookahead-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/greedy-lookahead/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/greedy-lookahead-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### HILLC WITH RANDOM INIT

### on raw graph
$(RESULTS_DIR)/%/hillc-random/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/hillc-random-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/hillc-random/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/hillc-random-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/hillc-random/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/hillc-random-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc-random  --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### SIMULATED ANNEALING WITH RANDOM INIT

### on raw graph
$(RESULTS_DIR)/%/anneal-random/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/anneal-random-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/anneal-random/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/anneal-random-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/anneal-random/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/anneal-random-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal-random --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### SIMULATED ANNEALING WITH GREEDY LOOKAHEAD

### on raw graph
$(RESULTS_DIR)/%/anneal/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/anneal-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/anneal/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/anneal-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/anneal/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/anneal-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal --optim-runs=10 < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### HILLC+GREEDYLA

### on raw graph
$(RESULTS_DIR)/%/hillc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

$(RESULTS_DIR)/%/hillc-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
$(RESULTS_DIR)/%/hillc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/hillc-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
$(RESULTS_DIR)/%/hillc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


$(RESULTS_DIR)/%/hillc-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@(timeout $(OVERALL_TIMEOUT) $(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log) || (echo "[]" > $@ && printf "[%s] An error or timeout occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


# targets

ilp-baseline: $(EVAL_ILP_BASELINE) $(EVAL_ILP_BASELINE_SEP) $(EVAL_ILP_BASELINE_PRUNED) $(EVAL_ILP_BASELINE_SEP_PRUNED) $(EVAL_ILP_BASELINE_UNTANGLED) $(EVAL_ILP_BASELINE_SEP_UNTANGLED)

ilp: $(EVAL_ILP) $(EVAL_ILP_SEP) $(EVAL_ILP_PRUNED) $(EVAL_ILP_SEP_PRUNED) $(EVAL_ILP_UNTANGLED) $(EVAL_ILP_SEP_UNTANGLED)

greedy: $(EVAL_GREEDY) $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_PRUNED) $(EVAL_GREEDY_SEP_PRUNED) $(EVAL_GREEDY_UNTANGLED) $(EVAL_GREEDY_SEP_UNTANGLED)

greedy-lookahead: $(EVAL_GREEDY_LOOKAHEAD) $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_GREEDY_LOOKAHEAD_PRUNED) $(EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED) $(EVAL_GREEDY_LOOKAHEAD_UNTANGLED) $(EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED)

hillc: $(EVAL_HILLC) $(EVAL_HILLC_SEP) $(EVAL_HILLC_PRUNED) $(EVAL_HILLC_SEP_PRUNED) $(EVAL_HILLC_UNTANGLED) $(EVAL_HILLC_SEP_UNTANGLED)

anneal: $(EVAL_ANNEAL) $(EVAL_ANNEAL_SEP) $(EVAL_ANNEAL_PRUNED) $(EVAL_ANNEAL_SEP_PRUNED) $(EVAL_ANNEAL_UNTANGLED) $(EVAL_ANNEAL_SEP_UNTANGLED)

hillc-random: $(EVAL_HILLC_RANDOM) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_HILLC_RANDOM_PRUNED) $(EVAL_HILLC_RANDOM_SEP_PRUNED) $(EVAL_HILLC_RANDOM_UNTANGLED) $(EVAL_HILLC_RANDOM_SEP_UNTANGLED)

anneal-random: $(EVAL_ANNEAL_RANDOM) $(EVAL_ANNEAL_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_PRUNED) $(EVAL_ANNEAL_RANDOM_SEP_PRUNED) $(EVAL_ANNEAL_RANDOM_UNTANGLED) $(EVAL_ANNEAL_RANDOM_SEP_UNTANGLED)

$(TABLES_DIR)/tbl-dataset-overview.tex: script/table.py script/template.tex $(EVAL_GREEDY)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py overview $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-dataset-overview.pdf: $(TABLES_DIR)/tbl-dataset-overview.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-dataset-overview $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-main-res-time.tex: script/table.py script/template.tex $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py main-res-time $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-main-res-time.pdf: $(TABLES_DIR)/tbl-main-res-time.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-main-res-time $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-main-res-approx-error.tex: script/table.py script/template.tex $(EVAL_ILP_CBC_SEP_UNTANGLED) $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED) $(EVAL_HILLC_SEP_UNTANGLED) $(EVAL_ANNEAL_SEP_UNTANGLED) $(EVAL_HILLC_SEP) $(EVAL_ANNEAL_SEP) $(EVAL_HILLC_RANDOM_SEP_UNTANGLED) $(EVAL_ANNEAL_RANDOM_SEP_UNTANGLED) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py main-res-approx-error $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-main-res-approx-error.pdf: $(TABLES_DIR)/tbl-main-res-approx-error.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-main-res-approx-error $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-approx-comp.tex: script/table.py script/template.tex $(EVAL_EXH) $(EVAL_EXH_SEP) $(EVAL_EXH_PRUNED) $(EVAL_EXH_SEP_PRUNED) $(EVAL_ILP_CBC_SEP_UNTANGLED) $(EVAL_ILP_CBC_UNTANGLED)  $(EVAL_GREEDY) $(EVAL_GREEDY_PRUNED) $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_LOOKAHEAD) $(EVAL_GREEDY_LOOKAHEAD_PRUNED) $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED) $(EVAL_HILLC_SEP) $(EVAL_ANNEAL_SEP) $(EVAL_ANNEAL_SEP_PRUNED) $(EVAL_HILLC_RANDOM_SEP_PRUNED) $(EVAL_ANNEAL_RANDOM_SEP_PRUNED) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP) $(EVAL_ANNEAL) $(EVAL_ANNEAL_PRUNED) $(EVAL_HILLC_RANDOM_PRUNED) $(EVAL_ANNEAL_RANDOM_PRUNED) $(EVAL_HILLC_RANDOM) $(EVAL_ANNEAL_RANDOM) $(EVAL_HILLC_SEP_PRUNED) $(EVAL_HILLC) $(EVAL_HILLC_PRUNED)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py approx-comp $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-approx-comp.pdf: $(TABLES_DIR)/tbl-approx-comp.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-approx-comp $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-ilp-comp.tex: script/table.py script/template.tex $(EVAL_ILP_SEP_PRUNED) $(EVAL_ILP_BASELINE_SEP_PRUNED) $(EVAL_ILP_BASELINE) $(EVAL_ILP_BASELINE_SEP) $(EVAL_ILP_BASELINE_PRUNED) $(EVAL_ILP_BASELINE_SEP_PRUNED) $(EVAL_ILP) $(EVAL_ILP_SEP) $(EVAL_ILP_PRUNED)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py ilp-comp $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-ilp-comp.pdf: $(TABLES_DIR)/tbl-ilp-comp.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-ilp-comp $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-untangling-graph-size.tex: script/table.py script/template.tex $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_SEP_PRUNED) $(EVAL_GREEDY_SEP_UNTANGLED)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py untangling-graph-size $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-untangling-graph-size.pdf: $(TABLES_DIR)/tbl-untangling-graph-size.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-untangling-graph-size $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-untangling-ilp.tex: script/table.py script/template.tex $(EVAL_ILP_SEP_PRUNED) $(EVAL_ILP_SEP_UNTANGLED) $(EVAL_ILP_PRUNED) $(EVAL_ILP_UNTANGLED)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py untangling-ilp $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-untangling-ilp.pdf: $(TABLES_DIR)/tbl-untangling-ilp.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-untangling-ilp $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-untangling-approx.tex: script/table.py script/template.tex $(EVAL_EXH_PRUNED) $(EVAL_EXH_SEP_PRUNED) $(EVAL_EXH_UNTANGLED) $(EVAL_EXH_SEP_UNTANGLED) $(EVAL_ILP_CBC_SEP_UNTANGLED) $(EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED) $(EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED) $(EVAL_HILLC_SEP_PRUNED) $(EVAL_HILLC_SEP_UNTANGLED) $(EVAL_ANNEAL_SEP_PRUNED) $(EVAL_ANNEAL_SEP_UNTANGLED) $(EVAL_HILLC_RANDOM_SEP_PRUNED) $(EVAL_HILLC_RANDOM_SEP_UNTANGLED) $(EVAL_ANNEAL_RANDOM_SEP_PRUNED) $(EVAL_ANNEAL_RANDOM_SEP_UNTANGLED)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py untangling-approx $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-untangling-approx.pdf: $(TABLES_DIR)/tbl-untangling-approx.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-untangling-approx $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-approx-comp-avg.tex: script/table.py script/template.tex $(EVAL_ILP_CBC_SEP_UNTANGLED) $(EVAL_ILP_CBC_UNTANGLED)  $(EVAL_GREEDY) $(EVAL_GREEDY_PRUNED) $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_SEP_PRUNED) $(EVAL_GREEDY_LOOKAHEAD) $(EVAL_GREEDY_LOOKAHEAD_PRUNED) $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED) $(EVAL_HILLC) $(EVAL_HILLC_PRUNED) $(EVAL_HILLC_RANDOM_PRUNED) $(EVAL_HILLC_SEP) $(EVAL_HILLC_SEP_PRUNED) $(EVAL_ANNEAL)  $(EVAL_ANNEAL_SEP) $(EVAL_ANNEAL_SEP_PRUNED) $(EVAL_HILLC_RANDOM_SEP_PRUNED) $(EVAL_ANNEAL_RANDOM_SEP_PRUNED) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP) $(EVAL_ANNEAL) $(EVAL_ANNEAL_PRUNED) $(EVAL_HILLC_RANDOM_PRUNED) $(EVAL_ANNEAL_RANDOM_PRUNED) $(EVAL_HILLC_RANDOM) $(EVAL_ANNEAL_RANDOM)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py approx-comp-avg $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-approx-comp-avg.pdf: $(TABLES_DIR)/tbl-approx-comp-avg.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-approx-comp-avg $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

help:
	cat README.md

check:
	@echo "glpk version:  " `glpsol --version | head -n1 | cut -d'v' -f3`
	@echo "CBC version:   " `echo "x" | cbc | head -n2 | tail -n1 | cut -d' ' -f2`
	@echo "gurobi version:" `gurobi_cl --version | head -n1 | cut -dv -f3 | cut -d' ' -f1`
	@echo "gurobi license:"
	@gurobi_cl --license
	@echo "loom version:" `$(LOOM) --version`
	@echo "results dir:" $(RESULTS_DIR)
	@echo "timeout:" $(OVERALL_TIMEOUT)s
	@echo "ILP cache dir:" $(ILP_CACHE_DIR)

clean:
	rm -rf $(RESULTS_DIR)
	rm -rf $(TABLES_DIR)
