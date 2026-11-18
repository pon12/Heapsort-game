class_name Sock
extends Control
@export var sock_pic: TextureRect
@export var label: Label

## Grafik der leeren Socke.
@export var textur_leer: Texture2D
## Grafik der gefüllten Socke.
@export var textur_voll: Texture2D

## Zeigt Wert und Zustand (voll = sortiert) der Socke an.
func set_value(wert: int) -> void:
	print("anzeigen: ", wert)
	label.text = str(wert)

func set_sorted(sorted: bool) -> void:
	sock_pic.texture = textur_voll if sorted else textur_leer
