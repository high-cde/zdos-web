#!/bin/bash

echo "=============================="
echo "   ZDOS-WEB AUTO-FIX v2.0"
echo "=============================="

# 1) Check repo
if [ ! -d .git ]; then
  echo "❌ Non sei dentro un repo Git!"
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

# 3) Pull
git pull --rebase

# 4) Add + Commit
git add index.html zlang-ide.html
git commit -m "AutoFix: update ZDOS web + IDE PRO" || echo "⚠ Nessun cambiamento"

# 5) Push
git push

echo
echo "=============================="
echo "   DEPLOY COMPLETATO"
echo "=============================="
echo "🌍 Sito online:"
echo "https://high-cde.github.io/zdos-web/"
echo "IDE Z-LANG PRO:"
echo "https://high-cde.github.io/zdos-web/zlang-ide.html"
echo "=============================="
