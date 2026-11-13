extends AudioStreamPlayer

@export var songs: Array[AudioStream] = []

func _ready() -> void:
	if songs.size() > 0:
		var song_index: int = int(SettingsStartup.get_setting("audio", "song_index", 0))
		waehle_song(song_index)

func waehle_song(index: int) -> void:
	if index < 0 or index >= songs.size():
		return

	stream = songs[index]
	play()
	
func get_song_name(index: int) -> String:
	if index < 0 or index >= songs.size():
		return ""

	var song: AudioStream = songs[index]

	if song.resource_name != "":
		return song.resource_name

	return "Song " + str(index + 1)
