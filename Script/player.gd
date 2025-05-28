extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var gravity: float = 900.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow

var can_move: bool = true
var is_dead: bool = false

func _ready():
	add_to_group("player")  # <-- Add this line

	SignalBus.player_died.connect(_on_player_died)

func _physics_process(delta: float) -> void:
	# Always apply gravity even when can_move is false
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if can_move:
		# Process movement input only when allowed
		var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.x = direction * speed
		
		# Jumping
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		
		# Animation control
		if not is_on_floor():
			sprite.play("jump")
		elif direction != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
	else:
		# Stop horizontal movement but keep falling
		velocity.x = 0
		# Play idle once landed
		if is_on_floor() and not is_dead:
			sprite.play("idle")

	# Always move and slide regardless of can_move state
	move_and_slide()

func die():
	if is_dead: 
		return
	is_dead = true
	can_move = false
	sprite.play("die")
	SignalBus.player_died.emit()

func _on_player_died():
	if is_dead:
		return  # Already dead
	
	can_move = false
	# Keep processing physics but stop input
	# Let gravity work naturally
