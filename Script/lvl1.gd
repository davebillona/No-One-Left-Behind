extends Node2D

@onready var menu_btn: TextureButton = $CanvasLayer/MenuBtn
@onready var grey_overlay: ColorRect = $GreyOverlay

var TryAgainScene = preload("res://Scene/try_again.tscn")
var popup_instance: Control = null

func _ready():
	menu_btn.pressed.connect(_on_menu_btn_pressed)
	await Fade.fade_out(1.0)

func _on_menu_btn_pressed():
	grey_overlay.visible = true
	
	if popup_instance == null:
		popup_instance = TryAgainScene.instantiate()
		add_child(popup_instance)

		# Make sure popup is NOT paused
		popup_instance.process_mode = Node.PROCESS_MODE_ALWAYS

		# Optional: center it
		popup_instance.position = get_viewport_rect().size / 2 - popup_instance.size / 2

		# Pause the game
		get_tree().paused = true

		# Connect popup signal to resume game
		popup_instance.connect("restart_pressed", Callable(self, "_on_restart_pressed"))

func _on_restart_pressed():
	# Resume the game
	get_tree().paused = false

	# Remove popup
	if popup_instance:
		popup_instance.queue_free()
		popup_instance = null

	# Hide overlay
	grey_overlay.visible = false

func get_next_level_path() -> String:
	return "res://scene/lvl2.tscn"
