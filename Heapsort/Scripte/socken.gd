class_name SockArray
extends HBoxContainer

## Szene, aus der die einzelnen Socken erzeugt werden.
@export var sock_szene: PackedScene
@export var baum: Node2D
##0 = Nichts sortiert 3 = die letzten 3 elemente sind sortiert
var sorted_amount: int = 0

## Erzeugt die Socken neu und entfernt vorher alle bisherigen.
func aufbauen(anzahl: int) -> void:
	for kind: Node in get_children():
		kind.queue_free()
	for i: int in anzahl:
		add_child(sock_szene.instantiate())

## Aktualisiert alle Socken passend zum Zustand des Baums.
func aktualisieren(werte: Array[int]) -> void:
	print("aktualisieren: ", werte, " Kinder: ", get_child_count())
	for i: int in werte.size():
		var sock: Sock = get_child(i)
		print("Test: " , sock)
		sock.set_value(i)

	var anzahl: int = get_child_count()
	var sortiert: int = clampi(sorted_amount, 0, anzahl)
	for i: int in range(anzahl - sortiert, anzahl):
		var sock: Sock = get_child(i)
		sock.set_sorted(true)


func on_pop_action() -> void:
	sorted_amount -= 1
	if baum.has_method("get_kugeln_array"):
		var kugeln: Array[TreeNode] = baum.get_kugeln_array()
		var werte: Array[int] = []
		for kugel: TreeNode in kugeln:
			werte.append(kugel.number)
		aktualisieren(werte)
	

func on_heap_sort_element_sorted(value: Variant, index: int, values: Array[int]) -> void:
	print("SORT TRIGGERED: ", value, "   ",index, "   ",values)
	sorted_amount += 1
	aktualisieren(values)
