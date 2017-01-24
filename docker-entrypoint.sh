#!/usr/bin/env bash
set -euo pipefail

main() {
  mkdir -p /logs/chrome
  chown selenium /logs/chrome

  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
}

main "$@"
