extends Node2D
@onready var lichterketten_head:Node2D = get_node("LichterKetten")
@onready var sock_array_ui: HBoxContainer = $"../SockArrayUI"
@export var heap_sort: HeapSort

var lichterkette = preload("res://Objekte/lichterkette.tscn")
var kugel_szene: PackedScene = preload("res://Objekte/tree_node.tscn")

var kugeln: Array[TreeNode] = []
var slots: Array[Marker2D] = []
var steps: Array[Dictionary] = []
var step_index: int = 0
var sorted_target_werte: Array = []

var sortierung_abgeschlossen: bool = false

var socken_array: Array[int] = []
var zufallsgenerator := RandomNumberGenerator.new()

var sorted_indices: Array[int] = []
func _ready() -> void:
	# Slots finden und registrieren
	for i in range(1, 16):
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

	# Slots passend zur Kugelanzahl anordnen
	ordne_slots_an(kugeln.size())

	# Kugeln auf die berechneten Slotpositionen setzen
	for i in range(kugeln.size()):
		kugeln[i].global_position = slots[i].global_position
		kugeln[i].rest_position = slots[i].global_position

	# Eltern-Kind-Verbindungen und Lichterketten erstellen
	baue_verbindungen_neu()

	# Socken beim Start füllen
	if sock_array_ui:
		var start_werte: Array = []
		for kugel in kugeln:
			start_werte.append(int(kugel.number))
		sock_array_ui.call_deferred("initialize", start_werte)

	aktualisiere_socken_array()

	# Heapsort vorbereiten
	_prepare_algorithm()
	aktualisiere_socken_array()
	_prepare_algorithm()

func _process(_delta: float) -> void:
	if sortierung_abgeschlossen:
		return
	for kugel in kugeln:
		kugel.check_heapsort_condition()

	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_N:
			next_step()
		elif event.keycode == KEY_P:
			pruefe_sortierung()


func _sync_order_from_slots() -> void:
	var neue_reihenfolge: Array[TreeNode] = []

	for i in range(kugeln.size()):
		var slot: Marker2D = slots[i]
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
		
	aktualisiere_socken_array()

func _prepare_algorithm() -> void:
	print("Kugeln im Algorithmus: ", kugeln.size())
	print("Slots vorhanden: ", slots.size())
	
	_sync_order_from_slots()
	_clear_highlights()

	var werte: Array = []
	for kugel in kugeln:
		werte.append(int(kugel.get("number")))

	steps = heap_sort.create_steps(werte)
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
	sortierung_abgeschlossen = false
	_prepare_algorithm()
	#print("Manuelle Aenderung erkannt. Simulation zurueckgesetzt.")
	if sock_array_ui:
		var aktuelle_werte: Array = []
		for kugel in kugeln:
			aktuelle_werte.append(int(kugel.get("number")))
		sock_array_ui.check_individual_socks(aktuelle_werte, sorted_target_werte)

	_aktualisiere_lichterketten()

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

	_aktualisiere_lichterketten()
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
		_aktualisiere_lichterketten()
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

func _mark_sorted(indices: Array[int]) -> void:
	if indices.is_empty():
		return
	for idx in indices:
		sorted_indices.append(idx)
	# Merken, welche Action diese Markierungen erzeugt hat (fuer Zurueck)
	if not ActionStack.action_list.is_empty():
		ActionStack.action_list.back().marked_sorted = indices


# Baut die Socken komplett aus den Daten auf: Werte + sorted_indices.
func _refresh_socks() -> void:
	if sock_array_ui == null:
		return
	var werte: Array = []
	for kugel in kugeln:
		werte.append(int(kugel.get("number")))
	sock_array_ui.update_values(werte)
	sock_array_ui.reset_sorted()
	for i in sorted_indices:
		sock_array_ui.set_sorted_state(i)

# Naechster Tausch-Schritt ab step_index (compare/info werden uebersprungen).
func _find_next_swap_step() -> int:
	for j in range(step_index, steps.size()):
		if str(steps[j].get("type", "")) == "swap":
			return j
	return -1


func _step_matches(step: Dictionary, ia: int, ib: int) -> bool:
	var a: int = int(step["a"])
	var b: int = int(step["b"])
	return (a == ia and b == ib) or (a == ib and b == ia)


func _consume_manual_step(j: int) -> void:
	var step: Dictionary = steps[j]
	step_index = j + 1

	_sync_order_from_slots()
	_clear_highlights()
	kugeln[int(step["a"])].set_highlight(true)
	kugeln[int(step["b"])].set_highlight(true)

	var neu: Array[int] = []
	for idx in step.get("sorted", []):
		neu.append(int(idx))
	_mark_sorted(neu)
	_refresh_socks()
	pruefe_sortierung()

func _zeige_meldung(text: String) -> void:
	print(text)

func aktualisiere_socken_array() -> void:
	socken_array.clear()

	for kugel in kugeln:
		socken_array.append(kugel.number)

	#print("Socken-Array: ", socken_array)    
	
func generiere_zufallszahlen(anzahl: int) -> Array[int]:
	var zahlen: Array[int] = []

	if anzahl < 3 or anzahl > 15:
		push_error("Es sind nur 3 bis 15 Zahlen erlaubt.")
		return zahlen

	zufallsgenerator.randomize()

	for i in range(anzahl):
		zahlen.append(zufallsgenerator.randi_range(1, anzahl))

	return zahlen
	
