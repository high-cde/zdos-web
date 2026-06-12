#!/bin/bash
set -e

echo "====================================="
echo "     Z D O S   H Y P E R   V 5"
echo "      QUANTUM GENESIS EDITION"
echo "====================================="

# 1) Sync repo
echo "[1] Sync repository..."
git pull --rebase || true

# 2) Ensure API folder
mkdir -p api

# 3) Load GENESIS meta (if missing)
if [ ! -f api/genesis-meta.json ]; then
  echo "[2] Creating genesis-meta.json..."
  cat << 'EOM' > api/genesis-meta.json
{
  "version": "5.0",
  "kernel": "Z-GENESIS-OS",
  "modules": [
    { "name": "core", "path": "kernel/core.zg", "type": "kernel" },
    { "name": "vm", "path": "vm/vm.zg", "type": "vm" },
    { "name": "fs", "path": "fs/fs.zg", "type": "fs" },
    { "name": "lang", "path": "lang/lang.zg", "type": "lang" }
  ],
  "bootflow": [
    "INIT",
    "META",
    "MAP",
    "FLOW",
    "CORE",
    "FS",
    "VM",
    "LANG",
    "LINK",
    "READY"
  ]
}
EOM
fi

# 4) Install GENESIS loader in IDE
echo "[3] Updating IDE with GENESIS V5 loader..."
cat << 'EOM' > genesis-v5.js
async function GENESIS_V5_BOOT() {
  const meta = await fetch("api/genesis-meta.json").then(r => r.json());
  window.GENESIS = meta;

  log("[GENESIS] V5 META LOADED (" + meta.modules.length + " modules)");
  log("[GENESIS] Bootflow: " + meta.bootflow.join(" → "));

  for (let i = 0; i < meta.bootflow.length; i++) {
    await new Promise(r => setTimeout(r, 150));
    log("[BOOT] " + meta.bootflow[i]);
  }

  log("[GENESIS] SYSTEM ONLINE (V5)");
}
EOM

# 5) Inject loader into IDE if not present
if ! grep -q "GENESIS_V5_BOOT" zlang-ide.html; then
  echo "[4] Injecting GENESIS V5 into IDE..."
  sed -i '/<\/body>/i <script src="genesis-v5.js"></script>\n<script>GENESIS_V5_BOOT();</script>' zlang-ide.html
fi

# 6) Commit & push
echo "[5] Commit & push..."
git add .
git commit -m "ZDOS V5: Hyper-Command Genesis Warp" || true
git push origin main || true

echo "====================================="
echo "       Z D O S   V 5   A C C E S O"
echo "====================================="
