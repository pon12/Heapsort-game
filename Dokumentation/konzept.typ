#import "@preview/ilm:2.1.1": *

#let platzhalter(body) = text(gray, body)
#let entscheidung(titel, detail, grund, bild: none) = [
  *#titel*: #detail  
  _Begründung:_ #grund
  #if bild!=none [
    #align(center, bild)
  ]
]

#set text(lang: "de", font: "Libertinus Serif")


#show: ilm.with(
  title: "Konzeptdokument Heap-Sort",
  authors: "Gruppe A3",
  abstract: text("Alina Felber, Josef Peinelt, Felix Kuehn, Janic Hebenstreit, Maxim Soehnel, Noah Schubart, Pontus Wild"),
  date: datetime.today()
)

= Einführung zum Thema

== Zugrundeliegendes Problem
Heapsort löst das Problem, eine Menge von Elementen effizient in eine Reihenfolge zu bringen. Die Laufzeit beträgt im besten, mittleren und schlechtesten Fall O(n log n), und der Algorithmus arbeitet in place, benötigt also keinen zusätzlichen Speicher. Dadurch unterscheidet er sich von Quicksort (im Worst Case O(n²)) und von Mergesort (benötigt O(n) Zusatzspeicher).
== Überblick über die Lösungen
#text[

Neben Heapsort gibt es wie z.B in 1.1 bereits genannt auch andere Algorithmen zur
Datensortierung. Bubblesort vergleicht Beispielsweise benachbarte Elemente und vertauscht diese
bei falscher Reihenfolge bis das Array vollständig sortiert ist. Quicksort hingegen teilt zunächst das
Array in zwei Listen mit einem „Pivotelement“ als Mittelwert auf. In die eine Liste kommen dann
alle Elemente, die kleiner als dieses Element sind und in die Andere die Größeren. Danach werden
die Listen einzeln geordnet, wodurch sich am Ende ein vollständig geordnetes Array ergibt. Beim
Mergesort wird das Array in seiner aktuellen Reihenfolge halbiert. Die daraus entstandenen Listen
können danach erneut halbiert werden. Anschließend werden zwei Listen miteinander verglichen in
dem man die noch nicht verglichenen und somit auch noch nicht übernommenen Elemente
miteinander vergleicht. Das kleinere Element wird nach diesem Vergleich übernommen. Somit
„merget“ man sich dann von den vielen kleinen und kurzen Listen zu einem vollständigen Array.


#align(left, image("pictures/tabelle_algorithmen_2.png", height: 6cm))
Quelle: https://neetcode.io/cheatsheets/sorting-algorithms

Einordnung Heapsort:
Heapsort ist somit ein effizienter, vergleichsbasierter Algorithmus welcher im Gegensatz zu
Mergesort ohne zusätzliche Hilfsarrays funktioniert. Seine besondere Stärke liegt in der garantierten
Laufzeit, welche von der Länge des Arrays abhängt und dem konstanten zusätzlichen
Speicherbedarf. Im Vergleich zu Quicksort ist Heapsort in praktischen Anwendungen aufgrund der
voneinander abhänigen Vergleichsabläufe innerhalb des Arrays häufig langsamer, bietet dafür aber einen 
besseren Worst Case, da er unabhänig von der
urpsürnlgichen Reihenfolge immer die gleichen Schritte abarbeitet (nicht adaptiv). Gegenüber
Mergesort benötigt er weniger zusätzlichen Speicher, ist jedoch sowie Quicksort nicht stabil.
Heapsort eignet sich deshalb besonders gut, wenn eine verlässliche obere Laufzeitgrenze und ein
geringer Speicherverbrauch wichtig sind und Stabilität sowie Maximalgeschwindigkeit eine
kleinere Rolle spielen
]
== Vorstellung des Algorithmus / der Datenstruktur
Heapsort ist ein vergleichsbasiertes, in-place arbeitendes Sortierverfahren mit einer garantierten Laufzeit von $O(n log n)$ im besten, mittleren und schlechtesten Fall. Es basiert auf der Datenstruktur des binären Max-Heaps und ordnet ein unsortiertes Array von $n$ Elementen aufsteigend nach ihrer Größe.

Der Max-Heap: Ein binärer Max-Heap ist ein vollständiger Binärbaum: Jeder Knoten hat höchstens zwei Kinder, alle Ebenen außer der letzten sind voll besetzt, und die letzte Ebene wird von links nach rechts aufgefüllt. Zusätzlich gilt die Max-Heap-Bedingung: Jeder Knoten ist mindestens so groß wie seine beiden Kinder. Daraus folgt, dass das größte Element stets in der Wurzel steht. Ein Heap ist jedoch nicht vollständig sortiert, denn eine Ordnung besteht nur zwischen Eltern- und Kindknoten, nicht zwischen Geschwistern oder verschiedenen Ästen.

