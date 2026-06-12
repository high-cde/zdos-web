#!/bin/bash
set -e

echo "=============================="
echo "   ZDOS · SUPER COMANDO CREATORE"
echo "=============================="

# 1) Clona o aggiorna zdos-web
if [ ! -d zdos-web ]; then
  echo "📥 Clono zdos-web..."
  git clone https://github.com/high-cde/zdos-web.git
fi

cd zdos-web

echo "📥 Pull zdos-web..."
git pull || true

# 2) Integra Z-GENESIS-OS come submodule
if [ ! -d genesis ]; then
  echo "🧬 Integro Z-GENESIS-OS come genesis/..."
  git submodule add https://github.com/high-cde/Z-GENESIS-OS.git genesis || true
else
  echo "🧬 Aggiorno submodule genesis..."
  git submodule update --init --recursive || true
fi

# 3) index.html con redirect
echo "🧩 Creo/aggiorno index.html..."
cat << 'EOR' > index.html
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="0; url=zlang-ide.html">
  <title>ZDOS · GENESIS PORTAL</title>
  <style>
    body { background:#000; color:#0f0; font-family:monospace; padding:40px; }
  </style>
</head>
<body>
  ZDOS · GENESIS PORTAL<br>
  Reindirizzamento a Z‑LANG IDE PRO…
</body>
</html>
EOR

# 4) zlang-ide.html base (IDE + terminale + GENESIS loader minimale)
if [ ! -f zlang-ide.html ]; then
  echo "🧠 Creo zlang-ide.html base..."
  cat << 'EOR' > zlang-ide.html
<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<title>Z‑LANG IDE · GENESIS CONSOLE</title>
<style>
  body { background:#000; color:#0f0; font-family:monospace; margin:0; }
  #topbar { background:#111; padding:8px; border-bottom:2px solid #0f0; display:flex; gap:10px; align-items:center; }
  #topbar .logo { font-weight:bold; color:#0f0; }
  #layout { display:flex; height:calc(100vh - 40px); }
  #sidebar { width:20%; background:#080808; border-right:2px solid #0f0; padding:8px; overflow:auto; }
  #editor { width:50%; background:#111; border-right:2px solid #0f0; padding:8px; color:#0f0; font-family:monospace; }
  #editor textarea { width:100%; height:100%; background:#000; color:#0f0; border:1px solid #0f0; }
  #right { width:30%; display:flex; flex-direction:column; }
  #output { flex:1; background:#000; padding:8px; overflow:auto; border-bottom:1px solid #0f0; }
  #term { padding:8px; background:#080808; border-top:1px solid #0f0; }
  #term input { width:100%; background:#000; color:#0f0; border:1px solid #0f0; padding:4px; }
  button { background:#000; color:#0f0; border:1px solid #0f0; padding:4px 8px; cursor:pointer; }
  button:hover { background:#0f0; color:#000; }
</style>
</head>
<body>
<div id="topbar">
  <span class="logo">ZDOS · Z‑LANG IDE · GENESIS</span>
  <button onclick="runProgram()">Run VM</button>
  <button onclick="genesisMap()">GENESIS MAP</button>
  <button onclick="genesisBoot()">GENESIS BOOT</button>
</div>

<div id="layout">
  <div id="sidebar">
    <h3>GENESIS CORE</h3>
    <div id="genesis-panel">Carica mappa GENESIS…</div>
  </div>

  <div id="editor">
    <textarea id="editor-area"># Z-LANG / GENESIS CONSOLE
# Usa il terminale in basso:
# genesis map
# genesis boot
</textarea>
  </div>

  <div id="right">
    <div id="output"></div>
    <div id="term">
      <input id="term-input" placeholder="ZDOS> comando" onkeydown="if(event.key==='Enter') handleTermCommand(this.value)">
    </div>
  </div>
</div>

<script>
const outEl = document.getElementById("output");
const editorEl = document.getElementById("editor-area");

function log(msg) {
  outEl.innerHTML += msg + "<br>";
  outEl.scrollTop = outEl.scrollHeight;
}

function zdos(msg) { log(msg); }

/* MINI VM PLACEHOLDER */
const VM = { pc:0, program:[] };

function parseProgram() {
  VM.program = editorEl.value.split("\\n").map(l => l.trim()).filter(l => l);
}

function runProgram() {
  outEl.innerHTML = "";
  parseProgram();
  log("[VM] Esecuzione simbolica Z-LANG…");
  VM.program.forEach(line => log(">> " + line));
}

/* GENESIS LOADER (via raw GitHub) */
const GENESIS_BASE = "https://raw.githubusercontent.com/high-cde/Z-GENESIS-OS/main/";

const genesisModules = [
  "README.md",
  "kernel/",
  "fs/",
  "vm/"
];

function genesisMap() {
  const panel = document.getElementById("genesis-panel");
  panel.innerHTML = "";
  genesisModules.forEach(m => {
    panel.innerHTML += "<div onclick=\\"openGenesis('"+m+"')\\">" + m + "</div>";
  });
  log("[GENESIS] Mappa caricata.");
}

async function openGenesis(path) {
  try {
    const res = await fetch(GENESIS_BASE + path);
    if (!res.ok) throw new Error(res.status);
    const txt = await res.text();
    editorEl.value = txt;
    log("[GENESIS] Caricato: " + path);
  } catch(e) {
    log("[GENESIS] Errore caricando " + path + ": " + e);
  }
}

function genesisBoot() {
  log("[GENESIS] Boot simbolico del kernel…");
  log("[GENESIS] (Futuro: esecuzione reale dei moduli kernel)");
}

/* TERMINALE ZDOS */
function handleTermCommand(cmd) {
  const input = document.getElementById("term-input");
  cmd = cmd.trim();
  if (!cmd) return;
  zdos("ZDOS> " + cmd);

  if (cmd === "genesis map") {
    genesisMap();
  } else if (cmd === "genesis boot") {
    genesisBoot();
  } else if (cmd.startsWith("genesis load ")) {
    const p = cmd.replace("genesis load ", "");
    openGenesis(p);
  } else if (cmd === "run") {
    runProgram();
  } else {
    zdos("[errore] Comando sconosciuto.");
  }

  input.value = "";
}
</script>
</body>
</html>
EOR
else
  echo "🧠 zlang-ide.html esiste già, non lo sovrascrivo (modificalo tu a mano se vuoi)."
fi

# 5) Commit + push
echo "📝 Commit & push..."
git add index.html zlang-ide.html genesis .gitmodules || true
git commit -m "GENESIS PRIMORDIALE: portal + IDE + core" || echo "⚠ Nessun cambiamento da committare."
git push origin main || true

echo
echo "=============================="
echo "   SUPER COMANDO COMPLETATO"
echo "=============================="
echo "🌍 Portal:"
echo "https://high-cde.github.io/zdos-web/"
echo "🧠 IDE / GENESIS CONSOLE:"
echo "https://high-cde.github.io/zdos-web/zlang-ide.html"
echo "=============================="
