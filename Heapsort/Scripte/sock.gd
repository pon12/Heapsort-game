class_name Sock
extends Control

@export var sock_pic: TextureRect
@export var label: Label
@export var textur_leer: Texture2D
@export var textur_voll: Texture2D

func set_value(wert: int, position: int) -> void:
	label.text = "%d" % [wert]

func set_sorted(sorted: bool) -> void:
	sock_pic.texture = textur_voll if sorted else textur_leer
