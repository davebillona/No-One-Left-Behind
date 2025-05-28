extends Sprite2D

@export var scroll_speed := 0.003
var time_passed := 0.0

func _process(delta):
	time_passed += delta
	if material:
		var sm = material as ShaderMaterial
		sm.set_shader_parameter("time_passed", time_passed)
		sm.set_shader_parameter("scroll_speed", scroll_speed)
