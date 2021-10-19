# (C) 2021 University of Freiburg
# Chair of Algorithms and Data Structures
# Authors: Patrick Brosi (brosi@cs.uni-freiburg.de)

LOOM = /home/patrick/repos/loom/build/loom
ILP_TIMEOUT = 43200 # timeout = 12 hours
ILP_CACHE_DIR = /tmp

GLOB_ARGS = --ilp-time-limit=$(ILP_TIMEOUT) --output-stats=1 --in-station-crossing-penalty-factor-same-seg=12 --in-station-crossing-penalty-factor-diff-seg=3 --diff-seg-cross-penalty-factor=1 --same-seg-cross-penalty-factor=4

GLOB_ARGS_NOSEP = --separation-penalty-factor=0 --in-station-separation-penalty-factor=0

GLOB_ARGS_SEP = --separation-penalty-factor=3 --in-station-separation-penalty-factor=9

GLOB_ARGS_RAW = --prune=0 --untangle=0

GLOB_ARGS_PRUNED = --prune=1 --untangle=0

GLOB_ARGS_UNTANGLED = --prune=0 --untangle=1

DATASETS = $(basename $(notdir $(wildcard datasets/*.json)))

EVAL_ILP_BASELINE := $(patsubst %, results/%/ilp-baseline/raw/res.json, $(DATASETS))
EVAL_ILP_BASELINE_SEP := $(patsubst %, results/%/ilp-baseline-sep/raw/res.json, $(DATASETS))
EVAL_ILP_BASELINE_PRUNED := $(patsubst %, results/%/ilp-baseline/pruned/res.json, $(DATASETS))
EVAL_ILP_BASELINE_SEP_PRUNED := $(patsubst %, results/%/ilp-baseline-sep/pruned/res.json, $(DATASETS))
EVAL_ILP_BASELINE_UNTANGLED := $(patsubst %, results/%/ilp-baseline/untangled/res.json, $(DATASETS))
EVAL_ILP_BASELINE_SEP_UNTANGLED := $(patsubst %, results/%/ilp-baseline-sep/untangled/res.json, $(DATASETS))

EVAL_ILP := $(patsubst %, results/%/ilp/raw/res.json, $(DATASETS))
EVAL_ILP_SEP := $(patsubst %, results/%/ilp-sep/raw/res.json, $(DATASETS))
EVAL_ILP_PRUNED := $(patsubst %, results/%/ilp-pruned/res.json, $(DATASETS))
EVAL_ILP_SEP_PRUNED := $(patsubst %, results/%/ilp-sep/pruned/res.json, $(DATASETS))
EVAL_ILP_UNTANGLED := $(patsubst %, results/%/ilp-untangled/res.json, $(DATASETS))
EVAL_ILP_SEP_UNTANGLED := $(patsubst %, results/%/ilp-sep/untangled/res.json, $(DATASETS))

EVAL_GREEDY := $(patsubst %, results/%/greedy/raw/res.json, $(DATASETS))
EVAL_GREEDY_SEP := $(patsubst %, results/%/greedy-sep/raw/res.json, $(DATASETS))
EVAL_GREEDY_PRUNED := $(patsubst %, results/%/greedy/pruned/res.json, $(DATASETS))
EVAL_GREEDY_SEP_PRUNED := $(patsubst %, results/%/greedy-sep/pruned/res.json, $(DATASETS))
EVAL_GREEDY_UNTANGLED := $(patsubst %, results/%/greedy/untangled/res.json, $(DATASETS))
EVAL_GREEDY_SEP_UNTANGLED := $(patsubst %, results/%/greedy-sep/untangled/res.json, $(DATASETS))

EVAL_GREEDY_LOOKAHEAD := $(patsubst %, results/%/greedy-lookahead/raw/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP := $(patsubst %, results/%/greedy-lookahead-sep/raw/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_PRUNED := $(patsubst %, results/%/greedy-lookahead/pruned/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP_PRUNED := $(patsubst %, results/%/greedy-lookahead-sep/pruned/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_UNTANGLED := $(patsubst %, results/%/greedy-lookahead/untangled/res.json, $(DATASETS))
EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED := $(patsubst %, results/%/greedy-lookahead-sep/untangled/res.json, $(DATASETS))

EVAL_HILLC := $(patsubst %, results/%/hillc/raw/res.json, $(DATASETS))
EVAL_HILLC_SEP := $(patsubst %, results/%/hillc-sep/raw/res.json, $(DATASETS))
EVAL_HILLC_PRUNED := $(patsubst %, results/%/hillc/pruned/res.json, $(DATASETS))
EVAL_HILLC_SEP_PRUNED := $(patsubst %, results/%/hillc-sep/pruned/res.json, $(DATASETS))
EVAL_HILLC_UNTANGLED := $(patsubst %, results/%/hillc/untangled/res.json, $(DATASETS))
EVAL_HILLC_SEP_UNTANGLED := $(patsubst %, results/%/hillc-sep/untangled/res.json, $(DATASETS))

EVAL_ANNEAL := $(patsubst %, results/%/anneal/raw/res.json, $(DATASETS))
EVAL_ANNEAL_SEP := $(patsubst %, results/%/anneal-sep/raw/res.json, $(DATASETS))
EVAL_ANNEAL_PRUNED := $(patsubst %, results/%/anneal/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_SEP_PRUNED := $(patsubst %, results/%/anneal-sep/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_UNTANGLED := $(patsubst %, results/%/anneal/untangled/res.json, $(DATASETS))
EVAL_ANNEAL_SEP_UNTANGLED := $(patsubst %, results/%/anneal-sep/untangled/res.json, $(DATASETS))

EVAL_HILLC_RANDOM := $(patsubst %, results/%/hillc-random/raw/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP := $(patsubst %, results/%/hillc-random-sep/raw/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_PRUNED := $(patsubst %, results/%/hillc-random/pruned/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP_PRUNED := $(patsubst %, results/%/hillc-random-sep/pruned/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_UNTANGLED := $(patsubst %, results/%/hillc-random/untangled/res.json, $(DATASETS))
EVAL_HILLC_RANDOM_SEP_UNTANGLED := $(patsubst %, results/%/hillc-random-sep/untangled/res.json, $(DATASETS))

EVAL_ANNEAL_RANDOM := $(patsubst %, results/%/anneal-random/raw/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP := $(patsubst %, results/%/anneal-random-sep/raw/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_PRUNED := $(patsubst %, results/%/anneal-random/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP_PRUNED := $(patsubst %, results/%/anneal-random-sep/pruned/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_UNTANGLED := $(patsubst %, results/%/anneal-random/untangled/res.json, $(DATASETS))
EVAL_ANNEAL_RANDOM_SEP_UNTANGLED := $(patsubst %, results/%/anneal-random-sep/untangled/res.json, $(DATASETS))

.PHONY: TODO

.SECONDARY:

#### BASELINE ILP

### on raw graph
results/%/ilp-baseline/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/ilp-baseline-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/ilp-baseline/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/ilp-baseline-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/ilp-baseline/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/ilp-baseline-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for baseline ILP with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=ilp-naive < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### IMPROVED ILP

### on raw graph
results/%/ilp/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/ilp-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_SEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/ilp-pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/ilp-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/ilp-untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/ilp-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for impr. ILP with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=ilp < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### GREEDY

### on raw graph
results/%/greedy/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/greedy-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/greedy/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/greedy-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/greedy/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/greedy-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for Greedy with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________


#### GREEDY+LOOKAHEAD

### on raw graph
results/%/greedy-lookahead/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/greedy-lookahead-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/greedy-lookahead/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/greedy-lookahead-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/greedy-lookahead/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/greedy-lookahead-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for greedy-lookahead with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=greedy-lookahead < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### HILLC WITH RANDOM INIT

### on raw graph
results/%/hillc-random/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/hillc-random-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/hillc-random/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/hillc-random-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/hillc-random/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/hillc-random-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc-random with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### SIMULATED ANNEALING WITH RANDOM INIT

### on raw graph
results/%/anneal-random/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/anneal-random-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/anneal-random/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/anneal-random-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/anneal-random/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/anneal-random-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal-random with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal-random < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### SIMULATED ANNEALING WITH GREEDY LOOKAHEAD

### on raw graph
results/%/anneal/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/anneal-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/anneal/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/anneal-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/anneal/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/anneal-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for anneal with greedy LA with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=anneal < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

# _____________________________________________________________________________

#### HILLC+GREEDYLA

### on raw graph
results/%/hillc/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_RAW) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

results/%/hillc-sep/raw/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on raw graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS) $(GLOB_ARGS_SEP) $(GLOB_ARGS_RAW) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on pruned graph
results/%/hillc/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/hillc-sep/pruned/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on pruned graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_PRUNED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"

### on untangled graph
results/%/hillc/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA w/o separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED)  $(GLOB_ARGS) $(GLOB_ARGS_NOSEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

	@printf "[%s] Done.\n" "$$(date -Is)"


results/%/hillc-sep/untangled/res.json: datasets/%.json
	@printf "[%s] Calculating results for hillc with greedy LA with separation penality on untangled graph for $< ... \n" "$$(date -Is)"
	@mkdir -p $(dir $@) # create directory
	@$(LOOM) $(GLOB_ARGS_UNTANGLED) $(GLOB_ARGS) $(GLOB_ARGS_SEP) --optim-method=hillc < $< > $@ 2> $(basename $@).log || (rm $@ && printf "[%s] An error occured, see the log for details.\n" "$$(date -Is)")

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

tables/tbl-dataset-overview.tex: $(EVAL_GREEDY)
	@mkdir -p tables
	@python3 script/table.py overview $(patsubst %, results/%, $(DATASETS)) > $@

tables/tbl-dataset-overview.pdf: tables/tbl-dataset-overview.tex
	@cat script/template.tex > tables/tmp
	@cat $^ >> tables/tmp
	@echo "\\\end{document}" >> tables/tmp
	@pdflatex -output-directory=tables -jobname=tbl-dataset-overview tables/tmp > /dev/null
	@rm tables/tmp

tables/tbl-main-res-time.tex: $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP)
	@mkdir -p tables
	@python3 script/table.py main-res-time $(patsubst %, results/%, $(DATASETS)) > $@

tables/tbl-main-res-time.pdf: tables/tbl-main-res-time.tex
	@cat script/template.tex > tables/tmp
	@cat $^ >> tables/tmp
	@echo "\\\end{document}" >> tables/tmp
	@pdflatex -output-directory=tables -jobname=tbl-main-res-time tables/tmp
	@rm tables/tmp

tables/tbl-main-res-approx-error.tex: $(EVAL_ILP_SEP_UNTANGLED) $(EVAL_GREEDY_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP) $(EVAL_GREEDY_LOOKAHEAD_SEP_UNTANGLED) $(EVAL_HILLC_SEP_UNTANGLED) $(EVAL_ANNEAL_SEP_UNTANGLED) $(EVAL_HILLC_SEP) $(EVAL_ANNEAL_SEP) $(EVAL_HILLC_RANDOM_SEP_UNTANGLED) $(EVAL_ANNEAL_RANDOM_SEP_UNTANGLED) $(EVAL_HILLC_RANDOM_SEP) $(EVAL_ANNEAL_RANDOM_SEP)
	@mkdir -p tables
	@python3 script/table.py main-res-approx-error $(patsubst %, results/%, $(DATASETS)) > $@

tables/tbl-main-res-approx-error.pdf: tables/tbl-main-res-approx-error.tex
	@cat script/template.tex > tables/tmp
	@cat $^ >> tables/tmp
	@echo "\\\end{document}" >> tables/tmp
	@pdflatex -output-directory=tables -jobname=tbl-main-res-approx-error tables/tmp
	@rm tables/tmp


help:
	cat README.md

clean:
	rm -rf results
	rm -rf tables
