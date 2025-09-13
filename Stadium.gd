extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
var exit_flag = false

func _ready():
	Sound.get_node("StadiumMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Stadium/Stadium.tscn"
	$YSort/Carmen/AnimatedSprite.playing = true
	$YSort/Chicharito/AnimatedSprite.playing = true
	$YSort/Enrique/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	if !GameState.has_visited_stadium:
		var dialogue = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
		DialogueManager.show_example_dialogue_balloon("stadium", dialogue)
		
	if GameState.current_day >= 9 and GameState.soccer_game_result != "":
		$YSort/Chicharito.visible = false
		var dialogue = load("res://Dialogue//9.tres")		
		DialogueManager.show_example_dialogue_balloon(END_DAY, dialogue)
	elif GameState.current_day >= 10:
		$YSort/Chicharito.visible = false
		
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Stadium/Stadium.tscn"
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
