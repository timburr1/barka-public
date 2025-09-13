extends Node2D

var can_talk = false

func _process(_delta):
	if $PlayerDetectionZone.can_see_player():
		$QuestionBubble.visible = true
		can_talk = true
	else:
		$QuestionBubble.visible = false
		can_talk = false
		
func _on_ClickableArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !GameState.dialogue_active and !GameState.book_active:
			var ScoreOverlay = load("res://World/Apartment/303/HighScores.tscn")
			var score_overlay = ScoreOverlay.instance()
			get_tree().current_scene.get_node("YSort/Player/Camera2D").add_child(score_overlay)
			GameState.book_active = true
