#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# ==============================================================================
set -e

function set_debug() {
    STEPDEBUG=0
    if ! [[ "${__BASHIO_LOG_LEVEL_DEBUG}" -gt "${__BASHIO_LOG_LEVEL}" ]]; then
        STEPDEBUG=1
    fi
    export STEPDEBUG
}
