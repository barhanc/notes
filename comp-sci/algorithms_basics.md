## Elementary algorithms
* TODO: (Extended) Euclidean algorithm
* TODO: Binary search
* TODO: Counting sort, Bucket sort
* TODO: Quickselect

## Elementary data structures
* Abstrakcyjna struktura danych to **kontrakt** między strukturą, a jej użytkownikiem (opisuje więc
  jakie operacje można wykonać na takiej strukturze). 

* Tablica (Array) - abstrakcyjna struktura danych, która pozwala odwoływać się do poszczególnych
  *komórek* za pomocą ich indeksów

* Lista jedno-/dwukierunkowa (Linked list) - abstrakcyjna struktura danych, która pozawa poruszać
  się po kolei po elementach w jedną (lub dwie) strony i wpinać lub usuwać elementy.

* Stos (Stack, LIFO Queue) - abstrakcyjna struktura danych, która pozwala na odkładanie na
  wierzchołek i zdejmowanie z niego

* Kolejka (Queue, FIFO Queue) - abstrakcyjna struktura danych, która pozwala dokładać elementy na
  koniec i zabierać je z początku

* Kolejka priorytetowa (Priority Queue) - abstrakcyjna struktura danych, która pozwala dokładać
  elementy i zabierać elementy najmniejszy (największy)

* Kopiec (Heap) - drzewo binarne, w którym w każdym węźle przechiwujemy wartość większą lub równą
  niż wartości w jego dzieciach. Inaczej w kopcu dla dowolnego węzła `x` zachodzi `x.val >=
  x.left.val` i `x.val >= x.right.val`. Kopiec to konkretna realizacja kolejki priorytetowej.

* TODO: Binary Search Tree
* TODO: Hashmaps
* TODO: Segment trees

## Graph algorithms

* TODO: Graph representations
* TODO: BFS, DFS
  
  Multi-source BFS works just like the standard BFS, we just add to the queue all the sources and it
  finds the shortest distance to any source. This works because BFS first considers all vertices
  that are distance 0 from the source(s), then all vertices that are distance 1 and so on... . You
  can also think about as adding a super-source which connects to all the sources.

  - Toposort

* TODO: Dijkstra algorithm
* TODO: Bellman-Ford algorithm
* TODO: Floyd-Warshall algorithm
* TODO: Prim's MST algorithm
* TODO: Ford-Fulkerson algorithm

## Dynamic Programming

* TODO: Intro
* TODO: Longest Common Subsequence
* TODO: Longest Increasing Subsequence
* TODO: Knapsack problem

## Elementary numerical methods

* TODO: 2s-complement representation of integers
* TODO: Floating-point arithmetic (IEEE754)
* TODO: Bisection method
* TODO: Newton's method
* TODO: QR decomposition
* TODO: FFT algorithm
