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
#platzhalter[In der Einführung zeigen Sie, wie intensiv Sie sich bereits mit dem Algorithmus bzw. der Datenstruktur auseinandergesetzt haben. Gehen Sie dabei ordentlich ins Detail, damit Ihre Ausarbeitung später als Referenz genutzt werden kann. Denken Sie daran: Das gesamte Dokument wird benotet – also auch dieser Abschnitt.]

== Zugrundeliegendes Problem
#platzhalter[Beschreiben Sie in diesem Abschnitt, welches Problem Ihr Algorithmus oder Ihre Datenstruktur löst. Gehen Sie dabei auf die praktische Relevanz ein und verdeutlichen Sie Ihre Ausführungen anhand einer Skizze, Abbildung oder eines Beispiels.]

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

#v(2em)


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
#platzhalter[Bevor Sie mit der Implementierung starten, entwickeln Sie zunächst ein umfassendes Konzept. Da Ihre Projektarbeit auf die Erstellung von Lehrmaterialien abzielt, ist es wichtig, dass dieses Konzept didaktisch gut durchdacht ist. Denken Sie daran: Das gesamte Dokument wird benotet – also auch dieser Abschnitt.]

== Zielgruppe
#platzhalter[Beschreiben Sie Ihre Zielgruppe -- also Ihre Kommilitonen--, die sich in der zweiten Hälfte des Moduls mithilfe Ihres Projektergebnisses weiterbilden werden.]

== Lehr-Lern-Ziele
#platzhalter[Grundlage für alles sind die Lehr-Lern-Ziele, die beschreiben, was Sie mit Ihrem Projektergebnis erreichen wollen. Sie legen fest, was Lernende nach einer Veranstaltung tatsächlich können sollen. Deshalb werden sie konsequent aus der Perspektive der Studierenden formuliert ("Die Studierenden können ...") und nicht aus der Sicht der Lehrenden. Vage Formulierungen wie "verstehen" oder "wissen" eignen sich nicht, weil sie schwer prüfbar sind. Stattdessen verwendet man handlungsorientierte Verben wie "analysieren", "erklären", "vergleichen", "anwenden" oder "konstruieren". Hilfreich ist dabei das SMART-Prinzip, das Ziele spezifisch, messbar, attraktiv, realistisch und terminiert macht. Eine wichtige Rolle spielt die Bloom'sche Taxonomie, die Lernziele nach kognitiver Anspruchshöhe staffelt. Sie unterscheidet zwischen den Stufen Erinnern, Verstehen, Anwenden, Analysieren, Evaluieren und Erschaffen. Je nach gewünschtem Kompetenzniveau werden passende Verben gewählt, sodass Lernziele vom einfachen Faktenabruf bis hin zu komplexen Problemlösungen differenziert formuliert werden können.

Ein Beispiel aus einem anderen Bereich verdeutlicht den Unterschied. Das Ziel "UML verstehen" ist ungeeignet, weil es kein konkretes Können beschreibt, unklar bleibt, was genau gemeint ist, und damit auch nicht überprüfbar wird. Besser sind mehrere, abgestufte Ziele, die verschiedene Anspruchsniveaus der Taxonomie abdecken. Hier ist eine Auswahl möglicher konkreter Ziele als Beispiel:
- Die Studierenden können zentrale Elemente der UML (z. B. Klasse, Assoziation, Generalisierung) korrekt benennen. (Erinnern)
- Die Studierenden können in eigenen Worten erklären, wie ein Klassendiagramm grundlegende Strukturen eines Softwaresystems darstellt. (Verstehen)
- Die Studierenden können für ein gegebenes Szenario ein UML-Klassendiagramm erstellen, das die relevanten Entitäten und Beziehungen korrekt abbildet. (Anwenden)
- Die Studierenden können in einem vorliegenden UML-Aktivitätsdiagramm Modellierungsfehler identifizieren und begründen, warum diese problematisch sind. (Analysieren)
- Die Studierenden können unterschiedliche UML-Diagrammtypen (z. B. Klassen-, Aktivitäts-, Sequenzdiagramm) hinsichtlich ihrer Eignung für eine bestimmte Aufgabenstellung beurteilen. (Evaluieren)
- Die Studierenden können auf Basis einer textuellen Anforderungsspezifikation ein konsistentes Set aus mindestens drei UML-Diagrammen entwickeln, das die wichtigsten strukturellen und dynamischen Aspekte des Systems abbildet. (Erschaffen)
Die 6 Beispielziele decken die vage Formulierung "UML verstehen" nicht vollständig ab; die konkrete Formulierung der Ziele ermöglicht es Ihnen aber, viel besser abzustecken, was wirklich erreicht werden soll. Sie merken also hoffentlich, dass hier Sorgfalt notwendig ist; und dass die Liste durchaus einige Ziele enthalten kann! Es lohnt sich aber, da Sie die Ziele zu jedem Zeitpunkt als Checklist / Maßstab nutzen können, um ihren Projektfortschritt zu evaluieren.
]

== Didaktische Entscheidungen
#platzhalter[Im Abschnitt Didaktische Entscheidungen werden alle wesentlichen Festlegungen dokumentiert, die sonst oft "aus dem Bauch heraus" getroffen würden. Jede Entscheidung besteht aus einem kurzen Titel, einer knappen Beschreibung und einer Begründung. So wird nachvollziehbar, warum bestimmte Methoden, Medien, Formate, Mechaniken, ... gewählt wurden und wie diese mit den Lehr-Lern-Zielen zusammenhängen. Auf diese Weise wird sichergestellt, dass zentrale didaktische Überlegungen explizit gemacht, reflektiert und für Dritte transparent werden. Zuerst wird es aussehen, als würden hier nur wenige Basisentscheidungen stehen; überlegen Sie aber genau und das Kapitel wird sich füllen!

