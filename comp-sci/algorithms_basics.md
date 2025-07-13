Algorithms & Data Structures
----------------------------

## Elementary algorithms
* (Extended) Euclidean algorithm Standard Euclidean algorithm is used to compute the gcd of two
  numbers
* Sieve of Erathosthenes
* Binary search
* Counting sort, Bucket sort
* Quickselect

## Elementary data structures
* Abstrakcyjna struktura danych to **kontrakt** między strukturą, a jej użytkownikiem (opisuje więc
  jakie operacje można wykonać na takiej strukturze). 

* Tablica (Array) - abstrakcyjna struktura danych, która pozwala odwoływać się do poszczególnych
  *komórek* za pomocą ich indeksów

* Lista jedno-/dwukierunkowa (Linked list) - abstrakcyjna struktura danych, która pozawa poruszać się
  po kolei po elementach w jedną (lub dwie) strony i wpinać lub usuwać elementy.

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
  
  Multi-source BFS works just like the standard BFS, we just add to the queue all the sources and it
  finds the shortest distance to any source. This works because BFS first considers all vertices
  that are distance 0 from the source(s), then all vertices that are distance 1 and so on... . You
  can also think about as adding a super-source which connects to all the sources.

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
* Floating-point arithmetic (IEEE754)
* Bisection method
* Newton's method
* QR decomposition
* FFT algorithm
