extends gun

@onready var itemID = 2
@onready var betweenShotsTimer: Timer
@onready var timeBetweenShots: float = 0.5
@onready var isBetweenShots: bool = false

var ammoPerReload = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	currentAmmo = 6
	maxAmmo = 6
	bullet_scene = preload("res://scenes/Projectiles/pellet.tscn")
	kickAmount = 500
	baseAccuracy = 0.85
	baseSpreadRate = 0.5
	bulletsPerShot = 12
	timeToReload = 0.5
	
	# If between shots
	betweenShotsTimer = Timer.new()
	betweenShotsTimer.set_one_shot(true)
	betweenShotsTimer.set_wait_time(timeBetweenShots)
	betweenShotsTimer.connect("timeout", _on_between_shots_timer_timeout)
	add_child(betweenShotsTimer)
	
	super()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func shoot():
	if (!isBetweenShots):
		super()
		isBetweenShots = true
		betweenShotsTimer.start()
	else:
		print("click!")

func _on_between_shots_timer_timeout():
	betweenShotsTimer.stop()
	isBetweenShots = false
	
func _on_reload_timer_timeout():
	if (currentAmmo != maxAmmo):
		currentAmmo += ammoPerReload
		reloadTimer.start()
	else:
		reloadTimer.stop()
	
