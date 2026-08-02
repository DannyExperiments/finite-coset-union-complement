# A sharp complement bound for non-full unions of cosets

## Theorem

Let \(G\) be a finite group. Let \(C_1,\ldots,C_n\) be arbitrary left or
right cosets of subgroups of \(G\), and assume

\[
U=C_1\cup\cdots\cup C_n\ne G.
\]

Then

\[
\lvert G\setminus U\rvert\ge \frac{\lvert G\rvert}{2^n}.
\]

## Proof

Set

\[
A=G\setminus U,\qquad m=\lvert A\rvert,\qquad N=\lvert G\rvert.
\]

The hypothesis \(U\ne G\) makes \(A\) nonempty. Choose \(t\in A\) and
left-translate all sets by \(t^{-1}\). This preserves cardinalities and puts
the identity \(1\) in the translated complement.

A left translate of a left coset is again a left coset. If \(Ha\) is a right
coset, then

\[
t^{-1}Ha=(t^{-1}Ht)(t^{-1}a)
\]

is a right coset of the conjugate subgroup \(t^{-1}Ht\); and every right coset
\(Kb\) can be written as the left coset

\[
Kb=b(b^{-1}Kb).
\]

We may therefore write every translated coset as

\[
C_i=a_iH_i
\]

and assume \(1\in A\).

For each \(i\), choose an injection

\[
\lambda_i:G/H_i\longrightarrow\mathbb Q.
\]

Such an injection exists because \(G/H_i\) is finite. Index rows and columns
by elements of \(G\), and define

\[
M_i(x,y)=\lambda_i(yH_i)-\lambda_i(xa_iH_i).
\]

The first term depends only on \(y\), and the second only on \(x\), so \(M_i\)
is the difference of two rank-one matrices. Hence

\[
\operatorname{rank}M_i\le 2.
\]

Injectivity of \(\lambda_i\) gives the exact zero condition

\[
\begin{aligned}
M_i(x,y)=0
&\iff yH_i=xa_iH_i\\
&\iff x^{-1}y\in a_iH_i\\
&\iff x^{-1}y\in C_i.
\end{aligned}
\]

Now form the entrywise, or Hadamard, product

\[
M=M_1\circ M_2\circ\cdots\circ M_n.
\]

Write each \(M_i\) as the sum of two rank-one matrices. Distributing the
Hadamard product produces at most \(2^n\) terms, and the Hadamard product of
rank-one matrices is again rank at most one. Therefore

\[
\operatorname{rank}M\le 2^n.
\]

For fixed \(x\in G\),

\[
\begin{aligned}
M(x,y)\ne0
&\iff M_i(x,y)\ne0\quad\text{for all }i\\
&\iff x^{-1}y\notin C_i\quad\text{for all }i\\
&\iff x^{-1}y\in A\\
&\iff y\in xA.
\end{aligned}
\]

Thus the support of row \(x\) is exactly \(xA\), so every row contains exactly
\(m\) nonzero entries. Moreover, \(1\in A\), so

\[
M(x,x)\ne0
\]

for every \(x\in G\).

We finish with a sparse-diagonal rank lemma.

### Lemma

If an \(N\times N\) matrix has nonzero diagonal and at most \(m\) nonzero
entries in each row, then its rank \(r\) satisfies

\[
r\ge \frac Nm.
\]

### Proof of the lemma

Choose \(r\) rows forming a basis for the row space. Their supports together
contain at most \(rm\) columns. They must meet every column: otherwise a
column vanishes on all basis rows and therefore on every row, contradicting
the nonzero diagonal entry in that column. Hence \(N\le rm\), proving the
lemma.

Applying the lemma to \(M\) gives

\[
\frac{\lvert G\rvert}{\lvert A\rvert}
\le \operatorname{rank}M
\le 2^n.
\]

Therefore

\[
\lvert A\rvert\ge\frac{\lvert G\rvert}{2^n}.
\]

Since \(A=G\setminus U\), this is the claimed bound. For \(n=0\), the result
is immediate because \(U=\varnothing\).

## Sharpness

Let \(K\) be any finite group and set

\[
G=K\times(\mathbb Z/2\mathbb Z)^n.
\]

For \(1\le i\le n\), let \(C_i\) be the coset consisting of elements whose
\(i\)-th binary coordinate is \(1\). Then

\[
G\setminus\bigcup_{i=1}^n C_i
=K\times\{0\}^n,
\]

and hence

\[
\left|G\setminus\bigcup_{i=1}^n C_i\right|
=\frac{\lvert G\rvert}{2^n}.
\]

Thus the constant is best possible.
