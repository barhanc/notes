Python
------

* In Python 3.8+ you can compute inverse of `a` modulo `m` using built-in (not from `math` module)
  `pow` function like this
  ```python
  b = pow(a, -1, m)
  assert((a * b - 1) % m == 0)
  ```

* Python has built-in `divmod` function which returns the quotient and the remainder
  ```python
  q, r = divmod(n, d)
  ```

* When working with 2-D vectors represented as `tuple[int, int]` you can use built-in complex
  numbers instead. You can easily 

  * compute linear combination of vectors

  * rotate vector `z = x + y * 1j` by an angle using multiplication by a suitable complex number
    $e^{i\theta}$, e.g. `1j` for 90 degrees.

* Don't forget about `@functools.cache` decorator which makes memoization a breeze.

* There is `cmath` library for complex number mathematical functions.

* `collections.Counter` is useful. It is basically a histogram.

* In Python there is `for else` construct
  ```python
  for x in iterable:
      if cond(x):
          # do something if condition is true
          break
      # do something
  else:
      # do something if the for loop was not interrupted using break or iterable is empty
  ```

* What is the difference between Python `Generator`, `Iterator` and `Iterable`?

  Well, `Iterator` is just an instance of a class which implements two special methods: `__next__()`
  (which returns the next elemnt from the iterated sequence, duh) and `__iter__()` which returns
  `self`.
  
  Now `Iterable` is an instance of a class that implements `__iter__()` method which returns some
  `Iterator` and as such enables one to iterate over it.

  Finally `Generator` is a special object constructed using either the `yield` keyword in the
  function implementation or the *generator expression* e.g.
  ```python
  def squares(n: int):
      for i in range(n):
          yield i**2
  ```
  ```python
  (i**2 for i in range(n))
  ```
  are examples of generators (and these are equivalent).

  NOTE: **Every generator is an iterator (as generator implements the abstract iterator
  interface).**

  You may want to use a custom iterator, rather than a generator, when you need a class with
  somewhat complex state-maintaining behavior, or want to expose other methods besides `__next__`
  (and `__iter__` and `__init__`). Most often, a generator (sometimes, for sufficiently simple
  needs, a generator expression) is sufficient, and it's simpler to code because state maintenance
  (within reasonable limits) is basically "done for you" by the frame getting suspended and resumed.

*  With duck typing, an object is of a given type if it has all methods and properties required by
   that type. Duck typing is an application of the duck test—"If it walks like a duck and it quacks
   like a duck, then it must be a duck"

* There is `.bit_count()` method to count bits of the `int`. (since Python 3.10)

* In `itertools` there is `zip_longest` function with `fillvalue` argument

* **Context managers** allow you to allocate and release resources precisely when you want to. The
  most widely used example of context managers is the with statement.
  ```python
  with open('some_file', 'w') as file:
      file.write('Hola!')
  ```
  At the very least a context manager has an `__enter__` and `__exit__` method defined. 
  ```python
  class File(object):
      def __init__(self, file_name, method):
          self.file_obj = open(file_name, method)
      def __enter__(self):
          return self.file_obj
      def __exit__(self, type, value, traceback):
          self.file_obj.close()
  ```
  We can also implement Context Managers using decorators and generators. Python has a contextlib
  module for this very purpose. Instead of a class, we can implement a Context Manager using a
  generator function.
  ```python
  from contextlib import contextmanager

  @contextmanager
  def open_file(name):
      f = open(name, 'w')
      try:
          yield f
      finally:
          f.close()
  ```

* `bisect` from `bisect` module in standard library returns an index `i` which for a given array
  `xs` and target `y` partitions the array into two halves such that `all(x <= y for x in xs[:i])`
  and `all(x > y for x in xs[i:])`

* `heapq` is VERY useful as it is a good, standard implementation of a min/max heap data structure
  that you can use. It is arguably better (and objectively faster) than `queue.PriorityQueue`
  although the API is a bit less intuitive.

* To check whether a number `n` in the given range (e.g. `int32`) is a power of some number `k` you
  just have to check if `k**p % n == 0` where `p` is the greatest number such that `k**p` is still
  in the given range.

* PEP (Python Enhancement Proposal) jest oficjalnym dokumentem informacyjnym dla społeczności
  programistów Pythona. Dokumenty tego typu służą między innymi jako dokumentacja nowych funkcji
  języka.

* What I like the most about Python: in general it is a language which enables one to write code
  that is concise, easy-to-read and powerful at the same time. Examples of this are: powerful list
  comprehensions and generator expressions which combined with (batteries-included) standard library
  functions like `all`, `any`, `sum`, etc. enable to express complex logic in a concise but
  easy-to-read and elegant (cough cough looking at you C++) way. 
  
  One feature that I don't particularly like in Python (except for the lack of performance) is the
  lack of truly private/protected fields and methods in classes.

* TODO: Dunder names, methods
* TODO: Pickling objects
* TODO: PIP (Package Installer for Python), publishing, wheels, etc.
* TODO: Decorators
* TODO: Linters, formatters, type checking
* TODO: Testing in Python
* TODO: Clean code

