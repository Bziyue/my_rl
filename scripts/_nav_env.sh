#!/usr/bin/env bash

# Shared runtime environment for launching SRU navigation from this workspace.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISAACLAB_DIR="${ISAACLAB_DIR:-/home/zdp/CodeField/IsaacLab-2.3.2}"
ENV_NAME="${ENV_NAME:-${CONDA_DEFAULT_ENV:-env_isaacsim}}"

if [[ -n "${CONDA_ENV_DIR:-}" ]]; then
    CONDA_ENV_DIR="${CONDA_ENV_DIR}"
elif [[ -n "${CONDA_PREFIX:-}" ]]; then
    CONDA_ENV_DIR="${CONDA_PREFIX}"
else
    CONDA_ENV_DIR="/home/zdp/anaconda3/envs/${ENV_NAME}"
fi

if [[ -n "${ISAACSIM_DIR:-}" ]]; then
    ISAACSIM_DIR="${ISAACSIM_DIR}"
elif [[ -n "${ISAACSIM_PATH:-}" ]]; then
    ISAACSIM_DIR="${ISAACSIM_PATH}"
else
    ISAACSIM_DIR=""
fi

RUNTIME_CACHE_DIR="${RUNTIME_CACHE_DIR:-${ROOT_DIR}/.runtime-cache}"

check_nav_runtime_prereqs() {
    if [[ ! -x "${CONDA_ENV_DIR}/bin/python" ]]; then
        echo "Missing conda env python: ${CONDA_ENV_DIR}/bin/python" >&2
        return 1
    fi
}

setup_nav_runtime_env() {
    check_nav_runtime_prereqs

    mkdir -p "${RUNTIME_CACHE_DIR}/warp" "${RUNTIME_CACHE_DIR}/xdg"

    export CONDA_PREFIX="${CONDA_ENV_DIR}"
    export PATH="${CONDA_ENV_DIR}/bin:${PATH}"
    export PYTHONPATH="${ROOT_DIR}/sru-navigation-learning:${ROOT_DIR}/sru-navigation-sim${PYTHONPATH:+:${PYTHONPATH}}"
    export WARP_CACHE_DIR="${RUNTIME_CACHE_DIR}/warp"
    export XDG_CACHE_HOME="${RUNTIME_CACHE_DIR}/xdg"

    if [[ -n "${ISAACSIM_DIR}" && -f "${ISAACSIM_DIR}/setup_conda_env.sh" ]]; then
        set +u
        # shellcheck disable=SC1090
        source "${ISAACSIM_DIR}/setup_conda_env.sh"
        set -u
    fi

    # If Isaac Sim is installed outside the conda env, add omni.client explicitly.
    if [[ -n "${ISAACSIM_DIR}" && -d "${ISAACSIM_DIR}/kit/extscore/omni.client.lib" ]]; then
        export PYTHONPATH="${ISAACSIM_DIR}/kit/extscore/omni.client.lib${PYTHONPATH:+:${PYTHONPATH}}"
    fi
}
