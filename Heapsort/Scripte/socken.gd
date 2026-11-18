class_name SockArray
extends HBoxContainer

## Szene, aus der die einzelnen Socken erzeugt werden.
@export var sock_szene: PackedScene
@export var baum: Node2D
##0 = Nichts sortiert 3 = die letzten 3 elemente sind sortiert
var sorted_amount: int = 0

func ensure_count(anzahl: int) -> void:
	while get_child_count() > anzahl:
		var sock := get_child(get_child_count() - 1)
		remove_child(sock)
		sock.free()

	while get_child_count() < anzahl:
		add_child(sock_szene.instantiate())


func aufbauen(anzahl: int) -> void:
	ensure_count(anzahl)

func aktualisieren(werte: Array[int]) -> void:
	ensure_count(werte.size())

	var erwartet: Array[int] = []
	for wert in werte:
		erwartet.append(wert)
	erwartet.sort()

	var first_sorted := werte.size()
	for i in range(werte.size() - 1, -1, -1):
		if werte[i] != erwartet[i]:
			break
		first_sorted = i

	for i in range(werte.size()):
		var sock := get_child(i) as Sock
		sock.set_value(werte[i], i)
		sock.set_sorted(i >= first_sorted)



func set_all_sorted() -> void:
	for sock in get_children():
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
	#print("SORT TRIGGERED: ", value, "   ",index, "   ",values)
	sorted_amount += 1
	aktualisieren(values)