func setze_zahlen(werte: Array[int]) -> void:
	if werte.size() < 3 or werte.size() > 15:
		push_error("Es sind nur 3 bis 15 Zahlen erlaubt.")
		return

	# Alte Rückgängig-Aktionen dürfen keine entfernten Kugeln referenzieren
	ActionStack.action_list.clear()

	passe_kugelanzahl_an(werte.size())

	for i in range(werte.size()):
		kugeln[i].number = werte[i]
		kugeln[i].label.text = str(werte[i])

	baue_verbindungen_neu()

	sortierung_abgeschlossen = false
	sorted_indices.clear()

	# Socken in der passenden Anzahl neu erstellen
	sock_array_ui.initialize(werte)
	
	aktualisiere_socken_array()
	_prepare_algorithm()


##DEFINITIV NOCH NICHT FERTIG
func _aktualisiere_lichterketten() -> void:
	if sortierung_abgeschlossen:
		return

	for kugel in kugeln:
		if is_instance_valid(kugel.left_lichterkette):
			kugel.left_lichterkette.set_done()

		if is_instance_valid(kugel.right_lichterkette):
			kugel.right_lichterkette.set_done()

func passe_kugelanzahl_an(anzahl: int) -> void:
	if anzahl < 3 or anzahl > 15:
		return

	# Überzählige Kugeln entfernen
	while kugeln.size() > anzahl:
		var kugel: TreeNode = kugeln.pop_back()
		kugel.remove_from_group("tree_balls")
		kugel.queue_free()

	# Fehlende Kugeln hinzufügen
	while kugeln.size() < anzahl:
		var kugel: TreeNode = kugel_szene.instantiate()
		add_child(kugel)
		kugel.add_to_group("tree_balls")
		kugeln.append(kugel)

	ordne_slots_an(anzahl)

	# Kugeln auf ihre Positionen setzen
	for i in range(kugeln.size()):
		kugeln[i].global_position = slots[i].global_position
		kugeln[i].rest_position = slots[i].global_position
		
func baue_verbindungen_neu() -> void:
	# Alte Lichterketten entfernen
	for licht in lichterketten_head.get_children():
		lichterketten_head.remove_child(licht)
		licht.queue_free()

	# Alte Verbindungen zurücksetzen
	for kugel in kugeln:
		kugel.left_child = null
		kugel.right_child = null
		kugel.parent_treenode = null
		kugel.left_lichterkette = null
		kugel.right_lichterkette = null

	# Neue Verbindungen aufbauen
	for i in range(kugeln.size()):
		var links: int = 2 * i + 1
		var rechts: int = 2 * i + 2

		# Linkes Kind
		if links < kugeln.size():
			kugeln[i].left_child = kugeln[links]
			kugeln[links].parent_treenode = kugeln[i]

			var licht_links: LichterKette = lichterkette.instantiate()
			lichterketten_head.add_child(licht_links)

			kugeln[i].left_lichterkette = licht_links

			# Position, Richtung und Länge automatisch anpassen
			licht_links.passe_laenge_an(
				kugeln[i].global_position,
				kugeln[links].global_position
			)

		# Rechtes Kind
		if rechts < kugeln.size():
			kugeln[i].right_child = kugeln[rechts]
			kugeln[rechts].parent_treenode = kugeln[i]

			var licht_rechts: LichterKette = lichterkette.instantiate()
			lichterketten_head.add_child(licht_rechts)

			kugeln[i].right_lichterkette = licht_rechts

			# Position, Richtung und Länge automatisch anpassen
			licht_rechts.passe_laenge_an(
				kugeln[i].global_position,
				kugeln[rechts].global_position
			)
			
func ordne_slots_an(anzahl: int) -> void:
	if anzahl < 3 or anzahl > 15:
		return

	var ebenen: int = int(ceil(log(float(anzahl + 1)) / log(2.0)))

	# Grenzen der Baumkrone in lokalen Koordinaten
	var oben_y: float = -310.0
	var unten_y: float = 10.0

	# Maximaler Abstand zwischen zwei Ebenen
	var maximaler_abstand: float = 130.0

	# Maximale halbe Breite des Baums
	var maximale_halbe_breite: float = 200.0

	# Verfügbaren Platz berechnen
	var verfuegbare_hoehe: float = unten_y - oben_y

	# Ebenenabstand an die Kugelanzahl anpassen
	var ebenen_abstand: float

	if ebenen == 4:
		# Bei 8 bis 15 Kugeln mehr Platz nutzen
		ebenen_abstand = verfuegbare_hoehe / 2.5
	else:
		# Bei 3 bis 7 Kugeln bisherige Abstände beibehalten
		ebenen_abstand = minf(
		maximaler_abstand,
		verfuegbare_hoehe / float(ebenen - 1)
	)

	# Gesamten Binärbaum vertikal zentrieren
	var gesamte_hoehe: float = float(ebenen - 1) * ebenen_abstand
	var start_y: float = oben_y + (verfuegbare_hoehe - gesamte_hoehe) / 2.0

	for i in range(anzahl):
		var ebene: int = int(floor(log(float(i + 1)) / log(2.0)))
		var erster_index: int = (1 << ebene) - 1
		var position_in_ebene: int = i - erster_index
		var plaetze_in_ebene: int = 1 << ebene

		# Vertikale Position
		var y: float = start_y + float(ebene) * ebenen_abstand

		# Breite an die tatsächliche Höhe auf dem Baum anpassen
		var anteil: float = clampf(
			(y - oben_y) / verfuegbare_hoehe,
			0.0,
			1.0
		)

		var halbe_breite: float = maximale_halbe_breite * anteil

		# Horizontale Position
		var x: float = 0.0

		if plaetze_in_ebene > 1:
			x = lerpf(
				-halbe_breite,
				halbe_breite,
				float(position_in_ebene) / float(plaetze_in_ebene - 1)
			)

		slots[i].position = Vector2(x, y)
