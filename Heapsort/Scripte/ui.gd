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

func _ready() -> void:
	if tree == null:
		print("UI has no Tree assigned")

func _on_button_pressed() -> void:
	if tree.pruefe_sortierung() == true:
		#sorted_label.text = "Sortiert"
		return
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
