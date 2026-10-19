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
static func pop_action() -> void:
	print("POP")
	action_list.pop_back()

static func debug_print_action_list() -> void:
	for i in action_list:
		print("1: ", i.first_node , " 2:",  i.second_node)
