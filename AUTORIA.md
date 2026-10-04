# Guia de autoria — Coleção Escala TRI (Matemática ENEM)

Este guia vale para todos os capítulos dos três volumes. Ele define a estrutura,
o padrão pedagógico, a calibragem de dificuldade (TRI) e a sintaxe LaTeX.

## 1. Arquivos

| O quê | Onde |
|---|---|
| Classe (design, caixas, questões, links) | `tex/enemebook.cls` |
| Capítulo | `tex/v<vol>/<id>.tex` — ex.: `tex/v1/v1c06.tex` |
| Catálogo de capítulos (ids, títulos, escopo) | `data/capitulos.json` |
| Banco de questões oficiais (INEP, 2009–2025) | `data/banco_enem_mt.json` |
| Candidatas do ENEM por capítulo, já ordenadas pelo parâmetro *b* | `data/candidatas/<id>.md` |
| Recorte oficial (PDF vetorial) de cada questão | `cache/oficial/<ano>-<q>.pdf` (gerado) |
| Prévia em imagem de cada questão oficial | ver caminho indicado em `data/candidatas/<id>.md` |
| Figuras próprias (opcional; prefira TikZ inline) | `tex/figuras/` |

Para conferir um capítulo isolado: `cd tex && ./compilar-capitulo.sh v1c06`.
O script mostra erros, caixas estouradas e o número de páginas; o PDF sai em
`tex/_cap-v1c06.pdf` (pode ser renderizado com `pdftoppm -r 70 -png`).

## 2. Estrutura obrigatória de cada capítulo

```latex
\capitulo{v1c06}            % abre o capítulo (título, abertura, abas, progresso)

\section{...}               % 2 a 4 seções de TEORIA (explicação)
  ... texto, definicao, exemplo (com \solucao), formula, contexto ...

\section{Dicas e macetes}   % seção própria, sempre com este título
  ... 3–5 dica, 2–4 macete, 2–3 atencao (pegadinhas), 1 resumo no final ...

\secaoenem                  % "Questões de edições anteriores"
  \questaoenem{2019-142}    % 5 a 6 questões oficiais, ORDEM CRESCENTE de b
  \begin{resolucao}{C} ... \end{resolucao}
  ...

\secaoineditas              % "Questões inéditas"
  \begin{questaoinedita}{1}{16} ... \end{questaoinedita}   % 5 a 6, nível 1 → 4
  \begin{resolucao}{B} ... \end{resolucao}
  ...
```

* Não use `\chapter`, `\section*`, `\documentclass`, `\begin{document}` nem `\usepackage`.
* As resoluções são escritas **logo depois** de cada questão, mas a classe as
  imprime automaticamente no fim do capítulo (seção “Resoluções comentadas”),
  com links de ida e volta e o gabarito rápido.
* Meta de tamanho: 14 a 24 páginas por capítulo compilado.

## 3. Teoria (explicação)

* Linguagem clara, direta, em português do Brasil, falando com o estudante (“você”).
* Comece pelo **porquê** (situação real típica do ENEM) e só depois formalize.
* Em cada seção de teoria: conceito → exemplo resolvido → ligação com o ENEM.
* Pelo menos **3 exemplos resolvidos** (`exemplo` + `\solucao`) no capítulo,
  graduados do simples ao típico de prova.
* Use figuras em TikZ/pgfplots sempre que ajudarem (gráficos, figuras geométricas,
  diagramas de árvore, retas numéricas). Capítulos de geometria e funções devem
  ter várias figuras.
* Notação brasileira: vírgula decimal (`3,5` funciona em modo matemático graças
  ao pacote icomma), `\num{1234,5}`, `\SI{12}{\km\per\hour}`, `R\$~25,00`.

### Caixas disponíveis

| Ambiente | Uso |
|---|---|
| `\begin{definicao}[título opcional]` | conceito/definição formal |
| `\begin{exemplo}[título] enunciado \solucao resolução \end{exemplo}` | exemplo resolvido |
| `\begin{formula}[título opcional]` | fórmula-chave em destaque (centralizada) |
| `\begin{dica}[título]` | **Dica ENEM** — estratégia de leitura/prova |
| `\begin{macete}[título]` | **Macete** — atalho de cálculo ou raciocínio rápido |
| `\begin{atencao}[título]` | **Pegadinha** — erro comum, armadilha de distrator |
| `\begin{contexto}[título]` | **No mundo real** — aplicação/curiosidade |
| `\begin{resumo}` | **Resumo para a prova** (um por capítulo, no fim de “Dicas e macetes”) |

Macros úteis: `\chip{ebookPrim}{texto}`, `\passo{título}`, `\resposta{texto}`,
`\fonte{texto da fonte}`, cores `ebookPrim`, `ebookAcc`, `nivelA..nivelD`.

