#!/usr/bin/env python3
"""Copia para tex/oficial/ apenas os recortes oficiais usados nos capítulos
(a pasta cache/oficial/ contém os 765 recortes e não é versionada)."""
import glob, os, re, shutil

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
usadas = set()
for f in glob.glob(os.path.join(ROOT, 'tex', 'v[123]', '*.tex')):
    src = re.sub(r'(?<!\\)%.*', '', open(f, encoding='utf-8').read())
    usadas |= set(re.findall(r'\\questaoenem\{([0-9]{4}-[0-9]{3})\}', src))
dst = os.path.join(ROOT, 'tex', 'oficial')
os.makedirs(dst, exist_ok=True)
cache = os.path.join(ROOT, 'cache', 'oficial')
faltando = []
for q in sorted(usadas):
    origem = os.path.join(cache, q + '.pdf')
    if os.path.exists(origem):
        shutil.copy2(origem, os.path.join(dst, q + '.pdf'))
    elif not os.path.exists(os.path.join(dst, q + '.pdf')):
        faltando.append(q)
for f in glob.glob(os.path.join(dst, '*.pdf')):
    if os.path.basename(f)[:-4] not in usadas:
        os.remove(f)
print(f'{len(usadas)} recortes oficiais em tex/oficial/' + (f'; FALTANDO: {faltando}' if faltando else ''))