Abbildung auf das Array: Der Baum wird nicht als eigene Struktur gespeichert, sondern direkt im Array abgebildet, indem es Ebene für Ebene von links nach rechts gelesen wird. Bei nullbasierter Indizierung gilt für einen Knoten an Index $i$: linkes Kind $2i + 1$, rechtes Kind $2i + 2$, Elternknoten $floor((i-1)/2)$. Die Wurzel liegt an Index 0. Existiert ein berechneter Kindindex nicht mehr innerhalb des Heaps, hat der Knoten dieses Kind nicht. Bei gerader Elementanzahl besitzt der letzte innere Knoten daher nur ein Kind.

Sift-Down (Heapify): Die zentrale Operation ist das Absenken eines Knotens, dessen Heap-Bedingung verletzt sein kann, wobei seine beiden Teilbäume bereits gültige Heaps sind. Der Knoten wird mit seinem größeren Kind verglichen. Ist dieses Kind echt größer, werden beide getauscht, und der Vorgang wiederholt sich an der neuen Position. Er endet, sobald kein Kind mehr größer ist oder ein Blatt erreicht wurde. Der Aufwand ist durch die Baumhöhe begrenzt, also $O(log n)$.

Phase 1: Heap aufbauen: Zu Beginn ist das Array unsortiert, die Max-Heap-Bedingung also noch nicht erfüllt. Beginnend beim letzten inneren Knoten (Index $n/2 - 1$) wird rückwärts bis zur Wurzel (Index 0) für jeden Knoten Sift-Down ausgeführt. Blätter müssen nicht betrachtet werden, da sie bereits gültige Heaps sind. Nach Abschluss ist das Array ein gültiger Max-Heap und das größte Element steht an Index 0.

Phase 2: Sortieren: Solange der Heap mehr als ein Element enthält, wird wiederholt: (1) die Wurzel, also das Maximum, mit dem letzten Element des Heap-Bereichs getauscht, (2) die Heap-Größe um 1 verringert, da das Maximum nun an seiner endgültigen Position steht, und (3) die neue Wurzel, die die Heap-Bedingung vermutlich verletzt, per Sift-Down auf den verkleinerten Heap abgesenkt. Am Array-Ende wächst so der sortierte Bereich, vorne schrumpft der Heap. Bei Heap-Größe 1 endet der Algorithmus; das verbleibende Element ist das kleinste und steht bereits an der richtigen Stelle. Das Array ist dann aufsteigend sortiert.

#v(5em)


Heapsort – Sonderfälle 

Leeres Array und ein einzelnes Element. Ein Array mit n = 0 oder n = 1 ist per Definition bereits sortiert. Der Algorithmus erkennt das ohne Sonderbehandlung: Der Startindex von Phase 1 ist n/2 - 1 = -1, die Schleife wird nie betreten, und auch die Sortierphase läuft nur, solange der Heap mehr als ein Element enthält. Es findet kein einziger Tausch statt.

Zwei Elemente. Bei n = 2 besitzt die Wurzel genau ein Kind. Phase 1 stellt sicher, dass das größere Element vorne steht, Phase 2 tauscht beide einmal. Das ist der kleinste Fall, in dem beide Phasen tatsächlich etwas tun.

Knoten mit nur einem Kind: Bei gerader Elementanzahl hat der letzte innere Knoten nur ein linkes Kind. Beispiel: Bei n = 4 hat Index 1 das linke Kind an Index 3, der Index 4 des rechten Kindes liegt aber außerhalb des Heaps. Beim Sift-Down muss daher immer zuerst geprüft werden, ob das rechte Kind überhaupt existiert (2i + 2 < "Heap-Größe"), bevor es verglichen wird. Ohne diese Prüfung greift der Algorithmus auf ein Element zu, das nicht mehr zum Heap gehört.

Heap-Größe und Array-Länge: Im Sift-Down schrumpft die Heap-Größe, die Länge des Arrays bleibt aber gleich. Die bereits einsortierten Elemente am Ende des Arrays liegen physisch noch im Array, gehören logisch aber nicht mehr zum Heap. Sift-Down darf sie deshalb weder vergleichen noch tauschen. Alle Indexprüfungen müssen sich auf die aktuelle Heap-Größe beziehen, nicht auf die Array-Länge. Dieser Punkt ist eine der häufigsten Fehlerquellen bei der Implementierung.

