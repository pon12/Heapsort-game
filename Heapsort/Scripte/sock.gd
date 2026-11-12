class_name Sock
extends Control
@export var sock_pic: TextureRect
@export var label: Label

## Grafik der leeren Socke.
@export var textur_leer: Texture2D
## Grafik der gefüllten Socke.
@export var textur_voll: Texture2D

## Zeigt Wert und Zustand (voll = sortiert) der Socke an.
func anzeigen(wert: int, sortiert: bool) -> void:
	print("anzeigen: ", wert, " ", sortiert)
	label.text = str(wert)
	sock_pic.texture = textur_voll if sortiert else textur_leer