Beispiel:

#entscheidung("Gesprochene Dialoge im Lehrspiel", "Alle Texte im interaktiven Tutorial (z. B. NPC-Dialoge, Hilfestellungen, Hinweise) werden nicht nur als Text angezeigt, sondern zusätzlich eingesprochen. Die Stimmen stammen von Mitgliedern des Projektteams.", "Durch den Einsatz menschlicher Stimmen entsteht eine persönlichere, angenehmere Lernumgebung, die die Beziehung zwischen Lernenden und Inhalt stärkt. Gesprochene Sprache vermittelt Emotionen und Nähe besser als reiner Text und wirkt dadurch motivierender. Außerdem wird das Risiko reduziert, dass Lernende Texte lediglich überfliegen oder überspringen, ohne sich mit dem Inhalt auseinanderzusetzen.")
]

== Übersicht über die Verteilung der Inhalte
#platzhalter[Gerade bei den Spezialisierungen Video und interaktives Tutorial sollen Sie hier die Struktur Ihres Materials darstellen. Geben Sie also Video für Video bzw. Level für Level an, welche Inhalte in welcher Reihenfolge vermittelt werden und welche Mechaniken Sie jeweils einsetzen. Auf diese Weise werden bereits Zusammenhänge und Abhängigkeiten sichtbar, sodass ein stimmiger Ablauf entsteht. Wichtig ist dabei, nicht nur Oberbegriffe zu nennen, sondern schon so konkret zu werden, dass sich die geplante Struktur auf Plausibilität prüfen lässt.]
#text[
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


]

= Audio-Visuelles Konzept
#platzhalter[Hier folgt die Konzeption der audio-visuellen Darstellung. Bevor Sie mit der eigentlichen Umsetzung beginnen, entwickeln Sie zunächst ein klares Gestaltungskonzept. Da Ihre Projektarbeit nicht nur inhaltlich, sondern auch visuell und akustisch überzeugen soll, ist es wichtig, dass Farben, Formen, Stimmen und Klänge, Stimmungen und vieles weitere bewusst gewählt und auf die Lehr-Lern-Ziele abgestimmt sind. So stellen Sie sicher, dass die Materialien nicht nur korrekt, sondern auch ansprechend, konsistent und lernförderlich gestaltet werden. Denken Sie daran: Das gesamte Dokument wird benotet – also auch dieser Abschnitt.]

== Erste wichtige Skizzen / Visionen
#platzhalter[Sicher haben Sie zu Beginn bereits ein erstes Set an Skizzen angefertigt, um Ihre Vision zu verdeutlichen. Ergänzen Sie diese hier und fügen Sie kurze textuelle Erläuterungen hinzu. #align(center,image("bild.png", height: 8cm))
]

== Designentscheidungen
#platzhalter[Im Abschnitt Designentscheidungen werden alle wesentlichen Festlegungen dokumentiert, die sonst oft "aus dem Bauch heraus" getroffen würden. Diesmal beziehen Sie sich jedoch nicht primär auf die Didaktik, sondern eher auf die audio-visuelle Ausgestaltung des Projektes. Jede Entscheidung besteht aus einem kurzen Titel, einer knappen Beschreibung und einer Begründung. Wenn vorhanden, kann ein Bild angfügt werden. So wird nachvollziehbar, warum bestimmte Stile, Farben, Anordnungen, Töne, Stimmungen,... gewählt wurden und wie diese mit den Lehr-Lern-Zielen zusammenhängen. Auf diese Weise wird sichergestellt, dass zentrale audiovisuelle Designüberlegungen explizit gemacht, reflektiert und für Dritte transparent werden. Zuerst wird es aussehen, als würden hier nur wenige Basisentscheidungen stehen; überlegen Sie aber genau und das Kapitel wird sich füllen!

Beispiel (könnten auch zwei Entscheidungen sein!):

#entscheidung("Hochschulblau als Akzentfarbe im Pixel-Art-Stil", "Das offizielle Hochschulblau wird als Akzentfarbe verwendet und gezielt in einer Pixel-Art-Optik umgesetzt, die sich durch klare, kantige Formen und reduzierte Farbflächen auszeichnet. So erscheinen Buttons, Symbole und Illustrationen in einer spielerisch anmutenden Gestaltung.", "Die Wahl der Hochschulfarbe sorgt für Wiedererkennbarkeit und Verankerung im institutionellen Kontext, während die Pixel-Art-Umsetzung positive Assoziationen zu Spielen weckt. Diese spielerische Anmutung erleichtert den Zugang, senkt Hemmschwellen und steigert die Motivation. Lernende erleben die Oberfläche als vertraut und gleichzeitig spielerisch herausfordernd, was nachweislich die Aufmerksamkeit und die Bereitschaft zum Ausprobieren fördert. Durch die Kombination von institutioneller Vertrautheit und spielerischem Design wird so die Lernumgebung sowohl konsistent als auch lernförderlich gestaltet.", bild: image("bild2.png", scaling: "pixelated", height: 4cm))
]

= Weitere Ergänzungen, die Sie für sinnvoll halten.
