#!/bin/sh

set -e

umask 0077

cookie_key_file="/etc/apache2/webauthcookie.key"
if [ ! -f "${cookie_key_file}" ]; then
  echo "-- Generating new webauth cookie key."
  head -c 64 /dev/urandom > "${cookie_key_file}"
else
  echo "-- Using existing webauth cookie key."
fi

extra_args=""

if [ -z "${SERVER_NAME}" ]; then
  echo "!! SERVER_NAME must be set to the FQDN for the server." >&2
  exit 1
fi

if [ -z "${BACKEND_URL}" ]; then
  echo "!! BACKEND_URL must be set to the base URL to proxy." >&2
  exit 1
fi

if [ ! -z "${LOOKUP_GROUP_ID}" ]; then
  echo "Adding extra restriction: lookup group id=${LOOKUP_GROUP_ID}."
  extra_args="${extra_args} -D WithLDAPGroup"
fi

echo "-- Starting apache"
exec /usr/sbin/apachectl -D FOREGROUND ${extra_args}
