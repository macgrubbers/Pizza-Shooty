extends CharacterBody2D

@export var speed: float = 360.0
@export var lr_flag: bool = true # Enable body left right animation
@export var rotate_flag: bool = true # Enable body rotation 

var screen_size # Size of the game window.
var lr: bool = true # Default face right
var aim_pos: Vector2 = Vector2(0, 0)
var is_shot_cd: bool = false
var push_dir: Vector2 = Vector2(0, 0)
var push_strength: float = 0.0
var push_timer: float = 0.0
var mouse_pos: Vector2

var movementArray: Array = []

var rightHand: Node2D
var leftHand: Node2D

# Reference
@onready var move_trail_effect: GPUParticles2D = $MovementTrailEffect
@onready var shot_effect: GPUParticles2D = $BodyRotate/ShootingEffect
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta):
	mouse_pos = get_parent().get_global_mouse_position()
	
	if rightHand:
		rightHand.look_at(mouse_pos)
		rightHand.flip()
		
	if Input.is_action_just_pressed('open_inventory'):
		if $PlayerInventory.visible:
			$PlayerInventory.visible = false
		else:
			$PlayerInventory.visible = true
		
	velocity = Vector2.ZERO # The player's movement vector.
	# Movement input
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite2D.play("walk_right")
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite2D.play("walk_left")
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		$AnimatedSprite2D.play("walk_down")
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		$AnimatedSprite2D.play("walk_up")
		
	# Normalize velocity if move along x and y together
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_trail_effect.emitting = true # Play movement trail effect
	
	# Apply movement effects
	# effect = [x direction, y direction, duration]
	for effect in movementArray:
		if effect[2] > 0:
			velocity += Vector2(effect[0], effect[1])
			movementArray[movementArray.find(effect)] = Vector3(effect[0], effect[1], effect[2] - delta)
		else:
			movementArray.erase(effect)
	
	# Handle body_lr
	#update_body_lr()
	# Limit the player movement, add your character scale if needed
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	move_and_slide()

	

func setup(pos: Vector2):
	position = pos
	show()

		
func add_to_inventory(pickup: int, quantity: int):
	#add gun on pickup
	$PlayerInventory.add_item(Vector2i(pickup, quantity))
	var newGun = load("res://scenes/Weapons/shotgun.tscn").instantiate()
	newGun.connect("applyKick", _on_apply_kick)
	#add_child(newGun)
	#rightHand = newGun

func _on_apply_kick(kickVectorAndDuration: Vector3):
	movementArray.append(kickVectorAndDuration)
