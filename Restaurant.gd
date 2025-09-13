extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")
var exit_flag = false

func _ready():
	Sound.get_node("RestaurantMusic").play()
	transition.visible = true
	GameState.current_screen = "res://World/Restaurant/Restaurant.tscn"
	$YSort/Antonio/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	if GameState.current_day > 3:
		# TODO: more people?
		pass
		
	if !door_sound.playing:
		door_sound.play()

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
