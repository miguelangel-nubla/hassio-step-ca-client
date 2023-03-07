#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This sets up the root CA in the addon.
# ==============================================================================
#set -e

bashio::log.info "Setting up Root CA authority"

URL=$(bashio::config 'ca_url')
FINGERPRINT=$(bashio::config 'root_ca_fingerprint')

step ca bootstrap -f \
--ca-url="$URL" \
--fingerprint="$FINGERPRINT"

step ca roots -f "/ssl/$(bashio::config 'cafile')"
