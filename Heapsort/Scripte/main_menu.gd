extends Control

@export var settings: Window
@export var credits: Window

const PLAY_SZENE = preload("uid://dotqstm7li6l")


func _ready() -> void:
	settings.hide()
	credits.hide()

	MenuManager.open_menu(self)

	settings.visibility_changed.connect(_on_settings_visibility_changed)
	credits.visibility_changed.connect(_on_credits_visibility_changed)


func on_button_play_yourself_pressed() -> void:
	MenuManager.clear_menus()
	get_tree().change_scene_to_packed(PLAY_SZENE)


func on_button_settings_pressed() -> void:
	MenuManager.open_menu(settings)


func on_button_end_game_pressed() -> void:
	get_tree().quit()


func on_button_credits_pressed() -> void:
	MenuManager.open_menu(credits)


func _on_settings_visibility_changed() -> void:
	if not settings.visible:
		if MenuManager.get_current_menu() == settings:
			MenuManager.go_back()


func _on_credits_visibility_changed() -> void:
	if not credits.visible:
		if MenuManager.get_current_menu() == credits:
			MenuManager.go_back()
