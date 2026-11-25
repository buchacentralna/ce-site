# Bucha Centralna church site: 3 prototypes

Plain static HTML and CSS, no build step. Run it from this folder:

    python3 -m http.server 8090

Open http://localhost:8090/ (use `localhost`, not `127.0.0.1`: on `127.0.0.1` the YouTube embeds
show "This video is unavailable").

- `/`: choose a variant
- `/v1/`: based on the idea of Elevation Church (USA): monochrome, large photos
- `/v2/`: based on the idea of "Dzherelo Zhyttia" church (Lviv): dark, video hero
- `/v3/`: based on the idea of "Blaha Zvistka" church (Kyiv): light, app-like tiles

Facts and sources: `CONTENT.md`. Photos: `assets/photos/` (chosen), `assets/fb/`, `assets/ig/`
(everything downloaded from the church's social media).

Public link for a demo (dev mode): `./serve.sh` starts the server and ngrok and prints both links;
Ctrl+C stops them. It needs `python3` and `ngrok` with an authtoken
(`ngrok config add-authtoken <token>`). Step-by-step instructions (also for Claude Code) are in
`CLAUDE.md`.
