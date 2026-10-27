extends Control

@export var tree: Node2D
@onready var sorted_label: Label = $VBoxContainer/Label

func _ready() -> void:
	if tree == null:
		print("UI has no Tree assigned")

func _on_button_pressed() -> void:
	if tree.pruefe_sortierung() == true:
		sorted_label.text = "Sortiert"
	else:
		sorted_label.text = "Nicht Sortiert"
		tree.next_step()


func Back_button_on_pressed() -> void:
	ActionStack.pop_action()
	if tree and tree.has_method("aktualisiere_nach_aktion"):
		tree.aktualisiere_nach_aktion()
