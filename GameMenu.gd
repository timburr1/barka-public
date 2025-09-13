extends CanvasLayer

onready var load_dialog = $LoadDialog
onready var save_dialog = $SaveDialog
onready var menu_background = $FileOverlay5

func _on_SaveButton_pressed() -> void:
	if OS.get_name() == "HTML5":
		var game_state = GameState.export_game_state()
		# print(game_state)
		JavaScript.download_buffer(game_state.to_utf8(), "save.json")
	else:
		menu_background.visible = false
		save_dialog.visible = true
		
func _on_LoadButton_pressed() -> void:
	# https://www.tangent-zero.com/files/HTML_File_Operations.pdf
	if OS.get_name() == "HTML5":
		var _ret # generic return value
		# use global context (true) adding a new JavaScript
		# global variable – fileData saves me creating a callback
		_ret = JavaScript.eval("var fileData = 'init var';", true)
		#print("Create global variable in JS: ", _ret)
		#ret = JavaScript.eval("fileData = 'This is a test.';", true)
		#print("Set fileData: ", _ret)
		# open file picker
		_ret = JavaScript.eval("load_file()", true)
		#print("pick_file returned: ", _ret)
		
		# give the user 30 seconds to pick the file or time out
		for _a in range(10):
			#add a wait
			var t = Timer.new()
			t.set_wait_time(3)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			
			_ret = JavaScript.eval("fileData;", true)
			if _ret == "init var":
				# keep on waiting or time out
				pass
			else:
				# stop the timer since it is not needed
				t.stop()
				# send the updated fileData to get displayed
				GameState.load_game(_ret)
				# resets my info label at the bottom of the page
				# GlobalVariables.InfoLabel = "default"
				# break out of the loop so we don't keep
				# reloading the map
				return
		# show a warning message after 30 seconds
		# GlobalVariables.InfoLabel = "Load Map timed out, please try again."
	else:
		menu_background.visible = false
		load_dialog.visible = true

func _on_QuitButton_pressed() -> void:
	GameState.change_scene("res://TitleMenu.tscn")

func _on_LoadDialog_file_selected(file_path) -> void:
	var file = File.new()
	if not file.file_exists(file_path):
		GameState.change_scene("res://NotFound.tscn")
		
	file.open(file_path, file.READ)
	var text = file.get_as_text()
	file.close()
	
	GameState.load_game(text)
	reset()
	
func _on_SaveDialog_file_selected(file_path) -> void:
	var file = File.new()
	var game_state = GameState.export_game_state()
	file.open(file_path, file.WRITE)
	file.store_line(game_state)
	file.close()	
	reset()

func _on_Dialog_tree_exited():
	reset()

func _on_Dialog_modal_closed():
	reset()

func reset() -> void:
	GameState.menu_active = false
	menu_background.visible = true
