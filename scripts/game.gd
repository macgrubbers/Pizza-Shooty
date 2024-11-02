extends Node2D

@export var noise_shake_speed: float = 15.0
@export var noise_shake_strength: float = 16.0
@export var shake_decay_rate: float = 20.0

var start_pos: Vector2
var enemy_list: Array = []
var table_list: Array = []
var customer_list: Array = []
var pickup_list: Array = []
var bullet_list: Array = []
var noise_i: float = 0.0
var shake_strength: float = 0.0

@onready var enemy_class = preload("res://scenes/People/enemy.tscn")
@onready var table_class = preload("res://scenes/Decor/table.tscn")
@onready var customer_class = preload("res://scenes/People/customer.tscn")
@onready var pickup_class = preload("res://scenes/pickup.tscn")
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Player/Camera2D
@onready var noise = FastNoiseLite.new()
@onready var rand = RandomNumberGenerator.new()

func _ready():
	var screen_size = get_viewport_rect().size
	start_pos = Vector2(screen_size.x/2, screen_size.y/2)
	player.setup(start_pos)
	# Camera shake related
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 0.1
	
	setup_level()


func _process(delta: float):
	shake_camera(delta)

	if Input.is_action_just_pressed("spawn_customer"):
		spawn_customer()

	if Input.is_action_just_pressed("spawn_enemy"):
		spawn_enemy()
		
	if Input.is_action_just_pressed("spawn_pickup"):
		spawn_pickup()

func shake_camera(delta: float):
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	var shake_offset: Vector2
	shake_offset = get_noise_offset(delta, noise_shake_speed, shake_strength)
	# Shake by adjusting camera.offset, move the camera via it's position
	camera.offset = shake_offset

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)

func on_enemy_destroyed(enemy):
	shake_strength = noise_shake_strength
	enemy_list.erase(enemy)

func on_customer_destroyed(customer):
	customer_list.erase(customer)
	
func on_pickup_entered(pickup, itemID, quantity):
	player.add_to_inventory(itemID, quantity)
	pickup_list.erase(pickup)
	
func setup_level():
	pass

func spawn_customer():
	var claimedChair = get_tree().get_nodes_in_group('unclaimed_chairs').pick_random()
	if claimedChair:
		var newCustomer = customer_class.instantiate()
		var startingPosition = $Stage/Enterance.global_position
		newCustomer.set_position(startingPosition)
		newCustomer.setup(startingPosition, claimedChair)
		claimedChair.claim_chair(newCustomer) # Claim chair
		newCustomer.connect("customer_destroyed", on_customer_destroyed)
		add_child(newCustomer)
		customer_list.append(newCustomer)
	else:
		print("No more chairs, customer not spawned!")
	
func spawn_enemy():
	var enemy = enemy_class.instantiate()
	enemy.connect("enemy_destroyed", on_enemy_destroyed)
	var pos = Vector2(randf_range(100, 1000), randf_range(150, 500))
	enemy.setup(pos, player)
	get_tree().root.add_child(enemy)
	enemy_list.append(enemy)
	
func spawn_pickup():
	var newPickup = pickup_class.instantiate()
	var pos = Vector2(randf_range(100, 1000), randf_range(150, 500))
	newPickup.set_position(pos)
	newPickup.connect("pickup_entered", on_pickup_entered)
	add_child(newPickup)
	pickup_list.append(newPickup)
