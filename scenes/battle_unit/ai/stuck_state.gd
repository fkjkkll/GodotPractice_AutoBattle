class_name StuckState
extends State

const STUCK_WAIT_TIME := 0.5

var elapsed := 0.0


func physics_process(delta: float) -> void:
	elapsed += delta
	if elapsed >= STUCK_WAIT_TIME:
		change_state.emit(StateType.CHASE)