Doppelte Werte: Heapsort funktioniert auch bei gleichen Elementen korrekt, denn die Max-Heap-Bedingung (>=) erlaubt Gleichheit. Beim Sift-Down wird nur getauscht, wenn ein Kind echt größer ist. Dadurch entstehen keine unnötigen Tausche. Die Reihenfolge gleicher Elemente bleibt dabei jedoch nicht erhalten, Heapsort ist nicht stabil. Beispiel: Im Array [2_a, 2_b, 1] (der Index kennzeichnet nur, welche Zwei welche ist) ergibt sich nach dem Aufbau der Heap [2_a, 2_b, 1. In der Sortierphase wird zuerst 2_a mit 1 getauscht und danach 2_b an die Wurzel gehoben und mit 1 getauscht. Das Ergebnis ist [1, 2_b, 2_a], die beiden Zweien haben ihre Reihenfolge vertauscht. Sind alle Elemente gleich, findet kein einziger Tausch beim Absenken statt, und der Algorithmus läuft schneller durch.

Bereits sortierte und umgekehrt sortierte Eingabe.: Heapsort ist nicht adaptiv, es nutzt eine vorhandene Vorsortierung nicht aus. Bei einem aufsteigend sortierten Array muss Phase 1 fast jeden inneren Knoten über viele Ebenen absenken, da die großen Werte hinten stehen. Ein absteigend sortiertes Array ist dagegen bereits ein gültiger Max-Heap, sodass Phase 1 keine Tausche benötigt. Die Sortierphase benötigt dennoch in beiden Fällen O(n log n), weil die Wurzel nach jedem Tausch durch ein kleines Element ersetzt wird, das im Regelfall bis in die unteren Ebenen absinkt. Die garantierte Laufzeit hängt damit nicht von der Eingabeordnung ab. Das ist ein Vorteil gegenüber Quicksort, dessen Laufzeit bei ungünstigen Eingaben auf O(n^2) steigen kann.

*Problemlösung durch den Algorithmus*

Das Problem eines unsortierten Arrays, in welchem die Daten in einer ungünstigen Datenanordnung für Quicksort liegen löst Heapsort am zuverlässigsten. 
Die Worst-Case-Laufzeit von Heapsort ist deutlich schneller mit $O(n log n)$ als Quicksort mit einer O-Notation von $O(n²)$. Somit ist Heapsort im Worst-Case der schnellere Algorhithmus zum Sortieren eines unsortierten Arrays.

== Durchführung des Algorithmus / Demonstration der Datenstruktur an einem Beispiel
#text[
Für Heap-Sort verwenden wir einen Max-Heap (das sollte euch aus „Fortgeschrittene Programmiertechniken“ schon bekannt sein): In einem Max-Heap ist jeder Elternknoten mindestens so groß wie seine Kinder. Deshalb steht das Maximum immer an der Wurzel.

Beispiel: Das Array [4, 10, 3, 5, 1, 8, 7, 6]

Zuerst stellen wir das Array als vollständigen Binärbaum dar. Ein Binärbaum hat höchstens zwei Kinder pro Knoten. Bei einem vollständigen Binärbaum werden die Ebenen von oben nach unten und innerhalb jeder Ebene von links nach rechts gefüllt. Deshalb steht die 4 oben, darunter stehen 10 und 3, dann 5, 1, 8 und 7. Das letzte Element, die 6, kommt als linkes Kind unter die 5.
text
#align(center,image("pictures/tree_unsorted.png", height: 4cm))

Wir bearbeiten die Array-Indizes rückwärts, beginnend beim letzten Knoten, der noch Kinder hat. So sind die Teilbäume unter einem Knoten bereits geprüft, wenn wir ihn bearbeiten.

Für unser Array [4, 10, 3, 5, 1, 8, 7, 6] sind die Indizes: \
Index:  0   1  2  3  4  5  6  7 \
Wert:   4  10  3  5  1  8  7  6

Bei einer 0-basierten Indizierung beginnt der Index bei 0. Der Knoten an Index i hat seine Kinder an den Indizes 2i + 1 und 2i + 2. Der letzte Knoten mit Kindern ist hier an Index 3; deshalb bearbeiten wir die Indizes 3, 2, 1 und 0 in dieser Reihenfolge.

1. Wir beginnen bei Index 3. Dort steht die 5. Sie hat ein Kind an Index 7 mit dem Wert 6. Weil 6 > 5, tauschen wir die beiden Werte. Das Array lautet jetzt [4, 10, 3, 6, 1, 8, 7, 5].
#align(center,image("pictures/tree_sort_1.png", height: 3cm))
2. Wir gehen rückwärts zu Index 2. Dort steht die 3, und ihre Kinder stehen an den Indizes 5 und 6: Dort stehen 8 und 7. Beide sind größer als 3, also tauschen wir die 3 mit dem größeren Kind, der 8. Das Array lautet jetzt [4, 10, 8, 6, 1, 3, 7, 5]. \
#align(center,image("pictures/tree_sort_2.png", height: 3cm))
3. Als Nächstes kommt Index 1. Dort steht die 10. Ihre Kinder stehen an den Indizes 3 und 4: Dort stehen 6 und 1. Beide sind kleiner als 10, deshalb ist hier kein Tausch nötig. Das Array bleibt [4, 10, 8, 6, 1, 3, 7, 5]. \
#align(center,image("pictures/tree_sort_3.png", height: 3cm))
4. Zuletzt bearbeiten wir Index 0, also die Wurzel mit dem Wert 4. Ihre Kinder sind 10 und 8. Wir tauschen die 4 mit dem größeren Kind, der 10. Jetzt steht die 4 an Index 1 und hat die Kinder 6 und 1. Da 6 > 4, tauschen wir die 4 mit der 6. Nun steht die 4 an Index 3 und hat dort noch das Kind 5. Weil 5 > 4, tauschen wir erneut.
#align(center,image("pictures/tree_sort_4.png", height: 3cm))

Danach lautet das Array [10, 6, 8, 5, 1, 3, 7, 4]. Damit ist der Max-Heap aufgebaut. Die 10 steht an der Wurzel, und jeder Knoten ist mindestens so groß wie seine Kinder.

Nun tauschen wir die Wurzel mit dem letzten Element des noch unsortierten Heaps. Das größte Element steht dann an seiner endgültigen Position. Anschließend verkleinern wir den Heap um ein Element und stellen die Heap-Eigenschaft wieder her, indem wir die neue Wurzel bei Bedarf mit ihrem größeren Kind nach unten tauschen.

1. Wir tauschen die Wurzel 10 mit dem letzten Element des Heaps, der 4. Die 10 steht jetzt am Ende des Arrays und ist sortiert. Die neue Wurzel 4 ist kleiner als ihre Kinder 6 und 8. Deshalb tauschen wir sie mit dem größeren Kind, der 8. Danach hat die 4 die Kinder 3 und 7; wir tauschen sie mit der größeren Zahl, der 7. Das Array lautet jetzt [8, 6, 7, 5, 1, 3, 4, (10)].
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_1.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_2.png", height: 3cm),
  ),
)
2. Jetzt tauschen wir die Wurzel 8 mit dem letzten Element des noch unsortierten Heaps, der 4. Die 8 kommt damit an ihre endgültige Position. Die neue Wurzel 4 ist kleiner als ihre Kinder 6 und 7, also tauschen wir sie mit der 7. Das Array lautet jetzt [7, 6, 4, 5, 1, 3, (8), (10)]. Die 4 hat im aktiven Heap nur noch ein Kind: die 3. Da 3 < 4, ist die Heap-Eigenschaft wiederhergestellt.
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_3.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_4.png", height: 3cm),
  ),
)
3. Wir tauschen die Wurzel 7 mit dem letzten Element des noch unsortierten Heaps, der 3. Danach sinkt die 3 nach unten: Sie tauscht zuerst mit der größeren ihrer Kinder, der 6, und anschließend mit der 5. Das Array lautet jetzt [6, 5, 4, 3, 1, (7), (8), (10)].
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_5.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_6.png", height: 3cm),
  ),
)
4. Wir tauschen die Wurzel 6 mit dem letzten Element des noch unsortierten Heaps, der 1. Die 6 ist nun sortiert. Die neue Wurzel 1 sinkt nach unten: Sie tauscht zuerst mit der 5 und danach mit der 3. Das Array lautet jetzt [5, 3, 4, 1, (6), (7), (8), (10)].
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_7.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_8.png", height: 3cm),
  ),
)
5. Wir tauschen die Wurzel 5 mit dem letzten Element des noch unsortierten Heaps, der 1. Die 5 ist nun sortiert. Die neue Wurzel 1 tauscht mit ihrem größeren Kind, der 4. Das Array lautet jetzt [4, 3, 1, (5), (6), (7), (8), (10)].
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_9.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_10.png", height: 3cm),
  ),
)
6. Wir tauschen die Wurzel 4 mit dem letzten Element des noch unsortierten Heaps, der 1. Die 4 ist nun sortiert. Die neue Wurzel 1 tauscht mit ihrem größeren Kind, der 3. Das Array lautet jetzt [3, 1, (4), (5), (6), (7), (8), (10)].
#grid(
  columns: (2),
  rows: (1),
  gutter: 2cm,
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_11.png", height: 3cm),
  ),
  grid.cell(
    colspan: 1,
    image("pictures/tree_heap_12.png", height: 3cm),
  ),
)
7. Zuletzt tauschen wir die Wurzel 3 mit dem letzten noch unsortierten Element, der 1. Damit ist das Array vollständig sortiert: [1, 3, 4, 5, 6, 7, 8, 10].
#align(center,image("pictures/tree_heap_13.png", height: 3cm))
]


