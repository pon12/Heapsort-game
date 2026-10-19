class_name Action
extends Object
##Eine Aktion Struktur für den [ActionStack]

var first_node: Node2D ##Das erste tree_node element einer [Action]
var second_node: Node2D ##Das zweite tree_node elemnt einer [Action]

func set_action(first:Node2D, second: Node2D) -> void:
	first_node = first
	second_node = second

func debug_print_action() -> void:
	print("1: ", first_node, " 2: ", second_node)
