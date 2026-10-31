class_name ActionStack
extends Object
##Der Stack für Undo funktionalität. 
##[method ActionStack.push_action] um eine getätigte Aktion hinzuzufügen,
##und [method ActionStack.pop_action] um eine Aktion rückgängig zu machen.
##Mithilfe von [Action] strukturen.
static var action_list: Array[Action] = [] ##[Action] Array um Aktionen festzuhalten.


##Aktion zum Stack hinzufügen.
static func push_action(action: Action) -> void:
	action_list.push_back(action)
	print("PUSH")
	
##Aktion rückgängig machen.
static func pop_action(notify_tree: bool = true) -> Action:
	if action_list.is_empty():
		print("action_list is empty")
		return null

	var action: Action = action_list.back()
	var tree = action.first_node.get_parent()
	print("POP 1: ", action.first_node.number, " 2: ", action.second_node.number)

	action.first_node.swap_back(action.second_node)
	action_list.pop_back()

	if notify_tree:
		tree.on_manual_move()
	return action

static func debug_print_action_list() -> void:
	for i in action_list:
		print("1: ", i.first_node.number , " 2:",  i.second_node.number)
