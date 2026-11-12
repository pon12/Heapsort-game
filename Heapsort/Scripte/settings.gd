extends Window

@onready var screen_mode_button: OptionButton = $Control/VBoxContainer/ScrollContainer/VBoxContainer/ScreenMode/OptionButton

func _ready() -> void:
	match_config()

func match_config() -> void:
	var screen_value: Variant = SettingsStartup.get_setting("display", "fullscreen", false)
	match screen_value:
		false:
			screen_mode_button.select(0)
		true:
			screen_mode_button.select(1)

func _on_close_requested() -> void:
	visible = false
func on_button_save_exit_pressed() -> void:
	SettingsStartup.save_settings()
	visible = false


func on_window_screen_setting(index: int) -> void:
	match index:
		0:
			SettingsStartup.set_setting("display", "fullscreen", false)
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			SettingsStartup.set_setting("display", "fullscreen", true)
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	SettingsStartup.apply_all_settings()
