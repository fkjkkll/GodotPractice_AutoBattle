class_name FiniteStateMachine
extends RefCounted

signal state_changed(type: State)

var states := {}

var curState: State = null

var curStateType: State.StateType:
	set(value):
		curStateType = value
		curState = states[curStateType]
		if not curState: return
		curState.enter()
		state_changed.emit(curState)


func _init(actor: BattleUnit) -> void:
	states[State.StateType.CHASE] = ChaseState.new(actor)
	states[State.StateType.AUTO_ATTACK] = AutoAttackState.new(actor)
	states[State.StateType.STUCK] = StuckState.new(actor)
	states[State.StateType.CAST] = CastState.new(actor)
	for key in State.StateType:
		var state = states[State.StateType[key]] as State
		state.change_state.connect(_on_change_state)


func process(delta: float) -> void:
	if not curState: return
	curState.process(delta)


func physics_process(delta: float) -> void:
	if not curState: return
	curState.physics_process(delta)


func _on_change_state(type: State.StateType):
	if curState:
		curState.exit()
	curStateType = type


func start(type: State.StateType) -> void:
	curStateType = type


func pause() -> void:
	if curState:
		curState.exit()
	curState = null
