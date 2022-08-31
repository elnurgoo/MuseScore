#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-CLA-applies
#
# MuseScore
# Music Composition & Notation
#
# Copyright (C) 2021 MuseScore BVBA and others
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
GITHUB_TOKEN=$1
GITHUB_REPOSITORY=$2

S3_KEY=$3
S3_SECRET=$4
S3_URL=$5
S3_BUCKET=%6

echo "=== Get release info ==="

RELEASE_INFO=$(curl \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/latest)

echo "Release info = ${RELEASE_INFO}"

cat >~/.s3cfg <<EOL
[default]
access_key = ${S3_KEY}
secret_key = ${S3_SECRET}
host_base = ${S3_BUCKET}:443
host_bucket = ${S3_BUCKET}.com:443
website_endpoint = https://${S3_BUCKET}.com:443
EOL

echo "=== Publish to S3 ==="

s3cmd -c ~/.s3cfg ls ${S3_URL}
