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
func reset_sorted() -> void:
	for sock in sock_nodes:
		sock.set_sorted(false)
