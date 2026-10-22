class_name Action
extends Object
##Eine Aktion Struktur für den [ActionStack]
##Wird mit [method new] erstellt, mit 2 [TreeNode] argumenten

var first_node: TreeNode ##Das erste tree_node element einer [Action]
var second_node: TreeNode ##Das zweite tree_node elemnt einer [Action]

func _init(first: TreeNode, second: TreeNode) -> void:
	first_node = first
	second_node = second


func debug_print_action() -> void:
	print("1: ", first_node, " 2: ", second_node)
