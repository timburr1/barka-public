extends Node2D

onready var museum_exit = $MuseumExits
onready var outside_exit = $OutsideExit
onready var player = $YSort/Player
onready var transition = $SceneTransition
onready var fountain_sprite = $YSort/MagicFountain32X32Frame26

var exit_flag = false

func _ready():	
	transition.visible = true
	GameState.current_screen = "res://World/Fountain/Fountain.tscn"
	Sound.get_node("FountainMusic").play()
	
	if GameState.just_finished_coloring:
		GameState.just_finished_coloring = false
		var dialogue_name = "after_fountain"		
		var dialog = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
		if DialogueManager.get_line(dialogue_name, dialog, []) != null:
			DialogueManager.show_example_dialogue_balloon(dialogue_name, dialog)
		else:
			var default = load("res://Dialogue//Default.tres")
			DialogueManager.show_example_dialogue_balloon(dialogue_name, default)
	
	if GameState.current_day == 7 and !GameState.found_india:
		$YSort/India/AnimatedSprite.playing = true
	else:
		$YSort/India.visible = false
		
	fountain_sprite.playing = true

func _process(_delta):	
	if museum_exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Fountain/Fountain.tscn"
			GameState.current_screen = "res://World/Museum/Museum.tscn"
			transition.transition_to("res://World/Museum/Museum.tscn")
		else:
			end_day()
	elif outside_exit.can_see_player() and !exit_flag:
		exit_flag = true
		if !GameState.end_day:
			GameState.previous_screen = "res://World/Fountain/Fountain.tscn"
			GameState.current_screen = "res://World/WorldMap/WorldMap.tscn"
			transition.transition_to("res://World/WorldMap/WorldMap.tscn")
		else:
			end_day()
	elif !museum_exit.can_see_player() and !museum_exit.can_see_player():
		exit_flag = false
		
const END_DAY = "end_day"
func end_day():
	var dialogue = load("res://Dialogue//" + str(GameState.current_day) + ".tres")		
	var temp = DialogueManager.get_line(END_DAY, dialogue, [])
	if temp != null:
		DialogueManager.show_example_dialogue_balloon(END_DAY, dialogue)
	else:
		var default = load("res://Dialogue//Default.tres")
		DialogueManager.show_example_dialogue_balloon(END_DAY, default)
				
func _exit_tree():
	GameState.stop_music()
	
func _on_Fountain_start_animation_finished() -> void:
	fountain_sprite.animation = "maintain"

func remove_india() -> void:
	$YSort/India.visible = false
