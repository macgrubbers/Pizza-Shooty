extends StaticBody2D

@onready var chair = preload("res://scenes/Decor/chair.tscn")
@onready var chairPoints: Array =[$ChairPoint1,
								  $ChairPoint2,
								  $ChairPoint3,
								  $ChairPoint4]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_chairs()
	print("Table at: " + str(position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_chairs():
	for n in range(randi_range(1,4)):
		var newChair = chair.instantiate()
		newChair.position = chairPoints[n-1].global_position
		get_parent().add_child(newChair)
		get_parent().chair_list.append(newChair)
		print("new chair at: " + str(newChair.position))
