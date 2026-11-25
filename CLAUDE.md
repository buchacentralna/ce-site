# Bucha Centralna church site: instructions for Claude Code

A static site: three prototypes of a small website for the Seventh-day Adventist church
"Bucha-Centralna" (Bucha, Ukraine). No build step and no dependencies: each `index.html` holds
its own HTML and CSS, photos live in `assets/`. The site text is in Ukrainian. Facts for any
site text come only from `CONTENT.md`.

## Dev mode: run the site and share a public link (ngrok)

When the user asks to run the site, show the site, or get a link for a friend, do this:

1. **Check the tools:** `python3 --version` and `ngrok version`.
   - No `ngrok`: on macOS `brew install ngrok`; on Linux or Windows see https://ngrok.com/download.
     Installing changes the user's machine, so ask first.
   - No `python3`: ask the user to install it (https://www.python.org/downloads/).
2. **Check that ngrok has an authtoken:**
   `grep -q authtoken "$(ngrok config check 2>&1 | sed -n 's/.*file at //p')"`
   (without one, `serve.sh` fails with `ERR_NGROK_4018`). If there is no authtoken, do NOT enter
   a token yourself and do not ask the user to paste it into the chat. Ask the user to sign up at
   https://dashboard.ngrok.com (free), copy the authtoken, and run in the prompt:
   `! ngrok config add-authtoken <token>`.
3. **Start it** from the repository root in the background (Bash with `run_in_background`):
   `./serve.sh` (another port: `PORT=8091 ./serve.sh`).
   The script starts `python3 -m http.server` and ngrok, prints both links and keeps them up
   while it runs. Ctrl+C or killing the script stops both. Logs go to `.run/` (git-ignored).
4. **Verify** before you hand out the link:
   `curl -s -o /dev/null -w '%{http_code}' http://localhost:8090/`, and the same for the public
   URL with the header `-H 'ngrok-skip-browser-warning: 1'`. Both must return `200`.
5. **Give the user** the public link from the output (`https://….ngrok-free.app/`) and the local
   one, `http://localhost:8090/`. Warn them: on the first visit ngrok shows a warning page, and
   the visitor has to click "Visit Site".

Important:
- Open the site locally on `localhost`, not `127.0.0.1`: on `127.0.0.1` the YouTube embeds show
  "This video is unavailable".
- The link works only while `serve.sh` runs and the machine stays awake. After a restart the URL
  is different.
- Windows without bash (Git Bash or WSL): run two commands in separate terminals:
  `python -m http.server 8090 --bind 127.0.0.1` and `ngrok http 127.0.0.1:8090`. The URL is shown
  in the ngrok window.

## Layout

- `/` (`index.html`): the variant chooser; `/v1/`, `/v2/`, `/v3/`: three designs (see `README.md`)
- `CONTENT.md`: the single source of facts (address, schedule, people, videos). Do not invent
  anything that is not there.
- `assets/photos/`: chosen photos; `assets/fb/`, `assets/ig/`, `assets/yt/`: raw downloads from
  the church's social media.
