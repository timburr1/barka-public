extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var player = $YSort/Player
onready var door_sound = Sound.get_node("DoorSound")
var exit_flag = false

func _ready():
	transition.visible = true
	GameState.current_screen = "res://World/Apartment/301/Apt301.tscn"
	
	if !Sound.get_node("ApartmentMusic").playing:
		Sound.get_node("ApartmentMusic").play()
		
	if !door_sound.playing:
		door_sound.play()
	$YSort/Juan/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	if GameState.pancake_time:
		player.position = Vector2(420, 420)
		var dialog = load("res://Dialogue//6.tres")
		DialogueManager.show_example_dialogue_balloon("pancakes", dialog)
		
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Apartment/301/Apt301.tscn"
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
