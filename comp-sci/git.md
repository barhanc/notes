
# Git
https://mimuw.edu.pl/~mwrochna/teaching/inzop/git/

## Praca ze stashem

Stash to lokalny stos gdzie możemy sobie schować swoje zmiany, nie zmieniając w żaden sposób
commitów. Przydaje się kiedy chcemy schować lokalne zmiany na czas pracy z innymi branchami, lub
przenieść zmiany na inny branch.

- `git stash` (czyli `git stash push`) wrzuca lokalne zmiany (włącznie z tymi staged, czyli po `git
  add` przed `git commit`) na stash, chowając je – lokalne pliki wracają do HEAD – ostatniego
  commitu.

- `git stash pop` zdejmuje ostatnią wrzutkę ze stasha i przykłada te zmiany na obecne pliki.

- `git stash list`.

## Praca na branchach

Branch to wskaźnik na commit. HEAD to wskaźnik na aktualny branch (czasem na commit, ale wtedy wiele
operacji nie ma sensu i zwraca błąd "detached head").

- `git switch <branch>` przestawia HEAD na wzkazanego brancha i zmienia lokalne pliki na stan z
  brancha.

- `git switch -c <branch>` tworzy nowy branch i na niego przestawia HEAD.

- `git commit` tworzy nowy commit i przesuwa obecnego brancha (ten pod HEAD) na tego commita.

- `git push` wrzuca commity na serwer zdalny.

- `git pull` zbiera zmiany z obecnego brancha z serwera i jeśli się da to robi po prostu
  "fast-forward", czyli przesuwa lokalny stan brancha na najnowszy commit. Jeśli się nie da, bo
  lokalnie są inne commity niż zdalnie (mamy forka), to domyślnie tylko powie że trzeba zrobić merge
  lub rebase (ale to zależy od konfiguracji). Trzeba wybrać git pull --rebase (to robi rebase, patrz
  niżej) lub git pull --no-rebase (to robi merge).

- `git branch --list` (pamiętaj o --).

- `qgit --all` pokazuje GUI z drzewkiem/DAGiem.

Unikaj `git checkout` – to polecenie zajmuje się dwoma różnymi rzeczami i zostało zastąpione dwoma
czytelniejszymi: `git switch`, `git restore`.

## Merge Requests i code review

Szczegóły zależą od zespołu ale zazwyczaj wygląda to następująco. Każdy pracuje na swoim branchu i
forki po prostu nie występują. Branche odpowiadają taskom, poza master/main (który dla gita niczym
się nie różni od innych).

- Kiedy nasz branch jest gotowy i zrobiliśmy git push, tworzymy Merge Request dla tego brancha (w
  przeglądarce). W GitHubie to się nazywa Pull Request.

- W GitLabie to pozwala np. innym zobaczyć tego brancha w liście MRów, komentować go, przypisać
  reviewer'a oraz assignee (obecnie pracujący nad branchem, czyli albo autor albo reviewer).

- Autor poprawia wrzucając kolejne commity (lub modyfikując istniejące), reviewer sprawdza, i tak w
  kółko, aż wreszcie reviewer akceptuje MR.

- Autor zaakceptowanego MR klika żeby go zmerge'ować do mastera (w przeglądarce).

- To zazwyczaj usuwa serwerowy branch (tj. sam wskaźnik nazwa_brancha). Możemy też wybrać opcję
  squash, czyli czy chcemy z wszystkich commitów w branchu zrobić jeden (to zazwyczaj poprawia to
  czytelność historii).

- Lokalnie potem robimy git switch master, git pull.

- Zatem zazwyczaj nie potrzeba robić żadnych merge ani rebase, GitLab sam to spróbuje automatycznie
  zrobić po akceptacji MR.

### Git merge

Czasem jednak trzeba samemu złączyć dwie wersje zmian i są na to dwa sposoby.

- merge jest bezpieczniejszy bo nie zmienia istniejących commitów, tylko tworzy nowego commita
  scalając zmiany z dwóch branchy.

- `git merge foo` scala zmiany z foo do obecnego brancha, dodając commit do obecnego brancha (foo
  zostaje bez zmian).

- Najczęściej robimy `git merge master` żeby wciągnąć najnowsze zaakceptowane zmiany z mastera do
  swojego brancha i samemu naprawić problemy z merge'em, jeśli się pojawią. Potem wrzucamy powstały
  merge-commit na naszym branchu robiąc git push. To nie zmienia mastera (ani lokalnie ani zdalnie).
  To też gwarantuje, że GitLab będzie mógł potem automatycznie zrobić merga z brancha do mastera (o
  ile master znów się nie zmienił).

- Wadą merge'a są mniej czytelne diffy i mniej czytelna historia kiedy tych merge-commitów mamy
  wiele.

### Git rebase

Alternatywą jest rebase, który przerabia wszystkie commity w obecnym branchu, odtwarzając zmiany z
innego punktu startowego.

- git rebase foo zmiena obecny branch, zmieniając jego podstawę na foo. foo pozostaje bez zmian.

-Najczęściej robimy git rebase master, żeby wciągnąć najnowsze zmiany z mastera i odtworzyć nasz
branch na ich podstawie.

- Rebase zmienia commity, więc potencjalnie powoduje poważne problemy z rozsynchronizowaniem
  repozytoriów.

  - Jeśli nikt naszego obecnego brancha nie widział, to jesteśmy bezpieczni (GitLab sobie poradzi
    bez problemów).

  - Jeśli ktoś go ściągnął żeby przetestować, to raczej też zwykły git pull u tej osoby wystarczy.

  - Jeśli ktoś go ściągnął i zaczął swoje zmiany na podstawie naszego brancha, to rebase jest złem.
    Dlatego dobrze trzymać się zasady, że nie robimy zmian nad branchami innych, chyba że po
    uzgodnieniu.

- Rebase po kolei przepisuje każdy commit w naszym branchu; to czasem powoduje że proces jest dość
  uciążliwy: np. jeśli najnowsze zmiany w masterze powodują konflikt, który rozwiązujemy usuwając
  część naszego branchowego kodu, to prawdopodobnie będziemy musieli to usunięcie powtórzyć tyle
  razy, ile mamy commitów w branchu. Ogólnie dla dużych konfliktów rebase jest trudniejszy i lepiej
  w nietrywialnych sytuacjach użyć merge. Ale w najgorszym przypadku zawsze możemy zrobić git rebase
  --abort w połowie.

- Wrzucamy zmienione commity z git push --force.

- Podobnie git commit --amend (dołączenie zmian do ostatniego commita/zmiana commit message'a) – też
  zmienia commita, te same zasady.

---

* If you’re unsure or collaborating closely with others, ask your team about the preferred workflow.
  Many teams have a convention “always rebase before PR”.

* `git revert <commit>` creates a new commit that undoes the changes introduced by a previous
  commit.