class_name OutlineHighlighter
extends Node

@export var visuals: CanvasGroup
@export var outline_color: Color = Color.WHITE
@export_range(1, 10) var outline_thickness: int

var is_highlight := false

func _ready() -> void:
	visuals.material.set_shader_parameter("line_color", outline_color)


func highlight() -> void:
	is_highlight = true
	visuals.material.set_shader_parameter("line_thickness", outline_thickness)


func clear_highlight() -> void:
	is_highlight = false
	visuals.material.set_shader_parameter("line_thickness", 0)
