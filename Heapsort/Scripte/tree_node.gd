class_name TreeNode
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

@export var number: int = 1
@export var picture: CompressedTexture2D
@export var Scaling: Vector2 = Vector2(0.017, 0.017)
@export var left_child: TreeNode
@export var right_child: TreeNode
@export var parent_treenode: TreeNode

@export var left_lichterkette: LichterKette
@export var right_lichterkette: LichterKette

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var rest_position: Vector2 = Vector2.ZERO
var drag_start_position: Vector2 = Vector2.ZERO

var target_distance: float = 110.0


func _ready() -> void:
	rest_position = global_position
	sprite.texture = picture
	sprite.scale = Scaling
	label.text = str(number)
	z_index = 10


func set_highlight(enabled: bool) -> void:
	if enabled:
		sprite.modulate = Color(1.0, 0.85, 0.2)
	else:
		sprite.modulate = Color.WHITE


func swap(node: TreeNode) -> void:
	if node == self:
		return

	var my_position: Vector2 = global_position
	global_position = node.global_position
	node.global_position = my_position

	rest_position = global_position
	node.rest_position = node.global_position
	
	swap_child_and_lichterketten_ownership(node)	
	
	var new_action: Action = Action.new(self, node)
	new_action.debug_print_action()
	ActionStack.push_action(new_action)
	ActionStack.debug_print_action_list()
	

func swap_back(node: TreeNode) -> void:
	if node == self:
		return

	var my_position: Vector2 = global_position
	global_position = node.global_position
	node.global_position = my_position
	
	swap_child_and_lichterketten_ownership(node)

	rest_position = global_position
	node.rest_position = node.global_position

##Prüft ob Maus anfängt die Node zu draggen
func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true
			drag_start_position = global_position
			drag_offset = global_position - get_global_mouse_position()
			move_to_front()
			get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (
			event.button_index == MOUSE_BUTTON_LEFT
			and not event.pressed
			and dragging
		):
			dragging = false
			_snap_to_slot()
			get_viewport().set_input_as_handled()


func _snap_to_slot() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()

	# Andere Kugel unter dem Cursor suchen
	var target_ball: TreeNode = null
	var closest_distance: float = target_distance

	for node in get_tree().get_nodes_in_group("tree_balls"):
		var ball: TreeNode = node

		if ball == null or ball == self:
			continue

		var distance: float = mouse_position.distance_to(ball.global_position)

		if distance < closest_distance:
			closest_distance = distance
			target_ball = ball

	# Wenn eine andere Kugel getroffen wurde:
	# Die gezogene Kugel kommt an deren Position.
	# Die andere Kugel kommt an die urspruengliche Position.
	if target_ball != null:
		var target_position: Vector2 = target_ball.global_position

		global_position = target_position
		target_ball.global_position = drag_start_position

		rest_position = global_position
		target_ball.rest_position = target_ball.global_position
		
		var new_action: Action = Action.new(self, target_ball)
		ActionStack.push_action(new_action)
		
		swap_child_and_lichterketten_ownership(target_ball)

		print(
			"Getauscht: ", number,
			" mit ", target_ball.get("number")
		)

		_notify_tree()
		return
		
	#toter code ? Ka mir egal ich lass ihn jetzt mal hier
	print("tree_node.gd: Kann dieser Code überhaupt eintreten ?")

	# Sonst den naechsten Marker suchen
	var nearest_slot: TreeNode = null
	var nearest_distance: float = INF

	for node in get_tree().get_nodes_in_group("drop_slots"):
		var slot := node as TreeNode

		if slot == null:
			continue

		var distance: float = mouse_position.distance_to(
			slot.global_position
		)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_slot = slot

	if nearest_slot == null:
		global_position = drag_start_position
		rest_position = global_position
		return
		
	# Kugel auf den Marker setzen
	#global_position = nearest_slot.global_position
	#rest_position = global_position
	swap(nearest_slot.get_parent())
	_notify_tree()


func _notify_tree() -> void:
	rest_position = global_position

	var baum := get_parent()

	if baum != null and baum.has_method("on_manual_move"):
		baum.on_manual_move()
		
