extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $Label

@export var number: int = 1
@export var picture: CompressedTexture2D
@export var Scaling: Vector2 = Vector2(0.017, 0.017)

@export var left_child: Node2D
@export var right_child: Node2D

var snap_distance: float = 70.0
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var rest_position: Vector2 = Vector2.ZERO




func swap(node: Node2D) -> void:
	var old_pos: Vector2 = self.rest_position
	self.global_position = node.global_position
	self.rest_position = global_position
	###
	node.get_parent().global_position = old_pos
	node.get_parent().rest_position = old_pos
	print(node.get_parent().position)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rest_position = global_position
	sprite.texture = picture
	sprite.scale = Scaling
	label.text = str(number)


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
		swap(nearest_slot)

	else:
		global_position = rest_position
