#!/usr/bin/env bash
set -e

if [[ "$RUNNER_DEBUG" == "1" ]]; then
  set -x
fi
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR
tofu init

declare -a WORKSPACES=($(tofu workspace list | sed 's/*//' | grep -v "default"))
for WORKSPACE in ${WORKSPACES}; do
  echo ${WORKSPACE}
  tofu workspace select ${WORKSPACE}
  tofu state pull
  INPUTS=$(tofu output | sed -n 's/input_//p' | sed 's/ //g' | sed 's/^/-var /' | tr -d '"')
  tofu destroy -auto-approve ${INPUTS}
  tofu state list
  tofu workspace select default
  tofu workspace delete ${WORKSPACE}
done
