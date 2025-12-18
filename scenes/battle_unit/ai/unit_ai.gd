class_name UnitAI
extends Node

@export var debug_label: Label
@export var enabled: bool: set = _set_enabled
@export var actor: BattleUnit

var fsm: FiniteStateMachine


func _ready() -> void:
	fsm = FiniteStateMachine.new(actor)
	fsm.state_changed.connect(
		func(state: State):
			if not debug_label: return
			debug_label.text = state.get_script().get_global_name()
	)


func _set_enabled(value: bool) -> void:
	enabled = value
	if enabled:
		actor.stats.health_reached_zero.connect(_handle_on_actor_die)
		fsm.start(State.StateType.CHASE)
	else:
		fsm.pause()
		actor.stats.health_reached_zero.disconnect(_handle_on_actor_die)


func _physics_process(delta: float) -> void:
	if not enabled: return
	fsm.physics_process(delta)


func _process(delta: float) -> void:
	if not enabled: return
	fsm.process(delta)


func _handle_on_actor_die() -> void:
	fsm.pause()
