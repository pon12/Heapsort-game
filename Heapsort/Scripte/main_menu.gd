extends Control
@export var settings: Window

const PLAY_SZENE = preload("uid://bmiq3vx3hrdb1")
func _ready() -> void:
	pass




func on_button_play_yourself_pressed() -> void:
	get_tree().change_scene_to_packed(PLAY_SZENE)


func on_button_settings_pressed() -> void:
	settings.visible = true
