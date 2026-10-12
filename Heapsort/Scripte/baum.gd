extends Node2D

@onready var tree_node: Node2D = $TreeNode
@onready var tree_node_2: Node2D = $TreeNode2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
 # Replace with function body.
	var test = tree_node_2.position
	tree_node_2.position = tree_node.position
	tree_node.position = test



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
