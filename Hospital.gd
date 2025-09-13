extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")
var exit_flag = false

func _ready():	
	Sound.get_node("HospitalMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Hospital/Hospital.tscn"
	$YSort/Aitana/AnimatedSprite.playing = true
	$YSort/Alvaro/AnimatedSprite.playing = true
	$YSort/Calista/AnimatedSprite.playing = true
	$YSort/HospitalSingles32X32200/Chicharito/AnimatedSprite.playing = true
	$YSort/Clara/AnimatedSprite.playing = true
	$YSort/Martin/AnimatedSprite.playing = true
	$YSort/Oscar/AnimatedSprite.playing = true
	$YSort/Silvia/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	if !door_sound.playing:
		door_sound.play()

const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Hospital/Hospital.tscn"
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
