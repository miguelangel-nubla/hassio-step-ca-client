# Home Assistant Add-on: step-ca-client

This is an [step-ca][step-ca] client add-on for Home Assistant.

It manages the automatic creation and renewal of x509 certificates from a
remote step-ca PKI server, in order to enable TLS/SSL connections in
Home Assistant and the installed addons.

Here is a [quick-start guide][pki-guide] on how to set up step-ca.

With a Yubikey, you can even set up set up a [hardware-based, local PKI][pki-guide-yubikey].

## Configuration

You will need a one-time token generated with `step ca token` to issue the
certificate, and to keep the addon always running so it renews the certificate
automatically (enable "Start on boot" and "Watchdog" on the
[addon configuration page][addon-config]).

**Note**: Certificates in step-ca have short lifetimes, usually 24 hours, if the addon
is not running and the certificate expires, you must manually generate
a new one-time token.

The certificate lifetime is dictated when creating the token. It will use the
default provisioner lifetime. You can change it with `step ca provisioner update <provisioner-name> --x509-default-dur=<duration>`
_before_ generating the token, but keep in mind [the design decisions of step-ca][passive-revocation].

Example add-on configuration:

```yaml
ca_url: https://tinyca.internal
root_ca_fingerprint: "d9d0978692f1c7cc791f5c343ce98771900721405e834cd27b9502cc719f5097"
token: "692f1c7cc791f5c343ce987d9d0978692f1c7cc791f5c343ce98692f1c7cc791f5c343ce987"
subjects:
  - homeassistant.local
  - mqtt.local
keyfile: privkey.pem
certfile: fullchain.pem
key_type: RSA
log_level: info
```

### Option: `ca_url`

URL of the targeted Step Certificate Authority.

### Option: `root_ca_fingerprint`

The fingerprint of the root certificate.

### Option: `token`

The token generated with `step ca token`.

As mentioned before, it will only be used the first time the addon runs. You can
remove it or keep it for regular operation. If there is ever any problem and the
certificate is not renewed before the expiration date, you will need to generate
a new token manually, configure it here and restart the addon.

The token must be generated with the same subjects configured on the
addon. If only using one, specifying it as the positional argument is enough.

### Option: `subjects`

Add domain names or IP Address as Subjective Alternative Names (SANs) to the
certificate.

Effectively the address you use to access the services you want
to use SSL/TLS with. Some examples:

- For `https://homeassistant.local:8123` use `homeassistant.local`
- For `mqtts://my-mqtt-server.internal` use `my-mqtt-server.internal`,
- For `https://mydomainname.com/hass/` use `mydomainname.com`

**Note**: if you need more than one, you will have to add `--san` arguments for every
one of them when creating the token, including the one you specify as the "principal"
subject. Else some certificate validators will not accept it.

In short, use either:

- `step ca token homeassistant.local` for:
  - `homeassistant.local`
- or `step ca token --san=mqtt.local --san=homeassistant.local homeassistant.local` for:
  - `homeassistant.local`
  - and `mqtt.local`

### Option: `cafile`

Path to where the root CA certificates will be stored relative to `/ssl/`.

### Option: `keyfile`

Path to where the private key file will be created relative to `/ssl/`.

### Option: `certfile`

Path to where the certificate file will be created relative to `/ssl/`.

### Option: `restart_ha`

Whether or not to restart Home Assistant core.

Currently there is no way to reload the certificates on the fly, so a
full restart of Home Assistant Core is required.

### Option: `restart_addons`

List of addons that will be restarted when a certificate is renewed.

Use the full `slug_addonname` identifier, you can find it on the url of
the addon. For the core mosquitto broker it will be `core_mosquitto`.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue.

### Option: `key_type`

The key-pair type to generate for the certificate.
Corresponding [step cli documentation][docs-step-ca-certificate-kty] for `--kty`

As of Tasmota v12.4.0, MQTT over TLS will only work with RSA keys, so keep this
as RSA if you plan to use the generated certificate with the MQTT server.
This limitation of tasmota also means that in order to do full chain
verification, all the certificates up to the root ca must have a compatible key
type. RSA is not the default for `step-ca init` when the PKI is created, and
not convenient to change for all the chain if the PKI is going to have more use
cases other than Tasmota.
Until upstream Tasmota adds support for EC keys, the workaround is to use RSA
for this certificate only, have a PKI with the defaults and use `SetOption132 1`
in Tasmota to switch to one-level fingerprint verification as described in Tasmota
[MQTT over TLS documentation][tasmota-mqtt-over-tls].

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## Contributing

This is an active open-source project. We are always open to people who want to
use the code or contribute to it.

We have set up a separate document containing our
[contribution guidelines](.github/CONTRIBUTING.md).

Thank you for being involved! :heart_eyes:

## Authors & contributors

Addon created by [Miguel Angel Nubla][miguelangel-nubla] based on the
[addon-example][addon-example] repository by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2023 Miguel Angel Nubla

Copyright (c) 2017-2023 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[addon-config]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=133adb15_step-ca-client&repository_url=https%3A%2F%2Fgithub.com%2Fmiguelangel-nubla%2Fhassio-repository
[addon-example]: https://github.com/hassio-addons/addon-example
[contributors]: https://github.com/miguelangel-nubla/hassio-step-ca-client/graphs/contributors
[docs-step-ca-certificate-kty]: https://smallstep.com/docs/step-cli/reference/ca/certificate#:~:text=token%20generating%20key.-,%2D%2Dkty%3D,-kty
[frenck]: https://github.com/frenck
[miguelangel-nubla]: https://github.com/miguelangel-nubla
[pki-guide]: https://smallstep.com/docs/step-ca/getting-started
[pki-guide-yubikey]: https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/
[releases]: https://github.com/miguelangel-nubla/hassio-step-ca-client/releases
[semver]: http://semver.org/spec/v2.0.0.html
[step-ca]: https://smallstep.com/docs/step-ca/installation
[tasmota-mqtt-over-tls]: https://tasmota.github.io/docs/TLS/
[passive-revocation]: https://smallstep.com/blog/passive-revocation/
