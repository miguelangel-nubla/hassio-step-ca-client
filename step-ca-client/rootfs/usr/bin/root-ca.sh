#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This sets up the root CA in the addon.
# ==============================================================================
set -e

# shellcheck source=/dev/null
source /usr/bin/helpers.sh
set_debug

bashio::log.info "Setting up Root CA authority"

URL=$(bashio::config 'ca_url')
FINGERPRINT=$(bashio::config 'root_ca_fingerprint')
CAFILE="/ssl/$(bashio::config 'cafile')"

if [[ ${STEPDEBUG} -eq 1 ]];then set -x; fi;
step ca bootstrap \
    -f \
    --ca-url="$URL" \
    --fingerprint="$FINGERPRINT"

step ca roots -f "${CAFILE}"
