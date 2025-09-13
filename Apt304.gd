extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")
var exit_flag = false

func _ready():
	transition.visible = true
	GameState.current_screen = "res://World/Apartment/304/Apt304.tscn"
#	Sound.get_node("ApartmentMusic").play()
	if !door_sound.playing:
		door_sound.play()
	$YSort/Lucia/AnimatedSprite.playing = true
	$YSort/Teo/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Apartment/304/Apt304.tscn"
			GameState.current_screen = "res://World/Apartment/Hallway/Hallway.tscn"
			transition.transition_to("res://World/Apartment/Hallway/Hallway.tscn")
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
