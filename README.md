# loom eval

This is the evaluation script for LOOM. Each JSON file generated by LOOM contains some statistics. These statistics are used by this Makefile, and the script scripts/tables.py, to render the evaluation tables.

It also comes with a web app for inspection the maps. An instance of this web app is running at [https://loom.cs.uni-freiburg.de](https://loom.cs.uni-freiburg.de).

**IMPORTANT:** To evaluate the ILPs against the `gurobi` solver, a gurobi license file must be present on your system at the location specified in the environment variable `GRB_LICENSE_FILE`. If you use the Docker container (see below), the file must be placed at `/output/gurobi.lic`.

## Requirements

 * gurobi
 * CBC
 * glpk
 * pdflatex
 * LOOM

## How to use

The following targets are provided:

**`list`**: List all available networks in `./datasets`

**`help`**: Show this README.

**`check`**: Run some checks on the environment.

**`tables`**: Generate all tables in `./tables`

**`render`**: Render examples for web app

**`http`**: Start HTTP server for web app at http://localhost:8000/web

For additional targets, see the Makefile itself.

Log files are always written to the corresponding output directory and have the same name as the generated file, ending with `.log`.

## Run with Docker

Build the container:

    $ docker build -t loom-eval .

Run the evaluation:

    $ docker run loom-eval <TARGET>

where `<TARGET>` is the Makefile target (see above).

Evaluation results will be output to `/output` inside the container. To retrieve them, mount `/output` to a local folder:

    $ docker run -v /local/folder/:/output loom-eval <TARGET>
