extends Node2D

@export var startCount: int = 7

@onready var heapSort: HeapSort = $HeapSort
@onready var heapTree: HeapTree = $HeapTree
@onready var arrayView: ArrayView = $ArrayView


func _ready() -> void:
	heapSort.arrayChanged.connect(onArrayChanged)
	heapTree.swapRequested.connect(onSwapRequested)
	heapSort.setNodeCount(startCount)


func onArrayChanged(values: Array[int], sortedCount: int) -> void:
	heapTree.showValues(values, sortedCount, heapSort.getCurrentIndex())
	arrayView.showValues(values, sortedCount)


func onSwapRequested(a: int, b: int) -> void:
	var result := heapSort.manualSwap(a, b)
	match result:
		HeapSort.SwapResult.CORRECT:
			heapTree.flash(a, b, Color(0.4, 1.0, 0.4))
		HeapSort.SwapResult.WRONG:
			heapTree.flash(a, b, Color(1.0, 0.4, 0.4))
		HeapSort.SwapResult.REJECTED:
			heapTree.flash(a, b, Color(1.0, 0.8, 0.3))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		heapSort.stepForward()
	elif event.is_action_pressed("ui_left"):
		heapSort.stepBackward()
	elif event.is_action_pressed("ui_accept"):
		heapSort.toggleAuto()
