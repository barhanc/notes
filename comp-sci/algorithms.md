Algorithms & Data Structures
----------------------------

* Multi-source BFS works just like the standard BFS, we just add to the queue all the sources and it
  finds the shortest distance to any source. This works because BFS first considers all vertices
  that are distance 0 from the source(s), then all vertices that are distance 1 and so on... . You
  can also think about as adding a super-source which connects to all the sources.


## Elementary algorithms
* (Extended) Euclidean algorithm
  Standard Euclidean algorithm is used to compute the gcd of two numbers
  ```python
  ```

* Sieve of Erathosthenes
  ```python
  ```

* Binary search
  ```python
  def bisect(a: list, x) -> int
      n = len(a)
      l, r = 0, n - 1
      while l <= r:
          m = l + (l + r) // 2
          if a[m] < x:
              l = m + 1
          elif a[m] > x:
              r = m - 1
          else:
              return m
      
      return None
  ```

* Counting sort, Bucket sort
  ```python
  ```

* Quickselect
  ```python
  ```

## Elementary data structures
* Abstrakcyjna struktura danych to **kontrakt** między strukturą, a jej użytkownikiem (opisuje więc
  jakie operacje można wykonać na takiej strukturze). 

* Tablica (Array) - abstrakcyjna struktura danych, która pozwala odwoływać się do poszczególnych
  *komórek* za pomocą ich indeksów

* List jedno-/dwukierunkowa (Linked list) - abstrakcyjna struktura danych, która pozawa poruszać się
  po kolei po elementach w jedną (lub dwie) strony i wpinać lub usuwać elementy.
  ```python
  class Node:
      def __init__(self, val, next: Optional[Node]):
          self.val = val
          self.next = next
  ```

* Stos (Stack, LIFO Queue) - abstrakcyjna struktura danych, która pozwala na odkładanie na
  wierzchołek i zdejmowanie z niego

* Kolejka (Queue, FIFO Queue) - abstrakcyjna struktura danych, która pozwala dokładać elementy na
  koniec i zabierać je z początku

* Kolejka priorytetowa (Priority Queue) - abstrakcyjna struktura danych, która pozwala dokładać
  elementy i zabierać elementy najmniejszy (największy)

* Kopiec (Heap) - drzewo binarne, w którym w każdym węźle przechiwujemy wartość większą lub równą
  niż wartości w jego dzieciach. Inaczej w kopcu dla dowolnego węzła `x` zachodzi `x.val >=
  x.left.val` i `x.val >= x.right.val`. Kopiec to konkretna realizacja kolejki priorytetowej.

* Binary Search Tree
* Hashmaps
* Segment trees

## Graph algorithms

* Graph representations
* BFS, DFS
* Toposort
* Euler cycle
* Bridge detection
* Dijkstra algorithm
* Bellman-Ford algorithm
* Floyd-Warshall algorithm
* Prim's MST algorithm
* Ford-Fulkerson algorithm

## Dynamic Programming

* Intro
* Longest Common Subsequence
* Longest Increasing Subsequence
* Knapsack problem

## Elementary numerical methods

* 2s-complement representation of integers
* Floating-point arithmetic
* Bisection method
* Newton's method
* QR decomposition
* FFT algorithm



---

*Maksymy i rady programistyczne*

* Programy mają być czytane przez ludzi. 
* Dawaj więcej komentarzy niż będzie ci, jak sądzisz potrzeba. 
* Stosuj komentarze wstępne. 
* Stosuj przewodniki w długich programach. 
* Komentarz ma dawać coś więcej, niż tylko parafrazę tekstu programu. 
* Błędne komentarze są gorsze niż zupełny brak komentarzy.
* Stosuj odstępy dla poprawienia czytelnoś ci.
* Używaj dobrych nazw mnemonicznych.
* Wystarczy jedna instrukcja w wierszu.
* Porządkuj listy według alfabetu.
* Nawiasy kosztują mniej niż błędy.
* Stosuj wcięcia dla uwidocznienia struktury programu i danych.