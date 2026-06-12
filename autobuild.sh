#!/bin/bash

echo "=============================="
echo "   ZDOS-WEB AUTO-BUILD v1.0"
echo "=============================="

# 1) Verifica repo
if [ ! -d .git ]; then
  echo "❌ Non sei dentro un repo Git!"
  exit 1
fi

# 2) Verifica file HTML
if [ ! -f index.html ] || [ ! -f zlang-ide.html ]; then
  echo "❌ Mancano index.html o zlang-ide.html!"
  exit 1
fi

# 3) Pull aggiornamenti
echo "📥 Pull aggiornamenti..."
git pull --rebase

# 4) Aggiungi file
echo "📦 Aggiungo file..."
git add index.html zlang-ide.html

# 5) Commit automatico
echo "📝 Commit..."
git commit -m "AutoBuild: update ZDOS web + Z-LANG IDE PRO" || echo "⚠ Nessun cambiamento da committare"

# 6) Push
echo "🚀 Push su origin..."
git push

# 7) Attiva GitHub Pages (se necessario)
echo "🌐 Verifica GitHub Pages..."
echo " - Vai su Settings → Pages → Source: main / root"

# 8) URL finale
echo
echo "=============================="
echo "   DEPLOY COMPLETATO"
echo "=============================="
echo "🌍 Sito online:"
echo "https://high-cde.github.io/zdos-web/"
echo "IDE Z-LANG PRO:"
echo "https://high-cde.github.io/zdos-web/zlang-ide.html"
echo "=============================="
