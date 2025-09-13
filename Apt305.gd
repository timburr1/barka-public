extends Node2D

onready var exit = $Exit
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")
onready var india = $YSort/India
var exit_flag = false

func _ready():
	transition.visible = true
	GameState.current_screen = "res://World/Apartment/305/Apt305.tscn"
	if !door_sound.playing:
		door_sound.play()
	$YSort/Lucas/AnimatedSprite.playing = true
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	
	print(GameState.current_day)
	print(GameState.current_day == 7)
	
	if GameState.current_day == 7 and (!GameState.found_india or !GameState.end_day):
		india.visible = false
	elif GameState.current_day < 7:
		$YSort/India/AnimatedSprite.animation = "IndiaIdle"
		$YSort/India/AnimatedSprite.playing = true
		india.visible = true
	else:
		$YSort/India/AnimatedSprite.animation = "IndiaPurpIdle"
		$YSort/India/AnimatedSprite.playing = true
		india.visible = true
		
func return_india() -> void:
	$YSort/India/AnimatedSprite.animation = "IndiaPurpIdle"
	$YSort/India/AnimatedSprite.playing = true
	india.visible = true
	
const END_DAY = "end_day"
func _process(_delta):	
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Apartment/305/Apt305.tscn"
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
		
