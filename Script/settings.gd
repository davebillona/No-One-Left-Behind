extends Control

signal popup_closed

@onready var close_button: TextureButton = $CanvasLayer/Panel/CloseButton

func _ready():
	close_button.connect("pressed", Callable(self, "_on_close_pressed"))

func _on_close_pressed():
	popup_closed.emit()
	queue_free()
