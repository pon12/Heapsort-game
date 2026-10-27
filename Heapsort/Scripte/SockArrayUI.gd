extends HBoxContainer

@export var sock_scene: PackedScene # Hier im Inspector die Sock.tscn zuweisen!

var sock_nodes: Array = []

# Initialisiert das Array beim Start oder Level-Beginn
func initialize(data: Array) -> void:
	# Alte Socken entfernen, falls welche da sind
	for child in get_children():
		child.queue_free()
	sock_nodes.clear()
	
	# Für jede Zahl im Array eine neue Socke instanziieren
	for val in data:
		var sock = sock_scene.instantiate()
		add_child(sock)
		sock.set_value(val)
		sock_nodes.append(sock)

# Aktualisiert alle Zahlenwerte (wird bei jedem Tausch aufgerufen)
func update_values(data: Array) -> void:
	for i in range(data.size()):
		if i < sock_nodes.size():
			sock_nodes[i].set_value(data[i])

# Markiert eine spezifische Socke als "fertig sortiert"
func set_sorted_state(index: int) -> void:
	if index < sock_nodes.size():
		sock_nodes[index].set_sorted(true)

# Prüft jede Socke einzeln, ob ihr aktueller Wert mit dem Ziel-Wert übereinstimmt
# Prüft, ob Socken sortiert sind (von rechts nach links bzw. nach HeapSort-Logik)
func check_individual_socks(aktuelle_werte: Array, ziel_werte: Array) -> void:
	# Wir prüfen von hinten nach vorne (weil HeapSort das Ende zuerst fixiert)
	var von_rechts_sortiert: bool = true
	
	for i in range(aktuelle_werte.size() - 1, -1, -1):
		var sock_node = get_child(i)
		if sock_node == null or not sock_node.has_method("set_sorted"):
			continue
			
		# Bedingung 1: Stimmt der Wert mit dem Ziel überein?
		# Bedingung 2: Ist es entweder das letzte Element (das Größte) ODER die Kette von rechts ist intakt?
		var ist_an_zielposition = (aktuelle_werte[i] == ziel_werte[i])
		
		if ist_an_zielposition and von_rechts_sortiert:
			sock_node.set_sorted(true)
		else:
			sock_node.set_sorted(false)
			# Sobald eine Socke von rechts kommend nicht mehr stimmt, 
			# bricht die Kette für die davor liegenden ab
			von_rechts_sortiert = false
