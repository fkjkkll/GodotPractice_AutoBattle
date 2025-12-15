class_name VelocityBasedRotation
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var target: Node2D
@export var x_velocity_threshold : int = 300
@export var max_arc: float = PI / 6.0
@export var change_speed: float = 5.0

var last_position: Vector2
var angle: float
var velocity: Vector2


func _ready() -> void:
	last_position = target.global_position


func _process(delta: float) -> void:
	if not enabled or not target:
		return
	# 关闭垂直同步，帧数暴涨到4000fps也可以正常运作
	velocity = 0.5 * velocity + 0.5 * (target.global_position - last_position) / delta
	last_position = target.global_position
	if abs(velocity.x) > x_velocity_threshold:
		angle = move_toward(target.rotation, sign(velocity.x) * max_arc, delta * change_speed)
	else:
		angle = move_toward(target.rotation, 0, delta * 5)
		if angle == 0:
			velocity = Vector2.ZERO

	target.rotation = angle


func _set_enabled(value: bool) -> void:
	enabled = value
	
	if target and enabled == false:
		target.rotation = 0.0
