extends EnemyState


func enter(previous_state_path: String, data := {}) -> void:
	pass


func physics_update(_delta: float) -> void:
	
	if enemy.tracker.player_found:
		# Set enemy's destination point to player and upadate velocity
		var player_position = enemy.tracker.last_player_location
		enemy.nav_agent.set_target_position(player_position)
		enemy.look_at(player_position)
		enemy.rotation.x = 0
		enemy.rotation.z = 0

		var current_position = enemy.global_position
		var next_path_position = enemy.nav_agent.get_next_path_position()
		enemy.velocity = current_position.direction_to(next_path_position) * enemy.SPEED
		enemy.velocity.y = 0
	
	if enemy.nav_agent.is_navigation_finished():
		pass
