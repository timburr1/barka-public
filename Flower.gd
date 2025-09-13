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
		if event.button_index == BUTTON_LEFT and event.pressed and clickable:
			Sound.get_node("ItemPickupSFX").play()
			GameState.buy_item("Flowers", 1, 0)
			
			if GameState.count_item("Flowers") >= 10 and !GameState.got_flowers:
				GameState.got_flowers = true
				var dialog = load("res://Dialogue//6.tres")
				DialogueManager.show_example_dialogue_balloon("found_flowers", dialog)
				
			queue_free()
