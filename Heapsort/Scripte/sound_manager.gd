extends Node

var swap_sound: AudioStream = preload("res://Audio/dragon-studio-christmas-bells-02-439604.mp3")

func play_swap() -> void:
	if swap_sound == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = swap_sound
	player.bus = "SFX"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

var win_sound: AudioStream = preload("res://Audio/gewonnen.mp3")
var win_sound_active: bool = false

func play_win() -> void:
	if win_sound_active:
		return

	if win_sound == null:
		return

	win_sound_active = true

	var music_was_playing: bool = MusicManager.playing and not MusicManager.stream_paused

	MusicManager.stream_paused = true

	var player := AudioStreamPlayer.new()
	player.stream = win_sound
	player.bus = "SFX"
	add_child(player)

	player.finished.connect(
		func() -> void:
			player.queue_free()
			if music_was_playing:
				MusicManager.stream_paused = false
	)

	player.play()

func reset_win() -> void:
	win_sound_active = false
