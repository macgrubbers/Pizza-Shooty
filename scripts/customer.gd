extends CharacterBody2D

signal customer_destroyed(customer)

@export var health: int = 100
@export var speed: float = 50.0

var claimedChair: Area2D
var push_dir: Vector2 = Vector2(0, 0)
var push_strength: float = 0.0
var push_timer: float = 0.0
var is_sitting: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var damage_text: Label = $DamageTextContainer/DamageText
@onready var blood_particle = preload("res://scenes/blood_particle.tscn")
@onready var navigation_agent = get_node("NavAgent")

# Replace with animation tree later?
var status = "Walking"

func _ready():
	damage_text.visible = false


func setup(pos: Vector2, chair: Area2D):
	claimedChair = chair


func _physics_process(delta):
	if not navigation_agent.get_target_position():
		navigation_agent.set_target_position(claimedChair.global_position)
	else:
		if status == "Walking" and !is_sitting:
			var dir = (navigation_agent.get_next_path_position() - global_position).normalized()
			velocity = dir * speed
			# Handle push
			push_back(delta)
			move_and_slide()
	

func get_hit(damage: int, bullet_trans: Transform2D):
	health -= damage
	damage_text.text = str(damage)
	animation_tree['parameters/conditions/is_damaged'] = true
	if health <= 0:
		animation_tree['parameters/conditions/is_destroyed'] = true
	# Bleeding effect
	var bleeding_effect = blood_particle.instantiate()
	get_tree().root.add_child(bleeding_effect)
	bleeding_effect.setup(bullet_trans)
	set_push(Vector2.RIGHT.rotated(bullet_trans.get_rotation()), 150.0, 0.1)

func destroy():
	customer_destroyed.emit(self)
	queue_free()

func set_push(dir: Vector2, strength: float, timer: float):
	push_dir = -dir
	push_strength = strength
	push_timer = timer

func push_back(delta: float):
	if push_timer > 0.0:
		position -= push_dir * push_strength * delta
		push_timer -= delta
	else:
		push_timer = 0.0

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "get_damage":
		animation_tree['parameters/conditions/is_damaged'] = false
	elif anim_name == "destroy":
		animation_tree['parameters/conditions/is_destroyed'] = false
		destroy()

func sit(chairPos: Vector2):
	position = chairPos
	is_sitting = true
