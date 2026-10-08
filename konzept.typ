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
  title: "Konzeptdokument",
  authors: "Gruppe X0",
  abstract: platzhalter("Dieses Dokument wird bewertet! Nehmen Sie es ernst!"),
  date: datetime.today()
)

= Einführung zum Thema
#platzhalter[In der Einführung zeigen Sie, wie intensiv Sie sich bereits mit dem Algorithmus bzw. der Datenstruktur auseinandergesetzt haben. Gehen Sie dabei ordentlich ins Detail, damit Ihre Ausarbeitung später als Referenz genutzt werden kann. Denken Sie daran: Das gesamte Dokument wird benotet – also auch dieser Abschnitt.]

== Zugrundeliegendes Problem
#platzhalter[Beschreiben Sie in diesem Abschnitt, welches Problem Ihr Algorithmus oder Ihre Datenstruktur löst. Gehen Sie dabei auf die praktische Relevanz ein und verdeutlichen Sie Ihre Ausführungen anhand einer Skizze, Abbildung oder eines Beispiels.]

== Überblick über die Lösungen
#platzhalter[Geben Sie einen Überblick, welche Lösungsmöglichkeiten für das oben beschriebene Problem durch Algorithmen oder Datenstrukturen existieren. Nutzen Sie nach Möglichkeit eine Visualisierung, um die Übersicht anschaulich zu gestalten. Ordnen Sie anschließend Ihren gewählten Ansatz in dieses Gesamtfeld ein. So wird deutlich, wo sich Ihr Thema im größeren Kontext befindet und welche Berührungspunkte es zu anderen Lösungen gibt.]

== Vorstellung des Algorithmus / der Datenstruktur
#platzhalter[Stellen Sie an dieser Stelle den gewählten Algorithmus bzw. die Datenstruktur im Detail vor. Gehen Sie auf die zugrunde liegenden Prinzipien, die algorithmischen Eigenschaften sowie den genauen Ablauf bzw. Aufbau ein. Verdeutlichen Sie außerdem, warum dieser Ansatz das zuvor beschriebene Problem zufriedenstellend löst. Nutzen Sie Abbildungen, und berücksichtigen Sie auch Sonderfälle und notwendige Operationen. Ziel ist es, ein fundiertes Verständnis aufzubauen, das Ihnen im weiteren Projektverlauf als Grundlage dient. Je genauer Sie hier Ihr eigenes Verständnis entwickeln und dokumentieren, desto leichter fällt Ihnen die spätere Arbeit im Projekt.]

== Durchführung des Algorithmus / Demonstration der Datenstruktur an einem Beispiel
#platzhalter[Arbeiten Sie den Algorithmus bzw. die Datenstruktur vollständig an einem Beispiel durch. Nutzen Sie dabei eine Kombination aus Abbildungen und erläuterndem Text. Wählen Sie kein minimales Beispiel, sondern eines, an dem sich die wesentlichen Eigenheiten und Mechanismen deutlich nachvollziehen lassen.]

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
