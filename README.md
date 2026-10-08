# Matemática para o ENEM — Coleção Escala TRI

Três ebooks interativos (PDF) de Matemática para o ENEM, cobrindo todos os objetos de
conhecimento da Matriz de Referência do exame:

| Volume | Conteúdo | Arquivo |
|---|---|---|
| 1 | Números, Contagem, Estatística e Probabilidade (13 capítulos) | `dist/ENEM-Matematica-Volume-1.pdf` |
| 2 | Geometria e Medidas (12 capítulos) | `dist/ENEM-Matematica-Volume-2.pdf` |
| 3 | Álgebra, Funções e Geometria Analítica (11 capítulos) | `dist/ENEM-Matematica-Volume-3.pdf` |

Cada capítulo traz **teoria com exemplos resolvidos**, **dicas**, **macetes**, **pegadinhas**,
**questões oficiais do ENEM (2009–2025)** e **questões inéditas**, todas com resolução comentada
e análise das alternativas erradas.

## A dificuldade vem da TRI de verdade

As questões oficiais estão em ordem crescente de dificuldade segundo o **parâmetro *b* da Teoria
de Resposta ao Item**, publicado pelo INEP nos Microdados do ENEM. Cada questão mostra os
parâmetros *a*, *b* e *c* e a posição aproximada na escala de notas (500 + 100*b*):

| Selo | Parâmetro *b* | Escala aproximada |
|---|---|---|
| Fácil | b < 1 | < 600 |
| Média | 1 ≤ b < 2 | 600–700 |
| Difícil | 2 ≤ b < 3 | 700–800 |
| Muito difícil | b ≥ 3 | > 800 |

As questões inéditas seguem a mesma progressão (nível estimado e calibrado pelas oficiais).

## Interatividade (funciona em leitores de PDF)

- Sumário, marcadores (bookmarks) e abas laterais clicáveis por capítulo;
- botões de navegação no rodapé de todas as páginas (sumário, início do capítulo, resoluções,
  gabarito geral);
- links questão → resolução comentada → volta à questão; gabarito rápido clicável por capítulo;
- links entre volumes no mapa do edital (os três PDFs devem ficar na mesma pasta);
- cartão-resposta (A–E) em cada questão e checklist “Meu progresso” em cada capítulo (campos
  de formulário: Acrobat Reader, navegadores, Foxit, Okular).

## Como gerar os PDFs

Requisitos: TeX Live com LuaLaTeX (pacotes `texlive-latex-extra`, `texlive-fonts-extra`,
`texlive-pictures`, `texlive-science`, `texlive-lang-portuguese`), `latexmk`, `poppler-utils`,
`qpdf`, Python 3 com `pypdf`.

```bash
scripts/build.sh          # gera dist/ENEM-Matematica-Volume-{1,2,3}.pdf e roda os testes
scripts/build.sh 2        # só o volume 2
tex/compilar-capitulo.sh v1c06   # compila um capítulo isolado (tex/_cap-v1c06.pdf)
python3 scripts/check_conteudo.py   # testa a estrutura pedagógica dos capítulos
python3 scripts/check_pdf.py dist/*.pdf   # testa links, destinos, formulários e fontes
```

## Estrutura do repositório

| Caminho | O quê |
|---|---|
| `tex/enemebook.cls` | Classe LaTeX: design, caixas, questões com selo TRI, links e navegação |
| `tex/volume{1,2,3}.tex` | Arquivos principais de cada volume |
| `tex/comum/` | Páginas comuns: como usar, ENEM e TRI, mapa do edital, créditos |
| `tex/v{1,2,3}/` | Capítulos (um arquivo por capítulo) |
| `tex/enem/`, `tex/oficial/` | Inclusão dos recortes vetoriais das questões oficiais usadas |
| `tex/dados/` | Metadados gerados (capítulos, parâmetros TRI, estatísticas) |
| `data/banco_enem_mt.json` | Banco das 765 questões de Matemática (2009–2025) com TRI e gabarito |
| `data/classificacao.json` | Classificação de cada questão por capítulo |
| `data/candidatas/` | Questões candidatas por capítulo, ordenadas por *b* |
| `scripts/` | Extração dos recortes, montagem do banco, geração de dados, build e testes |
| `AUTORIA.md` | Guia de autoria (estrutura, calibragem de níveis, padrão das resoluções) |

## Reconstruir o banco a partir das fontes do INEP

1. Baixe o caderno azul do 2.º dia de cada ano (`<ano>.pdf`) e o gabarito (`gb<ano>.pdf`) em
   <https://www.gov.br/inep/pt-br/areas-de-atuacao/avaliacao-e-exames-educacionais/enem/provas-e-gabaritos>.
2. Extraia `ITENS_PROVA_<ano>.csv` dos microdados em
   <https://www.gov.br/inep/pt-br/acesso-a-informacao/dados-abertos/microdados/enem>.
3. Rode:

```bash
python3 scripts/extract_oficial.py <dir_provas> cache/oficial cache/previas
python3 scripts/build_bank.py <dir_itens_csv> cache/oficial <dir_provas> data/banco_enem_mt.json
python3 scripts/gen_enem_tex.py && python3 scripts/gen_candidatas.py
```

## Fontes e créditos

Questões oficiais, gabaritos, parâmetros da TRI e Matriz de Referência: INEP. Textos teóricos,
questões inéditas e resoluções foram elaborados para esta coleção com apoio de inteligência
artificial e revisados em várias etapas. Material independente, sem vínculo com o INEP/MEC.
