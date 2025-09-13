extends Node2D

var can_talk = false
export(String) var dialogue_name
export(String) var img_path
export(String) var title
export(String) var artist
export(String) var year

func _process(_delta):
	if $PlayerDetectionZone.can_see_player():
		$SpeechBubble.visible = true
		can_talk = true
	else:
		$SpeechBubble.visible = false
		can_talk = false
		
func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !GameState.dialogue_active and !GameState.book_active:
			var PaintingOverlay = load("res://World/Museum/PaintingOverlay.tscn")
			var painting_overlay = PaintingOverlay.instance()
			painting_overlay.get_node("Sprite").texture = load(img_path)
			painting_overlay.get_node("Sprite/Title").text = title
			painting_overlay.get_node("Sprite/ArtistYear").text = artist + ", " + year
			painting_overlay.dialogue_name = dialogue_name
			get_tree().current_scene.get_node("YSort/Player/Camera2D").add_child(painting_overlay)
			GameState.book_active = true
