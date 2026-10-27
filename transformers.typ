// =============================================================================
// Monograph Outline: Modern Deep Learning: A Short Course
//
// 1. Learning as Likelihood Maximization
//    - Supervised and Unsupervised Learning
//    - Canonical Loss Functions
//    - Gradient-Based Optimization in High Dimensions
//
// 2. Neural Networks
//    - Multilayer Perceptrons
//    - The Computational Graph
//    - Forward Propagation
//    - Backward Propagation
//
// 3. Optimization and Initialization
//    - Weight Initialization and Variance Preservation
//    - Stochastic Gradient Descent
//    - Loss Landscape Geometry and Conditioning
//    - Momentum and Adaptive Step Sizes
//    - Decoupled Weight Decay
//
// 4. Attention and Transformers
//    - Permutation Equivariance and Set Operations
//    - Scaled Dot-Product Attention
//    - Normalization and Residual Connections
//    - Gated Feed-Forward Networks
//    - Representation Rank and Residual Dynamics
//
// 5. Autoregressive Sequence Models
//    - Joint Density Factorization
//    - Discrete Vocabularies and Token Embeddings
//    - Causal Masking
//    - Rotary Position Embeddings
//    - Key-Value Cache and Generation Dynamics
//    - Stochastic Decoding and Temperature Scaling
//
// 6. In-Context Learning and Prior-Data Fitted Networks
//    - In-Context Conditioning as Bayesian Inference
//    - Prior-Data Fitted Networks
//    - In-Context Gradient Steps and Activation Dynamics
// =============================================================================

#let title = "Modern Deep Learning: A Short Course"
#let authors = ("Bartosz Hanc",)

#set page(paper: "a5", numbering: "1")
#set text(font: "Concrete Math")
#set par(justify: true)
#set heading(numbering: "1.")

#show math.equation: set text(font: "Concrete Math")

#align(center, text(size: 17pt, strong(title)))
#for author in authors { align(center, text(author)) }

#outline()

// = Introduction

= Learning as Likelihood Maximization

Machine learning is fundamentally the task of inferring an unknown probability
distribution from a finite dataset $cal(D)$. Depending on whether the data
contain supervisory signals, we distinguish between two primary settings:
unsupervised and supervised learning.

In the unsupervised case, our dataset consists simply of unlabeled samples
$cal(D) = {bold(x)_1, ..., bold(x)_N}$, where $bold(x)_i in RR^d$. Our goal is
to learn the underlying data distribution---a task that we can broadly
summarize as estimating the data density and being able to sample new, unseen
examples $bold(x)$ from this distribution,
$
  bold(x) ~ P(dot; bold(theta)) quad.
$

In the supervised case, our dataset consists of input-target pairs
$cal(D) = {(bold(x)_1, y_1), ..., (bold(x)_N, y_N)}$, where
$bold(x)_i in RR^d$ is an input feature vector and $y_i$ is the corresponding
label or target. Our goal is to predict the target $y$ for an unseen input
$bold(x)$.

Both learning paradigms can be framed as likelihood maximization. Assuming the
samples in our training set are independent and identically distributed
(i.i.d.), the joint probability of observing the dataset under a model
parameterized by $bold(theta)$ factors as a product over individual examples,
$
  P(cal(D); bold(theta)) = product_(i=1)^N P(bold(x)_i; bold(theta))
    quad "(unsupervised)"
$
or, in the case of pairs,
$
  P(cal(D); bold(theta)) = product_(i=1)^N P(bold(x)_i, y_i; bold(theta))
    quad "(supervised)" quad.
$
In the supervised setting, we can factorize the joint distribution of each
pair as
$
  P(bold(x)_i, y_i; bold(theta)) =
    P(y_i | bold(x)_i; bold(theta)) P(bold(x)_i) quad.
$
When training discriminative models, we assume that the input marginal
distribution $P(bold(x))$ does not depend on the model parameters $bold(theta)$.
Taking the log-likelihood over the dataset $cal(D)$,
$
  log P(cal(D); bold(theta)) &= sum_(i=1)^N log P(bold(x)_i, y_i; bold(theta)) \
  &= sum_(i=1)^N log P(y_i | bold(x)_i; bold(theta)) +
    underbrace(sum_(i=1)^N log P(bold(x)_i), "const. w.r.t." bold(theta))
    quad.
