extends Control

@onready var label: Label = $Label
@onready var socken_bild: TextureRect = $SockPic

# Hier kannst du die Bilder direkt im Inspector zuweisen oder per Code laden
@export var normal_textur: Texture2D
@export var sortiert_textur: Texture2D

func set_value(val: int) -> void:
	if label:
		label.text = str(val)

func set_sorted(is_sorted: bool) -> void:
	if socken_bild:
		if is_sorted and sortiert_textur:
			socken_bild.texture = sortiert_textur
		elif not is_sorted and normal_textur:
			socken_bild.texture = normal_textur
