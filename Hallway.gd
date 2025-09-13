extends Node2D

onready var exit = $Exit
onready var player = $YSort/Player
onready var transition = $SceneTransition
onready var door_sound = Sound.get_node("DoorSound")

var exit_flag

func _ready():
	transition.visible = true
	if !Sound.get_node("ApartmentMusic").playing:
		Sound.get_node("ApartmentMusic").play()
		
	if !door_sound.playing:
		door_sound.play()
	GameState.current_screen = "res://World/Apartment/Hallway/Hallway.tscn"
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	exit_flag = false
	
	# move the player in front of whatever apt. they just left
	match GameState.previous_screen: 
		"res://World/Apartment/301/Apt301.tscn":
			player.position = Vector2(40, 80)
		"res://World/Apartment/302/Apt302.tscn":
			player.position = Vector2(296, 80)
		"res://World/Apartment/304/Apt304.tscn":
			player.position = Vector2(808, 80)
		"res://World/Apartment/305/Apt305.tscn":
			player.position = Vector2(1064, 80)
		"res://World/WorldMap/WorldMap.tscn":
			player.position = Vector2(0, 140)

const END_DAY = "end_day"
func _process(_delta):
	if $Door301/PlayerDetectionZone.can_see_player():
		GameState.current_screen = "res://World/Apartment/301/Apt301.tscn"
		GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
		transition.transition_to("res://World/Apartment/301/Apt301.tscn")
	elif $Door302/PlayerDetectionZone.can_see_player():
		GameState.current_screen = "res://World/Apartment/302/Apt302.tscn"
		GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
		transition.transition_to("res://World/Apartment/302/Apt302.tscn")
	elif $Door303/PlayerDetectionZone.can_see_player():
		if GameState.end_day:
			GameState.next_day()
		else:
			GameState.current_screen = "res://World/Apartment/303/Home.tscn"
			GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
			transition.transition_to("res://World/Apartment/303/Home.tscn")
	elif $Door304/PlayerDetectionZone.can_see_player():
		GameState.current_screen = "res://World/Apartment/304/Apt304.tscn"
		GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
		transition.transition_to("res://World/Apartment/304/Apt304.tscn")
	elif $Door305/PlayerDetectionZone.can_see_player():
		GameState.current_screen = "res://World/Apartment/305/Apt305.tscn"
		GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
		transition.transition_to("res://World/Apartment/305/Apt305.tscn")
	elif exit.can_see_player() and !exit_flag:
		exit_flag = true
		if GameState.count_friends() < 6:
			var dialog = load("res://Dialogue//1.tres")
			DialogueManager.show_example_dialogue_balloon("stop", dialog)
		elif !GameState.end_day:
			Sound.get_node("ApartmentMusic").stop()
			GameState.current_screen = "res://World/WorldMap/WorldMap.tscn"
			GameState.previous_screen = "res://World/Apartment/Hallway/Hallway.tscn"
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

