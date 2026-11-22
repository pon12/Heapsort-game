class_name HeapTree
extends Node2D

signal swapRequested(a: int, b: int)

@export var levelHeight: float = 110.0
@export var leafSpacing: float = 70.0
@export var nodeRadius: float = 26.0

@export_category("Lichterketten")
@export var edgeFrames: SpriteFrames
@export var edgeThickness: float = 6.0

@export_category("Kugeln")
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

var treeNodes: Array[HeapTreeNode] = []
var edges: Array[HeapEdge] = []


func _ready() -> void:
	buildEdges()
	buildNodes()


func slotPosition(index: int) -> Vector2:
	var level := int(floor(log(index + 1) / log(2.0)))
	var levelStart := (1 << level) - 1
	var slotsInLevel := 1 << level
	var totalWidth := leafSpacing * (1 << 3)
	var x := ((index - levelStart + 0.5) / slotsInLevel - 0.5) * totalWidth
	return Vector2(x, level * levelHeight)


func buildEdges() -> void:
	for index in range(1, HeapSort.MAXNODES):
		var edge := HeapEdge.new()
		edge.customFrames = edgeFrames
		edge.thickness = edgeThickness
		add_child(edge)
		edge.connectPoints(slotPosition((index - 1) >> 1), slotPosition(index))
		edges.append(edge)


func buildNodes() -> void:
	for index in HeapSort.MAXNODES:
		var node := HeapTreeNode.new()
		node.index = index
		node.radius = nodeRadius
		node.fontSize = fontSize
		node.normalColor = normalColor
		node.sortedColor = sortedColor
		node.highlightColor = highlightColor
		node.outlineColor = outlineColor
		node.textColor = textColor
		node.normalTexture = normalTexture
		node.sortedTexture = sortedTexture
		node.highlightTexture = highlightTexture
		node.textureScale = textureScale
		node.textureOffset = textureOffset
		add_child(node)
		node.setHome(slotPosition(index))
		node.dragFinished.connect(onDragFinished)
		treeNodes.append(node)


func showValues(values: Array[int], sortedCount: int, currentIndex: int = -1) -> void:
	var count := values.size()
	var heapSize := count - sortedCount
	for index in treeNodes.size():
		var node := treeNodes[index]
		node.visible = index < count
		if index < count:
			node.setValue(values[index])
			node.applyState(index >= heapSize, index == currentIndex, index < heapSize)
	for index in range(1, treeNodes.size()):
		var edge := edges[index - 1]
		edge.visible = index < count
		if index >= count:
			continue
		var parentIndex := (index - 1) >> 1
		if index >= heapSize:
			edge.setState(HeapEdge.State.SORTED)
		elif values[parentIndex] >= values[index]:
			edge.setState(HeapEdge.State.VALID)
		else:
			edge.setState(HeapEdge.State.INVALID)


func flash(a: int, b: int, color: Color) -> void:
	if a >= 0 and a < treeNodes.size():
		treeNodes[a].flash(color)
	if b >= 0 and b < treeNodes.size():
		treeNodes[b].flash(color)


func nodeAt(point: Vector2, ignore: int) -> int:
	for node in treeNodes:
		if node.index != ignore and node.visible and node.isInside(point):
			return node.index
	return -1


func onDragFinished(index: int, dropPoint: Vector2) -> void:
	var target := nodeAt(dropPoint, index)
	if target >= 0:
		swapRequested.emit(index, target)
