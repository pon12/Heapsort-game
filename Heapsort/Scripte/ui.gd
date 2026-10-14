extends Control

@export var tree: Node2D
@onready var sorted_label: Label = $VBoxContainer/Label

func _ready() -> void:
	if tree == null:
		print("UI has no Tree assigned")


func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	if tree.pruefe_sortierung() == true:
		sorted_label.text = "Sortiert"
	else:
		sorted_label.text = "Nicht Sortiert"
	tree.next_step()
