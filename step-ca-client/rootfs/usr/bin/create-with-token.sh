#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This runs the initial creation of the certificate from a one-time token
# ==============================================================================
set -e

# shellcheck source=/dev/null
source /usr/bin/helpers.sh
set_debug

bashio::log.warning "Previous certificate not valid for renewal, forcing creation of new one using token"

KEYTYPE="$(bashio::config 'key_type')"
TOKEN="$(bashio::config 'token')"
MAINSUBJECT="$(bashio::config 'subjects' | head -1)"
CERTFILE="/ssl/$(bashio::config 'certfile')"
KEYFILE="/ssl/$(bashio::config 'keyfile')"

if [[ ${STEPDEBUG} -eq 1 ]];then set -x; fi;
step ca certificate \
    -f \
    --kty="${KEYTYPE}" \
    --token="${TOKEN}" \
    "${MAINSUBJECT}" "${CERTFILE}" "${KEYFILE}"
set +x

/usr/bin/reload-certificates.sh
