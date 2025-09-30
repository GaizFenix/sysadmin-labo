#!/usr/bin/env bash
# simple-lastline-to-index.sh
# Reads ONLY the last line (DATE TIME TEMP) from the single file in SOURCE_DIR
# and writes/overwrites DEST_DIR/index.html with those values.

set -euo pipefail

# ---- Hardcoded paths (edit these) ----
SOURCE_DIR="/tmp/carpetaRemota"   # has exactly one data file
DEST_DIR="/home/urtea2014/MV4"       # where index.html will be written
DEST_PATH="$DEST_DIR/index.html"

# ---- 1) Check source directory ----
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

# ---- 2) Find exactly one file in source ----
file_count=$(find "$SOURCE_DIR" -maxdepth 1 -type f | wc -l | tr -d '[:space:]')
if [[ "$file_count" -ne 1 ]]; then
  echo "Error: expected exactly 1 file in $SOURCE_DIR, found $file_count" >&2
  exit 1
fi
SRC_FILE=$(find "$SOURCE_DIR" -maxdepth 1 -type f -print -quit)

# ---- 3) Read ONLY the last line: "DATE TIME TEMP" (e.g., 2025-09-09 10:10:10 19.7)
last_line=$(tail -n 1 "$SRC_FILE" | tr -d '\r')
IFS=' ' read -r DATA_DATE DATA_TIME DATA_TEMP <<< "$last_line" || {
  echo "Error: could not parse last line" >&2; exit 1; }

if [[ -z "${DATA_DATE:-}" || -z "${DATA_TIME:-}" || -z "${DATA_TEMP:-}" ]]; then
  echo "Error: malformed data (need: DATE TIME TEMP). Last line was: '$last_line'" >&2
  exit 1
fi

# ---- 4) Ensure destination directory ----
mkdir -p "$DEST_DIR"

# ---- 5) Overwrite index.html with embedded values ----
cat > "$DEST_PATH" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Latest Reading</title>
  <style>
    :root { --bg:#0f172a; --card:#111827; --fg:#e5e7eb; --muted:#9ca3af; --accent:#38bdf8; }
    * { box-sizing: border-box; }
    html, body { height: 100%; }
    body {
      margin: 0;
      display: grid;
      place-items: center;
      background:
        radial-gradient(70vmax 70vmax at 20% -10%, rgba(56,189,248,.14), transparent 60%),
        radial-gradient(55vmax 55vmax at 120% 10%, rgba(16,185,129,.10), transparent 60%),
        var(--bg);
      color: var(--fg);
      font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, "Helvetica Neue", Arial;
    }
    .card {
      width: min(92vw, 640px);
      background: linear-gradient(180deg, rgba(255,255,255,.03), rgba(255,255,255,.01));
      backdrop-filter: blur(6px);
      border: 1px solid rgba(255,255,255,.06);
      box-shadow: 0 10px 30px rgba(0,0,0,.35);
      border-radius: 22px;
      padding: 28px;
    }
    h1 { margin: 0 0 10px; font-weight: 700; letter-spacing: .2px; }
    .muted { color: var(--muted); font-size: .95rem; margin-bottom: 18px; }
    .grid { display: grid; gap: 14px; grid-template-columns: repeat(3, 1fr); }
    .tile {
      background: var(--card);
      border: 1px solid rgba(255,255,255,.06);
      border-radius: 18px;
      padding: 16px 18px;
    }
    .label { color: var(--muted); font-size: .85rem; margin-bottom: 6px; }
    .value { font-size: 1.4rem; font-weight: 700; letter-spacing: .3px; }
    .pill {
      display: inline-block;
      margin-top: 14px;
      padding: 6px 10px;
      border-radius: 999px;
      background: rgba(56,189,248,.15);
      border: 1px solid rgba(56,189,248,.35);
      color: var(--accent);
      font-size: .82rem;
      letter-spacing: .2px;
    }
  </style>
</head>
<body>
  <main class="card">
    <h1>Latest Reading</h1>
    <div class="muted">Values from the last line of the data file.</div>

    <section class="grid">
      <div class="tile">
        <div class="label">Date</div>
        <div class="value">${DATA_DATE}</div>
      </div>
      <div class="tile">
        <div class="label">Time</div>
        <div class="value">${DATA_TIME}</div>
      </div>
      <div class="tile">
        <div class="label">Temperature</div>
        <div class="value">${DATA_TEMP} °C</div>
      </div>
    </section>

    <div class="pill">Updated: ${DATA_DATE} ${DATA_TIME}</div>
  </main>
</body>
</html>
HTML

echo "Wrote: $DEST_PATH (last line -> date='${DATA_DATE}', time='${DATA_TIME}', temp='${DATA_TEMP}')"

