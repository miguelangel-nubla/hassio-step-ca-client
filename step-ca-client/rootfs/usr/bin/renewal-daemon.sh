#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This runs the automatic renewal of the certificates
# ==============================================================================
set -e

# shellcheck source=/dev/null
source /usr/bin/helpers.sh
set_debug

CERTFILE="/ssl/$(bashio::config 'certfile')"
KEYFILE="/ssl/$(bashio::config 'keyfile')"
#running following in subshell hides the command output until complete
if [[ ${STEPDEBUG} -eq 1 ]];then set -x; fi;
step ca renew \
    -f \
    --daemon \
    --exec="/usr/bin/reload-certificates.sh" \
    "${CERTFILE}" "${KEYFILE}"
