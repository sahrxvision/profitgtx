#!/usr/bin/env bash
set -euo pipefail

export WINEPREFIX="/root/.wine-mt5"

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MT5_EXPERTS_DIR="$WINEPREFIX/drive_c/Program Files/MetaTrader 5/MQL5/Experts"
PROJECT_DIR_NAME="profitgtx"
TARGET_DIR="$MT5_EXPERTS_DIR/$PROJECT_DIR_NAME"
MAIN_FILE="profitmaxxingt3.1.mq5"
LOG_FILE="$TARGET_DIR/compile.log"

mkdir -p "$TARGET_DIR"

rsync -a --delete \
  --include='*/' \
  --include='*.mq5' \
  --include='*.mqh' \
  --exclude='*' \
  "$REPO_DIR/" "$TARGET_DIR/"

WIN_MAIN_PATH="$(winepath -w "$TARGET_DIR/$MAIN_FILE")"
WIN_LOG_PATH="$(winepath -w "$LOG_FILE")"

xvfb-run -a metaeditor "/compile:$WIN_MAIN_PATH" "/log:$WIN_LOG_PATH" || true

if [[ -f "$LOG_FILE" ]]; then
  echo "Compile log: $LOG_FILE"
  strings "$LOG_FILE" | tail -n 80
else
  echo "Compile log not found: $LOG_FILE" >&2
  exit 1
fi
