#!/usr/bin/env python3
"""Monta o banco de questões oficiais de Matemática do ENEM (2009–2025).

Fontes (todas do INEP):
  * Caderno AZUL do 2.º dia de cada ano (PDF oficial) — enunciados recortados
    por scripts/extract_oficial.py (texto + recortes vetoriais).
  * Microdados do ENEM, arquivo ITENS_PROVA_<ano>.csv — código do item,
    habilidade da Matriz, gabarito e parâmetros a, b, c da TRI.
  * Gabarito oficial do caderno (PDF), usado para identificar o código da
    prova (CO_PROVA) do caderno azul impresso nos microdados.

  * Transcrição pública enem.dev (2009–2023), guardada apenas como texto de
    apoio quando a extração do PDF oficial falha (fontes sem mapeamento Unicode, 2021).

Uso:
  python3 scripts/build_bank.py <dir_itens_csv> <dir_recortes> <dir_gabaritos> data/banco_enem_mt.json [dir_enemdev]
"""
import csv, glob, json, os, re, subprocess, sys, collections

itens_dir, recortes_dir, gab_dir, out = sys.argv[1:5]
enemdev_dir = sys.argv[5] if len(sys.argv) > 5 else os.path.join(gab_dir, '..', 'enemdev')
transc = {}
for y in range(2009, 2024):
    fn = os.path.join(enemdev_dir, f'{y}.json')
    if not os.path.exists(fn):
        continue
    for q in json.load(open(fn)):
        if 136 <= q['index'] <= 180 and not q.get('language'):
            transc[f"{y}-{q['index']}"] = ((q['context'] or '') + '\n' + (q['alternativesIntroduction'] or '') + '\n' +
                                           '\n'.join(f"{a['letter']}) {a['text'] or '[imagem]'}" for a in q['alternatives']))


def gabarito_pdf(path):
    t = subprocess.run(['pdftotext', '-layout', path, '-'], capture_output=True, text=True).stdout
    ans = {}
    if 'Gab_Azul' in t:  # 2009: quatro cadernos lado a lado; o azul é o 3.º par
        for ln in t.splitlines():
            pares = re.findall(r'(\d{2,3})\s+([A-E]|Anulad[oa])\b', ln)
            if len(pares) >= 3 and 136 <= int(pares[2][0]) <= 180:
                ans[int(pares[2][0])] = pares[2][1] if len(pares[2][1]) == 1 else 'X'
        return ans
    for m in re.finditer(r'\b(1[3-8]\d)\s+([A-E]|[Aa]nulad[ao])\b', t):
        q = int(m.group(1))
        if 136 <= q <= 180:
            ans[q] = m.group(2) if len(m.group(2)) == 1 else 'X'
    return ans


def provas_mt(year):
    rows = list(csv.DictReader(open(glob.glob(f"{itens_dir}/{year}_*")[0], encoding='latin-1'), delimiter=';'))
    provas = collections.defaultdict(dict)
    for r in rows:
        if r['SG_AREA'] != 'MT':
            continue
        pos = int(r['CO_POSICAO'])
        if pos <= 45:
            pos += 135
        provas[(r['CO_PROVA'], r['TX_COR'])][pos] = r
    return provas


def f(x):
    try:
        return round(float(x), 5)
    except (TypeError, ValueError):
        return None


recortes = {}
for fn in glob.glob(os.path.join(recortes_dir, 'index-*.json')):
    recortes.update(json.load(open(fn)))

bank = []
for year in range(2009, 2026):
    gab = gabarito_pdf(os.path.join(gab_dir, f'gb{year}.pdf'))
    provas = provas_mt(year)
    fallback = len(gab) < 40
    if fallback:  # gabarito em PDF ilegível (2010): identifica o caderno pela transcrição enem.dev
        tr = json.load(open(os.path.join(gab_dir, '..', 'enemdev', f'{year}.json')))
        gab = {q['index']: q['correctAlternative'] for q in tr if 136 <= q['index'] <= 180 and q.get('language') is None}
    azuis = [k for k in provas if k[1].upper() == 'AZUL']
    best = max(azuis, key=lambda k: sum(1 for q, g in gab.items() if q in provas[k] and provas[k][q]['TX_GABARITO'] == g))
    score = sum(1 for q, g in gab.items() if q in provas[best] and provas[best][q]['TX_GABARITO'] == g)
    print(year, 'CO_PROVA', best[0], f'{score}/{len(gab)}')
    for qn in range(136, 181):
        r = provas[best].get(qn)
        rec = recortes[f'{year}-{qn}']
        anulada = (gab.get(qn) == 'X') or (r is not None and r['IN_ITEM_ABAN'] == '1') or r is None \
            or f(r['NU_PARAM_B']) is None
        bank.append({
            'id': f'{year}-{qn}', 'ano': year, 'questao': qn, 'caderno': 'Azul',
            'co_prova': best[0], 'co_item': r and r['CO_ITEM'],
            'habilidade': int(r['CO_HABILIDADE']) if r and r['CO_HABILIDADE'] else None,
            'param_a': r and f(r['NU_PARAM_A']), 'param_b': r and f(r['NU_PARAM_B']),
            'param_c': r and f(r['NU_PARAM_C']),
            'gabarito': (r['TX_GABARITO'] if r and r['TX_GABARITO'] in 'ABCDE' else None) if fallback
                        else (gab.get(qn) if gab.get(qn) != 'X' else None),
            'gabarito_microdados': r and r['TX_GABARITO'],
            'anulada': anulada,
            'segmentos': rec['segmentos'], 'fonte_pt': rec['fonte_pt'],
            'texto_oficial': rec['texto'],
            'texto_extraivel': year != 2021,
            'texto_transcricao_enemdev': transc.get(f'{year}-{qn}'),
        })
json.dump(bank, open(out, 'w'), ensure_ascii=False, indent=1)
print(len(bank), 'questões;', sum(q['anulada'] for q in bank), 'anuladas/sem parâmetros')
print('gabarito PDF ≠ microdados:', [q['id'] for q in bank if not q['anulada'] and q['gabarito'] != q['gabarito_microdados']])
