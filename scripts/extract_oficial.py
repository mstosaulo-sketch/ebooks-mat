#!/usr/bin/env python3
"""Recorta as questões de Matemática (136–180) dos cadernos oficiais do INEP.

Para cada questão gera um PDF vetorial (uma página por trecho de coluna), com
o conteúdo fora do recorte removido, além de uma prévia PNG e do texto extraído.

Uso:
  python3 scripts/extract_oficial.py <dir_provas> <dir_saida_pdf> <dir_previas>

<dir_provas> deve conter <ano>.pdf (caderno AZUL do 2.º dia de cada ano).
Saídas: <dir_saida_pdf>/<ano>-<q>.pdf e <dir_saida_pdf>/index.json
"""
import json, os, re, sys
import pymupdf

src, out, prev = sys.argv[1:4]
YEARS = set(int(y) for y in sys.argv[4].split(',')) if len(sys.argv) > 4 else None
os.makedirs(out, exist_ok=True)
os.makedirs(prev, exist_ok=True)

HEAD_RE = re.compile(r'^\s*(QUEST[ÃA]O|Quest[ãa]o)\s*(\d{2,3})\b')
FOOT_RE = re.compile(r'(CADERNO|Caderno)\s*\d|P[ÁA]GINA|Página|ENEM\s?20\d\d|^\s*\*.*\*\s*$|2[ºo°]\s*DIA|MT\s*[-–]\s*2', re.I)
SHARED_RE = re.compile(r'(?:Texto|TEXTO)\s+(?:para|PARA)\s+(?:as|AS)\s+(?:quest[õo]es|QUEST[ÕO]ES)\s+(\d{3})\s*(?:e|a|E|A)\s*(\d{3})')
TITLE_RE = re.compile(r'MATEM[ÁA]TICA E SUAS TECNOLOGIAS|Quest[õo]es de 136 a 180|QUEST[ÕO]ES DE 136 A 180', re.I)


def lines_of(page):
    d = page.get_text('dict')
    res = []
    for b in d['blocks']:
        if b['type'] == 1:
            res.append(('img', pymupdf.Rect(b['bbox']), '', 0))
            continue
        for l in b['lines']:
            t = ''.join(s['text'] for s in l['spans'])
            size = max((s['size'] for s in l['spans']), default=0)
            res.append(('txt', pymupdf.Rect(l['bbox']), t, size))
    for dr in page.get_drawings():
        r = pymupdf.Rect(dr['rect'])
        res.append(('drw', r, '', 0))
    return res


def page_limits(page, items):
    """Limites verticais do miolo (exclui cabeçalho e rodapé)."""
    H = page.rect.height
    top, bot = 0.0, H
    for kind, r, t, _ in items:
        if kind != 'txt' or not t.strip():
            continue
        numero = re.match(r'^\s*\d{1,2}\s*$', t)
        forte = FOOT_RE.search(t) and not numero
        if r.y1 < 0.12 * H and (forte or TITLE_RE.search(t) or (numero and r.y1 < 0.05 * H)):
            top = max(top, r.y1)
        if (r.y0 > 0.90 * H and forte) or (numero and r.y0 > 0.95 * H):
            bot = min(bot, r.y0)
    return top, bot


