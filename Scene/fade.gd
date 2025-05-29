extends CanvasLayer

signal fade_finished

@onready var rect: ColorRect = $ColorRect

# List of scenes where fading is disabled (can be full path or just filename)
var excluded_scenes := [
	"menu_ui.tscn",
]

func _ready():
	layer = 100
	rect.size = get_viewport().size
	await get_tree().process_frame
	rect.color = Color.BLACK
	rect.visible = true
	fade_out()

func fade_in(duration: float = 1.0) -> void:
	var current_scene = get_tree().current_scene
	var current_scene_path = ""
	if current_scene != null:
		current_scene_path = current_scene.scene_file_path

	var current_scene_name = current_scene_path.get_file()

	if current_scene_name in excluded_scenes:
		rect.visible = false
		fade_finished.emit()
		return

	rect.visible = true
	rect.size = get_viewport().size

	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	await tween.finished
	fade_finished.emit()

func fade_out(duration: float = 1.0) -> void:
	var current_scene = get_tree().current_scene
	var current_scene_path = ""
	if current_scene != null:
		current_scene_path = current_scene.scene_file_path

	var current_scene_name = current_scene_path.get_file()

	if current_scene_name in excluded_scenes:
		rect.visible = false
		fade_finished.emit()
		return

	rect.visible = true
	rect.size = get_viewport().size

	var tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, duration)
	await tween.finished
	fade_finished.emit()