= Didaktisches Konzept

== Zielgruppe
Zielgruppe sind die Studenten und Interessierten Informatiker Mittweidas, die sich auf interaktive Weise den Heapsort Algorithmus aneignen und verstehen möchten. Insbesondere Studenten aus dem Studiengang Medieninformatik und Interaktives Entertainment, als auch Kommilitonen aus der gesamten Fakultät "Angewandte Computer- und Biowissenschaften" sollen sich mit diesem Spiel ein Bild über den Heapsort Algorithmus machen können. Die Funktionsweise dieser Lehrmethode soll im Rahmen der Veranstaltungen dieses Moduls im Dezember abgegeben und im Januar vorgestellt werden. Zusammen mit den anderen Gruppen soll ein umfangreiches Lehrkonzept, bestehend aus einer analogen Aufbereitung via Arbeitsblättern, einem Tutorial und eines Interaktiven Spiels, geschaffen werden.

Unsere Zielgruppe muss kein Vorwissen zu dem Thema Heapsort haben. Nach dem Spielen sollen die Spielenden Heap-Bedingung und Sift-Down erklären und den Ablauf von Heapsort an einem kleinen Beispiel selbstständig durchführen können. 

Die Studierenden sind überwiegend zwischen 19 und 22 Jahren alt, das Durchschnittsalter liegt voraussichtlich bei etwa 20 Jahren. Die meisten befinden sich im 3. Fachsemester eines Bachelorstudiums in Vollzeit.

