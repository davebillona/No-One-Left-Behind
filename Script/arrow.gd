extends Sprite2D  # Or TextureRect

var fade_tween: Tween
@export var fade_speed: float = 0.8  # Time for full fade cycle
@export var fade_intensity: float = 0.3  # Minimum alpha (0-1)

func _ready():
	start_fade_effect()

func start_fade_effect():
	# Create a new tween if none exists
	if fade_tween:
		fade_tween.kill()
	
	fade_tween = create_tween().set_loops()
	
	# Configure fade animation
	fade_tween.tween_property(self, "modulate:a", fade_intensity, fade_speed/2).set_ease(Tween.EASE_IN_OUT)
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_speed/2).set_ease(Tween.EASE_IN_OUT)

func stop_fade_effect():
	if fade_tween:
		fade_tween.kill()
	modulate.a = 1.0  # Reset to full opacity
