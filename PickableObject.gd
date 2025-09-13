extends Node2D

export(String) var item_name
var clickable = false

func _process(_delta):
	if $ClickableObject/PlayerDetectionZone.can_see_player():
		$ClickableObject/QuestionBubble.visible = true
		clickable = true
	else:
		$ClickableObject/QuestionBubble.visible = false
		clickable = false
		
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and $ClickableObject/QuestionBubble.visible:
			GameState.buy_item("Seashell", 1, 0)
			$AudioStreamPlayer.play()
			var _result = $AudioStreamPlayer.connect("finished", self, "queue_free")
