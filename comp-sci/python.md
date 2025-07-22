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
  języka. Są podobne do RFC (Request For Comments).

* What I like the most about Python: in general it is a language which enables one to write code
  that is concise, easy-to-read and powerful at the same time. Examples of this are: powerful list
  comprehensions and generator expressions which combined with (batteries-included) standard library
  functions like `all`, `any`, `sum`, etc. enable to express complex logic in a concise but
  easy-to-read and elegant (cough cough looking at you C++) way. 
  
  One feature that I don't particularly like in Python (except for the lack of performance) is the
  lack of truly private/protected fields and methods in classes.

* The `pickle` module implements binary protocols for serializing and de-serializing a Python object
  structure. “Pickling” is the process whereby a Python object hierarchy is converted into a byte
  stream, and “unpickling” is the inverse operation, whereby a byte stream (from a binary file or
  bytes-like object) is converted back into an object hierarchy.

* Linters, also known as static code analyzers, are tools that analyze source code to detect
  potential issues such as syntax errors, style inconsistencies, and potential bugs. For Python I
  personally use Pylint from Microsoft.

* Polymorphism translates to "many forms." In programming it is the ability of an object with
  different types to be handled by a common interface.

  Polymorphism: By designing code around ABCs, you can write functions that accept objects based on
  their interfaces rather than specific classes. This promotes polymorphism and code reuse. 
  
  Duck typing is a form of dynamic polymorphism

* Python is strongly (Python interpeter checks whether the operation can be performed on a given
  object), dynamically (i.e. the values have types, not variables) typed. It does not have implicit
  casting.

* Testing in Python. For testing use Pytest (as a better alternative to built-in unittest module)
  
  - Tests should be written first. This is known as "Test-Driven Development" or "Red, Green,
    Refactor".
  - Because the primary purpose of a test framework is to run tests, it needs a way to find them.
    You can customize this, but the easiest way is to just make sure everything test-related starts
    with the word "test". Put your tests in a "tests" folder. Write your tests in files named
    "test_<something>.py", name your test classes (if you have them) TestSomething and name your
    test functions test_something_something.

* Wheels are the new standard of Python distribution and are intended to replace eggs. Advantages of
  wheels:
  - Faster installation for pure Python and native C extension packages.
  - Avoids arbitrary code execution for installation. (Avoids setup.py)
  - Installation of a C extension does not require a compiler on Linux, Windows or macOS.
  - Allows better caching for testing and continuous integration.
  - Creates .pyc files as part of installation to ensure they match the Python interpreter used.
  - More consistent installs across platforms and machines.

* SOLID
  - Single Responsibility Principle (SRP)

    A class should have only one reason to change. "Reasons to change" are, in essence, the
    responsibilities managed by a class or function.

  - Open/Closed Principle (OCP)

    Objects should be open for extension, but closed to modification. It should be possible to
    augment the functionality provided by an object (for example, a class) without changing its
    internal contracts. An object can enable this when it is designed to be extended cleanly.

  - Liskov Substitution Principle (LSP)
    
    In essence, a function accepting a supertype should also accept all its subtypes with no
    modification.
  
  - Interface Segregation Principle (ISP)

    Keep interfaces small so that users don’t end up depending on things they don’t need.

  - Dependency Inversion Principle (DIP)

    Depend upon abstractions, not concrete details

* Lambdas can have default arguments e.g.
  ```python
  f = lambda x, y=1: x * y
  ```

* **src vs flat layout** The “src layout” deviates from the flat layout by moving the code that is
  intended to be importable (i.e. import awesome_package, also known as import packages) into a
  subdirectory. This subdirectory is typically named src/, hence “src layout”.

* New projects are advised to avoid setup.py configurations (beyond the minimal stub) when custom
  scripting during the build is not necessary. Note that you can still keep most of configuration
  declarative in setup.cfg or pyproject.toml and use setup.py only for the parts not supported in
  those files (e.g. C extensions).
  https://setuptools.pypa.io/en/latest/userguide/quickstart.html#setup-py


