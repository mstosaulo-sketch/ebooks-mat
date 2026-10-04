#!/usr/bin/env python3
"""Gera os arquivos LaTeX das questões oficiais e os metadados usados pela classe.

Saídas:
  tex/enem/<id>.tex           inclusão do recorte oficial (vetorial) da questão
  tex/dados/enem-meta.tex     \\enemdef{id}{ano}{questão}{caderno}{H}{a}{b}{c}{gabarito}\\enemniv{id}{nível}{pontos}
  tex/dados/capitulos.tex     \\voldef e \\capdef a partir de data/capitulos.json
  tex/dados/estatisticas.tex  \\capstats (a partir de data/classificacao.json)
"""
import json, os, collections

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BANK = os.path.join(ROOT, 'data', 'banco_enem_mt.json')
CAPS = os.path.join(ROOT, 'data', 'capitulos.json')
CLASS = os.path.join(ROOT, 'data', 'classificacao.json')
OUT_Q = os.path.join(ROOT, 'tex', 'enem')
OUT_D = os.path.join(ROOT, 'tex', 'dados')

ALVO_PT = 10.6      # tamanho visual desejado do corpo do texto oficial
MAX_W = 425.0       # largura útil dentro da caixa da questão (pt)
MAX_H = 560.0       # altura máxima de cada trecho (pt)


def nivel(b):
    if b is None:
        return 0
    if b < 1.0:
        return 1
    if b < 2.0:
        return 2
    if b < 3.0:
        return 3
    return 4


def pontos(b):
    if b is None:
        return '—'
    p = 500 + 100 * b
    if p > 1000:
        return 'acima de 1000 pontos (item atípico)'
    return f"≈\\,{round(p)} pontos"


def question_tex(q):
    L = [f"% ENEM {q['ano']} · questão {q['questao']} · caderno {q['caderno']} · gabarito {q['gabarito']}",
         '% Recorte vetorial do caderno oficial do INEP (gerado por scripts/gen_enem_tex.py).']
    fonte = q['fonte_pt'] or 10.0
    base = ALVO_PT / fonte
    for k, seg in enumerate(q['segmentos'], 1):
        s = min(base, MAX_W / seg['largura'], MAX_H / seg['altura'])
        L.append('\\enemseg{%s}{%d}{%.3f}' % (q['id'], k, s))
    return '\n'.join(L) + '\n'


def main():
    bank = json.load(open(BANK))
    caps = json.load(open(CAPS))
    os.makedirs(OUT_Q, exist_ok=True)
    os.makedirs(OUT_D, exist_ok=True)
    meta = ['% gerado por scripts/gen_enem_tex.py — não editar']
    for q in bank:
        if q['anulada']:
            continue
        open(os.path.join(OUT_Q, q['id'] + '.tex'), 'w', encoding='utf-8').write(question_tex(q))
        fmt = lambda x: ('%.2f' % x)
        meta.append('\\enemdef{%s}{%d}{%d}{%s}{%s}{%s}{%s}{%s}{%s}\\enemniv{%s}{%d}{%s}' % (
            q['id'], q['ano'], q['questao'], q['caderno'], q['habilidade'],
            fmt(q['param_a']), fmt(q['param_b']), fmt(q['param_c']), q['gabarito'],
            q['id'], nivel(q['param_b']), pontos(q['param_b'])))
    open(os.path.join(OUT_D, 'enem-meta.tex'), 'w', encoding='utf-8').write('\n'.join(meta) + '\n')

    capl = ['% gerado por scripts/gen_enem_tex.py — não editar']
    shorts = {'v1': 'Números, Contagem e Estatística', 'v2': 'Geometria e Medidas',
              'v3': 'Álgebra, Funções e Geometria Analítica'}
    for v, d in caps.items():
        n = int(v[1])
        capl.append('\\voldef{%d}{%s}{%s}' % (n, d['titulo'], shorts[v]))
        for k, (cid, tit, escopo) in enumerate(d['capitulos'], 1):
            esco = escopo[0].upper() + escopo[1:] + '.'
            capl.append('\\capdef{%s}{%d}{%d}{%s}{%s}' % (cid, n, k, tit, esco))
    open(os.path.join(OUT_D, 'capitulos.tex'), 'w', encoding='utf-8').write('\n'.join(capl) + '\n')

    if os.path.exists(CLASS):
        cl = {c['id']: c for c in json.load(open(CLASS))}
        byid = {q['id']: q for q in bank}
        stats = collections.defaultdict(lambda: [0, 0, 0, 0, 0])
        habs = collections.defaultdict(collections.Counter)
        anos = [q['ano'] for q in bank]
        for qid, c in cl.items():
            q = byid.get(qid)
            if not q or not c.get('primario') or q['anulada']:
                continue
            s = stats[c['primario']]
            s[0] += 1
            s[nivel(q['param_b'])] += 1
            habs[c['primario']][q['habilidade']] += 1
        st = ['% gerado por scripts/gen_enem_tex.py — não editar',
              '\\def\\anosbanco{%d–%d}' % (min(anos), max(anos))]
        for v, d in caps.items():
            for cid, _, _ in d['capitulos']:
                s = stats[cid]
                top = ''.join('\\habchip{%d}' % h for h, _ in habs[cid].most_common(4))
                st.append('\\capstats{%s}{%d}{%d}{%d}{%d}{%d}{%s}' % (cid, *s, top or '—'))
        open(os.path.join(OUT_D, 'estatisticas.tex'), 'w', encoding='utf-8').write('\n'.join(st) + '\n')
    print('ok')


if __name__ == '__main__':
    main()
