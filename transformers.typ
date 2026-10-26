#let title = "Present & Future of Transformer LLMs"
#let authors = ("Bartosz Hanc",)

#set page(paper: "a5", numbering: "1")
#set text(font: "Concrete Math")
#set par(justify: true)
#set heading(numbering: "1.")

#show math.equation: set text(font: "Concrete Math")

// #align(center, text(size: 17pt, strong(title)))
// #for author in authors { align(center, text(author)) }

= Introduction

== Learning as Likelihood Maximization

Let's start with a short overview of the general problem of learning from a set
of examples. We generally distinguish two main types of learning
problems---unsupervised and supervised.

In the unsupervised case, our dataset consists simply of unlabeled samples
$cal(D) = {bold(x)_1, ..., bold(x)_N}$, where $bold(x)_i in RR^d$. Our goal is to learn the underlying data distribution---a
task that we can broadly summarize as estimating the data density and being able to sample new, unseen examples
$bold(x)$ from this distribution:
$
  bold(x) ~ P(dot; bold(theta)) quad.
$

In the supervised case, our dataset consists of input-target pairs
$cal(D) = {(bold(x)_1, y_1), ..., (bold(x)_N, y_N)}$, where $bold(x)_i in RR^d$ is an input feature vector and $y_i$ is the corresponding label or target. Our goal is to predict the target $y$ for an unseen input $bold(x)$.

Both learning paradigms can be framed as likelihood maximization. Assuming the samples in our training set are independent and identically distributed (i.i.d.), the joint probability of observing the dataset under a model parameterized by $bold(theta)$ factors as a product over the individual examples:
$
  P(cal(D); bold(theta)) = product_(i=1)^N P(bold(x)_i; bold(theta)) quad "(unsupervised)"
$
or, in the case of pairs:
$
  P(cal(D); bold(theta)) = product_(i=1)^N P(bold(x)_i, y_i; bold(theta)) quad "(supervised)" quad.
$
In the supervised setting, we can factorize the joint distribution of each pair as:
$
  P(bold(x)_i, y_i; bold(theta)) = P(y_i | bold(x)_i; bold(theta)) dot P(bold(x)_i) quad.
$
When training discriminative models, we assume that the input marginal distribution $P(bold(x))$ does not depend on the model parameters $bold(theta)$. Taking the log-likelihood over the dataset $cal(D)$:
$
  log P(cal(D); bold(theta)) &= sum_(i=1)^N log P(bold(x)_i, y_i; bold(theta)) \
  &= sum_(i=1)^N log P(y_i | bold(x)_i; bold(theta)) + underbrace(sum_(i=1)^N log P(bold(x)_i), "const. w.r.t." bold(theta)) quad.
$
Therefore, maximizing the joint log-likelihood over $cal(D)$ with respect to $bold(theta)$ is mathematically equivalent to maximizing the *conditional* log-likelihood:
$
  bold(theta)^* = arg max_bold(theta) sum_(i=1)^N log P(y_i | bold(x)_i; bold(theta)) quad.
$
By convention, optimization problems in machine learning are formulated as minimizations rather than maximizations, and the objective is normalized by the dataset size $N$ so that its scale remains independent of the number of training samples. We therefore define the *loss function* as the sample-averaged negative conditional log-likelihood:
$
  L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N log P(y_i | bold(x)_i; bold(theta)) quad,
$
(or, in the unsupervised case, $L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N log P(bold(x)_i; bold(theta))$). Finding the maximum likelihood estimate is thus equivalent to minimizing this loss:
$
  bold(theta)^* = arg min_bold(theta) L(cal(D); bold(theta)) quad.
$

For certain simple problems, it is possible to find the minimizer $bold(theta)^*$
in closed form. In general, however---and especially for deep neural networks where the loss function is non-linear but differentiable with respect to $bold(theta)$---we must resort to gradient-based numerical optimization algorithms. The basic gradient descent update rule is:
$
  bold(theta)_(t+1) = bold(theta)_t - eta (partial L) / (partial bold(theta))(cal(D); bold(theta)_t) quad,
$
where $eta > 0$ is the learning rate. We will discuss modern variants of gradient descent used in deep learning later.

We will now derive expressions for the loss functions of typical supervised
learning tasks: regression, binary classification, and multiclass classification.

=== Regression

For a standard regression problem where $bold(x) in RR^d$ and target $y in RR$,
we assume a conditional Gaussian model:
$
  y | bold(x) ~ cal(N)(f(bold(x); bold(theta)), sigma^2) quad,
