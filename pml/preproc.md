## Przygotowywanie danych

Kluczem do uzyskania dobrych wyników przy korzystaniu z algorytmów uczenia maszynowego jest
odpowiednie przygotowanie danych i ich preprocessing. Typowo preprocessing składa się z: 
- wczytywania danych (np. plików w formacie `.csv` do `DataFrame` w bibliotece `Pandas`)
- wstępnej analizy/eksploracji danych (wykresy, histogramy, heatmapa korelacji, wizualizacja liczby
    brakujących wartości dla każdej z cech (biblioteka `missingno`))
- czyszczenie  i imputacja danych (usunięcie silnie skorelowanych cech, usunięcie oczywistych
    outlierów lub cech posiadających zbyt dużo brakujących wartości, uzupełnienie wartości cech)
- skalowanie zmiennych numerycznych (klasy `MinMaxScaler`, `StandardScaler` w bibliotece
    `scikit-learn`). Metodę `.fit()` wykonujemy **tylko raz, dla danych treningowych**. Wyuczone
    parametry potrzebne do skalowania zostają zapisane w obiekcie `Scaler` i mogą być później
    używane do przeprowadzenia skalowania zarówno dla danych treningowych, jak i testowych (metoda
    `.transform()`). 
    
    Czemu nie wywołać `.fit()` na wszystkich danych, a nie tylko treningowych? 
    
    Wydzieliliśmy dane testowe po to, żeby sprawdzać, jak model poradzi sobie z danymi, których do
    tej pory nigdy nie widział, bo to właśnie takie dane będzie on dostawać w praktyce, po wdrożeniu
    do realnego systemu. Ta ocena obejmuje też etap preprocessingu, w tym skalowania. Więc jeśli
    etap preprocessingu zobaczy dane testowe, to nie będziemy w stanie uczciwie estymować jego
    zachowania na nowych danych. Wykorzystanie danych testowych w procesie treningu to błąd wycieku
    danych (**data leakage**). Skutkuje on niepoprawnym, nadmiernie optymistycznym oszacowaniem
    jakości modelu.

- one-hot encoding zmiennych kategorycznych (należy pamiętać, że kodując zmienną kategoryczną o $N$
    wartościach używamy $N-1$ *dummy variables*, aby nie wpaść w tzw. *dummy variable trap* --
    zależność liniową między cechami)

- transformacja logarytmiczna zmiennej objaśnianej -- jeśli histogram wartości zmiennej objaśnianej
    nie przypomina rozkładu normalnego (jest asymetryczny, skośny) to przekształcamy wartości tej
    zmiennej $y \mapsto \log(y)$. Dodatkowa korzyść z takiej transformacji jest taka, że regresja
    liniowa przewiduje dowolne wartości rzeczywiste. Po przekształceniu logarytmicznym jest to
    całkowicie ok, natomiast w oryginalnej przestrzeni trzeba by wymusić przewidywanie tylko
    wartości pozytywnych.

- feature engineering -- dodanie wielomianów cech do naszych danych lub skonstruowanie innych danych
    (np. dla przebiegów czasowych dodanie cech określających miesiąc, dzień itp.)

- podział zbioru danych na dane treningowe i testowe (lub w przypadku holdoutu treningowe, testowe i
  walidacyjne) zwykle w stosunku 80-20 lub 70-30

## Tuning hiper-parametrów, walidacja skrośna

Praktycznie wszystkie modele ML mają hiperparametry, często liczne, które w zauważalny sposób
wpływają na wyniki, a szczególnie na underfitting i overfitting. Ich wartości trzeba dobrać zatem
dość dokładnie. Jak to zrobić? Proces doboru hiperparametrów nazywa się tuningiem hiperparametrów
(hyperparameter tuning).

Istnieje na to wiele sposobów. Większość z nich polega na tym, że trenuje się za każdym razem model
z nowym zestawem hiperparametrów i wybiera się ten zestaw, który pozwala uzyskać najlepsze wyniki.
Metody głównie różnią się między sobą sposobem doboru kandydujących zestawów hiperparametrów.

Najprostsze i najpopularniejsze to:
- pełne przeszukiwanie (grid search) - definiujemy możliwe wartości dla różnych hiperparametrów, a
    metoda sprawdza ich wszystkie możliwe kombinacje (czyli siatkę),

- losowe przeszukiwanie (randomized search) - definiujemy możliwe wartości jak w pełnym
    przeszukiwaniu, ale sprawdzamy tylko ograniczoną liczbę losowo wybranych kombinacji.

Jak ocenić, jak dobry jest jakiś zestaw hiperparametrów? Nie możemy sprawdzić tego na zbiorze
treningowym - wyniki byłyby zbyt optymistyczne. Nie możemy wykorzystać zbioru testowego - mielibyśmy
data leakage, bo wybieralibyśmy model explicite pod nasz zbiór testowy. Trzeba zatem osobnego
zbioru, na którym będziemy na bieżąco sprawdzać jakość modeli dla różnych hiperparametrów. Jest to
zbiór walidacyjny (validation set).

Zbiór taki wycina się ze zbioru treningowego. Dzielimy zatem nasze dane nie na dwie, ale trzy
części: treningową, walidacyjną i testową. Typowe proporcje to 60-20-20\% lub 80-10-10\%.

Metody tuningu hiperparametrów są zaimplementowane w Scikit-Learn jako GridSearchCV oraz
RandomizedSearchCV.

Jednorazowy podział zbioru na części nazywa się split validation lub holdout. Używamy go, gdy mamy
sporo danych, i 10-20\% zbioru jako dane walidacyjne czy testowe to dość dużo, żeby mieć przyzwoite
oszacowanie. Zbyt mały zbiór walidacyjny czy testowy da nam mało wiarygodne wyniki - nie da się
nawet powiedzieć, czy zbyt pesymityczne, czy optymistyczne! W praktyce niestety często mamy mało
danych. Trzeba zatem jakiejś magicznej metody, która stworzy nam więcej zbiorów walidacyjnych z tej
samej ilości danych.

Taką metodą jest walidacja skrośna (cross-validation, CV). Polega na tym, że dzielimy zbiór na K
równych podzbiorów, tzw. foldów. Każdy podzbiór po kolei staje się zbiorem walidacyjnym, a pozostałe
łączymy w zbiór treningowy.

Trenujemy zatem K modeli dla tego samego zestawu hiperparametrów i każdy testujemy na zbiorze
walidacyjnym. Mamy K wyników dla zbiorów walidacyjnych, które możemy uśrednić (i ew. obliczyć
odchylenie standardowe). Takie wyniki są znacznie bardziej wiarygodne.

Szczególnym przypadkiem jest Leave-One-Out Cross-Validation (LOOCV), w którym ilość podzbiorów
(foldów) jest równa ilości rekordów. Czyli w danej chwili tylko 1 przykład jest zbiorem
walidacyjnym. Daje to możliwość prawie całkowitego wykorzystania naszych danych (w każdej iteracji
musimy wydzielić tylko 1 przykład na zbiór walidacyjny, cała reszta jest naszym zbiorem
treningowym), ale wprowadza ogromny koszt obliczeniowy. Jest to opłacalne tylko w szczególnych
przypadkach.