Die Mehrheit hat die allgemeine Hochschulreife oder Fachhochschulreife erworben, ein Teil kommt über eine abgeschlossene Ausbildung, etwa im IT- oder Mediensektor, oder über einen Quereinstieg. Dadurch unterscheiden sich Mathematikkenntnisse und Programmiererfahrung teils deutlich, obwohl alle denselben Studienstand haben.

Die Studierenden haben bereits Module zu Programmierung und Mathematik absolviert und kennen daher Arrays, Schleifen, Rekursion und einfache Sortierverfahren wie Bubble- oder Selection-Sort. Binärbäume und Heaps sind für die meisten neu oder nur aus Überblicksvorlesungen bekannt. Einige können Algorithmen selbstständig implementieren, andere benötigen Beispiele und Visualisierungen, um Abläufe nachzuvollziehen.

Als Medieninformatiker sind die Studierenden im Umgang mit Software, Browsern und verschiedenen Betriebssystemen sicher. Sie nutzen im Alltag Laptop und Smartphone und sind durch Streaming, Soziale Medien und Spiele an hochwertig gestaltete Interfaces gewöhnt. Daher reicht die  Spielerfahrung von gelegentlichem Spielen auf dem Smartphone bis zu regelmäßigem Spielen am PC oder an der Konsole, sodass das Spiel keine Vorkenntnisse in Spielmechaniken voraussetzen darf.



== Lehr-Lern-Ziele
Die Studierenden können den Heapsort Algorithmus in seinem Ablauf mit eigenen Worten erklären und auf 
unsortierte Arrays anwenden. Die Länge der Arrays variiert dabei je nach Komplexitätsstufe. Des Weiteren 
können die Studierenden die einzelnen Arbeitsschritte des Algorithmus unabhängig voneinander logisch ordnen 
und in der richtigen Reihenfolge anwenden.
Darüber hinaus ist das Umwandeln eines unsortierten Arrays in einen binären Baum ebenfalls Teil der 
Lernziele. Die Studierenden sind in der Lage, den binären Baum zielgerichtet in einen binären Max-Heap 
umzuwandeln und gleichzeitig Fehler in jenem zu erkennen. Diese Fehler können dann von den Studierenden 
analysiert und anschließend korrigiert werden. Fehlererkennung ist auch in der Umwandlung eines Arrays in 
einen binären Baum ein wichtiger Teil und gehört auch da zu den erlernten Fähigkeiten der Studierenden. 
Jene Fehler können dann analysiert und anschließend korrigiert werden.

== Didaktische Entscheidungen
1. Baum und Array werden parallel visualisiert
Beschreibung: Jede Aktion im Baum wird zeitgleich im Array (als Weihnachtssocken) sichtbar.
Begründung: Heapsort wird abstrakt als Baum erklärt, aber auf einem Array implementiert. Die Doppeldarstellung verbindet beide Sichten und fördert den Transfer in die Programmierung.

2. Direkte Manipulation per Drag & Drop
Beschreibung: Kugeln werden gezogen, ein Rechtsklick legt sie zurück in die Kiste.
Begründung: Aktives, handelndes Lernen statt passiven Zuschauens. Das Zurücklegen senkt die Hemmschwelle, Dinge auszuprobieren.

3. Sofort-Feedback über Lichterketten
Beschreibung: Verbindungen zwischen Knoten leuchten nicht bei verletzter Heap-Bedingung und bunt, wenn sie korrekt sind.
Begründung: Fehler werden unmittelbar und räumlich lokalisiert, ohne Text lesen zu müssen. Als Ergänzung (nicht als einziger Kanal) gibt es den Hinweistext, z. B. "Heap-Bedingung verletzt", der das Warum erklärt. Das ist auch barrierefreundlicher, da Farbe nicht allein Information trägt.

