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
