#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

cd /opt/vaani.client
export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx
#npm install

systemctl --system set-environment VAANI_BOOTS=$1
systemctl restart vaani