4. Sortierfehler sind erlaubt
Beschreibung: Falsche Züge werden nicht hart bestraft und führen nicht zum Abbruch.
Begründung: Fehler gelten als Lerngelegenheit. Spieler erkunden die Regeln selbst, statt Angst vor Fehlern zu haben.

5. Simulation mit Play, Pause und Einzelschritt
Beschreibung: Der Heapsort läuft automatisch ab, lässt sich pausieren und Schritt für Schritt weiterschalten.
Begründung: Spieler steuern ihr eigenes Tempo (Reduktion der kognitiven Belastung). Die Simulation dient als bearbeitbares Beispiel, an dem man den Ablauf nachvollzieht, bevor man ihn selbst anwendet.

6. Zuerst das Grundprinzip, dann Farben und Zahlen
Beschreibung: Erst wird die reine Heap-Struktur gespielt, danach kommen Wertungen (Farbe, Größe, Zahl) hinzu.
Begründung: Schrittweise Komplexitätssteigerung. Die verschiedenen Wertungen zeigen außerdem, dass ein Heap nur von der Vergleichsrelation abhängt, nicht von Zahlen (Variation der Merkmale fördert Transfer).

#v(5em)
7. Socken-Adventskalender in 2D-Sicht
Beschreibung: Das Array wird als Weihanhctssocken am Kamin dargestellt, auf denen Zahlen stehen. 
Begründung: Konkrete, vertraute Metapher für abstrakte Speicherplätze. Die 2D-Sicht hält die Darstellung übersichtlich und die Bedienung einfach.

== Übersicht über die Verteilung der Inhalte
=== Universalmodus
Der Universalmodus ist eine freie Übungsumgebung, in der Nutzerinnen und Nutzer Heapsort selbst ausprobieren und mit dem Ablauf des eingebauten Algorithmus vergleichen können.

- Eingabe und Darstellung: Zu Beginn legen die Nutzerinnen und Nutzer die Anzahl und Werte der Elemente fest oder lassen eine zufällige Folge erzeugen. Die Elemente werden sowohl als Array als auch als Heap-Baum dargestellt. Die Startanordnung lässt sich ebenfalls festlegen.
- Heap aufbauen: Zunächst wird aus den Elementen ein Max-Heap erstellt. Der jeweils betrachtete Knoten und seine Kinder werden hervorgehoben. Nutzerinnen und Nutzer können die nötigen Vergleiche und Vertauschungen selbst ausführen.
- Heap sortieren: Anschließend wird wiederholt das größte Element an die letzte noch unsortierte Position verschoben. Der verkleinerte Heap wird danach durch weitere Vergleiche und Vertauschungen wiederhergestellt. Sortierter Bereich und verbleibender Heap werden visuell voneinander abgegrenzt.

Während des gesamten Ablaufs stehen folgende Bedienelemente zur Verfügung:

- Rückgängig: Macht den letzten Schritt rückgängig. Optional können zusätzliche Tastenkombinationen mehrere Schritte zurückspringen, zum Beispiel fünf oder zehn.
- Einen Schritt vorwärts: Führt den nächsten Schritt des eingebauten Heapsort-Algorithmus aus. Optional kann die Schrittweite per Tastenkombination auf fünf oder zehn Schritte erhöht werden.
- Automatisch: Lässt den Algorithmus selbstständig ablaufen. Die Geschwindigkeit wird über eine einstellbare Anzahl von Zügen pro Sekunde festgelegt.
- Pause/Weiter: Pausiert den automatischen Ablauf beziehungsweise setzt ihn fort.

Die Nutzerinnen und Nutzer können die Heap-Operationen außerdem selbst ausführen, etwa Elemente vergleichen und vertauschen. Eine Schritt-für-Schritt-Historie ermöglicht es, den Vorgang zurückzuverfolgen und einzelne Entscheidungen nachzuvollziehen.

=== Optionaler Levelmodus

Falls ausreichend Zeit zur Verfügung steht, kann ergänzend ein Levelmodus mit vorbereiteten Aufgaben umgesetzt werden. Die Level könnten schrittweise schwieriger werden, zum Beispiel durch größere Arrays oder zusätzliche Bedingungen. Denkbar wären auch verschiedenfarbige Kugeln oder andere Formen, deren Eigenschaften sich auf die Sortieraufgabe auswirken. Dieser Modus ist bislang nicht konkret ausgearbeitet und hat gegenüber dem Universalmodus keine Priorität.


= Audio-Visuelles Konzept

