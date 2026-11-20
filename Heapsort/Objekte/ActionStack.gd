class_name ActionStack
extends Object

static var action_list: Array[Action] = []
static var redo_list: Array[Action] = []

static func push_action(action: Action) -> void:
	action_list.append(action)
	redo_list.clear()


static func pop_action() -> void:
	if action_list.is_empty():
		return

	var action: Action = action_list.pop_back()
	action.first_node.swap_back(action.second_node)
	redo_list.append(action)
	notify_history_change(action, false)


static func redo_action() -> void:
	if redo_list.is_empty():
		return

	var action: Action = redo_list.pop_back()
	action.first_node.swap_back(action.second_node)
	action_list.append(action)
	notify_history_change(action, true)


static func notify_history_change(action: Action, is_redo: bool) -> void:
	var tree := action.first_node.get_parent()
	if tree == null:
		return

	# Refresh the displayed/logical order, but don't rebuild the algorithm.
	if tree.has_method("_sync_order_from_slots"):
		tree.call("_sync_order_from_slots")

	var callback := "on_redo_action" if is_redo else "on_pop_action"
	if tree.has_method(callback):
		tree.call(callback)
	if tree.has_method("pruefe_sortierung"):
		tree.call("pruefe_sortierung")

static func has_redo() -> bool:
	return not redo_list.is_empty()

static func clear() -> void:
	action_list.clear()
	redo_list.clear()