def main():
    index = {}
    for fn in sorted(os.listdir(src)):
        m = re.match(r'^(\d{4})\.pdf$', fn)
        if not m:
            continue
        year = int(m.group(1))
        if YEARS and year not in YEARS:
            continue
        doc = pymupdf.open(os.path.join(src, fn))
        heads = []
        pages = {}
        for pno, page in enumerate(doc):
            items = lines_of(page)
            top, bot = page_limits(page, items)
            pages[pno] = (items, top, bot)
            mid = page.rect.width / 2
            for kind, r, t, _ in items:
                if kind != 'txt':
                    continue
                col = 0 if r.x0 < mid else 1
                hm = HEAD_RE.match(t)
                if hm and 136 <= int(hm.group(2)) <= 180:
                    heads.append((pno, col, r.y0, r.y1, int(hm.group(2)), None))
                    continue
                sm = SHARED_RE.search(t)
                if sm and 136 <= int(sm.group(1)) <= 180:
                    # texto compartilhado: inclui a própria linha no recorte
                    heads.append((pno, col, r.y0, r.y0 - 1.5, 0, (int(sm.group(1)), int(sm.group(2)))))
        heads.sort(key=lambda h: (h[0], h[1], h[2]))
        seen, hs = set(), []
        for h in heads:
            key = h[4] if h[4] else ('S',) + h[5]
            if key not in seen:
                seen.add(key); hs.append(h)
        heads = hs
        reais = [h[4] for h in heads if h[4]]
        assert reais == list(range(136, 181)), (year, reais)

        def segmentos(k):
            pno, col, hy0, hy1, qn, rng = heads[k]
            nxt = heads[k + 1] if k + 1 < len(heads) else None
            segs = []
            cur_p, cur_c, ystart = pno, col, hy1 + 1
            while True:
                page = doc[cur_p]
                items, top, bot = pages[cur_p]
                W = page.rect.width
                mid = W / 2
                ys0 = max(ystart, top)
                prox = min([hh[2] for hh in heads if hh[0] == cur_p and hh[2] > ys0 + 1] + [bot])
                full = any(kind == 'txt' and t.strip() and r.y0 >= ys0 - 0.5 and r.y1 <= prox + 0.5
                           and r.x0 < mid - 30 and r.x1 > mid + 30 for kind, r, t, _ in items)
                if full:
                    x0c, x1c = 0, W
                    if nxt and nxt[0] == cur_p and nxt[2] > ys0:
                        yend = nxt[2] - 1
                        last = True
                    else:
                        yend = bot
                        last = False
                else:
                    x0c, x1c = (0, mid) if cur_c == 0 else (mid, W)
                    if nxt and (nxt[0], nxt[1]) == (cur_p, cur_c):
                        yend = nxt[2] - 1
                        last = True
                    else:
                        yend = bot
                        last = False
                ys = max(ystart, top)
                content = []
                for kind, r, t, _ in items:
                    if kind == 'drw' and r.width < 3 and r.height > 0.3 * page.rect.height:
                        continue
                    if kind == 'drw' and (r.width > 0.9 * W or r.height > 0.9 * page.rect.height):
                        continue
                    if kind == 'txt' and not t.strip():
                        continue
                    cx = (r.x0 + r.x1) / 2
                    if not (x0c <= cx <= x1c):
                        continue
                    if r.y0 >= ys - 0.5 and r.y1 <= yend + 0.5:
                        if kind == 'txt' and TITLE_RE.search(t):
                            continue
                        content.append(r)
                if content:
                    bb = pymupdf.Rect(content[0])
                    for r in content[1:]:
                        bb |= r
                    bb = pymupdf.Rect(max(bb.x0 - 2, x0c), max(bb.y0 - 2, ys - 1),
                                      min(bb.x1 + 2, x1c), min(bb.y1 + 2, yend))
                    if bb.height > 4:
                        segs.append((cur_p, bb))
                if last or nxt is None:
                    break
                if full:
                    cur_p += 1; cur_c = 0
                elif cur_c == 0:
                    cur_c = 1
                else:
                    cur_p += 1; cur_c = 0
                ystart = 0
                if cur_p >= len(doc) or len(segs) > 4:
                    break
            return segs

        shared = []
        for k, h in enumerate(heads):
            if not h[4]:
                shared.append((h[5], segmentos(k)))
        for k, h in enumerate(heads):
            qn = h[4]
            if not qn:
                continue
            segs = []
            for (a, b), ss in shared:
                if a <= qn <= b:
                    segs += ss
            segs += segmentos(k)
            qid = f'{year}-{qn}'
            new = pymupdf.open()
            texts = []
            sizes = []
            for (p, bb) in segs:
                tmp = pymupdf.open()
                tmp.insert_pdf(doc, from_page=p, to_page=p)
                tp = tmp[0]
                pr = tp.rect
                for r in (pymupdf.Rect(0, 0, pr.width, bb.y0), pymupdf.Rect(0, bb.y1, pr.width, pr.height),
                          pymupdf.Rect(0, bb.y0, bb.x0, bb.y1), pymupdf.Rect(bb.x1, bb.y0, pr.width, bb.y1)):
                    if r.height > 0.1 and r.width > 0.1:
                        tp.add_redact_annot(r)
                tp.apply_redactions(images=pymupdf.PDF_REDACT_IMAGE_REMOVE,
                                    graphics=pymupdf.PDF_REDACT_LINE_ART_REMOVE_IF_COVERED,
                                    text=pymupdf.PDF_REDACT_TEXT_REMOVE)
                np_ = new.new_page(width=bb.width, height=bb.height)
                np_.show_pdf_page(np_.rect, tmp, 0, clip=bb)
                tmp.close()
                texts.append(doc[p].get_text('text', clip=bb))
                for kind, r, t, sz in pages[p][0]:
                    if kind == 'txt' and bb.contains(r) and sz:
                        sizes.append(round(sz, 1))
            new.save(os.path.join(out, qid + '.pdf'), garbage=4, deflate=True, clean=True)
            # prévia
            pv = pymupdf.open(os.path.join(out, qid + '.pdf'))
            pix_list = [pg.get_pixmap(dpi=110) for pg in pv]
            if pix_list:
                Wp = max(px.width for px in pix_list); Hp = sum(px.height for px in pix_list) + 8 * (len(pix_list) - 1)
                canvas = pymupdf.Pixmap(pymupdf.csRGB, pymupdf.IRect(0, 0, Wp, Hp), False)
                canvas.set_rect(canvas.irect, (255, 255, 255))
                y = 0
                for px in pix_list:
                    if px.alpha:
                        px = pymupdf.Pixmap(px, 0)
                    if px.colorspace and px.colorspace.n != 3:
                        px = pymupdf.Pixmap(pymupdf.csRGB, px)
                    px.set_origin(0, y)
                    canvas.copy(px, px.irect)
                    y += px.height + 8
                canvas.save(os.path.join(prev, qid + '.png'))
            body = max(set(sizes), key=sizes.count) if sizes else 10.0
            index[qid] = {
                'ano': year, 'questao': qn,
                'segmentos': [{'pagina_original': p + 1, 'largura': round(bb.width, 1), 'altura': round(bb.height, 1)}
                              for p, bb in segs],
                'fonte_pt': body,
                'texto': '\n'.join(texts),
            }
        print(year, 'ok', sum(1 for q in index if q.startswith(str(year))), flush=True)
        json.dump({k: v for k, v in index.items() if v['ano'] == year},
                  open(os.path.join(out, f'index-{year}.json'), 'w'), ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main()
