extends Control

@export var tree: Node2D
@onready var sorted_label: Label = $VBoxContainer/Label
@export var zahlen_eingabe: LineEdit
@onready var kugel_anzahl: SpinBox = $VBoxContainer/KugelAnzahl

func _ready() -> void:
	if tree == null:
		print("UI has no Tree assigned")

func _on_button_pressed() -> void:
	if tree.pruefe_sortierung():
		sorted_label.text = "Sortiert"
		tree._aktualisiere_lichterketten()
	else:
		sorted_label.text = "Nicht Sortiert"
		tree.next_step()


func Back_button_on_pressed() -> void:
	if tree != null and tree.has_method("step_back"):
		tree.step_back()

func pruefe_eingabe(text: String) -> Array[int]:
	var zahlen: Array[int] = []
	var teile := text.split(",")

	if teile.size() < 3 or teile.size() > 15:
		sorted_label.text = "Bitte 3 bis 15 Zahlen eingeben!"
		return zahlen

	for teil in teile:
		var wert := teil.strip_edges()

		if not wert.is_valid_int():
			sorted_label.text = "Ungueltige Eingabe: " + wert
			return []

		zahlen.append(int(wert))

	return zahlen
	
func _on_eingabe_button_pressed() -> void:
	var zahlen := pruefe_eingabe(zahlen_eingabe.text)

	if zahlen.is_empty():
		return

	tree.setze_zahlen(zahlen)
	sorted_label.text = "Zahlen uebernommen!"

func _on_zufallsbutton_pressed() -> void:
	var anzahl: int = int(kugel_anzahl.value)

	var zahlen: Array[int] = tree.generiere_zufallszahlen(anzahl)

	tree.setze_zahlen(zahlen)

	sorted_label.text = "Nicht Sortiert"