== Erste wichtige Skizzen / Visionen
#figure(
  grid(columns: (5),
    image("pictures/Socke.png", height: 3cm, width: auto),
    image("pictures/Kamin.png", height: 3cm, width: auto),
    image("pictures/Kugel_Rot.png", height: 3cm, width: auto),
    image("pictures/Skizze_Christmastree_Heapsort_Game.png", height: 3cm, width: auto),
    image("pictures/Tree_mit_Kugeln.png", height: 3cm, width: auto),
  ), caption: "Skizzen und erste Ideen für die Visualisierung des Spiels in Form eines Weihnachtsbaums mit Kugeln und Socken"
)


== Designentscheidungen


Entscheidung 1: Gesamtsetting „Weihnachtsraum“

*Beschreibung:* Das Spiel findet in einem gemütlichen Weihnachtsraum statt. Zu sehen sind ein Kamin mit Feuer, ein Bild an der Wand sowie Socken am Kamin. Die Farbpalette besteht aus warmen Farben (Rot-, Orange- und Gelbtöne).

*Begründung:* Ein durchgängiges Setting verbindet alle Spielelemente zu einer stimmigen Geschichte. Die warme, ruhige Atmosphäre senkt die Hemmschwelle gegenüber dem abstrakten Thema Heapsort und lädt zum Ausprobieren ein. Da Fehler im Spiel ausdrücklich erlaubt sind, unterstützt die einladende Stimmung eine entspannte Lernsituation ohne Leistungsdruck.

// Bild: Moodboard / Skizze des Weihnachtsraums

Entscheidung 2: Der Baum als Tannenbaum mit Kugeln

*Beschreibung:* Der Heap wird als Tannenbaum dargestellt. Die Knoten des Baumes sind Christbaumkugeln, die auf dem grünen Baum angeordnet werden. Die Kugeln werden per Drag and Drop bewegt.

*Begründung:* Ein Tannenbaum besitzt eine natürliche hierarchische Struktur und passt damit gut zur Baumstruktur des Heaps. Das Schmücken eines Baumes ist eine vertraute Handlung, die das Verschieben und Vertauschen von Knoten anschaulich und intuitiv macht. So kann sich die Aufmerksamkeit auf die Heap-Bedingung statt auf die Bedienung richten.

Entscheidung 3: Das Array als Weihnachtssocken am Kamin

*Beschreibung:* Das Array wird als Reihe von Weihnachtssocken am Kamin abgebildet. Jede Socke entspricht einem Arrayfeld der dazugehörigen Kugel. Wird die größte Kugel "aussortiert", ändert sich die Darstellung der Socken entsprechend. Die Socken fungieren als UI-Element und erinnern an einen Adventskalender, dessen Zahlen der "korrekten" Reihenfolge nach sortiert werden.

*Begründung:* Zentrales Lernziel ist, dass das, was im Baum passiert, zugleich im Array passiert. Beide Darstellungen sind deshalb gleichzeitig sichtbar. Die Socken passen zum Setting, und die Adventskalender-Metapher ähnelt dem schrittweisen Vorgehen des Sortierverfahrens: Mit jedem Schritt wird ein Element aus dem Heap entnommen und an die richtige Stelle gesetzt.

// Bild: Skizze Kamin mit Socken-Array
#v(2em)

Entscheidung 4: Kugeln mit Farbe, Größe und Zahl als Wertung

*Beschreibung:* Die Kugeln unterscheiden sich in Farbe (Rot, Gelb, Lila), Größe und Zahl. Der Baum selbst bleibt einheitlich grün. Zunächst steht das grundlegende Prinzip im Vordergrund, anschließend werden Farben, Größen und Zahlen als zusätzliche Wertungskriterien eingeführt.

*Begründung:* Verschiedene Wertungen ermöglichen unterschiedliche Schwierigkeitsgrade, ohne ein Levelsystem zu benötigen. Die Kugelfarben heben sich deutlich vom grünen Baum ab und bleiben gut erkennbar. Der schrittweise Aufbau verhindert eine Überforderung zu Beginn.

Entscheidung 5: Lichterketten als visuelles Feedback

*Beschreibung:* Lichterketten verbinden die Knoten des Baumes. Solange ein Knoten die Heap-Bedingung verletzt (unsortiert ist), bleibt die Lichterkette an dieser Stelle dunkel. Sobald der Knoten korrekt eingeordnet ist, leuchtet sie auf.

*Begründung:* Die Lichterketten machen die Kanten des Baumes sichtbar und zeigen unmittelbar, wo die Heap-Bedingung erfüllt oder verletzt ist. Das Feedback ist direkt, wortlos und passt zum Setting. Lernende erkennen so selbstständig, an welcher Stelle noch Handlungsbedarf besteht.

Entscheidung 6: Weihnachtsstern als Erfolgsrückmeldung

