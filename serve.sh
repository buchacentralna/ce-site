#!/usr/bin/env bash
# Dev mode: serve the site on localhost and share it through an ngrok tunnel. Ctrl+C stops both.
set -euo pipefail
cd "$(dirname "$0")"
PORT="${PORT:-8090}"

command -v python3 >/dev/null || { echo "python3 is required: https://www.python.org/downloads/"; exit 1; }
command -v ngrok >/dev/null || { echo "ngrok is required: https://ngrok.com/download (see CLAUDE.md)"; exit 1; }

mkdir -p .run
python3 -m http.server "$PORT" --bind 127.0.0.1 > .run/http.log 2>&1 &
SERVER=$!
ngrok http "127.0.0.1:$PORT" --log stdout --log-format logfmt > .run/ngrok.log 2>&1 &
NGROK=$!
trap 'kill $SERVER $NGROK 2>/dev/null || true' EXIT

sleep 1
kill -0 $SERVER 2>/dev/null || { echo "The server did not start (is port $PORT busy?). Try: PORT=8091 ./serve.sh"; tail -1 .run/http.log; exit 1; }

URL=""
for _ in $(seq 1 30); do
  URL=$(grep -o 'url=https://[^ ]*' .run/ngrok.log | head -1 | cut -d= -f2 || true)
  [ -n "$URL" ] && break
  kill -0 $NGROK 2>/dev/null || break
  sleep 0.5
done
if [ -z "$URL" ]; then
  echo "ngrok did not open a tunnel. Its log:"; grep -iE 'err|fail' .run/ngrok.log || cat .run/ngrok.log
  exit 1
fi

echo
echo "  Локально:   http://localhost:$PORT/"
echo "  Публічно:   $URL/"
echo
echo "  Ctrl+C — зупинити сервер і тунель."
wait $NGROK
