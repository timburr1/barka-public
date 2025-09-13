extends Node2D

export(String) var item_name = ""
var clickable = false

onready var label_background = $MarginContainer
onready var label = $MarginContainer/CenterContainer/Label

func _process(_delta):
	if $PlayerDetectionZone.can_see_player() and !label_background.visible:
		$QuestionBubble.visible = true
		clickable = true
	else:
		$QuestionBubble.visible = false
		clickable = false
		
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and $QuestionBubble.visible:
			$QuestionBubble.visible = false
			label.text = item_name
			label_background.visible = true
