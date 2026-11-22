class_name HeapSortState
extends RefCounted

enum Phase { BUILD, SORT, DONE }

const NOSWAP := Vector2i(-1, -1)

var values: Array[int] = []
var phase: Phase = Phase.BUILD
var buildIndex: int = -1
var current: int = -1
var heapSize: int = 0


static func create(source: Array[int]) -> HeapSortState:
	var state := HeapSortState.new()
	state.values.assign(source)
	state.heapSize = source.size()
	state.restartHeapify()
	return state


func copy() -> HeapSortState:
	var state := HeapSortState.new()
	state.values.assign(values)
	state.phase = phase
	state.buildIndex = buildIndex
	state.current = current
	state.heapSize = heapSize
	return state


func restartHeapify() -> void:
	current = -1
	if heapSize <= 1:
		heapSize = 0
		phase = Phase.DONE
		return
	phase = Phase.BUILD
	buildIndex = (heapSize >> 1) - 1


func getSortedCount() -> int:
	return values.size() - heapSize


func swapValues(a: int, b: int) -> void:
	var temp := values[a]
	values[a] = values[b]
	values[b] = temp


func siftTarget(index: int) -> int:
	var largest := index
	var left := index * 2 + 1
	var right := left + 1
	if left < heapSize and values[left] > values[largest]:
		largest = left
	if right < heapSize and values[right] > values[largest]:
		largest = right
	return largest


func advance() -> Vector2i:
	while phase != Phase.DONE:
		if current >= 0:
			var target := siftTarget(current)
			if target == current:
				current = -1
				if phase == Phase.BUILD:
					buildIndex -= 1
				continue
			var siftPair := Vector2i(current, target)
			swapValues(current, target)
			current = target
			return siftPair
		if phase == Phase.BUILD:
			if buildIndex < 0:
				phase = Phase.SORT
			else:
				current = buildIndex
			continue
		var last := heapSize - 1
		var extractPair := Vector2i(0, last)
		swapValues(0, last)
		heapSize = last
		if heapSize <= 1:
			heapSize = 0
			phase = Phase.DONE
		else:
			current = 0
		return extractPair
	return NOSWAP
