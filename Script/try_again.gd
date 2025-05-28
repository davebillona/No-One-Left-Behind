# ControlUI.gd
extends Control

signal restart_pressed

@onready var btn_restart: TextureButton = $CanvasLayer/Panel/RestartButton

func _ready():
	# Option A: old‐style connect
   # btn_restart.connect("pressed", self, "_on_btn_restart_pressed")
	# Option B: Godot 4 Callable
	btn_restart.connect("pressed", Callable(self, "_on_btn_restart_pressed"))
	visible = false   # start hidden

	

func popup():
	visible = true
	btn_restart.grab_focus()

func _on_btn_restart_pressed():
	emit_signal("restart_pressed")
	visible = false
