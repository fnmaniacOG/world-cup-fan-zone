#!/bin/bash
# Double-click this file to run World Cup Fan Zone with wallet + TxLINE support.
# It serves the folder over http://localhost so your Solana wallet can connect
# (wallets cannot inject into file:// pages). Leave this window open while using the app.

cd "$(dirname "$0")" || exit 1
PORT=8765

# pick python3 or python
if command -v python3 >/dev/null 2>&1; then PY=python3
elif command -v python >/dev/null 2>&1; then PY=python
else echo "Python is required but not found. Install it from https://www.python.org/downloads/"; read -r _; exit 1
fi

echo "Serving World Cup Fan Zone at:  http://localhost:$PORT/WorldCup-FanZone.html"
echo "Keep this window open. Press Ctrl+C (or close it) to stop the server."
( sleep 1; open "http://localhost:$PORT/WorldCup-FanZone.html" ) &
exec "$PY" -m http.server "$PORT"
