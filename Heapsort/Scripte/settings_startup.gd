extends Node

const PATH: String = "user://settings.cfg"

var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	var error: Error = config.load(PATH)
	if error != OK and error != ERR_FILE_NOT_FOUND:
		push_warning("Settings: could not read %s (error %d)" % [PATH, error])
	apply_all_settings()

func apply_all_settings() -> void:
	apply_display()

func apply_display() -> void:
	var fullscreen: bool = get_setting("display", "fullscreen", false)
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif fullscreen == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func get_setting(section: String, key: String, default_value: Variant) -> Variant:
	return config.get_value(section, key, default_value)

func set_setting(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)

func save_settings() -> void:
	var error: Error = config.save(PATH)
	if error != OK:
		push_error("Settings: save failed (error %d)" % error)
