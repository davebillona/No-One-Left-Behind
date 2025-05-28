extends Node2D

@onready var area_2d: Area2D = $Area2D

func _ready():
	area_2d.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		# 1. Prevent retriggering
		area_2d.monitoring = false

		# 2. Turn off collisions immediately
		for child in body.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", true)

		# 3. Freeze physics: zero out velocity and stop further physics
		body.velocity = Vector2.ZERO
		body.set_physics_process(false)

		# 4. Tween scale down (shrink) right at current position
		var tw = get_tree().create_tween()
		tw.tween_property(body, "scale", Vector2.ZERO, 0.5)
		tw.tween_callback(Callable(body, "hide"))
