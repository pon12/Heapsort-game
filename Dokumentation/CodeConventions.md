# Codekonventionen

## Namenskonventionen

Für GDScript verwenden wir folgende Namenskonventionen:

- Variablen, Funktionen und Signale: `snake_case`
- Klassen: `PascalCase`
- Nodes: `PascalCase`
- Konstanten: `CONSTANT_CASE`

Objekte sind Instanzen von Klassen. Ihre Bezeichner behandeln wir wie Variablennamen und schreiben sie daher in `snake_case`.

Wir beginnen eigene Funktionen und Variablen grundsätzlich nicht mit einem Unterstrich. In Godot kennzeichnet der Unterstrich häufig virtuelle Methoden der Engine, die wir überschreiben können, zum Beispiel `_ready()` oder `_process()`.

### Klassen, Objekte und Nodes

Klassen beschreiben, wie Objekte aufgebaut sind und sich verhalten. Ein Objekt ist eine konkrete Instanz einer Klasse.

Nodes sind spezielle Objekte. Sie können einem Szenenbaum hinzugefügt werden und bilden dort die Bestandteile einer Szene. Andere Objekte werden nicht automatisch zu Nodes im Szenenbaum.

## Typisierung

Bei Variablen, Funktionsparametern und Rückgabewerten geben wir den Typ ausdrücklich an. So ist direkt erkennbar, welche Werte eine Funktion erwartet und welchen Wert sie zurückgibt. Aussagekräftige Namen allein reichen dafür nicht immer aus.

```gdscript
var meine_variable: int = 69

func meine_funktion(parameter1: int, parameter2: Node2D) -> void:
    pass
```

## Dokumentation im Code

Godot unterstützt Dokumentationskommentare mit `##`. Damit können wir Beschreibungen direkt im Code hinterlegen. Der Editor kann diese Dokumentation beispielsweise anzeigen, wenn wir den Mauszeiger über einen dokumentierten Begriff bewegen.

Wir verwenden `##` für Dokumentation. Normale Kommentare mit `#` setzen wir sparsam ein, etwa um eine ungewöhnliche Implementierung oder den Grund für eine bestimmte Entscheidung zu erklären. Kommentare sollten nicht lediglich wiederholen, was der Code bereits eindeutig ausdrückt.

Ein Beispiel findet sich in `Heapsort/Objekte/ActionStack.gd`.

## Ordnerstruktur

Unsere aktuelle Ordnerstruktur sieht folgendermaßen aus:

```text
Heapsort/
├── Assets/
├── Objekte/
├── Scripte/
└── Szenen/
```

- In `Assets/` speichern wir alle Projektressourcen, zum Beispiel Grafiken, Audiodateien und Schriftarten.
- In `Scripte/` speichern wir Skripte, die nicht direkt zu einem Objekt gehören.
- In `Objekte/` speichern wir Skripte und Szenen, die wiederverwendbare Objekte oder Komponenten darstellen.
- In `Szenen/` speichern wir eigenständige Szenen, zum Beispiel das Hauptmenü oder die Benutzeroberfläche.
