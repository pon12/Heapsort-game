class_name SockArray
extends HBoxContainer

## Szene, aus der die einzelnen Socken erzeugt werden.
@export var sock_szene: PackedScene


## Erzeugt die Socken neu und entfernt vorher alle bisherigen.
func aufbauen(anzahl: int) -> void:
	for kind: Node in get_children():
		kind.queue_free()
	for i: int in anzahl:
		add_child(sock_szene.instantiate())

## Aktualisiert alle Socken passend zum Zustand des Baums.
func aktualisieren(werte: Array[int], sortiert: Array[int]) -> void:
	print("aktualisieren: ", werte, " Kinder: ", get_child_count())
	for i: int in werte.size():
		
		var sock: Sock = get_child(i)
		print("Test: " , sock)
		sock.anzeigen(werte[i], i in sortiert)
