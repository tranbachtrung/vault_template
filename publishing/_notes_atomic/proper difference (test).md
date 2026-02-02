---
aliases:
  - strict difference
type: definition
created: 2026-01-29 16:46:35
edited: 2026-01-29
reference: 
---
## Definition: proper difference
Let $A$ and $B$ be sets. A set difference $A\backslash B = A \cap B^c$ and $B$ is a proper (or strict) subset of $A$, i.e., $B \subset A$ (or $B \subsetneq A$).

```tikz
\begin{document}
\begin{tikzpicture}
  \draw (0,0) circle (1.75cm);
  \draw (0.5,0) circle (1cm);
  \fill[gray!30, even odd rule] (0,0) circle (1.74cm) (0.5,0) circle (1cm);
  \node at (-2,0) {$A$};
  \node at (-1.1,0) {$A \setminus B$};
  \node at (0.5,0) {$B$};
\end{tikzpicture}
\end{document}
```


## Examples


## Counter-Examples


## Notes



