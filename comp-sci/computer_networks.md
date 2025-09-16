# Sieci komputerowe

## Warstwy modelu OSI/ISO

1. Warstwa fizyczna - odpowiada zxa kodowanie strumienia danych do postaci sygnałów odpowiednich dla
   danego medium (kabel, eter) i przekazywaniem ich za pomocą tego medium

2. Warstwa łącza danych - zajmuje się dostępem do medium; strukturalizuje informacje w formie
   **ramek**; zapewnia komunikację między hostami w ramach jednej sieci lokalnej; dostarcza
   fizycznej adresacji hostów (MAC - Medium Access Control)

3. Warsta sieciowa - łączy sieci lokalne w większe systemy; zajmuje się przekazywaniem informacji
   między różnymi sieciami; dostarcza logicznej adresacji

   *datagram* - oakiet stanowiący osobną logiczną całość

4. Warstwa transportowa - odpowiada za segmentację danych z warstw wyższych i ponowne ich złożenie w
   punkcie docelowym; zapewnia QoS (Quality of Service)

5. Warstwa sesji - tworzy, zarządza i kończy sesje pomiędzy komunikującymi się hostami; odpowiada za
   synchronizację dialogu pomiędzy komputerami

6. Warstwa prezentacji - dokonuje konwersji pomiędzy różnymi standardami kodowania

7. Warstwa aplikacji - dostarcza aplikacji użytkownikowi

*Protokół* - zestaw reguł wymiany informacji w obrębie danej warstwy modelu OSI/ISO

Porcja danych na poziomie warstwy *n* nosi nazwę *n*-PDU (Protocol Data Unit) i składa się z:
headera, payloadu i trailera. PDU z warstwy *n+1* jest *enkapsulowane* w payload PDU z warstwy *n*.

## Zalety modelu warstwowego

* umożliwia niezależny rozwój warstw
* zmniejsza złożoność systemów
* standaryzuje interfejsy
* zapewnia współpracę między urządzeniami różnych producentów