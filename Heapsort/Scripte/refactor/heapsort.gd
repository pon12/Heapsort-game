class_name HeapSort
extends Node

signal arrayChanged(values: Array[int], sortedCount: int)
signal swapPerformed(a: int, b: int, byUser: bool)
signal swapUndone(a: int, b: int)
signal autoPlayChanged(running: bool)
signal finished

enum SwapResult { REJECTED, WRONG, CORRECT }

const MAXNODES := 15

@export var stepInterval: float = 0.8

var initialValues: Array[int] = []
var state: HeapSortState
var history: Array[Dictionary] = []
var timer: Timer
var autoRunning: bool = false


func _ready() -> void:
	state = HeapSortState.create(initialValues)
	timer = Timer.new()
	timer.one_shot = false
	timer.timeout.connect(onTimer)
	add_child(timer)


func setValues(newValues: Array[int]) -> bool:
	if newValues.is_empty() or newValues.size() > MAXNODES:
		return false
	pauseAuto()
	initialValues.assign(newValues)
	loadState()
	return true


func setNodeCount(count: int) -> void:
	var size := clampi(count, 1, MAXNODES)
	var pool: Array[int] = []
	for number in range(1, 100):
		pool.append(number)
	pool.shuffle()
	var generated: Array[int] = []
	for index in size:
		generated.append(pool[index])
	setValues(generated)


func setCustomNumbers(text: String) -> bool:
	var parsed: Array[int] = []
	for part in text.split(",", false):
		var cleaned := part.strip_edges()
		if not cleaned.is_valid_int():
			return false
		parsed.append(cleaned.to_int())
	return setValues(parsed)


func reset() -> void:
	pauseAuto()
	loadState()


func loadState() -> void:
	history.clear()
	state = HeapSortState.create(initialValues)
	emitChanged()


func getArray() -> Array[int]:
	var copied: Array[int] = []
	copied.assign(state.values)
	return copied


func getSortedCount() -> int:
	return state.getSortedCount()


func getHeapSize() -> int:
	return state.heapSize


func getCurrentIndex() -> int:
	return state.current


func isSorted(index: int) -> bool:
	return index >= state.heapSize


func isFinished() -> bool:
	return state.phase == HeapSortState.Phase.DONE


func canUndo() -> bool:
	return not history.is_empty()


func isAutoRunning() -> bool:
	return autoRunning


func getNextSwap() -> Vector2i:
	return state.copy().advance()


func stepForward() -> bool:
	if isFinished():
		return false
	var before := state.copy()
	var pair := state.advance()
	history.append({"state": before, "pair": pair})
	if pair != HeapSortState.NOSWAP:
		swapPerformed.emit(pair.x, pair.y, false)
	afterChange()
	return true


func stepBackward() -> bool:
	if history.is_empty():
		return false
	var entry: Dictionary = history.pop_back()
	state = entry["state"]
	var pair: Vector2i = entry["pair"]
	if pair != HeapSortState.NOSWAP:
		swapUndone.emit(pair.x, pair.y)
	emitChanged()
	return true


func manualSwap(a: int, b: int) -> SwapResult:
	if a == b or a < 0 or b < 0 or a >= state.heapSize or b >= state.heapSize:
		return SwapResult.REJECTED
	var expected := getNextSwap()
	var matches := (expected.x == a and expected.y == b) or (expected.x == b and expected.y == a)
	var before := state.copy()
	if matches:
		state.advance()
	else:
		state.swapValues(a, b)
		state.restartHeapify()
	history.append({"state": before, "pair": Vector2i(a, b)})
	swapPerformed.emit(a, b, true)
	afterChange()
	return SwapResult.CORRECT if matches else SwapResult.WRONG


func startAuto() -> void:
	if autoRunning or isFinished():
		return
	autoRunning = true
	timer.start(stepInterval)
	autoPlayChanged.emit(true)


func pauseAuto() -> void:
	if not autoRunning:
		return
	autoRunning = false
	timer.stop()
	autoPlayChanged.emit(false)


func toggleAuto() -> void:
	if autoRunning:
		pauseAuto()
	else:
		startAuto()


func setStepInterval(seconds: float) -> void:
	stepInterval = maxf(seconds, 0.02)
	if autoRunning:
		timer.start(stepInterval)


func afterChange() -> void:
	emitChanged()
	if isFinished():
		pauseAuto()
		finished.emit()


func emitChanged() -> void:
	arrayChanged.emit(getArray(), getSortedCount())


func onTimer() -> void:
	if not stepForward():
		pauseAuto()
