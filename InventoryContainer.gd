extends Node2D

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	GameState.set_item(data.item_index, data.item)
