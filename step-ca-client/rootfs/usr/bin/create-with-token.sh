#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This runs the initial creation of the certificate from a one-time token
# ==============================================================================
set -e

bashio::log.warning "Previous certificate not valid for renewal, forcing creation of new one using token"

step ca certificate --kty=RSA -f \
--token="$(bashio::config 'token')" \
"$(bashio::config 'subjects' | head -1)" "/ssl/$(bashio::config 'certfile')" "/ssl/$(bashio::config 'keyfile')"

/usr/bin/reload_certificates.sh
