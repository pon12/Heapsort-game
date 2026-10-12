extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $Label

@export var snap_distance: float = 70.0
@export var number: int = 1
@export var picture: CompressedTexture2D


var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var rest_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rest_position = global_position
	sprite.texture = picture
	label.text = str(number)
	print(label.text)


func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			move_to_front()


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging:
			dragging = false
			_snap_to_slot()


func _snap_to_slot() -> void:
	var nearest_distance := snap_distance
	var nearest_slot: Node2D = null

	for node in get_tree().get_nodes_in_group("drop_slots"):
		print(node)
		if node == marker_2d:
			continue
		var slot := node as Node2D
		if slot == null:
			continue

		var distance := global_position.distance_to(slot.global_position)
		if distance <= nearest_distance:
			nearest_distance = distance
			nearest_slot = slot

	if nearest_slot:
		global_position = nearest_slot.global_position
		rest_position = global_position
	else:
		global_position = rest_position