*Beschreibung:* Sind die Kugeln korrekt sortiert, erscheint der Weihnachtsstern als Abschlussfeedback. Optional kann Prof. Grundwald als Wichtel im Spiel auftreten, beispielsweise als Begleiter oder Kommentator.

*Begründung:* Der Stern ist der klassische Abschluss beim Schmücken eines Baumes und bildet damit einen natürlichen Höhepunkt. Er belohnt den Lernerfolg, ohne dass ein zusätzlicher Text nötig ist. Die Wichtel-Figur könnte die Identifikation erhöhen, ist aber noch optional.

Entscheidung 7: Interaktion über eine Hand als Cursor

*Beschreibung:* Der Mauszeiger ist eine offene Hand zum Greifen. Beim Drücken der linken Maustaste schließt sich die Hand, sodass eine Kugel per Drag and Drop bewegt werden kann. Das Ganze simuliert eine Person, die den Weihnachtsbaum schmückt.

*Begründung:* Der Zustandswechsel von offener zu geschlossener Hand gibt direktes Feedback, ob ein Objekt gegriffen wurde, und macht die Handlung greifbar. Die Metapher unterstützt das Setting und sorgt dafür, dass die Interaktion ohne Erklärung verständlich ist.

Entscheidung 8: Simulationssteuerung als abgebissene Kekse

*Beschreibung:* Die Steuerelemente für Start, Pause und „einen Schritt weiter“ werden als Keksformen mit Bissspuren gestaltet. Die Bissform bildet jeweils das Symbol des Buttons.

*Begründung:* Die Bedienelemente fügen sich in das Weihnachtssetting ein und bleiben dennoch als Standardsymbole erkennbar. Die Simulation, die den Heapsort selbstständig durchläuft, kann so jederzeit angehalten oder Schritt für Schritt nachvollzogen werden.

#v(2em)
Entscheidung 9: Hintergrund und Fokus

*Beschreibung:* Als Hintergrund dient ein Bild in 2K-Auflösung. Rückt der Baum in den Fokus, wird der Hintergrund unscharf dargestellt (Blur).

*Begründung:* Der Weichzeichner lenkt die Aufmerksamkeit auf den Baum und das Array, während die Atmosphäre des Raumes erhalten bleibt. Dadurch wird kognitive Überlastung durch Nebenelemente vermieden.

Entscheidung 10: Typografie

*Beschreibung:* Es werden weihnachtlich wirkende Schriftarten verwendet, vorgesehen sind „Santa’s Big Secret“ (https://www.1001freefonts.com/de/santas-big-secret.font) und „Navidad“ (https://www.dafontfree.io/navidad-font/).

*Begründung:* Die Schriften unterstützen das Setting und die Stimmung. Wichtig ist, dass Zahlen auf den Kugeln gut lesbar bleiben, da sie für die Wertung entscheidend sind. Dies ist beim Testen zu prüfen.

Entscheidung 11: Hinweistexte (offen)

*Beschreibung:* Es ist noch offen, ob Hinweistexte wie „Heap-Bedingung verletzt“ umgesetzt werden. Zu klären ist, ob dies technisch machbar ist und ob das visuelle Feedback durch die Lichterketten bereits ausreicht.

*Begründung:* Zu viel Text kann die Atmosphäre stören und vom Geschehen ablenken. Andererseits können kurze Hinweise Lernenden helfen, den Grund eines Fehlers zu verstehen. Die Entscheidung wird nach ersten Tests getroffen.

Entscheidung 12: Hintergrundmusik

*Beschreibung:* Im Hintergrund läuft ruhige, urheberrechtsfreie Weihnachtsmusik.

*Begründung:* Die Musik verstärkt die Atmosphäre des Settings. Die Verwendung urheberrechtsfreier Stücke vermeidet rechtliche Probleme. Die Musik sollte leise und unaufdringlich sein, damit sie die Konzentration nicht stört.

Entscheidung 13: Soundeffekte (offen)

*Beschreibung:* Soundeffekte für richtige und falsche Platzierungen sowie für den Abschluss sind noch nicht festgelegt. Denkbar sind ein Glöckchenklang bei Erfolg und ein sanfter, nicht abwertender Ton bei Fehlern. Quellen und Lizenzen der Audio-Assets sind noch zu klären.

*Begründung:* Akustisches Feedback ergänzt das visuelle Feedback und verstärkt den Lerneffekt. Da Sortierfehler von uns aus im Spiel erlaubt sind, sollten Fehlertöne ermutigend statt bestrafend wirken.

= Weitere Ergänzungen, die Sie für sinnvoll halten.

Bisher sind noch keine sinnvollen Ergänzungen in Frage gekommen, bzw. durchdacht worden. Allerdings wird die Erweiterung des Dokuments auf eine Teststrategie, Evaluation und Feedback-Visualisierung in Zukunft sicherlich sinnvoll.
