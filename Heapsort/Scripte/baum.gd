extends Node2D
@onready var lichterketten_head:Node2D = get_node("LichterKetten")
var lichterkette = preload("res://Objekte/lichterkette.tscn")

var kugeln: Array[TreeNode] = []
var slots: Array[Marker2D] = []
var steps: Array[Dictionary] = []
var step_index: int = 0
var sorted_target_werte: Array = []
@onready var sock_array_ui: HBoxContainer = $"../SockArrayUI"


func _ready() -> void:
	# Slots finden und registrieren
	for i in range(1, 8):
		var slot := get_node_or_null("Sprite2D/Slot" + str(i)) as Marker2D

		if slot == null:
			push_error("Slot%d wurde nicht gefunden!" % i)
			return

		slot.add_to_group("drop_slots")
		slots.append(slot)

	# Kugeln finden und registrieren
	for node in get_children():
		if node.has_method("swap") and node.get("number") != null:
			var kugel := node as TreeNode
			kugel.add_to_group("tree_balls")
			kugeln.append(kugel)

	if kugeln.size() != 7:
		push_error("Es wurden 7 Kugeln erwartet, aber %d gefunden." % kugeln.size())
		return

	# Jede Kugel auf einen Slot setzen
	for i in range(kugeln.size()):
		kugeln[i].global_position = slots[i].global_position
		kugeln[i].rest_position = slots[i].global_position

	_prepare_algorithm()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_N:
			next_step()
		elif event.keycode == KEY_P:
			pruefe_sortierung()


func _sync_order_from_slots() -> void:
	var neue_reihenfolge: Array[TreeNode] = []

	for slot in slots:
		var beste_kugel: TreeNode = null
		var kleinster_abstand: float = INF

		for kugel in kugeln:
			if neue_reihenfolge.has(kugel):
				continue

			var abstand := kugel.global_position.distance_to(slot.global_position)

			if abstand < kleinster_abstand:
				kleinster_abstand = abstand
				beste_kugel = kugel

		if beste_kugel != null:
			neue_reihenfolge.append(beste_kugel)

	if neue_reihenfolge.size() == kugeln.size():
		kugeln = neue_reihenfolge

	for kugel in kugeln:
		kugel.rest_position = kugel.global_position


func _prepare_algorithm() -> void:
	_sync_order_from_slots()
	_clear_highlights()

	var werte: Array = []
	for kugel in kugeln:
		werte.append(int(kugel.get("number")))

	steps = HeapSort.create_steps(werte)
	step_index = 0

	#print("")
	#print("========== HEAP SORT ==========")
	#print("Aktuelle Startreihenfolge: ", werte)
	#print("Schritte vorbereitet: ", steps.size())
	#print("N = naechster Simulationsschritt")
	#print("P = manuelle Sortierung pruefen")
	#print("================================")
	
	sorted_target_werte = werte.duplicate()
	sorted_target_werte.sort()
	
	if sock_array_ui:
		sock_array_ui.update_values(werte)


func on_manual_move() -> void:
	_prepare_algorithm()
	#print("Manuelle Aenderung erkannt. Simulation zurueckgesetzt.")
	if sock_array_ui:
		var aktuelle_werte: Array = []
		for kugel in kugeln:
			aktuelle_werte.append(int(kugel.get("number")))
		sock_array_ui.check_individual_socks(aktuelle_werte, sorted_target_werte)


func next_step() -> void:
	if step_index >= steps.size():
		#print("Simulation abgeschlossen. Druecke P fuer die Sortierpruefung.")
		return

	_clear_highlights()

	var step: Dictionary = steps[step_index]
	var typ: String = str(step.get("type", ""))
	var meldung: String = str(step.get("message", ""))

	print("Schritt %d/%d: %s" % [step_index + 1, steps.size(), meldung])

	match typ:
		"info":
			#print("--- Phasenwechsel ---")
			pass

		"compare":
			var a: int = int(step["a"])
			var b: int = int(step["b"])

			if a >= 0 and a < kugeln.size():
				kugeln[a].set_highlight(true)
			if b >= 0 and b < kugeln.size():
				kugeln[b].set_highlight(true)

		"swap":
			var a: int = int(step["a"])
			var b: int = int(step["b"])

			if a >= 0 and a < kugeln.size() and b >= 0 and b < kugeln.size():
				kugeln[a].swap(kugeln[b])

				var temp: TreeNode = kugeln[a]
				kugeln[a] = kugeln[b]
				kugeln[b] = temp

				kugeln[a].set_highlight(true)
				kugeln[b].set_highlight(true)
				
				if sock_array_ui:
					var aktuelle_werte: Array = []
					for kug in kugeln:
						aktuelle_werte.append(int(kug.get("number")))
					sock_array_ui.update_values(aktuelle_werte)
					sock_array_ui.check_individual_socks(aktuelle_werte, sorted_target_werte)

		"done":
			#print("--- Simulation beendet ---")
			pruefe_sortierung()

	step_index += 1


func _clear_highlights() -> void:
	for kugel in kugeln:
		kugel.set_highlight(false)


func pruefe_sortierung() -> bool:
	_sync_order_from_slots()

	var werte: Array[int] = []
	for kugel in kugeln:
		werte.append(int(kugel.get("number")))

	var korrekt: bool = true
	for i in range(1, werte.size()):
		if werte[i - 1] > werte[i]:
			korrekt = false
			break

	#print("Pruefung der aktuellen Reihenfolge: ", werte)

	if korrekt:
		#print("RICHTIG! Die Zahlen sind aufsteigend sortiert.")
		if sock_array_ui:
			for i in range(kugeln.size()):
				sock_array_ui.set_sorted_state(i)
		return true
	else:
		#print("NOCH NICHT RICHTIG. Die Zahlen sind nicht aufsteigend sortiert.")
		return false

# Aktualisiert Werte und Socken-Zustand nach außen hin (z.B. für den Zurück-Button)
func aktualisiere_nach_aktion() -> void:
	_sync_order_from_slots()
	var aktuelle_werte: Array = []
	for kugel in kugeln:
		aktuelle_werte.append(int(kugel.get("number")))
	
	if sock_array_ui:
		sock_array_ui.update_values(aktuelle_werte)
		sock_array_ui.check_individual_socks(aktuelle_werte, sorted_target_werte)
