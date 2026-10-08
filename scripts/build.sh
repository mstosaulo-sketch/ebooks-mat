#!/usr/bin/env bash
# Gera os três volumes em dist/ e roda os testes automáticos.
# Uso: scripts/build.sh [1 2 3]
set -uo pipefail
cd "$(dirname "$0")/.."
vols="${*:-1 2 3}"
python3 scripts/gen_enem_tex.py
python3 scripts/sync_oficial.py
python3 scripts/check_conteudo.py | tail -n +1 > build-conteudo.log || true
mkdir -p dist
status=0
for v in $vols; do
  ( cd tex && latexmk -lualatex -interaction=nonstopmode -halt-on-error "volume$v.tex" > "volume$v.build.log" 2>&1 )
  if [ $? -ne 0 ]; then
    echo "✗ volume $v falhou:"; grep -nE "^!" -A6 "tex/volume$v.log" | head -30; status=1; continue
  fi
  qpdf --linearize --object-streams=generate "tex/volume$v.pdf" "dist/ENEM-Matematica-Volume-$v.pdf"
  echo "✓ volume $v: $(pdfinfo "dist/ENEM-Matematica-Volume-$v.pdf" | awk '/Pages/{print $2}') páginas, $(du -h "dist/ENEM-Matematica-Volume-$v.pdf" | cut -f1)"
done
python3 scripts/check_pdf.py dist/ENEM-Matematica-Volume-*.pdf || status=1
exit $status
