class_name LichterKette
extends Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("sortiert")

func set_sorted() -> void:
	sprite.play("sortiert")
	
func set_unsorted() -> void:
	sprite.play("nicht_sortiert")
	
func set_done() -> void:
	sprite.play("fertig")
