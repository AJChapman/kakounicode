#!/usr/bin/env bash

set -euo pipefail

chr "$1" | sed -n '2p' | sed 's/\r//' | sed 's/[A-Z]/\L&/g' | sed 's/\b\(.\)/\u\1/'
