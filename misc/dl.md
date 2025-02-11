# What is a neural network?

Neural network is any Directed Acyclic Graph (DAG) in which every vertex $i$ has the following
attributes.

Set of previous nodes - $\mathscr{P}_i$.

Set of next nodes - $\mathscr{N}_i$.

Parametrized tensor function of the form
```math
\newcommand\Rbb{\mathbb{R}}

\bm{F}^{(i)} : \Rbb^{\left(n_{1}^{(1)}, \ldots, n_{k_1}^{(1)}\right)} \times \ldots \times  \Rbb^{\left(n_{1}^{(p)}, \ldots, n_{k_p}^{(p)}\right)} \times \Theta \mapsto \Rbb^{(m_1, \ldots, m_l)}
```
The function takes $p$ tensor arguments of dimensions $k_1,\ldots,k_p$ respectively (input tensor
$q$ of dimension $k_q$ has $n_{r}^{(q)}$ elements along the $r$ axis) and parameters
$\bm{\theta}^{(i)} \in \Theta$ and returns a tensor of dimension $l$. Obviously it must satisfy $p =
|\mathscr{P}_i|$ and the tensors returned by the parent nodes must have appropriate shapes.

The gradient functions of the function $\bm{F}^{(i)}$ w.r.t. to the parameters and w.r.t. all the
inputs, that is for all $j \in \mathscr{P}_i$ we have a gradient functions
```math
\newcommand{\pdv}[2]{\frac{\partial #1}{\partial #2}}
\pdv{F_\beta ^{(i)}}{\theta_\alpha ^{(i)}}\,,\quad \pdv{F_\beta ^{(i)}}{F_\alpha ^{(j)}} \,,
```
where $\alpha$, $\beta$ are the suitable multi-indices.


# Loss functions

Training of a neural network consists of changing the parameters $\bm{\theta}^{(i)}$ of the nodes in
such a way as to make the network perform the given task. The task is specified by a training set
$\mathcal{X}$ which contains the ''blueprint answers'' of the network. To train the network we
introduce the quantitative measure of networks performance on the dataset which implicitly (through
the outputs of the network) depends on the parameters of the network (here collectively denoted by
$\bm{\theta}$) $L(\mathcal{X}, \bm{\theta})$. Training can be then phrased as an optimization
problem of the form
```math
    \bm{\theta}^* = \arg \min_{\bm{\theta}} L(\mathcal{X}, \bm{\theta})
```
for a fixed training set $\mathcal{X}$.

There is no single established way of constructing loss functions. One of the more motivated
approaches is based on the maximum likelihood criterion. The idea is that we model our data using
some parametrized statistical model and express the parameters of this model as an output of a
neural network. The loss function is then taken to be the *negated log-likelihood function*. In this
manner one can derive the most common loss functions.

## Mean Squared Error
```math
    \boxed{
    L(\mathcal{X}, \bm{\theta}) = \frac{1}{n} \sum_\alpha \left[ y_\alpha - \Phi_\alpha(\bm{X};\bm{\theta}) \right]^2 \,,
}
```
where $\bm{X}$ is a tensor which can be interpreted as a stack of $n$ 1-D feature-vectors residing
in the last dimension of $\bm{X}$, $\bm{y}$ is the corresponding tensor of $n$ scalar continuous
outputs for each feature-vector (so called target) and $\bm{\Phi}$ denotes the neural network.

## (Binary) Cross Entropy
```math
\begin{split}
    &\boxed{L(\mathcal{X}, \bm{\theta}) = \frac{1}{n} \sum_{\alpha} \left[ t_\alpha \log \pi_\alpha + (1-t_\alpha)\log(1-\pi_\alpha) \right]} \\
    & \bm{\pi} = \sigma\left( \bm{\Phi}(\bm{X}; \bm{\theta})\right)\,,\quad \sigma(z) = \frac{1}{1 + \mathrm{e}^{-z}}\,,
\end{split}
```
where $\bm{X}$ is a tensor which can be interpreted as a stack of $n$ 1-D feature-vectors residing
in the last dimension of $\bm{X}$, $\bm{t}$ is the corresponding tensor of $n$ binary (i.e. 0 or 1)
values denoting the class for each feature-vector, $\sigma$ is the logistic function, $\bm{\Phi}$
denotes the neural network and $\bm{\pi}$ is a tensor of the same shape as $\bm{t}$ which contains
the probabilities of the positive class.

## Cross Entropy
```math
\begin{split}
    &\boxed{L(\mathcal{X}, \bm{\theta}) = \frac{1}{n}\sum_{\alpha}\sum_{\beta} t_{\alpha\beta} \log \pi_{\alpha\beta}}\\
    & \bm{\pi} = \bm{\sigma}\left( \bm{\Phi}(\bm{X};\bm{\theta}) \right)\,,\quad \sigma_{\alpha'\alpha}(\bm{z}) = \frac{\exp z_{\alpha'\alpha}}{\sum_{\beta} \exp z_{\alpha'\beta}}\,,
\end{split}
```
where $\bm{X}$ is a tensor which can be interpreted as a stack of $n$ 1-D feature-vectors residing
in the last dimension of $\bm{X}$, $\bm{t}$ is the corresponding thensor which can be interpreted as
a stack of $n$ 1-D one-hot-vectors residing in the last dimension of $\bm{t}$ encoding the correct
class, $\bm{\sigma}$ is the soft-max function which given the stack of 1-D vectors independently
normalizes each of them so that the entries are non-negative and sum to 1 and $\bm{\Phi}$ denotes
the neural network.


