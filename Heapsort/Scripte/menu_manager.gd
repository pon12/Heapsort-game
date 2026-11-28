extends Node

var menu_stack: Array[Node] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func open_menu(menu: Node) -> void:
	if not is_instance_valid(menu):
		return

	if menu_stack.has(menu):
		return

	if not menu_stack.is_empty():
		menu_stack.back().hide()

	menu_stack.append(menu)
	menu.show()


func go_back() -> void:
	if menu_stack.is_empty():
		return

	var current_menu: Node = menu_stack.pop_back()

	if is_instance_valid(current_menu):
		current_menu.hide()

	if not menu_stack.is_empty():
		menu_stack.back().show()


func clear_menus() -> void:
	while not menu_stack.is_empty():
		var menu: Node = menu_stack.pop_back()

		if is_instance_valid(menu):
			menu.hide()


func get_current_menu() -> Node:
	if menu_stack.is_empty():
		return null

	return menu_stack.back()
