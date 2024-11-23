# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name EnemyState extends State

const IDLE = "Idle"
const PATROL = "Patrol"
const PURSUE = "Pursue"

var enemy: Enemy


func _ready() -> void:
	await owner.ready
	print(owner)
	enemy = owner as Enemy
	assert(enemy != null)
