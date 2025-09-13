extends Node2D

var clickable = false

onready var player = $AudioStreamPlayer

func _process(_delta):
	if $PlayerDetectionZone.can_see_player():
		$QuestionBubble.visible = true
		clickable = true
	else:
		$QuestionBubble.visible = false
		clickable = false
		
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and clickable:
			player.play()
