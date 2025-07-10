# Sieci komputerowe

## Model OSI/ISO

```
 ==================================================
|        OSI/ISO        |         TCP/IP            |
|===================================================|
| Warstwa Aplikacji     |                           |
| Warstwa Prezentacji   |  Warstwa aplikacji        |
| Warstwa Sesji         |                           |
|---------------------------------------------------|
| Warstwa Transportowa  |  Warstwa transportowa     |
|---------------------------------------------------|
| Warstwa Sieciowa      |  Warstwa sieci            |
|---------------------------------------------------|
| Warstwa Łącza danych  |  Warstwa dostępu do siecu |
| Warstwa Fizyczna      |                           |
 ---------------------------------------------------
```

w. fizyczna - odpowiada za kodowanie strumienia danych do postaci sygnałów odpowiednich dla danego
medium transimisyjnego (kabel, eter) i przekazywaniem ich za pomocą tego medium

w. łącza danych - zajmuje się dostępem do mediuml; strukturalizauje informacje w formie **ramek**.
Zapewnia komunikację między **hostami** w ramach jednej sieci, dostarcza fizycznej adresacji hostów
(**MAC (Medium Access Control)**)

w. sieciowa - łączy sieci lokalne (na poziomie w. łącza danych) w większe systemy. Zajmuje się
przekazywaniem informacji między różnymi sieciami. Dostarcza **adresacji logicznej**.

w. transportowa - odpowiada za **segmentację** danych z warstw wyższych i ponowne ich złożenie w
punkcie docelowym. Zapewnia **Quality of Service (QoS)**

w. sesji - tworzy, zarządza i kończy sesje między komunikującymi się hostami.


w. prezentacji - dokonuje konwersji pomiędzy różnymi standardami kodowania

w. aplikacji - dostarcza aplikacji użytkownikowi

### Podstawowe pojęcia

**Protokół** - zestaw reguł wymiany informacji w obrębie **danej warstwy** modelu OSI/ISO
```           
              Protocol
      ...       <->         ...  
 -------------         -------------
| w. łącza d. | <->   | w. łącza d. |
 -------------         -------------
| w. fizyczna | <->   | w. fizyczna |
 -------------          -------------      
     Host1                  Host2

```

Porcja danych na poziomie warstwy n nosi nazwę **n-PDU** (**Protocol Data Unit**) i składa się
zawsze z:

- nagłówka (header)
- zawartości (payload)
- trailer

PDU z warstwy n+1 jest **enkapsulowane** w payload PDU z warstwy n. 

Szerokość pasma (bandwidth) - wyraża maksymalną **teoretyczną** przepustowość sieci (b/s)

Przepustowość (throughput) - wyraża **aktualne** możliwoście sieci w zakresie przesyłania danych


## Warstwa fizyczna

Nie jest tak istotna z punktu widzenia informatyka (w porównaniu np. z kimś kto zajmuje się
telekomunikacją).

## Warstwa łącza danych

Obejmuje sieci lokalne (mała rozległość, duża przpustowość). Protokołem służącym do przesyłania
danych w postaci **ramek** jest **Ethernet**.

### Adresacja MAC

Każdy host (komputer) w sieci LAN posiada kartę **NIC** (**Network Interface Card**), który zapewnia
mu dostęp do medium w określonym standardzie (tutaj Ethernet). Karta NIC posiada niezmieny, unikalny
(w skali światowej) adres **MAC** (**Medium Access Control**), który składa się z **48 bitów**
zapisywanych najczęściej w postaci kolejnych 6 bajtów zapisanych w systemie szesnastkowym
oddzielonych dwukropkiem np. **12:34:56:AA:DC:FF**. 

Rodzaje adresów:
- unicast: adres konkretnego hosta
- broadcast: adres rozgłoszeniowy (do wszystkich hostów) **FF:FF:FF:FF:FF:FF**

Karta NIC odbiera tylko te ramki Ethernet, których adres docelowy jest tożsamy z adresem MAC tej
karty lub jest adresem rozgłoszeniowym.

**Domena rozgłoszeniowa** to fragment sieci, jaki pokonują ramki typu broadcast. Domena
rozgłoszeniowa obejmuje wszystkie hosty połączone przez switche (ramki Ethernet typu broadcast nie
przechodzą przez routery).

**Switch** to urządzenie działające na poziomie warstwy łącza danych, które dzieli sieć na kilka
części w oparciu o **porty**, do których te fragmenty są podłączone. Posiada wiedzę, w którym
segmencie sieci znajduje się host o danym MAC (poprzez tablicę zawierającą `Port | MAC | Time since
last check`). Gdy switch odbiera ramkę Ethernet poszukuje jej adresu w tablicy:
- jeśli port jest taki sam, jak port z którego przyszła ramka to switch nic nie robi;
- jeśli port w tablicy jest inny to przesyła ramkę pod ten port;
- jeśli nie ma wpisu (lub adres broadcast) to rozsyła ramkę na wszystkie porty;


## Warstwa sieciowa

Zadaniem warstwy sieciowej jest dostarczanej **logicznej adresacji** i znalezienie najlepszej drogi
łączącej dwa hosty, które mogą znajdować się w oddzielnych z punktu widzenia warstwy łącza danych
miejscach.

### Adresacja IP

O ile adres MAC jest unikalny w skali światowej, to problemem jest brak hierarchii. Adresacja IP
jest hierarchiczna i powiązana z położeniem geograficznym. Składa się z 32 bitów typowo zapisywanych
w postaci kolejnych 4 bajtów oddzielonych kropką, przy czym każdy bajt jest zapisywany w postaci
liczby dziesiętnej z zakresu od 0 do 255 np. **6.132.2.1**. Adres jest podzielony na dwie części:
**sieci i hosta**


## Warstwa transportowa



## HTTP i HTTPS

# Systemy rozproszone

## Twierdzenie CAP

- C (consistency) - all nodes should see the same data at the same time
- A (availability) - node failures do not prevent system from operating
- P (partition-tolerant) - the system continues to operate despite arbitrary message loss

Żaden system rozproszony nie może mieć jednocześnie wszystkich 3 własności C, A, P. Musimy zadowolić
się jedynie dwiema wybranymi.

## REST (Representational State Transfer)

REST is a software architecture style that defines a pattern for client and server communications
over a network. REST provides a set of constraints for software architecture to promote performance,
scalability, simplicity, and reliability in the system.
