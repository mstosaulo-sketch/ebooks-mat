#!/usr/bin/env python3
"""Testador dos PDFs finais: hyperlinks, destinos, marcadores, formulários e fontes.

Uso: python3 scripts/check_pdf.py dist/ENEM-Matematica-Volume-1.pdf [...]
Sai com código 1 se houver link interno quebrado ou link entre volumes quebrado.
"""
import os, sys, subprocess, collections
from pypdf import PdfReader
from pypdf.generic import IndirectObject


def nome(x):
    if isinstance(x, IndirectObject):
        x = x.get_object()
    if isinstance(x, bytes):
        return x.decode('latin-1')
    return str(x)


def destinos(reader):
    try:
        return set(reader.named_destinations.keys())
    except Exception:
        return set()


def outline_count(items):
    n = 0
    for it in items:
        if isinstance(it, list):
            n += outline_count(it)
        else:
            n += 1
    return n


cache = {}


def abrir(path):
    if path not in cache:
        r = PdfReader(path)
        cache[path] = (r, destinos(r))
    return cache[path]


falhas = 0
for path in sys.argv[1:]:
    reader, dests = abrir(path)
    base = os.path.dirname(path)
    tipos = collections.Counter()
    quebrados, externos_quebrados, urls = [], [], set()
    for pno, page in enumerate(reader.pages, 1):
        for a in page.get('/Annots') or []:
            a = a.get_object()
            if a.get('/Subtype') != '/Link':
                continue
            act = a.get('/A')
            act = act.get_object() if act is not None else None
            if act is None and '/Dest' in a:
                tipos['GoTo'] += 1
                d = nome(a['/Dest'])
                if d not in dests:
                    quebrados.append((pno, d))
                continue
            s = act.get('/S') if act else None
            if s == '/GoTo':
                tipos['GoTo'] += 1
                d = act.get('/D')
                if not isinstance(d.get_object() if isinstance(d, IndirectObject) else d, list):
                    d = nome(d)
                    if d not in dests:
                        quebrados.append((pno, d))
            elif s == '/GoToR':
                tipos['GoToR'] += 1
                f = nome(act.get('/F'))
                d = nome(act.get('/D')) if act.get('/D') is not None else None
                alvo = os.path.join(base, f)
                if not os.path.exists(alvo):
                    externos_quebrados.append((pno, f, d, 'arquivo ausente'))
                else:
                    _, d2 = abrir(alvo)
                    if d and d not in d2:
                        externos_quebrados.append((pno, f, d, 'destino ausente'))
            elif s == '/URI':
                tipos['URI'] += 1
                urls.add(nome(act.get('/URI')))
            else:
                tipos[str(s)] += 1
    fields = reader.get_fields() or {}
    ftipos = collections.Counter(str(v.get('/FT')) for v in fields.values())
    q = sum(1 for d in dests if d.startswith('q-'))
    r = sum(1 for d in dests if d.startswith('r-'))
    fonts = subprocess.run(['pdffonts', path], capture_output=True, text=True).stdout.splitlines()[2:]
    nao_emb = [ln for ln in fonts if ln.split()[-5:-4] == ['no']]
    print(f'== {os.path.basename(path)}')
    print(f'   páginas: {len(reader.pages)} | destinos nomeados: {len(dests)} | marcadores: {outline_count(reader.outline)}')
    print(f'   links: {dict(tipos)} | URLs externas: {len(urls)}')
    print(f'   questões com âncora: {q} | resoluções com âncora: {r}')
    print(f'   campos de formulário: {len(fields)} {dict(ftipos)}')
    print(f'   fontes não incorporadas: {len(nao_emb)}')
    if q != r:
        print('   ✗ número de questões e de resoluções difere'); falhas += 1
    if quebrados:
        falhas += 1
        print(f'   ✗ {len(quebrados)} links internos quebrados, ex.: {quebrados[:8]}')
    else:
        print('   ✓ todos os links internos apontam para destinos existentes')
    if externos_quebrados:
        falhas += 1
        print(f'   ✗ {len(externos_quebrados)} links entre volumes quebrados, ex.: {externos_quebrados[:5]}')
    elif tipos['GoToR']:
        print('   ✓ links entre volumes apontam para arquivos e destinos existentes')
    for u in sorted(urls):
        print('     URL:', u)
sys.exit(1 if falhas else 0)
