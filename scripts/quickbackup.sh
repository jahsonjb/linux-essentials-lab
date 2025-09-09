#!/usr/bin/env bash
set -euo pipefail
TS=$(date +%F_%H%M)
DEST="$HOME/backups/etc-$TS.tar.gz"
mkdir -p "$HOME/backups"
sudo tar -czf "$DEST" /etc
echo "Wrote $DEST"
