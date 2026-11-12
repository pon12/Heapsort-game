class_name Sock
extends Control

## Grafik der leeren Socke.
@export var textur_leer: Texture2D
## Grafik der gefüllten Socke.
@export var textur_voll: Texture2D

## Zeigt Wert und Zustand (voll = sortiert) der Socke an.
func anzeigen(wert: int, sortiert: bool) -> void:
	print("anzeigen: ", wert, " ", sortiert)
	$Label.text = str(wert)
	$SockPic.texture = textur_voll if sortiert else textur_leer
