extends Node2D

onready var transition = $SceneTransition
var exit_flag = false

func _ready():
	GameState.current_day = 9
	
	Sound.get_node("StadiumMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Stadium/SoccerGame.tscn"
	
	$YSort/Carmen/AnimatedSprite.playing = true
	$YSort/Chicharito/AnimatedSprite.playing = true
	$YSort/Enrique/AnimatedSprite.playing = true
	$YSort/Goalie/AnimatedSprite.playing = true
	$YSort/Pimienta/AnimatedSprite.playing = true
	$YSort/Lucia/AnimatedSprite.playing = true
	$YSort/Teo/AnimatedSprite.playing = true
	$YSort/Javi/AnimatedSprite.playing = true
	$YSort/Ximena/AnimatedSprite.playing = true
	$YSort/Vega/AnimatedSprite.playing = true
	$YSort/Pilar/AnimatedSprite.playing = true
	$YSort/Fiel/AnimatedSprite.playing = true
	$YSort/Angel/AnimatedSprite.playing = true
	
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	var dialogue = load("res://Dialogue//9.tres")
	DialogueManager.show_example_dialogue_balloon("first_half", dialogue)
		
func _exit_tree():
	GameState.stop_music()
