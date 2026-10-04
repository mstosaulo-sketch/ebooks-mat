#!/usr/bin/env bash
# Compila um capítulo isolado para conferência.
# Uso: ./compilar-capitulo.sh v1c06      → gera _cap-v1c06.pdf e mostra erros/avisos relevantes
set -u
cd "$(dirname "$0")"
id="$1"; vol="${id:0:2}"
[ -f "$vol/$id.tex" ] || { echo "Arquivo $vol/$id.tex não existe"; exit 1; }
job="_cap-$id"
printf '\\documentclass[%s]{enemebook}\n\\begin{document}\n\\input{%s/%s}\n\\end{document}\n' "$vol" "$vol" "$id" > "$job.tex"
latexmk -lualatex -interaction=nonstopmode -halt-on-error -silent "$job.tex" > /dev/null 2>&1
status=$?
echo "== $id: latexmk saiu com código $status"
grep -nE "^!|GABARITO DIVERGENTE|sem resolução|desconhecid" "$job.log" -A6 | head -40
grep -E "Overfull \\\\hbox \(([1-9][0-9]+|[2-9])\.[0-9]+pt" "$job.log" -A2 | head -20
grep -E "LaTeX Warning: (Reference|Label|There were undefined)" "$job.log" | sort -u | head -10
[ -f "$job.pdf" ] && echo "páginas: $(pdfinfo "$job.pdf" 2>/dev/null | awk '/Pages/{print $2}')  →  tex/$job.pdf"
exit $status