# Forward propagation

Let $\bm{v}^{(i)}$ be the (tensor) value of the function $\bm{F}^{(i)}$. To propagate the (tensor)
inputs to the network and get the output we use the following recursive equation
```math
\boxed{
    \bm{v}^{(i)} = \bm{F}^{(i)} \left[ \left(\bm{v}^{(j)}\right)_{j \in \mathscr{P}_i} ; \bm{\theta}^{(i)} \right]
}
```
and visit the nodes in the \emph{topological order} as this guarantees that we visit every node
exactly once. We assume here that nodes $\bm{v}^{(i)}$ such that $\mathscr{P}_i = \varnothing$ are
the inputs to the network and nodes $\bm{v}^{(i)}$ such that $\mathscr{N}_i = \varnothing$ are the
output of the network.


# Backward propagation

Let $L$ be the loss function. In order to compute the derivatives $\partial_{\bm{\theta}^{(i)}}L$ we
use the following recursive equations
```math
\boxed{\begin{split}
    &\pdv{L}{\theta^{(i)}_\alpha} = \sum_\beta \pdv{L}{F^{(i)}_\beta} \pdv{F^{(i)}_\beta}{\theta^{(i)}_\alpha} \\
    &\pdv{L}{F_\alpha^{(i)}} = \sum_{j \in \mathscr{N}_i} \sum_\beta \pdv{L}{F_\beta^{(j)}} \pdv{F_\beta ^{(j)}}{F_\alpha^{(i)}}
\end{split}
}
```
where $\alpha$, $\beta$ are the suitable multi-indices. We visit nodes in the \emph{reversed
topological order} and compute and store the values of loss function derivatives. All derivatives
are computed for the current values of $\bm{v}^{(i)}$ and $\bm{\theta}^{(i)}$, therefore before
backward propagation one must perform forward propagation to compute values $\bm{v}^{(i)}$.


# Optimization methods

## Stochastic Gradient Descent

The standard optimization method used to train neural networks is the Stochastic Gradient Descent,
which is an iterative, gradient-based algorithm in which in every step $t$ we update the parameters
$\bm{\theta}^{(i)}$ utilizing the gradient information. Let $\bm{\theta}^{(i,t)}$ denote the value
of parameters $\bm{\theta}^{(i)}$ at step $t$ and let $\bm{v}^{(i,t)}$ be the values of the function
$\bm{F}^{(i)}$ at step $t$. In each step we take a batch $\mathcal{X}$ of training data, perform
forward propagation to compute values $\bm{v}^{(i,t)}$ and the value of the loss function
$L(\mathcal{X},\bm{\theta}^{(t)})$, next perform backward propagation to compute the values of
gradients $\bm{g}^{(i,t)} = \partial_{\bm{\theta}^{(i)}}L\left(\mathcal{X},\bm{\theta}^{(t)}\right)$
and afterwards we update the parameters according to
```math
\boxed{
    \theta_\alpha^{(i,t+1)} = \theta_\alpha^{(i,t)} - \eta g_\alpha^{(i,t)}
}
```
where $\eta$ is the learning rate.

## Momentum

The problem with vanilla SGD is that it gets stuck in the local minima. To overcome this problem one
can take inspiration from simple physics. We first introduce velocity tensor $\bm{V}$ with the
following update rule
```math
\boxed{
    V^{(i,t+1)}_\alpha = \gamma V^{(i,t)}_\alpha - \eta g^{(i,t)}_\alpha
}
```
where $0 < \gamma < 1$ is the so called momentum term and update parameters using
```math
\boxed{
    \theta_\alpha ^{(i,t+1)} = \theta_\alpha ^{(i,t)} + V_\alpha ^{(i,t+1)}
}
```

## Adaptive Moment Estimation (Adam)

Another problem with vanilla SGD is that it uses the same learning rate for every scalar parameter.
Adam algorithm solves this problem by introducing running averages with exponential forgetting of
both the gradients and the second moments of the gradients.
```math
\boxed{\begin{split}
    &M_\alpha^{(i,t+1)} = \beta_1 M_\alpha^{(i,t)} + (1-\beta_1) g_\alpha ^{(i,t)} \\
    &V_\alpha ^{(i,t+1)} = \beta_2 V_\alpha^{(i,t)} + (1 - \beta_2) \left(g_\alpha^{(i,t)}\right)^2 \\
    &\tilde{M}_\alpha^{(i,t+1)} = \frac{M_\alpha^{(i,t+1)}}{1 - \beta_1^t} \\
    &\tilde{V}_\alpha^{(i,t+1)}=\frac{ V_\alpha^{(i,t+1)}}{1 - \beta_2^t} \\
    &\theta_\alpha ^{(i,t+1)} = \theta_\alpha ^{(i,t)} - \eta \frac{\tilde{M}_\alpha^{(i,t+1)}}{\sqrt{\tilde{V}_\alpha^{(i,t+1)}} + \epsilon}
\end{split}
}
```
where $\epsilon \simeq 10^{-8}$  is used to prevent division by 0, $\eta$ is the learning rate and
$\beta_1$ and $\beta_2$ are the forgetting factors typically set to $\beta_1=0.9$ and
$\beta_2=0.999$. Additionally popular choice for $\eta$ is 3e-4.


# Regularization methods

TODO

# Architectures

TODO
## MLP
## CNN
## RBM
## DBN
## Autoencoder
## VAE
## GAN
## DDPM
## Transformer


# Interpretability
