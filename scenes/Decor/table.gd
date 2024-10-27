class_name table
extends StaticBody2D

@onready var chair = preload("res://scenes/Decor/chair.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Table at: " + str(position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
