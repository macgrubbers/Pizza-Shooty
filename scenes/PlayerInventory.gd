extends Control

@onready var inventoryArray: Array = [$ColorRect/GridContainer/InventorySlot01, 
									  $ColorRect/GridContainer/InventorySlot02, 
									  $ColorRect/GridContainer/InventorySlot03,
									  $ColorRect/GridContainer/InventorySlot04, 
									  $ColorRect/GridContainer/InventorySlot05]
@onready var inventorySize = 10

#		dict = { key: [scene_path, can_stack]}
@onready var itemDictionary = {1: ["res://scenes/Weapons/pistol.tcsn", false, "res://assets/pistol01.png"],
							   2: ["res://scenes/Weapons/shotgun.tcsn", false, "res://assets/shotgun01.png"]}

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_item(newItem: Vector2i):
	
	# Check if item is in database
	var newItemID = newItem[0]
	var dictionaryEntry = itemDictionary.get(newItemID)
	
	if (dictionaryEntry == null):
		print("ERROR: ItemID " + str(newItemID) + " not found in databse!")
		return
		
	# Check if there's space
	var newSlot = get_next_available_slot(dictionaryEntry[1])
	if ( newSlot != -1):
		inventoryArray[newSlot].give_item(newItem[0], newItem[1], dictionaryEntry[0], dictionaryEntry[2])
	else:
		print("No free slot in backpack!!!")
		

# Add an amount to an existing item in inventory
# Assumes item can be stacked
func stack_item(index,addAmount):
	var oldItem = inventoryArray[index]
	var newItemAmount = Vector2(oldItem[0], oldItem[1] + addAmount)
	inventoryArray[index] = newItemAmount

# Returns the index of the closest available slot
func get_next_available_slot(stackable: bool) -> int:
	var returnIndex = -1
	
	# First, search for empty spots
	for slotIndex in range(inventoryArray.size(),0,-1):
		if ( inventoryArray[slotIndex-1].is_empty ):
			returnIndex = slotIndex-1
	
	# TODO: Search for stackable slots
	if stackable: # and slotID == itemID
		pass
		
	return returnIndex
