extends CanvasLayer

signal fade_finished

@onready var rect: ColorRect = $ColorRect

func _ready():
	# Make sure we cover the entire screen including UI
	layer = 100  # High layer number to cover everything
	rect.size = get_viewport().size
	await get_tree().process_frame  # Ensure nodes are ready
	rect.color = Color.BLACK
	rect.visible = true
	fade_out()

func fade_in(duration: float = 1.0) -> void:
	rect.visible = true
	# Update size in case window was resized
	rect.size = get_viewport().size
	
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	await tween.finished
	fade_finished.emit()

func fade_out(duration: float = 1.0) -> void:
	rect.visible = true
	# Update size in case window was resized
	rect.size = get_viewport().size
	
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, duration)
	await tween.finished
	fade_finished.emit()
