class_name ArrayView
extends Node2D

@export var cellSize := Vector2(54, 54)
@export var fontSize: int = 20
@export var indexFontSize: int = 12
@export var textColor := Color(1, 1, 1)

@export_category("Textures")
@export var cellTexture: Texture2D
@export var sortedTexture: Texture2D
@export var textureScale: float = 1.0
@export var textureOffset := Vector2.ZERO

@export_category("Fallback")
@export var outlineColor := Color(1, 1, 1)
@export var heapColor := Color(0.2, 0.45, 0.85)
@export var sortedColor := Color(0.4, 0.4, 0.45)

var values: Array[int] = []
var sortedCount: int = 0


func showValues(newValues: Array[int], newSortedCount: int) -> void:
	values.assign(newValues)
	sortedCount = newSortedCount
	queue_redraw()


func _draw() -> void:
	var count := values.size()
	var heapSize := count - sortedCount
	var totalWidth := cellSize.x * count
	var font := ThemeDB.fallback_font
	for index in count:
		var rect := Rect2(Vector2(index * cellSize.x - totalWidth / 2.0, 0.0), cellSize)
		var isSortedCell := index >= heapSize
		var texture := sortedTexture if isSortedCell else cellTexture
		if texture != null:
			var imageSize := cellSize * textureScale
			var imageRect := Rect2(rect.get_center() - imageSize / 2.0 + textureOffset, imageSize)
			draw_texture_rect(texture, imageRect, false)
		else:
			draw_rect(rect, sortedColor if isSortedCell else heapColor)
		var text := str(values[index])
		var textSize := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fontSize)
		var baseline := (font.get_ascent(fontSize) - font.get_descent(fontSize)) / 2.0
		var center := rect.get_center()
		draw_string(font, Vector2(center.x - textSize.x / 2.0, center.y + baseline), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fontSize, textColor)
		var indexText := str(index)
		var indexSize := font.get_string_size(indexText, HORIZONTAL_ALIGNMENT_LEFT, -1, indexFontSize)
		draw_string(font, Vector2(center.x - indexSize.x / 2.0, rect.end.y + indexFontSize + 4.0), indexText, HORIZONTAL_ALIGNMENT_LEFT, -1, indexFontSize, outlineColor)
