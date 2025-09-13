extends Node2D

export(String) var color = ""
var clickable = false

func _ready():
	$Sprite.texture = load("res://UI/InventoryItems/Seashell/" + color + ".png")

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
			Sound.get_node("ItemPickupSFX").play()
			GameState.buy_colored_item("Seashell", color, 1, 0)
			queue_free()
