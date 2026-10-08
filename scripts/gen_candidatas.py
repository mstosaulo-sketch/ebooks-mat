#!/usr/bin/env python3
"""Gera data/candidatas/<capítulo>.md: questões oficiais candidatas para cada capítulo,
ordenadas pelo parâmetro b da TRI (dificuldade crescente)."""
import json, os, re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
bank = {q['id']: q for q in json.load(open(os.path.join(ROOT, 'data', 'banco_enem_mt.json')))}
cl = json.load(open(os.path.join(ROOT, 'data', 'classificacao.json')))
caps = json.load(open(os.path.join(ROOT, 'data', 'capitulos.json')))
out = os.path.join(ROOT, 'data', 'candidatas')
os.makedirs(out, exist_ok=True)
NIV = {1: 'Fácil', 2: 'Média', 3: 'Difícil', 4: 'Muito difícil'}


def nivel(b):
    return 1 if b < 1 else 2 if b < 2 else 3 if b < 3 else 4


def texto(q):
    t = q['texto_oficial'] if q['texto_extraivel'] else (q['texto_transcricao_enemdev'] or '')
    t = re.sub(r'\s+', ' ', t).strip()
    return t[:700] + ('…' if len(t) > 700 else '')


for v, d in caps.items():
    for cid, tit, esc in d['capitulos']:
        prim = [c for c in cl if c['primario'] == cid and not bank[c['id']]['anulada']]
        sec = [c for c in cl if c.get('secundario') == cid and c['primario'] != cid and not bank[c['id']]['anulada']]
        L = [f'# Candidatas — {cid} · {tit}', '', f'Escopo: {esc}', '',
             'Ordenadas por b (dificuldade TRI oficial, crescente). Prévia da questão impressa: '
             '`/home/user/ebooks-mat/cache/previas/<id>.png`. Recorte usado no livro: `\\questaoenem{<id>}`.', '']
        for titulo, lista in (('Foco principal neste capítulo', prim), ('Foco secundário neste capítulo (use se couber)', sec)):
            L.append(f'## {titulo} ({len(lista)})')
            L.append('')
            for c in sorted(lista, key=lambda c: bank[c['id']]['param_b']):
                q = bank[c['id']]
                b = q['param_b']
                L.append(f"### {q['id']} · b = {b:.2f} (≈ {500 + 100 * b:.0f} pts) · {NIV[nivel(b)]} · H{q['habilidade']} · gabarito {q['gabarito']}"
                         + (' · figura essencial' if c.get('imagem_essencial') else '')
                         + (f" · primário: {c['primario']}" if c['primario'] != cid else ''))
                L.append(f"Resumo: {c.get('resumo')}")
                L.append(f"Texto (extraído{'' if q['texto_extraivel'] else ' da transcrição pública; confira na prévia'}): {texto(q)}")
                L.append('')
        open(os.path.join(out, cid + '.md'), 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print('ok')
