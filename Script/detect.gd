extends Area2D

@onready var label: Label = $CanvasLayer/Label

var characters_in_area: = []  # Holds references to bodies currently inside

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_label()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		characters_in_area.append(body)
		_update_label()

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D and body in characters_in_area:
		characters_in_area.erase(body)
		_update_label()

func _update_label() -> void:
	label.text = "Players here: %d" % characters_in_area.size()
