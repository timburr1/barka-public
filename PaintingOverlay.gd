extends Control

export(String) var dialogue_name

var counter = 0

func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if counter == 0:
			GameState.book_active = false
			var dialog
			if dialogue_name == "fountain" and GameState.current_day == 7:
				dialog = load("res://Dialogue//7.tres")
			else:
				dialog = load("res://Dialogue//Default.tres")
			DialogueManager.show_example_dialogue_balloon(dialogue_name, dialog)
			counter += 1
		else:
			queue_free()