$
Therefore, maximizing the joint log-likelihood over $cal(D)$ with respect to
$bold(theta)$ is mathematically equivalent to maximizing the *conditional*
log-likelihood,
$
  bold(theta)^* = arg max_bold(theta) sum_(i=1)^N
    log P(y_i | bold(x)_i; bold(theta)) quad.
$
By convention, optimization problems in machine learning are formulated as
minimizations rather than maximizations, and the objective is normalized by the
dataset size $N$ so that its scale remains independent of the number of
training samples. We therefore define the *loss function* as the
sample-averaged negative conditional log-likelihood,
$
  L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N
    log P(y_i | bold(x)_i; bold(theta)) quad,
$
(or, in the unsupervised case,
$L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N log P(bold(x)_i; bold(theta))$).
Finding the maximum likelihood estimate is thus equivalent to minimizing this
loss,
$
  bold(theta)^* = arg min_bold(theta) L(cal(D); bold(theta)) quad.
$

For certain simple problems, it is possible to find the minimizer
$bold(theta)^*$ in closed form. In general, however---and especially for deep
neural networks where the loss function is non-linear and high-dimensional---we
must resort to iterative numerical optimization. In such massive parameter
spaces, gradient-free search is rendered intractable by the curse of
dimensionality, making exact gradient information indispensable for pointing
in the direction of steepest descent. The basic gradient descent update rule is
$
  bold(theta)_(t+1) = bold(theta)_t - eta (partial L) / (partial bold(theta))
    (cal(D); bold(theta)_t) quad,
$
where $eta > 0$ is the learning rate. We will discuss modern variants of
gradient descent used in deep learning later.

We will now derive expressions for the loss functions of typical supervised
learning tasks: regression, binary classification, and multiclass
classification.

- *Regression (Mean Squared Error):* For a standard regression problem where
  $bold(x) in RR^d$ and target $y in RR$, we assume a conditional Gaussian
  model,
  $
    y | bold(x) ~ cal(N)(f(bold(x); bold(theta)), sigma^2) quad,
  $
  where $f(dot; bold(theta)): RR^d -> RR$ is parameterized by $bold(theta)$
  (e.g., a neural network). The loss function is therefore
  $
    L(cal(D); bold(theta), sigma) &= - 1 / N sum_(i=1)^N log {
      1 / sqrt(2 pi sigma^2) exp(- [y_i - f(bold(x)_i; bold(theta))]^2 /
      (2sigma^2))
    } \
    &= 1 / (2N sigma^2) sum_(i=1)^N [y_i - f(bold(x)_i; bold(theta))]^2 +
      1 / 2 log (2pi sigma^2) quad.
  $
  Assuming fixed noise variance $sigma^2$, minimizing this loss with respect to
  $bold(theta)$ is strictly equivalent to minimizing the Mean Squared Error
  (MSE),
  $
    L_"MSE" (cal(D); bold(theta)) = 1 / (2N) sum_(i=1)^N
      [y_i - f(bold(x)_i; bold(theta))]^2 quad,
  $
  which yields the gradient with respect to $f_i = f(bold(x)_i; bold(theta))$,
  $
    (partial L_"MSE") / (partial f_i) = 1 / N (f_i - y_i) quad.
  $

- *Binary Classification (Binary Cross-Entropy):* For a binary classification
  problem where $bold(x) in RR^d$ and target label $y in {0, 1}$, we assume a
  conditional Bernoulli model,
  $
    y | bold(x) ~ "Ber"(pi(bold(x); bold(theta))) quad,
  $
  where $pi(bold(x); bold(theta)) = P(y = 1 | bold(x); bold(theta)) in [0, 1]$.
  The loss function (binary cross-entropy) is given by
  $
    L (cal(D); bold(theta)) &= - 1 / N sum_(i=1)^N log {
      pi(bold(x)_i; bold(theta))^(y_i) dot
      (1 - pi(bold(x)_i; bold(theta)))^(1 - y_i)
    } \
    &= - 1 / N sum_(i=1)^N {
      y_i log pi(bold(x)_i; bold(theta)) +
      (1 - y_i) log [1 - pi(bold(x)_i; bold(theta))]
    } quad.
  $
  To ensure that $pi(bold(x); bold(theta)) in [0, 1]$, we express $pi$ as the
  composition of the standard logistic sigmoid function $sigma: RR -> [0, 1]$
  and an unconstrained scalar model output $f(bold(x); bold(theta)) in RR$
  (called the logit),
  $
    pi(bold(x); bold(theta)) = sigma(f(bold(x); bold(theta))) =
      1 / (1 + exp(-f(bold(x); bold(theta)))) quad.
  $
  This choice is particularly appealing because
  $
    (d sigma) / (d z) = sigma(z) dot [1 - sigma(z)]
  $
  which yields a clean gradient with respect to the logit
  $f_i = f(bold(x)_i; bold(theta))$,
  $
    (partial L) / (partial f_i) = 1 / N (pi_i - y_i) quad.
  $

