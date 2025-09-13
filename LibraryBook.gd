extends Node2D

var clickable = false

onready var player_detecation_zone = $ClickableObject/PlayerDetectionZone
onready var question_bubble = $ClickableObject/QuestionBubble

func _process(_delta):
	if player_detecation_zone.can_see_player():
		question_bubble.visible = true
		clickable = true
	else:
		question_bubble.visible = false
		clickable = false
			
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and question_bubble.visible:
			GameState.found_book = true
			Sound.get_node("ItemPickupSFX").play()
			GameState.buy_item("Book", 1, 0)
			queue_free()
