extends Area2D

@onready var pickupItemID = 001 # Pistol
@onready var quantity = 1

signal pickup_entered(itemID)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		pickup_entered.emit(self, pickupItemID, quantity)
		queue_free()
