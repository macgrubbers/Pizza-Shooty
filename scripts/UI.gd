extends Control

@onready var player = get_parent().get_parent().get_node("Player3d")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	$AmmoLabel.text = "Ammo: "
	if player:
		var maxAmmo = player.get_node("Gun3D").max_ammo
		var currentAmmo = player.get_node("Gun3D").current_ammo
		$AmmoLabel.text += str(currentAmmo) + " / " + str(maxAmmo)
