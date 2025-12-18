class_name AutoAttackState
extends State

var actor_unit: BattleUnit
var target: BattleUnit
var running := false


func enter() -> void:
	running = true
	actor_unit = actor as BattleUnit
	target = actor_unit.target_finder.targets_in_range[0]
	actor_unit.detect_range.area_exited.connect(_on_detect_range_exited)
	actor_unit.attack_timer.timeout.connect(_attack)
	actor_unit.stats.mana_bar_filled.connect(_ability_ready)
	_setup_attack_timer()
	actor_unit.animation_player.play("RESET")


func exit() -> void:
	actor_unit.detect_range.area_exited.disconnect(_on_detect_range_exited)
	actor_unit.attack_timer.stop()
	actor_unit.attack_timer.timeout.disconnect(_attack)
	actor_unit.stats.mana_bar_filled.disconnect(_ability_ready)
	running = false


func _ability_ready() -> void:
	change_state.emit(StateType.CAST)


func _setup_attack_timer() -> void:
	actor_unit.attack_timer.wait_time = actor_unit.stats.get_time_between_attacks()
	actor_unit.attack_timer.start()


func _attack() -> void:
	actor_unit.flip_sprite.flip_sprite_towards(target.global_position)
	actor_unit.animation_player.play("attack")
	SFXPlayer.play(actor_unit.stats.auto_attack_sound)
	
	if actor_unit.stats.is_melee():
		var hitbox := actor_unit.melee_attack.attack(target.global_position) as HitBox
		hitbox.damage = actor_unit.stats.get_attack_damage()
		hitbox.collision_layer = actor_unit.stats.get_team_collision_layer()
		hitbox.collision_mask = actor_unit.stats.get_team_collision_mask()
		actor_unit.animation_player.animation_finished.connect(_on_attack_hit.unbind(1), CONNECT_ONE_SHOT)
	else:
		var projectile := actor_unit.ranged_attack.attack(target.global_position) as Projectile
		projectile.target = target.global_position
		projectile.hitbox.collision_layer = actor_unit.stats.get_team_collision_layer()
		projectile.hitbox.collision_mask = actor_unit.stats.get_team_collision_mask()
		projectile.hitbox.damage = actor_unit.stats.get_attack_damage()
		projectile.hitbox.hit.connect(_on_attack_hit)


func _on_attack_hit() -> void:
	if not target: return
	actor_unit.stats.mana += UnitStats.MANA_PER_ATTACK
	
	if running and target.stats.health <= 0:
		change_state.emit(StateType.CHASE)


func _on_detect_range_exited(area: Area2D) -> void:
	if area is BattleUnit and area == target:
		change_state.emit(StateType.CHASE)