- *Multiclass Classification (Categorical Cross-Entropy):* For a multiclass
  classification problem where $bold(x) in RR^d$ and target label
  $y in {1, ..., K}$, we assume a conditional Categorical model,
  $
    y | bold(x) ~ "Cat"(pi_1 (bold(x); bold(theta)), ...,
      pi_K (bold(x); bold(theta))) quad,
  $
  where $bold(pi)(bold(x); bold(theta)): RR^d -> [0, 1]^K$ satisfies
  $sum_(k=1)^K pi_k (bold(x); bold(theta)) = 1$. The loss function (categorical
  cross-entropy) is
  $
    L (cal(D); bold(theta)) &= - 1 / N sum_(i=1)^N log {
      product_(k=1)^K pi_k (bold(x)_i; bold(theta))^[y_i = k]
    } \
    &= - 1 / N sum_(i=1)^N sum_(k=1)^K [y_i = k]
      log pi_k (bold(x)_i; bold(theta)) quad,
  $
  where $[dot]$ denotes the Iverson bracket. Writing the one-hot target
  component as $y_(i k) = [y_i = k]$, this becomes
  $
    L(cal(D); bold(theta)) = - 1 / N sum_(i=1)^N sum_(k=1)^K y_(i k)
      log pi_k (bold(x)_i; bold(theta)) quad.
  $
  To parameterize $bold(pi)$, we map $bold(x)$ to a vector of unnormalized
  scores (logits) $bold(f)(bold(x); bold(theta)) in RR^K$ followed by the
  softmax function,
  $
    ["softmax"(bold(z))]_k = exp(z_k) / (sum_(j=1)^K exp(z_j)) quad,
  $
  which for numerical stability is computed as
  $
    ["softmax"(bold(z))]_k = exp(z_k - m) / (sum_(j=1)^K exp(z_j - m)) quad,
  $
  where $m = max_j z_j$ (ensuring that all exponential arguments are $<= 0$,
  avoiding numerical overflow).

  This formulation leads to a particularly clean gradient with respect to the
  logit $f_(i k) = [bold(f)(bold(x)_i; bold(theta))]_k$,
  $
    (partial L) / (partial f_(i k)) = 1 / N (pi_(i k) - y_(i k)) quad,
  $
  where $pi_(i k) = pi_k (bold(x)_i; bold(theta))$.

= Neural Networks

The maximum likelihood formulation reduces learning to minimizing an empirical
loss $L(cal(D); bold(theta))$, but leaves the parameterization of
$bold(f)(bold(x); bold(theta))$ unspecified. While a linear model
$f(bold(x)) = bold(w)^top bold(x) + b$ yields a convex optimization problem,
it cannot separate non-linear data distributions or capture complex manifolds.
Real-world data (such as text or images) require learning rich, hierarchical
feature representations, which deep neural networks achieve via function
composition.

== A Brief History

The artificial neuron originated with the threshold logic unit of McCulloch and
Pitts (1943), extended to learnable weights and biases by Rosenblatt (1958) in
the *perceptron*,
$
  f(bold(x)) = sigma(bold(w)^top bold(x) + b) quad.
$
Early models used a discontinuous step activation, famously proven by Minsky
and Papert (1969) to be limited to linearly separable problems (failing even on
XOR). Modern networks overcome this by stacking neurons into *Multi-Layer
Perceptrons* (MLPs) with smooth, non-linear activations $sigma$ (e.g., sigmoid,
$tanh$, or ReLU). An MLP is a direct function composition,
$
  f(bold(x)) = (f_L compose dots.c compose f_1)(bold(x)) =
    sigma_L (bold(W)_L dots.c sigma_1 (bold(W)_1 bold(x) + bold(b)_1) dots.c +
    bold(b)_L) quad,
$
where each layer computes $f_l (bold(h)_(l-1)) = sigma_l (bold(W)_l
bold(h)_(l-1) + bold(b)_l)$ with $bold(h)_0 = bold(x)$. Smooth activations
render the composition differentiable end-to-end, and such networks act as
universal function approximators (Cybenko, 1989; Hornik, 1991).

