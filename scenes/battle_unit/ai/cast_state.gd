class_name CastState
extends State

var actor_unit: BattleUnit
var ability: UnitAbility


func enter() -> void:
	actor_unit = actor as BattleUnit
	actor_unit.stats.mana = 0
	
	if not actor_unit.stats.ability:
		change_state.emit.call_deferred(StateType.CHASE)
	else:
		actor_unit.animation_player.play("cast")
		ability = actor_unit.ability_spawner.spawn_scene(actor_unit.get_tree().root) as UnitAbility
		ability.caster = actor_unit
		ability.global_position = actor_unit.global_position
		ability.ability_cast_finished.connect(_on_ability_cast_finished, CONNECT_ONE_SHOT)
		ability.use.call_deferred()


func exit() -> void:
	if ability:
		ability.queue_free()


func _on_ability_cast_finished() -> void:
	change_state.emit(StateType.CHASE)