func check_heapsort_condition() -> void:
	if left_child != null and left_lichterkette !=null:
		if left_child.number > self.number:
			left_lichterkette.set_unsorted()
		else:
			left_lichterkette.set_sorted()
	if right_child != null and right_lichterkette !=null:
		if right_child.number > self.number:
			right_lichterkette.set_unsorted()
		else:
			right_lichterkette.set_sorted()
		
		
func swap_child_and_lichterketten_ownership(node: TreeNode) -> TreeNode:
	if node == null or node == self:
		return find_root(self)

	var old_root: TreeNode = find_root(self)

	var path: Array = ancestor_path(self, node)
	if not path.is_empty():
		swap_ancestor_positions(path)
	elif not ancestor_path(node, self).is_empty():
		path = ancestor_path(node, self)
		swap_ancestor_positions(path)
	else:
		swap_unrelated_positions(node)

	if old_root == self:
		return node
	if old_root == node:
		return self
	return old_root


func swap_unrelated_positions(node: TreeNode) -> void:
	var self_parent: TreeNode = parent_treenode
	var node_parent: TreeNode = node.parent_treenode

	if self_parent != null:
		replace_child_references(self_parent, self, node)
	if node_parent != null and node_parent != self_parent:
		replace_child_references(node_parent, self, node)

	parent_treenode = node_parent
	node.parent_treenode = self_parent

	var temp_left_child: TreeNode = left_child
	left_child = node.left_child
	node.left_child = temp_left_child

	var temp_right_child: TreeNode = right_child
	right_child = node.right_child
	node.right_child = temp_right_child

	var temp_left_chain: LichterKette = left_lichterkette
	left_lichterkette = node.left_lichterkette
	node.left_lichterkette = temp_left_chain

	var temp_right_chain: LichterKette = right_lichterkette
	right_lichterkette = node.right_lichterkette
	node.right_lichterkette = temp_right_chain

	update_child_parent_references(self)
	update_child_parent_references(node)


func swap_ancestor_positions(path: Array) -> void:
	var last_index: int = path.size() - 1
	var outside_parent: TreeNode = path[0].parent_treenode

	var left_children: Array = []
	var right_children: Array = []
	var left_chains: Array = []
	var right_chains: Array = []

	for path_node in path:
		left_children.append(path_node.left_child)
		right_children.append(path_node.right_child)
		left_chains.append(path_node.left_lichterkette)
		right_chains.append(path_node.right_lichterkette)

	var occupants: Array = path.duplicate()
	occupants[0] = path[last_index]
	occupants[last_index] = path[0]

	for i in range(last_index):
		var old_next: TreeNode = path[i + 1]
		var new_next: TreeNode = occupants[i + 1]

		if left_children[i] == old_next:
			left_children[i] = new_next
		if right_children[i] == old_next:
			right_children[i] = new_next

	if outside_parent != null:
		replace_child_references(outside_parent, path[0], path[last_index])

	for i in range(path.size()):
		var occupant: TreeNode = occupants[i]
		occupant.left_child = left_children[i]
		occupant.right_child = right_children[i]
		occupant.left_lichterkette = left_chains[i]
		occupant.right_lichterkette = right_chains[i]

		if i == 0:
			occupant.parent_treenode = outside_parent
		else:
			occupant.parent_treenode = occupants[i - 1]

		update_child_parent_references(occupant)


func ancestor_path(ancestor: TreeNode, descendant: TreeNode) -> Array:
	var reversed_path: Array = []
	var current: TreeNode = descendant

	while current != null:
		reversed_path.append(current)
		if current == ancestor:
			reversed_path.reverse()
			return reversed_path
		current = current.parent_treenode

	return []


func replace_child_references(parent: TreeNode,old_a: TreeNode,old_b: TreeNode) -> void:
	if parent.left_child == old_a:
		parent.left_child = old_b
	elif parent.left_child == old_b:
		parent.left_child = old_a

	if parent.right_child == old_a:
		parent.right_child = old_b
	elif parent.right_child == old_b:
		parent.right_child = old_a


func update_child_parent_references(parent: TreeNode) -> void:
	if parent.left_child != null:
		parent.left_child.parent_treenode = parent
	if parent.right_child != null:
		parent.right_child.parent_treenode = parent


func find_root(node: TreeNode) -> TreeNode:
	var current: TreeNode = node

	while current != null and current.parent_treenode != null:
		current = current.parent_treenode

	return current
