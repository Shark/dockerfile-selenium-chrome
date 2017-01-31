#!/usr/bin/env bash
set -euo pipefail

main() {
  if [[ "${FFMPEG_DISABLE:-}" -eq 1 ]]; then
    echo "ffmpeg is disabled; exiting"
    return 0
  fi

  sleep 10
  exec /usr/bin/ffmpeg -y \
                       -f x11grab \
                       -s $SCREEN_RESOLUTION \
                       -i $DISPLAY \
                       -r 15 \
                       -vcodec libx264 \
                       -crf 25 \
                       -profile:v high \
                       -preset veryfast \
                       -pix_fmt yuv420p \
                       /logs/chrome/screen.mkv
}

main "$@"
