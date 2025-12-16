@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

@export var stats: UnitStats : set = _set_stats

@onready var skin: PackedSprite2D = %Skin
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var tier_icon: TierIcon = $TierIcon

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var velocity_based_rotation: VelocityBasedRotation = $VelocityBasedRotation
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var animations: UnitAnimations = $UnitAnimations


func _set_stats(value: UnitStats) -> void:
	stats = value
	if value == null:
		return
	
	if not is_node_ready():
		await ready
	
	if not Engine.is_editor_hint():
		stats = value.duplicate()
	
	skin.coordinates = stats.skin_coordinates
	tier_icon.stats = stats


func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_started.connect(_on_drag_started)
		drag_and_drop.dropped.connect(_on_dropped.unbind(1))
		drag_and_drop.drag_canceled.connect(_on_drag_canceled.unbind(1))


func _input(event: InputEvent) -> void:
	if not outline_highlighter.is_highlight: return
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()


func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
	outline_highlighter.highlight()


func _on_mouse_exited() -> void:
	if drag_and_drop.dragging:
		return
	outline_highlighter.clear_highlight()


func _on_drag_started() -> void:
	velocity_based_rotation.enabled = true


func _on_dropped() -> void:
	velocity_based_rotation.enabled = false


func _on_drag_canceled() -> void:
	velocity_based_rotation.enabled = false


func reset_after_dragging(starting_pos: Vector2) -> void:
	global_position = starting_pos
