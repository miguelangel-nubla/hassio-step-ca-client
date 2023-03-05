#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Add-on: step-ca-client
#
# step-ca-client add-on for Home Assistant.
# This sets up the root CA in the addon.
# ==============================================================================
set -e

bashio::log.info "Setting up Root CA authority"

step ca bootstrap -f \
--ca-url="$(bashio::config 'ca_url')" \
--fingerprint="$(bashio::config 'root_ca_fingerprint')"

step ca roots -f "/ssl/$(bashio::config 'cafile')"
