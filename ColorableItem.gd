extends InventoryItem

class_name ColorableItem

export(String) var color = ""

func _ready():
	load_texture()

func load_texture() -> void:
	texture = load("res://UI/InventoryItems/" + item_name + "/" + color + ".png")
