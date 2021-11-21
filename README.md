# Headlines Onet TVPInfo

* [Info](#Info)
* [Dane](#Dane)
* [Uruchomienie kodu](#Uruchomienie_projektu)
* [Prezentacja wyników](#Wizualizacja)
* [Wykorzystana technologia](#Technologia)

## Info

Skrypt poprzez analizę słów kluczy pozwala stwierdzić jak często jest poruszany dany temat (bądź pisane są artykuły o poszczególnych osobach) w dwóch konkurencyjnych 
serwisach informacyjnych. Należy mieć na uwadze, że skrypt porównuje tylko ilość wystąpień wybranych słów kluczy. Nie analizuje tego jak nacechowany jest dany artykuł 
(pozytywnie lub negatywnie na wskazany w tytule temat).

## Dane

Nagłówki wykorzystane do stworzenia statystyk zostały pobrane i zapisane z udostępnionych do wiadomości publicznej treści serwisów internetowych 
(https://www.onet.pl i https://www.tvp.info). Dane były pobierane od 03.11.2021 do 21.11.2021 - w godzinach popołudniowych.

## Uruchomienie_projektu

By uruchomić projekt na lokalnym komputerze w pierwszej kolejności należy uzupełnić skrypt w folderze "connDataBase" poprawnymi wartościami
(zmienna server, database, username i password). Następnie należy zmienić nazwę pliku z "ConnLocalDatabase_example.py" na "ConnLocalDatabase.py".

Kolejnym krokiem wykonywanym w głównym skrypcie ("GetHeaders.py") jest zdefiniowanie ścieżki odkładania się danych CSV (z nich korzysta skrypt w R) jak i ewentualna
zmiana nazwy tworzonej tabeli w naszym SQL Server (zmienne: "name_table" i "path_csv" na początku kodu). Skrypt podczas uruchomienia sprawdza czy stworzona jest 
odpowiednia tabela do odkładania danych - jeżeli nie zostanie ona automatycznie stworzona w wybranej przez nas bazie.

Ostatnim krokiem do wykonania jest definicja odpowiednich ścieżek plików w skrypcie z R (sekcja "#PATH"). Podajemy w nich położenie CSV (definiowanej wcześniej w 
skrypcie pobierającym nagłówki ze stron) jak i lokalizację gdzie będą odkładane wyexportowane wykresy.

By zautomatyzować pobieranie nagłówków możemy stworzyć zadanie wykonywane cyklicznie (np. co godzinę) uruchamiające skrypt pobierający nagłówki. Treści nagłówków nie 
będą zduplikowane, ponieważ przed zapisaniem nowych nagłówków do bazy, zostaje sprawdzone czy dana treść nie znajduje się już w tabeli.

## Wizualizacja

Prezentowane wykresy stworzone są w oparciu o nagłówki zapisane w bazie danych. Skrypt zlicza ilość wystąpień słowa "klucz" we wszystkich nagłówkach danego serwisu informacyjnego, 
a następnie sprawdza jaki procent nagłówki z danym słowem klucz stanowią w ogólnej liczbie nagłówków danej stacji. Wyniki prezentowane są w procentach z powodu 
różnej ilości artykułów w konkurencyjnych serwisach informacyjnych - czyste dane liczbowe mogłyby wprowadzać w błąd.

![artykuly slowo Kaczynski](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_1.jpg?raw=true)

Z powyższego wykresu dowiadujemy się, że w przypadku obu serwisów informacyjnych artykuły o prezesie partii rządzącej (stan na listopad 2021 rok) stanowiły około 5% ogólnej
ilości artykułów w każdym z serwisów.

![artykuly slowo Tusk](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_2.jpg?raw=true)

Powyższy wykres prezentuje ilość artykułów ze słowem "Tusk" w tytule artykułu (przewodniczący największej partii opozycyjnej - stan na listopad 2021 rok). Możemy zaobserwować, 
że serwis informacyjny TVP Info znacznie częściej pisał o przewodniczącym największej partii opozycyjnej niż ONET. W okresie 03.11.2021 do 21.11.2021 artykuły ze słowem "Tusk"
stanowiły około 1,5% wszystkich artykułów w serwisie TVP Info, natomiast w serwisie ONET stanowiły one niecałe 0,5% całości.

![artykuly slowo Inflacja](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_3.jpg?raw=true)

Powyższa wizualizacja wyników informuje nas o tym, że Inflacja była tematem, który poruszany był częściej w serwisie ONET niż w TVP Info (odpowiednio około 0,6% i 0,3%
wszystkich artykułów). Słowo inflacja zostało dodane do zliczanych słów kluczy, ponieważ w okresie powstawania artykułu inflacja wynosi 6,8% (dane podane przez GUS - 
październik 2021), więc temat może być ciekawy dla różnych serwisów informacyjnych.

![artykuly slowo Morawiecki](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_4.jpg?raw=true)

Na portalu TVP Info znacznie częściej mogliśmy przeczytać artykuły o panu Mateuszu Morawickim (premier RP - stan na listopad 2021 roku), niż w konkurencyjnym
serwisie informacyjnym.

![artykuly slowo Rzad](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_5.jpg?raw=true)

Oba serwisy informacyjne równie często poruszały temat rządu.

![artykuly slowo Aborcja](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_6.jpg?raw=true)

Portal TVP Info większą część swoich artykułów poświęcił tematyce aborcji niż ONET. Aborcja jako słowo klucz zostało dodane do skryptu, gdyż jest ciągle nośnym tematem po
wyroku Trybunały Konstytucyjnego RP w tej sprawie (stan na listopad 2021 roku).

![artykuly slowo TVN](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_7.jpg?raw=true)

O stacji TVN portal TVP Info pisał częściej niż konkurencyjny portal informacyjny.

![artykuly slowo TVP](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_8.jpg?raw=true)

O polskim publicznym nadawcy (TVP) każdy z serwisów przeznaczył podobną część swoich artykułów.

![artykuly slowo TVP](https://github.com/WHHY100/Headlines-Onet-TVPInfo/blob/main/img/plot_9.jpg?raw=true)

Portal TVP Info znacznie częściej pisał Imigrantach niż konkurencyjny portal ONET. Aktualny temat z powodu kryzysu migracyjnego w listopadzie 2021 roku.

## Technologia

Python 3.9 / PyCharm

R / Rstudio

SQL / SQL Server
