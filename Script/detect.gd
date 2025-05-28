extends Area2D

@onready var label: Label = $CanvasLayer/Label


var characters_in_area: = []  # Holds references to bodies currently inside

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_label()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		characters_in_area.append(body)
		_update_label()

# detect.gd
func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D and body in characters_in_area:
		# Check if the exiting body is the player and is dead
		var is_player := body.is_in_group("player")
		var can_move = false
		var is_dead := false
		if is_player:
			is_dead = body.is_dead  # Access the player's `is_dead` variable
		
		characters_in_area.erase(body)
		_update_label()
		
		# Do NOT proceed to next level if the player exited due to death
		if is_player and is_dead:
			return
		
		# Proceed only if all characters have left (not due to player death)
		if characters_in_area.size() == 0:
			await get_tree().create_timer(1.0).timeout
			call_deferred("_next_level")

func _update_label() -> void:
	label.text = "Players here: %d" % characters_in_area.size()

func _next_level():
	var level_node = get_parent()
	if level_node.has_method("get_next_level_path"):
		var next_scene = level_node.get_next_level_path()
		await Fade.fade_in(1.0)
		
		var tree = Engine.get_main_loop()
		if tree:
			var err = tree.change_scene_to_file(next_scene)
			if err != OK:
				print("Error changing scene:", err)
		else:
			print("Error: Could not get SceneTree (main loop) to change scene")
	else:
		print("Level node does NOT have 'get_next_level_path' method")
