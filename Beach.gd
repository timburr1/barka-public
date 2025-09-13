extends Node2D

onready var exit = $Exit
onready var player = $YSort/Player
onready var transition = $SceneTransition
onready var Seashell = preload("res://World/Beach/Seashell.tscn")

var exit_flag = false

func _ready():
	transition.visible = true
	GameState.current_screen = "res://World/Beach/Beach.tscn"
		
	$YSort/Livia/AnimatedSprite.playing = true
	$YSort/Mosquito/AnimatedSprite.playing = true
	$YSort/Rafa/AnimatedSprite.playing = true
	$Claudio/AnimatedSprite.playing = true
	$YSort/Pilar/AnimatedSprite.playing = true
	$YSort/Fiel/AnimatedSprite.playing = true
	$YSort/Marisol/AnimatedSprite.playing = true

	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Sand.wav")
	Sound.get_node("BeachMusic").play()
	place_seashells()

	if !GameState.has_visited_beach:
		GameState.has_visited_beach = true
		var dialog = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
		DialogueManager.show_example_dialogue_balloon("playa", dialog)
	
	if GameState.just_won_swimming_game:
		player.position = GameState.player_position
		GameState.just_won_swimming_game = false
		var dialog = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
		DialogueManager.show_example_dialogue_balloon("won_swimming_game", dialog)
	elif GameState.just_lost_swimming_game:
		player.position = GameState.player_position
		GameState.just_lost_swimming_game = false
		var dialog = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
		DialogueManager.show_example_dialogue_balloon("lost_swimming_game", dialog)
	
		
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
			GameState.previous_screen = "res://World/Beach/Beach.tscn"
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

const colors = ["Black", "Blue", "Brown", "Green", "Grey", 
"Orange", "Pink", "Purple", "Red", "White", "Yellow"]
func random_color() -> String:
	var idx = randi() % len(colors)
	return colors[idx]
	
func place_seashells():
	for _i in range(0, 16):
		var seashell = Seashell.instance()
		seashell.position.x = 100 + randi() % 1400
		seashell.position.y = 50 + randi() % 600
		seashell.color = random_color()
		
		get_node("YSort").add_child(seashell)
