extends Area2D

@onready var timer: Timer = $Timer
var player_body: CharacterBody2D = null

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is CharacterBody2D:
		player_body = body
		player_body.die()
		Engine.time_scale = 0.5
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
