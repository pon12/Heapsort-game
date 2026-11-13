extends Window

@onready var screen_mode_button: OptionButton = $Control/VBoxContainer/ScrollContainer/VBoxContainer/ScreenMode/OptionButton
@onready var mute_button: CheckBox = $Control/VBoxContainer/ScrollContainer/VBoxContainer/MuteButton
@onready var song_button: OptionButton = $Control/VBoxContainer/ScrollContainer/VBoxContainer/Background_Music/OptionButton
@onready var music_slider: HSlider = $Control/VBoxContainer/ScrollContainer/VBoxContainer/Music_Strength/HBoxContainer/HSlider
@onready var music_spinbox: SpinBox = $Control/VBoxContainer/ScrollContainer/VBoxContainer/Music_Strength/HBoxContainer/SpinBox

func _ready() -> void:
	match_config()

func match_config() -> void:
	var screen_value: Variant = SettingsStartup.get_setting("display", "fullscreen", false)
	match screen_value:
		false:
			screen_mode_button.select(0)
		true:
			screen_mode_button.select(1)
	var muted: bool = SettingsStartup.get_setting("audio", "muted", false)
	mute_button.set_pressed_no_signal(muted)
	lade_songs()
	var volume: float = float(SettingsStartup.get_setting("audio", "volume", 50.0))
	music_slider.set_value_no_signal(volume)
	music_spinbox.set_value_no_signal(volume)

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

func _on_mute_button_toggled(toggled_on: bool) -> void:
	SettingsStartup.set_setting("audio", "muted", toggled_on)
	SettingsStartup.apply_audio()
	
func lade_songs() -> void:
	song_button.clear()

	for i in range(MusicManager.songs.size()):
		song_button.add_item(MusicManager.get_song_name(i), i)

	if MusicManager.songs.size() > 0:
		var index: int = int(SettingsStartup.get_setting("audio", "song_index", 0))
		song_button.select(clampi(index, 0, MusicManager.songs.size() - 1))
		
func _on_song_selected(index: int) -> void:
	MusicManager.waehle_song(index)
	SettingsStartup.set_setting("audio", "song_index", index)

func _on_music_slider_value_changed(value: float) -> void:
	music_spinbox.set_value_no_signal(value)
	SettingsStartup.set_setting("audio", "volume", value)
	SettingsStartup.apply_audio()

func _on_music_spinbox_value_changed(value: float) -> void:
	music_slider.set_value_no_signal(value)
	SettingsStartup.set_setting("audio", "volume", value)
	SettingsStartup.apply_audio()
