extends CanvasLayer

@onready var settings: Window = $Settings
@onready var overlay: Control = $Overlay
@onready var guide: Control = $HeapsortGuide
@onready var heap_sort: HeapSort = $"../HeapSort"
@onready var phase_label: Label = $Overlay/InfoContainer/PhaseLabel
@onready var hint_label: Label = $Overlay/InfoContainer/HintLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10

	overlay.hide()
	guide.hide()
	settings.hide()

	settings.visibility_changed.connect(_on_settings_visibility_changed)
	guide.get_node("VBoxContainer/BackButton").pressed.connect(_on_guide_back_button_pressed)
	heap_sort.phaseChanged.connect(_on_phase_changed)
	heap_sort.hintChanged.connect(_on_hint_changed)


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
	_on_phase_changed(heap_sort.state.phase)
	_on_hint_changed(heap_sort.getCurrentHint())

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
	
func _on_phase_changed(phase: int) -> void:
	match phase:
		HeapSortState.Phase.BUILD:
			phase_label.text = "Aktuelle Phase: Max-Heap aufbauen"

		HeapSortState.Phase.SORT:
			phase_label.text = "Aktuelle Phase: Sortieren und Absenken"

		HeapSortState.Phase.DONE:
			phase_label.text = "Aktuelle Phase: Abgeschlossen"


func _on_hint_changed(hint: String) -> void:
	hint_label.text = "Algorithmus-Hinweis:\n" + hint
