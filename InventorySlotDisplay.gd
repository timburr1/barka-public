extends CenterContainer

onready var item_texture_rect = $ItemTextureRect
onready var item_amount_label = $ItemTextureRect/ItemAmountLabel

func display_item(item):
	var amount_txt = ""
	if item is InventoryItem:
		item_texture_rect.texture = item.texture
		if item.amount > 1:
			amount_txt = str(item.amount)
		item_amount_label.text = amount_txt
	else:
		item_texture_rect.texture = load("res://UI/InventoryItems/EmptyInventorySlot.png")
		item_amount_label.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = GameState.remove_item_idx(item_index)
	if item is InventoryItem:
		var data = {}
		data.item = item
		data.item_index = item_index
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.texture
		drag_preview.rect_position = Vector2.ZERO
		GameState.drag_data = data
		set_drag_preview(drag_preview)
		# We need to make the drag_preview object a child of the 
		# root CanvasLayer, so that they are displayed in the 
		# correct order:
#		get_parent().get_parent().get_parent().remove_child(drag_preview)
#		get_parent().get_parent().get_parent().get_parent().get_parent().add_child(drag_preview)
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = GameState.inventory[my_item_index]
	if my_item is InventoryItem and my_item.item_name == data.item.item_name:
		my_item.amount += data.item.amount
		GameState.emit_signal("items_changed", [my_item_index])
	else:
		GameState.swap_items(my_item_index, data.item_index)
		GameState.set_item(my_item_index, data.item)
	GameState.drag_data = null
