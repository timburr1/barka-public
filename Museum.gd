extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")

var exit_flag = false

func _ready():
	Sound.get_node("MuseumMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Museum/Museum.tscn"
	
	if GameState.just_finished_numbers_game:
		GameState.just_finished_numbers_game = false
		$YSort/Player.position = GameState.player_position
	elif !door_sound.playing:
		door_sound.play()
	
	$YSort/Alejandro/AnimatedSprite.playing = true
	$YSort/Alma/AnimatedSprite.playing = true
	$YSort/Bonita/AnimatedSprite.playing = true
	$YSort/Enzo/AnimatedSprite.playing = true
	$YSort/Ivan/AnimatedSprite.playing = true
	$YSort/SraGonzalez/AnimatedSprite.playing = true
	$YSort/Vega/AnimatedSprite.playing = true
	
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Museum/Museum.tscn"
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
