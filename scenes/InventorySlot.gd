extends Panel

@onready var is_empty = true
@onready var itemID: int = 0
@onready var count: int = 0
@onready var scenePath: String = ""
@onready var spritePath: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func give_item(newID: int, itemCount: int, newScene: String, newSprite: String):
	if itemID == newID and is_empty == false:
		count += itemCount
	else:
		itemID = newID
		count = itemCount
		scenePath = newScene
		spritePath = newSprite
		is_empty = false
		update_sprite()
		
func update_sprite():
	$Sprite2D.set_texture(load(spritePath))
