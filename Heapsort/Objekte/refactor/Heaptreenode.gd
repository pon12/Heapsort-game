class_name HeapTreeNode
extends Node2D

signal dragStarted(index: int)
signal dragFinished(index: int, dropPoint: Vector2)

@export var radius: float = 26.0
@export var fontSize: int = 20
@export var normalColor := Color(0.2, 0.45, 0.85)
@export var sortedColor := Color(0.4, 0.4, 0.45)
@export var highlightColor := Color(0.95, 0.65, 0.15)
@export var outlineColor := Color(1, 1, 1)
@export var textColor := Color(1, 1, 1)

@export var normalTexture: Texture2D
@export var sortedTexture: Texture2D
@export var highlightTexture: Texture2D
@export var textureScale: float = 1.0
@export var textureOffset := Vector2.ZERO

var index: int = 0
var value: int = 0
var sorted: bool = false
var highlighted: bool = false
var draggable: bool = true
var dragging: bool = false
var homePosition := Vector2.ZERO
var dragOffset := Vector2.ZERO
var popTween: Tween
var flashTween: Tween


func setHome(point: Vector2) -> void:
	homePosition = point
	position = point


func setValue(newValue: int) -> void:
	var changed := newValue != value
	value = newValue
	if changed:
		playPop()
	queue_redraw()


func applyState(newSorted: bool, newHighlighted: bool, newDraggable: bool) -> void:
	sorted = newSorted
	highlighted = newHighlighted
	draggable = newDraggable
	queue_redraw()


func isInside(globalPoint: Vector2) -> bool:
	return to_local(globalPoint).length() <= radius


func flash(color: Color) -> void:
	if flashTween:
		flashTween.kill()
	modulate = color
	flashTween = create_tween()
	flashTween.tween_property(self, "modulate", Color.WHITE, 0.6)


func playPop() -> void:
	if popTween:
		popTween.kill()
	scale = Vector2(1.25, 1.25)
	popTween = create_tween()
	popTween.tween_property(self, "scale", Vector2.ONE, 0.2)


func _input(event: InputEvent) -> void:
	var button := event as InputEventMouseButton
	if button != null and button.button_index == MOUSE_BUTTON_LEFT:
		if button.pressed:
			if not dragging and draggable and visible and isInside(get_global_mouse_position()):
				dragging = true
				dragOffset = global_position - get_global_mouse_position()
				z_index = 10
				dragStarted.emit(index)
				get_viewport().set_input_as_handled()
		elif dragging:
			dragging = false
			z_index = 0
			position = homePosition
			dragFinished.emit(index, get_global_mouse_position())
		return
	if dragging and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + dragOffset


func _draw() -> void:
	var fill := normalColor
	var texture := normalTexture
	if sorted:
		fill = sortedColor
		texture = sortedTexture
	elif highlighted:
		fill = highlightColor
		texture = highlightTexture
	if texture == null:
		texture = normalTexture
	if texture != null:
		var imageSize := Vector2(radius, radius) * 2.0 * textureScale
		draw_texture_rect(texture, Rect2(-imageSize / 2.0 + textureOffset, imageSize), false)
	else:
		draw_circle(Vector2.ZERO, radius, fill)
		draw_arc(Vector2.ZERO, radius, 0.0, TAU, 32, outlineColor, 3.0, true)
	var font := ThemeDB.fallback_font
	var text := str(value)
	var textSize := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fontSize)
	var baseline := (font.get_ascent(fontSize) - font.get_descent(fontSize)) / 2.0
	draw_string(font, Vector2(-textSize.x / 2.0, baseline), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fontSize, textColor)
