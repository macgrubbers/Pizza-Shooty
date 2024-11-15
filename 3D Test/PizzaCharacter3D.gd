class_name PizzaCharacter3D
extends CharacterBody3D


@onready var invulnerability_timer: Timer = Timer.new()
@onready var invulnerability_time: float = 0.2


var is_invulernable = false
var health = 100
var SPEED = 3.5
var knockback: Vector3
var knockback_restore_rate: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	invulnerability_timer.set_one_shot(true)
	invulnerability_timer.connect("timeout", _on_invulernability_timer_timeout)
	invulnerability_timer.set_wait_time(invulnerability_time)
	add_child(invulnerability_timer)


func _physics_process(delta):
	velocity += knockback
	move_and_slide()
	knockback = lerp(knockback, Vector3.ZERO, knockback_restore_rate)
	
	handle_animation()


func apply_damage(amount: float, knockback_amount: Vector3):
	if not is_invulernable:
		is_invulernable = true
		health -= amount
		knockback = knockback_amount
		if health <= 0:
			die()
		else:
			invulnerability_timer.start()
	else:
		print("INVULNERABLE")
		
		
func die():
	pass
	

func _on_invulernability_timer_timeout():
	invulnerability_timer.stop()
	is_invulernable = false
	

func handle_animation():
	pass
	#if animation player:
	#	return
	# if walking this way:
	#	animation this way
