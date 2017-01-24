#!/usr/bin/env bash
set -euo pipefail

main() {
  mkdir /logs/chrome
  chown -R selenium /logs

  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
}

main "$@"
