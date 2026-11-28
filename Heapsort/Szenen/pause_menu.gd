extends CanvasLayer

@onready var settings: Window = $Settings
@onready var overlay: Control = $Overlay
@onready var guide: Control = $HeapsortGuide


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10

	overlay.hide()
	guide.hide()
	settings.hide()

	settings.visibility_changed.connect(_on_settings_visibility_changed)
	guide.get_node("VBoxContainer/BackButton").pressed.connect(_on_guide_back_button_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not get_tree().paused:
			pausieren()
		elif MenuManager.get_current_menu() == overlay:
			fortsetzen()
		else:
			MenuManager.go_back()

		get_viewport().set_input_as_handled()


func pausieren() -> void:
	get_tree().paused = true
	MenuManager.open_menu(overlay)


func fortsetzen() -> void:
	MenuManager.clear_menus()
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	fortsetzen()


func _on_main_menu_button_pressed() -> void:
	MenuManager.clear_menus()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Szenen/main_menu.tscn")


func _on_settings_button_pressed() -> void:
	MenuManager.open_menu(settings)


func _on_settings_visibility_changed() -> void:
	if not settings.visible:
		if MenuManager.get_current_menu() == settings:
			MenuManager.go_back()


func _on_guide_button_pressed() -> void:
	MenuManager.open_menu(guide)


func _on_guide_back_button_pressed() -> void:
	MenuManager.go_back()
