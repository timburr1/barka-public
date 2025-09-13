extends Node2D

var clickable = false

func _ready() -> void:
	if GameState.found_lunchbox or GameState.finished_lunchbox_quest:
		queue_free()

func _process(_delta):
	if $ClickableObject/PlayerDetectionZone.can_see_player():
		$ClickableObject/QuestionBubble.visible = true
		clickable = true
	else:
		$ClickableObject/QuestionBubble.visible = false
		clickable = false
		
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and clickable:
			Sound.get_node("ItemPickupSFX").play()
			GameState.buy_item("LunchBox", 1, 0)
			GameState.found_lunchbox = true
			queue_free()
