#!/bin/bash

echo "=============================="
echo "   ZDOS-WEB AUTOBUILD MASTER"
echo "=============================="

# 1) Check repo
if [ ! -d .git ]; then
  echo "❌ Non sei in un repo Git!"
  exit 1
fi

# 2) Assicura index.html con redirect base
if [ ! -f index.html ]; then
  echo "🧩 Creo index.html con redirect all'IDE..."
  cat << 'EOR' > index.html
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="refresh" content="0; url=zlang-ide.html">
  <title>ZDOS Redirect</title>
  <style>
    body { background:#000; color:#0f0; font-family:monospace; padding:40px; }
  </style>
</head>
<body>
  Reindirizzamento a Z‑LANG IDE PRO…
</body>
</html>
EOR
fi

# 3) Check IDE
if [ ! -f zlang-ide.html ]; then
  echo "❌ Manca zlang-ide.html (crealo o copialo qui e rilancia)."
  exit 1
fi

# 4) Pull
echo "📥 Pull..."
git pull --rebase || echo "⚠ Pull non riuscito, continuo comunque."

# 5) Add + Commit
echo "📝 Commit..."
git add index.html zlang-ide.html autobuild.sh
git commit -m "Autobuild: update ZDOS web + IDE" || echo "⚠ Nessun cambiamento da committare."

# 6) Push
echo "🚀 Push su origin..."
git push origin main

echo
echo "=============================="
echo "   DEPLOY COMPLETATO"
echo "=============================="
echo "🌍 Sito:"
echo "https://high-cde.github.io/zdos-web/"
echo "IDE:"
echo "https://high-cde.github.io/zdos-web/zlang-ide.html"
echo "=============================="
