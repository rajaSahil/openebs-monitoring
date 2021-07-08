#!/usr/bin/env bash


set -e
set -x
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail


# Make sure to start with a clean 'dashboards_out and alerts' dir
rm -rf /dashboards_out alerts
mkdir -p dashboards_out alerts


jsonnet -J vendor -m dashboards_out lib/dashboards.jsonnet
jsonnet -J vendor -m alerts lib/rules.jsonnet
