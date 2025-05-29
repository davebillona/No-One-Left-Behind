extends Control

signal restart_pressed
@onready var panel: Panel = $CanvasLayer/Panel
@onready var main_menu: TextureButton = $CanvasLayer/Panel/MainMenu

@onready var btn_restart: TextureButton = $CanvasLayer/Panel/RestartButton
@onready var settings_button: TextureButton = $CanvasLayer/Panel/SettingsButton

var current_popup: Control = null
var settings_scene: PackedScene = preload("res://Scene/settings.tscn")

func _ready():
	btn_restart.connect("pressed", Callable(self, "_on_btn_restart_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_pressed"))
	main_menu.connect("pressed", Callable(self, "_on_main_menu_pressed"))

	panel.visible = true

func popup():
	# Show ControlUI popup, hide any other popups
	_hide_settings_popup()
	panel.visible = true
	btn_restart.grab_focus()
	current_popup = self

func _on_btn_restart_pressed():
	emit_signal("restart_pressed")
	panel.visible = false
	current_popup = null

func _on_settings_pressed():
	# Hide this ControlUI popup, don't free it
	panel.visible = false

	# Close previous settings popup if any
	_hide_settings_popup()

	# Instance and show settings popup
	var settings = settings_scene.instantiate()
	settings.name = "SettingsPopup"
	settings.visible = true
	settings.top_level = true
	settings.z_index = 100

	# Fullscreen anchors
	settings.anchor_left = 0
	settings.anchor_top = 0
	settings.anchor_right = 1
	settings.anchor_bottom = 1
	settings.offset_left = 0
	settings.offset_top = 0
	settings.offset_right = 0
	settings.offset_bottom = 0

	add_child(settings)
	current_popup = settings

	if settings.has_signal("popup_closed"):
		settings.connect("popup_closed", Callable(self, "_on_settings_closed"))

func _on_settings_closed():
	_hide_settings_popup()
	# Show ControlUI popup again
	panel.visible = true
	btn_restart.grab_focus()
	current_popup = self

func _hide_settings_popup():
	# Find the settings popup node if it exists, then free it
	if current_popup and current_popup != self and current_popup.is_inside_tree():
		current_popup.queue_free()
		current_popup = null

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scene/menu_ui.tscn")
