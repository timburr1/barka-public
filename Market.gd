extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var player = $YSort/Player
var exit_flag = false

func _ready():	
	Sound.get_node("MarketMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Market/Market.tscn"

	$YSort/Javi/AnimatedSprite.playing = true
	$YSort/Dante/AnimatedSprite.playing = true
	$YSort/Ximena/AnimatedSprite.playing = true
	$YSort/Gabriela/AnimatedSprite.playing = true
	$YSort/Maya/AnimatedSprite.playing = true
	$YSort/Mariposa/AnimatedSprite.playing = true
	$YSort/Hugo/AnimatedSprite.playing = true
	$YSort/Tobi/AnimatedSprite.playing = true
	
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	if GameState.just_finished_clothing_minigame:
		player.position = GameState.player_position
		GameState.just_finished_clothing_minigame = false
		run_dialogue("finished_clothing_sorting_game")
	elif GameState.just_finished_grocery_minigame:
		player.position = GameState.player_position
		GameState.just_finished_grocery_minigame = false
		run_dialogue("finished_grocery_sorting_game")
	elif GameState.just_finished_pharmacy_minigame:
		player.position = GameState.player_position
		GameState.just_finished_pharmacy_minigame = false
		run_dialogue("finished_pharmacy_sorting_game")

func run_dialogue(dialogue_name:String) -> void:
	var dialog = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
	if DialogueManager.get_line(dialogue_name, dialog, []) != null:
		DialogueManager.show_example_dialogue_balloon(dialogue_name, dialog)
	else:
		var default = load("res://Dialogue//Default.tres")
		DialogueManager.show_example_dialogue_balloon(dialogue_name, default)
	
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if GameState.current_day == 9 and !GameState.end_day:
			var dialogue = load("res://Dialogue//9.tres")
			DialogueManager.show_example_dialogue_balloon("not_time_yet", dialogue)
		elif GameState.current_day == 9 and GameState.end_day:
			var dialogue = load("res://Dialogue//9.tres")
			DialogueManager.show_example_dialogue_balloon("leave_for_stadium", dialogue)
		elif !GameState.end_day:
			GameState.previous_screen = "res://World/Market/Market.tscn"
			GameState.current_screen = "res://World/WorldMap/WorldMap.tscn"
			transition.transition_to("res://World/WorldMap/WorldMap.tscn")
		else:
			var dialogue = load("res://Dialogue//" + str(GameState.current_day) + ".tres")		
			var temp = DialogueManager.get_line(END_DAY, dialogue, [])
			if temp != null:
				DialogueManager.show_example_dialogue_balloon(END_DAY, dialogue)
			else:
				var default = load("res://Dialogue//Default.tres")
				DialogueManager.show_example_dialogue_balloon(END_DAY, default)
	elif !exit.can_see_player():
		exit_flag = false

func _exit_tree():
	GameState.stop_music()
