---
aliases: []
type: definition
created: 2026-01-29 16:45:35
edited: 2026-01-29
reference:
---
## Definition ([[Kal2021]], pg. 10): symmetric difference
The symmetric difference of $A$ and $B$ is given by
$$
A \triangle B = (A \backslash B) \cup (B \backslash A).
$$
Venn diagram of symmetric difference:
```tikz
\begin{document}
\begin{tikzpicture}
  \begin{scope}
    \clip (0,0) circle (1.5cm);
    \fill[gray!30, even odd rule] (1.2,0) circle (1.5cm) (0,0) circle (1.5cm);
  \end{scope}
  \begin{scope}
    \clip (1.2,0) circle (1.5cm);
    \fill[gray!30, even odd rule] (0,0) circle (1.5cm) (1.2,0) circle (1.5cm);
  \end{scope}

  \draw (0,0) circle (1.5cm);
  \draw (1.2,0) circle (1.5cm);

  \node at (-0.7,1.7) {$A$ (circle)};
  \node at (1.9,1.7) {$B$ (circle)};
  \node at (0.6,-2.0) {$A \triangle B$ (grey)};
\end{tikzpicture}
\end{document}
```
## Examples


## Counter-Examples


## Notes

