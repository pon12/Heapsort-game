extends RefCounted
class_name HeapSort


static func sort(input: Array) -> Array:
	var values: Array = input.duplicate()
	var n: int = values.size()

	# Phase 1: Max-Heap von unten nach oben aufbauen.
	for start in range(n / 2 - 1, -1, -1):
		_sift_down(values, start, n)

	# Phase 2: Groesstes Element ans Ende verschieben.
	for end in range(n - 1, 0, -1):
		_swap(values, 0, end)
		_sift_down(values, 0, end)

	return values


static func create_steps(input: Array) -> Array[Dictionary]:
	var values: Array = input.duplicate()
	var steps: Array[Dictionary] = []
	var n: int = values.size()

	steps.append({
		"type": "info",
		"message": "Phase 1: Max-Heap von unten nach oben aufbauen."
	})

	# Letzten Elternknoten zuerst bearbeiten.
	for start in range(n / 2 - 1, -1, -1):
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
			"type": "info",
			"message": "Stelle den Max-Heap im verbleibenden Bereich wieder her."
		})

		_sift_down_steps(values, 0, end, steps, "Rest-Heap")

	steps.append({
		"type": "done",
		"message": "Heap Sort abgeschlossen."
	})

	return steps


static func _sift_down(
	values: Array,
	root: int,
	end_exclusive: int
) -> void:
	var parent: int = root

	while true:
		var left: int = 2 * parent + 1
		var right: int = 2 * parent + 2
		var largest: int = parent

		if left < end_exclusive and values[left] > values[largest]:
			largest = left

		if right < end_exclusive and values[right] > values[largest]:
			largest = right

		if largest == parent:
			break

		_swap(values, parent, largest)
		parent = largest


static func _sift_down_steps(
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


static func _swap(values: Array, a: int, b: int) -> void:
	var temp = values[a]
	values[a] = values[b]
	values[b] = temp