## 4. Questões oficiais (`\questaoenem`)

* Escolha **5 ou 6** questões em `data/candidatas/<id>.md`. O arquivo já vem
  ordenado pelo parâmetro *b* (dificuldade TRI oficial do INEP).
* Cubra a escala: de preferência pelo menos uma Fácil (b < 1), Médias (1 ≤ b < 2),
  Difíceis (2 ≤ b < 3) e, se houver, uma Muito difícil (b ≥ 3). Prefira anos
  variados e inclua questões recentes (2022–2025) quando existirem.
* Mantenha **ordem crescente de b** no capítulo (a lista já está nessa ordem).
* **Abra a prévia em imagem** de cada questão escolhida (ferramenta Read) e
  resolva-a de verdade antes de escrever. O enunciado é inserido automaticamente
  pelo recorte vetorial do caderno oficial — não transcreva o enunciado.
* O gabarito no `\begin{resolucao}{X}` é conferido pela classe contra o gabarito
  oficial: se divergir, a compilação falha com “GABARITO DIVERGENTE”.
* Não use questões anuladas (elas não aparecem nas listas de candidatas).
* Evite questões cujo foco principal seja de outro capítulo (há a coluna “secundário”).

## 5. Questões inéditas (`questaoinedita`)

`\begin{questaoinedita}{<nível 1–4>}{<habilidade 1–30>}` … `\end{questaoinedita}`

* **5 ou 6** questões **originais** (não copie nem parafraseie questões reais),
  no estilo ENEM: texto-base contextualizado (situação do cotidiano, ciência,
  economia, esporte, saúde…), comando claro e 5 alternativas.
* **Níveis em ordem não decrescente**, começando em 1 e chegando a 4.
  Sugestão: 1, 2, 2, 3, 3, 4.
* Calibragem (use as questões oficiais do capítulo como referência):
  - **Nível 1 · Fácil (≈ b < 1):** aplicação direta de um conceito, 1 passo,
    leitura simples, dados explícitos.
  - **Nível 2 · Média (≈ 1 ≤ b < 2):** 2–3 passos, exige interpretar o contexto
    ou uma tabela/gráfico, cálculo moderado.
  - **Nível 3 · Difícil (≈ 2 ≤ b < 3):** vários passos, combina dois conceitos,
    distratores construídos a partir de erros frequentes, informação “escondida”
    no texto.
  - **Nível 4 · Muito difícil (≈ b ≥ 3):** modelagem não óbvia, integração de
    conteúdos, raciocínio inverso ou de otimização, texto longo, armadilhas sutis.
* Alternativas com `\begin{alternativas} \item ... \end{alternativas}` ou, para
  respostas curtas, `\begin{alternativas*}[5]` (colunas; use 2, 3 ou 5).
* **Exatamente uma** alternativa correta. **Cada distrator deve corresponder a um
  erro plausível** (esquecer uma etapa, inverter razão, somar porcentagens etc.).
* Distribua o gabarito entre A–E (não repita a mesma letra em todas).
* Verifique numericamente cada inédita (pode usar `python3` para conferir contas).
* Figuras das inéditas: TikZ/pgfplots dentro do enunciado.

## 6. Resoluções (`resolucao`)

Toda questão (oficial ou inédita) tem uma resolução comentada completa:

```latex
\begin{resolucao}{C}
\passo{1. Entendendo o problema.} O que o enunciado dá e o que pede...
\passo{2. Montando a conta.} ...
\passo{3. Calculando.} ...
\resposta{alternativa C — 25\%.}
\begin{distratores}
\alt{A} Erro de quem ... (mostre de onde sai o número)
\alt{B} ...
\alt{D} ...
\alt{E} ...
\end{distratores}
\end{resolucao}
```

* Explique o raciocínio, não só as contas. Mostre o caminho mais eficiente e,
  quando valer a pena, cite o macete do capítulo que acelera a resolução.
* `distratores`: explique **as quatro** alternativas erradas (qual erro leva a cada
  uma). Se uma alternativa errada não vier de um erro identificável, diga
  brevemente por que ela não é possível.
* Para as oficiais, sempre que útil, comente em uma frase por que o item tem a
  dificuldade que tem (ex.: “item difícil (b = 2,6): exige perceber que …”).

## 7. Qualidade e conferência

* Rigor matemático absoluto: confira cada número, unidade e arredondamento.
* Português correto (acentuação, crase, concordância).
* Compile com `./compilar-capitulo.sh <id>` até não haver erros nem caixas
  estouradas relevantes; renderize algumas páginas e confira o visual.
* Não altere `enemebook.cls`, arquivos em `tex/dados/` ou `tex/enem/`. Se precisar
  de um recurso novo, descreva-o no relatório final.