== Computational Graph Perspective

Modern architectures (such as Transformers) go beyond strictly sequential
layers by incorporating branching, attention mechanisms, and residual
connections. In general, a neural network is formalized as an *attributed
Directed Acyclic Graph* (DAG) $cal(G) = (cal(V), cal(E))$.

In this graph, directed edges represent data flow: a directed edge $(j, i) in
cal(E)$ indicates that the value $bold(v)_j$ computed at node $j$ is passed as
an input to node $i$. Each node $i in cal(V)$ is characterized by:
- *Predecessors (inputs):* The set of parent nodes $cal(P)_i = {j in cal(V) |
  (j, i) in cal(E)}$ whose outputs feed into node $i$. Nodes with no incoming
  edges ($cal(P)_i = emptyset$) are the *input nodes*, which receive external
  features $bold(x)$.
- *Successors (consumers):* The set of child nodes $cal(N)_i = {k in cal(V) |
  (i, k) in cal(E)}$ that consume the value $bold(v)_i$. Nodes with no outgoing
  edges ($cal(N)_i = emptyset$) are the *output nodes*, yielding the model's
  predictions $bold(f)(bold(x); bold(theta))$.
- *Local computation:* A differentiable function $bold(f)_i$ parameterized by
  local parameters $bold(theta)_i$ (with $bold(theta)_i = emptyset$ for
  parameter-free operations), computing the intermediate tensor
$
  bold(v)_i = bold(f)_i ({bold(v)_j}_(j in cal(P)_i); bold(theta)_i) quad.
$
- *Local derivatives:* The known partial derivatives of output components with
  respect to parameters and parent activations (where $p, q$ denote
  multi-indices indexing tensor elements),
$
  (partial v_(i, p)) / (partial theta_(i, q)) quad "and" quad
  (partial v_(i, p)) / (partial v_(j, q)) quad (j in cal(P)_i) quad.
$

== Forward Propagation

Because the computational graph $cal(G)$ is directed and acyclic, its vertices
admit a *topological ordering*---a permutation of nodes $(v_1, v_2, ...,
v_(|cal(V)|))$ such that for every directed edge $(j, i) in cal(E)$, node $j$
appears before node $i$.

Forward propagation evaluates the nodes sequentially in topological order,
$
  bold(v)_i = bold(f)_i ({bold(v)_j}_(j in cal(P)_i); bold(theta)_i) quad.
$
Topological sorting guarantees that whenever a node $i$ is visited, the outputs
$bold(v)_j$ of all its parent nodes $j in cal(P)_i$ have already been computed.
The evaluation begins at the input nodes and terminates at the output nodes
$bold(f)$. The intermediate values $bold(v)_i$ are cached in memory, as they
are required during the backward pass to evaluate the local derivatives.

== Backward Propagation

To optimize the network parameters via gradient descent, we must compute the
gradient of the scalar loss $L$ with respect to the parameters of every node.
Crucially, backward propagation is initialized directly at the network's
output nodes $bold(f)$ using the analytical loss gradients derived in Section
1.1.

Starting from these known boundary gradients at the output nodes, we traverse
the computational graph in *reverse topological order* back toward the input
nodes. For any internal node $i$, the computation is governed by two chain
rule equations (where $p, q$ denote suitable multi-indices over tensor
elements):

1. *Gradient with respect to intermediate activations:* Because the
   activation $v_(i, p)$ can affect the loss $L$ through multiple downstream
   paths via successor nodes $j in cal(N)_i$, the total derivative sums over
   all child nodes and their components,
$
  (partial L) / (partial v_(i, p)) = sum_(j in cal(N)_i) sum_q
    (partial L) / (partial v_(j, q)) (partial v_(j, q)) / (partial v_(i, p))
    quad.
$

2. *Gradient with respect to node parameters:* The parameters $theta_(i, p)$
   influence the loss $L$ exclusively through the node's own output values
   $v_(i, q)$,
$
  (partial L) / (partial theta_(i, p)) = sum_q
    (partial L) / (partial v_(i, q)) (partial v_(i, q)) / (partial theta_(i, p))
    quad.
$

In reverse topological order, when visiting node $i$, the incoming gradients
$(partial L) / (partial v_(j, q))$ from all successors $j in cal(N)_i$ have
already been computed. We first evaluate $(partial L) / (partial v_(i, p))$,
and then use it to compute $(partial L) / (partial theta_(i, p))$ and propagate
gradients backward to all predecessors of node $i$.
