#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This runs the automatic renewal of the certificates
# ==============================================================================
set -e

step ca renew --daemon -f \
--exec="/usr/bin/reload_certificates.sh" \
"/ssl/$(bashio::config 'certfile')" "/ssl/$(bashio::config 'keyfile')"
