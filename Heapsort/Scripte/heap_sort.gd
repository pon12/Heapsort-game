extends Node
class_name HeapSort

signal sort_started(input: Array) ##Emitted when sorting begins. input is a copy of the input array.
signal sift_down_started(root: int, end_exclusive: int) ##Emitted when the heap-restoration step begins. Only elements before end_exclusive are included in the heap.
signal comparison_made(index_a: int, index_b: int, value_a: Variant, value_b: Variant) ##Emitted when two elements are compared. Includes their indices and values.
signal values_swapped(index_a: int, index_b: int, value_a: Variant, value_b: Variant, values: Array) ##Emitted after two elements are swapped. Includes their indices, the values now at those indices, and a snapshot of the array.
signal sift_down_finished(root: int, end_exclusive: int, values: Array) ##Emitted when heap restoration is complete. Includes the heap range and a snapshot of the array.
signal max_heap_created(heap: Array) ##Emitted after the max-heap has been built. heap is a snapshot of the array at that point.
signal element_sorted(value: Variant, index: int, values: Array) ##Emitted when an element reaches its final sorted position. Includes the element, its index, and an array snapshot.
signal sort_finished(sorted_values: Array) ##Emitted when sorting is complete. sorted_values is a snapshot of the final sorted array.


func create_steps(input: Array) -> Array[Dictionary]:
	var values: Array = input.duplicate()
	var steps: Array[Dictionary] = []
	var n: int = values.size()

	steps.append({
		"type": "info",
		"message": "Phase 1: Max-Heap von unten nach oben aufbauen."
	})

	# Letzten Elternknoten zuerst bearbeiten.
	for start in range(int(n / 2.0) - 1, -1, -1):
		steps.append({
			"type": "info",
			"message": "Pruefe Teilbaum mit Wurzel an Index %d." % start
		})

		_sift_down_steps(values, start, n, steps, "Max-Heap")

	steps.append({
		"type": "info",
		"message": "Phase 2: Max-Heap aufsteigend sortieren."
	})

	for end in range(n - 1, 0, -1):
		steps.append({
			"type": "swap",
			"a": 0,
			"b": end,
			"message": "Tausche groesstes Element %d an Index %d."
				% [values[0], end]
		})
		
		_swap(values, 0, end)
		
		steps.append({
			"type": "sorted",
			"index": end,
			"value": values[end],
			"message": "Element %d ist an Index %d final sortiert." % [values[end], end]
		})

		steps.append({
			"type": "info",
			"message": "Stelle den Max-Heap im verbleibenden Bereich wieder her."
		})

		_sift_down_steps(values, 0, end, steps, "Rest-Heap")

	if n > 0:
		steps.append({
			"type": "sorted",
			"index": 0,
			"value": values[0],
			"message": "Element %d ist an Index 0 final sortiert." % values[0]
		})
		
	steps.append({
		"type": "done",
		"message": "Heap Sort abgeschlossen."
	})

	return steps


func sort(input: Array) -> Array:
	var values: Array = input.duplicate()
	var n: int = values.size()

	sort_started.emit(input.duplicate())

	# Build the max-heap.
	for start in range(int(n / 2.0) - 1, -1, -1):
		_sift_down(values, start, n)

	max_heap_created.emit(values.duplicate())

	# Move the largest remaining value to the end of the unsorted section.
	for end in range(n - 1, 0, -1):
		_swap(values, 0, end)
		_sift_down(values, 0, end)
		element_sorted.emit(values[end], end, values.duplicate())

	# The remaining root, if there is one, is also in its final position.
	if n > 0:
		element_sorted.emit(values[0], 0, values.duplicate())

	sort_finished.emit(values.duplicate())
	return values


func _sift_down(values: Array, root: int, end_exclusive: int) -> void:
	var original_root: int = root
	sift_down_started.emit(root, end_exclusive)

	var parent: int = root

	while true:
		var left: int = 2 * parent + 1
		var right: int = 2 * parent + 2
		var largest: int = parent

		if left < end_exclusive:
			comparison_made.emit(parent, left, values[parent], values[left])
			if values[left] > values[largest]:
				largest = left

		if right < end_exclusive:
			comparison_made.emit(largest, right, values[largest], values[right])
			if values[right] > values[largest]:
				largest = right

		if largest == parent:
			break

		_swap(values, parent, largest)
		values_swapped.emit(
			parent, largest,
			values[parent], values[largest],
			values.duplicate()
		)
		parent = largest

	sift_down_finished.emit(original_root, end_exclusive, values.duplicate())

func _sift_down_steps(
	values: Array,
	root: int,
	end_exclusive: int,
	steps: Array[Dictionary],
	phase: String
) -> void:
	var parent: int = root

	while true:
		var left: int = 2 * parent + 1
		var right: int = 2 * parent + 2
		var largest: int = parent

		# Erst den Elternknoten mit dem linken Kind vergleichen.
		if left < end_exclusive:
			steps.append({
				"type": "compare",
				"a": parent,
				"b": left,
				"message": "%s: Vergleiche Elternknoten %d mit linkem Kind %d."
					% [phase, values[parent], values[left]]
			})

			if values[left] > values[largest]:
				largest = left

		# Danach den groessten bisherigen Kandidaten mit dem rechten Kind vergleichen.
		if right < end_exclusive:
			steps.append({
				"type": "compare",
				"a": largest,
				"b": right,
				"message": "%s: Vergleiche %d mit rechtem Kind %d."
					% [phase, values[largest], values[right]]
			})

			if values[right] > values[largest]:
				largest = right

		# Elternknoten ist bereits groesser als beide Kinder.
		if largest == parent:
			steps.append({
				"type": "info",
				"message": "%d bleibt an Index %d: Heap-Eigenschaft erfuellt."
					% [values[parent], parent]
			})
			break

		# Groessten Kandidaten mit dem Elternknoten tauschen.
		steps.append({
			"type": "swap",
			"a": parent,
			"b": largest,
			"message": "Tausche Elternknoten %d mit groesstem Kind %d."
				% [values[parent], values[largest]]
		})

		_swap(values, parent, largest)

		# Am neuen Platz des kleineren Werts weiterpruefen.
		parent = largest


func _swap(values: Array, a: int, b: int) -> void:
	var temp = values[a]
	values[a] = values[b]
	values[b] = temp
