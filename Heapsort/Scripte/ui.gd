extends Control

@export var tree: Node2D
@onready var sorted_label: Label = $VBoxContainer/Label
@onready var speed_slider: HSlider = $VBoxContainer/speed_slider
@onready var auto_algo_button: CheckButton = $VBoxContainer/auto_algo_button

var auto_speed: float = 1.0
var auto_timer: float = 0.0
var auto_is_active: bool = false
@export_category("Geschwindigkeit Auto-Algo")
##0.1 ~ 10 moves per second 1.0 ~ 1 move per second
@export var stufe0 = 1.0
@export var stufe1 = 0.8
@export var stufe2 = 0.5
@export var stufe3 = 0.4
@export var stufe4 = 0.2
@export var stufe5 = 0.1
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
		#sorted_label.text = "Nicht Sortiert"
		tree.next_step()


func Back_button_on_pressed() -> void:
	ActionStack.pop_action()
	if tree and tree.has_method("aktualisiere_nach_aktion"):
		tree.aktualisiere_nach_aktion()

func on_speed_slider_drag_ended(value_changed: bool) -> void:
	if value_changed == false:
		return
	else:
		# 0.1 ~ 10 moves per second 1.0 ~ 1 move per second
		match speed_slider.value:
			0.0:
				auto_speed = stufe0
			1.0:
				auto_speed = stufe1
			2.0:
				auto_speed = stufe2
			3.0:
				auto_speed = stufe3
			4.0:
				auto_speed = stufe4
			5.0:
				auto_speed = stufe5
		print("New Speed: ", auto_speed)
	
func _process(delta: float) -> void:
	if not auto_is_active or tree == null:
		return

	if tree.pruefe_sortierung() == true:
		auto_is_active = false
		auto_algo_button.button_pressed = false
		sorted_label.text = "Sortiert"
		return
	
	auto_timer += delta
	sorted_label.text = "Nicht Sortiert"
	
	if auto_timer >= auto_speed:
		auto_timer -= auto_speed
		tree.next_step()

func on_auto_algo_button_toggled(toggled_on: bool) -> void:
	auto_is_active = toggled_on
	auto_timer = 0.0
	print("Auto Sort toggled: ", auto_is_active)
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
