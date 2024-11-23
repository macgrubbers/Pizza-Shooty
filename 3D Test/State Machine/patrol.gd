extends EnemyState


func enter(previous_state_path: String, data := {}) -> void:
	pass


func physics_update(_delta: float) -> void:
	print("Patrolling!")
	if enemy.tracker.player_found:
		finished.emit(PURSUE)
		print("found!")
	pass
