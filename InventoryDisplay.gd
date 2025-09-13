extends GridContainer

func _ready():
	#TODO: fix duplicate connections
	var _result = GameState.connect("items_changed", self, "_on_items_changed")
	GameState.make_items_unique()
	# print(GameState.inventory)
	update_inventory_display()

func update_inventory_display():
	for item_index in GameState.inventory.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventory_slot_display = get_child(item_index)
	var item = GameState.inventory[item_index]
	inventory_slot_display.display_item(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if GameState.drag_data is Dictionary:
			GameState.set_item(GameState.drag_data.item_index, GameState.drag_data.item)