$
where $f(dot; bold(theta)): RR^d -> RR$ is a function parameterized by $bold(theta)$ (e.g., a neural network).
The loss function is therefore:
$
  L(cal(D); bold(theta), sigma) &= - 1 / N sum_(i=1)^N log {1 / sqrt(2 pi sigma^2) exp(- [y_i - f(bold(x)_i; bold(theta))]^2 / (2sigma^2))} \
  &= 1 / (2N sigma^2) sum_(i=1)^N [y_i - f(bold(x)_i; bold(theta))]^2 + 1 / 2 log (2pi sigma^2) quad.
$
Assuming fixed noise variance $sigma^2$, minimizing this loss with respect to $bold(theta)$ is strictly equivalent to minimizing the Mean Squared Error (MSE):
$
  L_"MSE" (cal(D); bold(theta)) = 1 / N sum_(i=1)^N [y_i - f(bold(x)_i; bold(theta))]^2 quad.
$

=== Binary Classification

For a binary classification problem where $bold(x) in RR^d$ and target label $y in {0, 1}$,
we assume a conditional Bernoulli model:
$
  y | bold(x) ~ "Ber"(pi(bold(x); bold(theta))) quad,
$
where $pi(bold(x); bold(theta)) = P(y = 1 | bold(x); bold(theta)) in [0, 1]$. The loss function (binary cross-entropy) is given by:
$
  L(cal(D); bold(theta)) &= - 1 / N sum_(i=1)^N log {pi(bold(x)_i; bold(theta))^(y_i) dot (1 - pi(bold(x)_i; bold(theta)))^(1 - y_i)} \
  &= - 1 / N sum_(i=1)^N { y_i log pi(bold(x)_i; bold(theta)) + (1 - y_i) log [1 - pi(bold(x)_i; bold(theta))]} quad.
$
To ensure that $pi(bold(x); bold(theta)) in [0, 1]$, we express $pi$ as the composition of the standard logistic sigmoid function $sigma: RR -> [0, 1]$ and an unconstrained scalar model output $f(bold(x); bold(theta)) in RR$ (called the logit):
$
  pi(bold(x); bold(theta)) = sigma(f(bold(x); bold(theta))) = 1 / (1 + exp(-f(bold(x); bold(theta)))) quad.
$
This choice is particularly appealing because:
$
  (d sigma) / (d z) = sigma(z) dot [1 - sigma(z)]
$
which yields a clean gradient with respect to the logit $f_i = f(bold(x)_i; bold(theta))$:
$
  (partial L) / (partial f_i) = 1 / N (pi_i - y_i) quad.
$

=== Multiclass Classification

For a multiclass classification problem where $bold(x) in RR^d$ and target label
$y in {1, ..., K}$, we assume a conditional Categorical model:
$
  y | bold(x) ~ "Cat"(pi_1 (bold(x); bold(theta)), ..., pi_K (bold(x); bold(theta))) quad,
$
where $bold(pi)(bold(x); bold(theta)): RR^d -> [0, 1]^K$ satisfies $sum_(k=1)^K pi_k (bold(x); bold(theta)) = 1$. The loss function (categorical cross-entropy) is:
$
  L(cal(D); bold(theta)) &= - 1 / N sum_(i=1)^N log { product_(k=1)^K pi_k (bold(x)_i; bold(theta))^[y_i = k] } \
  &= - 1 / N sum_(i=1)^N sum_(k=1)^K [y_i = k] log pi_k (bold(x)_i; bold(theta)) quad,
$
where $[dot]$ denotes the Iverson bracket. Writing the one-hot target component as $y_(i k) = [y_i = k]$, this becomes:
$
  L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N sum_(k=1)^K y_(i k) log pi_k (bold(x)_i; bold(theta)) quad.
$
To parameterize $bold(pi)$, we map $bold(x)$ to a vector of unnormalized scores (logits) $bold(f)(bold(x); bold(theta)) in RR^K$ followed by the softmax function:
$
  ["softmax"(bold(z))]_k = exp(z_k) / (sum_(j=1)^K exp(z_j)) quad,
$
which for numerical stability is computed as:
$
  ["softmax"(bold(z))]_k = exp(z_k - m) / (sum_(j=1)^K exp(z_j - m)) quad,
$
where $m = max_j z_j$ (ensuring that all exponential arguments are $<= 0$, avoiding numerical overflow).

This formulation leads to a particularly clean gradient with respect to the logit $f_(i k) = [bold(f)(bold(x)_i; bold(theta))]_k$:
$
  (partial L) / (partial f_(i k)) = 1 / N (pi_(i k) - y_(i k)) quad,
$
where $pi_(i k) = pi_k (bold(x)_i; bold(theta))$.
