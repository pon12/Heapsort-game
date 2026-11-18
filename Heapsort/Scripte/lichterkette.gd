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

func passe_laenge_an(von: Vector2, nach: Vector2) -> void:
	var abstand: float = von.distance_to(nach)

	global_position = von
	global_rotation = (nach - von).angle() - PI / 2.0

	# Dicke der Lichterkette beibehalten
	scale.x = 0.3

	# Länge an den Abstand zwischen den Kugeln anpassen
	var grundlaenge: float = absf(sprite.position.y) * 2.0
	if grundlaenge > 0.0:
		scale.y = abstand / grundlaenge
