#!/usr/bin/env python3
"""Testador de conteúdo: confere a estrutura pedagógica de cada capítulo.

Verifica, para cada tex/v*/v*c*.tex:
  * presença das seções obrigatórias (teoria, Dicas e macetes, \\secaoenem, \\secaoineditas);
  * questões oficiais em ordem crescente de b e sem repetição entre capítulos;
  * inéditas com níveis não decrescentes, começando em 1 e chegando a 4;
  * uma resolução por questão; distribuição de gabaritos das inéditas;
  * número mínimo de caixas (dica, macete, atencao, exemplo, resumo).
Uso: python3 scripts/check_conteudo.py [--estrito]
"""
import glob, json, os, re, sys, collections

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
bank = {q['id']: q for q in json.load(open(os.path.join(ROOT, 'data', 'banco_enem_mt.json')))}
cl = {c['id']: c for c in json.load(open(os.path.join(ROOT, 'data', 'classificacao.json')))}
caps = json.load(open(os.path.join(ROOT, 'data', 'capitulos.json')))
ordem = [c[0] for v in caps.values() for c in v['capitulos']]

problemas = []
avisos = []
usadas = collections.defaultdict(list)
resumo = []

for cid in ordem:
    path = os.path.join(ROOT, 'tex', cid[:2], cid + '.tex')
    if not os.path.exists(path):
        problemas.append(f'{cid}: arquivo ausente')
        continue
    src = open(path, encoding='utf-8').read()
    src_nc = re.sub(r'(?<!\\)%.*', '', src)
    if not src_nc.lstrip().startswith('\\capitulo{%s}' % cid):
        problemas.append(f'{cid}: não começa com \\capitulo{{{cid}}}')
    for marca in ('\\section{Dicas e macetes}', '\\secaoenem', '\\secaoineditas'):
        if marca not in src_nc:
            problemas.append(f'{cid}: falta {marca}')
    pos_dicas = src_nc.find('\\section{Dicas e macetes}')
    n_teoria = len(re.findall(r'\\section\{', src_nc[:pos_dicas])) if pos_dicas > 0 else 0
    if n_teoria < 2:
        avisos.append(f'{cid}: só {n_teoria} seção(ões) de teoria antes de Dicas e macetes')
    cont = {k: len(re.findall(r'\\begin\{%s\}' % k, src_nc)) for k in
            ('dica', 'macete', 'atencao', 'exemplo', 'resumo', 'definicao', 'tikzpicture')}
    for k, mn in (('dica', 3), ('macete', 2), ('atencao', 2), ('exemplo', 3), ('resumo', 1)):
        if cont[k] < mn:
            avisos.append(f'{cid}: {cont[k]} {k} (mínimo sugerido {mn})')
    enem = re.findall(r'\\questaoenem\{([0-9]{4}-[0-9]{3})\}', src_nc)
    for q in enem:
        usadas[q].append(cid)
        if q not in bank:
            problemas.append(f'{cid}: questão {q} não existe no banco')
        elif bank[q]['anulada']:
            problemas.append(f'{cid}: questão {q} é anulada')
    bs = [bank[q]['param_b'] for q in enem if q in bank]
    if bs != sorted(bs):
        problemas.append(f'{cid}: oficiais fora da ordem crescente de b: ' +
                         ', '.join(f'{q}({bank[q]["param_b"]:.2f})' for q in enem))
    ined = re.findall(r'\\begin\{questaoinedita\}\{(\d)\}\{(\d+)\}', src_nc)
    niveis = [int(n) for n, _ in ined]
    if niveis != sorted(niveis):
        problemas.append(f'{cid}: níveis das inéditas fora de ordem: {niveis}')
    if niveis and (niveis[0] != 1 or niveis[-1] != 4):
        avisos.append(f'{cid}: inéditas deveriam ir do nível 1 ao 4: {niveis}')
    for _, h in ined:
        if not 1 <= int(h) <= 30:
            problemas.append(f'{cid}: habilidade inválida H{h}')
    res = re.findall(r'\\begin\{resolucao\}\{([A-E])\}', src_nc)
    if len(res) != len(enem) + len(ined):
        problemas.append(f'{cid}: {len(enem) + len(ined)} questões e {len(res)} resoluções')
    # gabaritos das inéditas: resoluções que vêm logo após cada inédita
    gab_ined = re.findall(r'\\end\{questaoinedita\}\s*\\begin\{resolucao\}\{([A-E])\}', src_nc)
    dist = collections.Counter(gab_ined)
    if gab_ined and max(dist.values()) > max(2, len(gab_ined) // 2):
        avisos.append(f'{cid}: gabaritos das inéditas concentrados: {dict(dist)}')
    n_dist = len(re.findall(r'\\begin\{distratores\}', src_nc))
    if n_dist < len(res):
        avisos.append(f'{cid}: {len(res) - n_dist} resolução(ões) sem análise de distratores')
    if len(enem) + len(ined) < 10:
        avisos.append(f'{cid}: apenas {len(enem) + len(ined)} questões no total')
    fora = [q for q in enem if q in cl and cl[q]['primario'] != cid and cl[q].get('secundario') != cid]
    if fora:
        avisos.append(f'{cid}: oficiais classificadas em outro conteúdo: {fora}')
    resumo.append((cid, len(enem), len(ined), niveis,
                   ' '.join(f'{bank[q]["param_b"]:.2f}' for q in enem if q in bank), cont['tikzpicture']))

for q, cs in usadas.items():
    if len(cs) > 1:
        problemas.append(f'questão {q} usada em mais de um capítulo: {cs}')

print('capítulo  oficiais  inéditas  níveis inéditas      b das oficiais            figuras')
for cid, ne, ni, nv, bs, nf in resumo:
    print(f'{cid:9} {ne:^8} {ni:^8}  {str(nv):20} {bs:30} {nf}')
print(f'\nTotal: {sum(r[1] for r in resumo)} oficiais e {sum(r[2] for r in resumo)} inéditas.')
print(f'\nPROBLEMAS ({len(problemas)}):')
for p in problemas:
    print('  ✗', p)
print(f'\nAVISOS ({len(avisos)}):')
for a in avisos:
    print('  !', a)
if '--estrito' in sys.argv and problemas:
    sys.exit(1)
