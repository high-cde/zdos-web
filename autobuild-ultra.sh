#!/bin/bash

echo "======================================"
echo "     ZDOS WEB · AUTOBUILD ULTRA"
echo "======================================"

# 1) Check repo
if [ ! -d .git ]; then
  echo "❌ Non sei in un repo Git!"
  exit 1
fi

# 2) Check HTML files
missing=0
for f in index.html zlang-ide.html; do
  if [ ! -f "$f" ]; then
    echo "❌ Manca: $f"
    missing=1
  fi
done

if [ $missing -eq 1 ]; then
  echo "⚠ Copia i file HTML nella cartella e rilancia."
  exit 1
fi

# 3) Backup
echo "📦 Backup locale..."
mkdir -p .backup
cp index.html .backup/index.html.bak
cp zlang-ide.html .backup/zlang-ide.html.bak

# 4) Minify (HTML/CSS/JS)
echo "🧪 Minify HTML..."
for f in index.html zlang-ide.html; do
  sed -i 's/[[:space:]]\+/ /g' "$f"
  sed -i 's/> </></g' "$f"
done

# 5) Pull aggiornamenti
echo "📥 Pull..."
git pull --rebase

# 6) Add + Commit
echo "📝 Commit..."
git add index.html zlang-ide.html autobuild-ultra.sh
git commit -m "ULTRA: deploy ZDOS web + IDE PRO" || echo "⚠ Nessun cambiamento"

# 7) Push
echo "🚀 Push su origin..."
git push origin main

# 8) GitHub Pages auto-enable (branch main)
echo "🌐 Verifica GitHub Pages..."
echo " - Assicurati che Pages sia attivo su: main / root"

# 9) URL finale
echo
echo "======================================"
echo "         DEPLOY COMPLETATO"
echo "======================================"
echo "🌍 Sito online:"
echo "https://high-cde.github.io/zdos-web/"
echo "IDE Z-LANG PRO:"
echo "https://high-cde.github.io/zdos-web/zlang-ide.html"
echo "======================================"
