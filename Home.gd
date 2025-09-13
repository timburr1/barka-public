extends Node2D

onready var door_sound = Sound.get_node("DoorSound")
onready var knock_sound = Sound.get_node("Knock")

onready var exit = $Exit
onready var player = $YSort/Player
onready var timer = $Timer
onready var transition = $SceneTransition

var exit_active = false

func _ready():	
	transition.visible = true
	GameState.current_screen = "res://World/Apartment/303/Home.tscn"
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Concrete 2.wav")
	Sound.get_node("ApartmentMusic").play()
	
	if !GameState.friends_with("Carlos Segundo"):
		$YSort/Player/Carlos/Shadow.visible = false
		$YSort/Player/Carlos/AnimatedSprite.visible = false
		$YSort/Player/Camera2D/HUD.visible = false		
		player.position = Vector2( 420, 269 )
		timer.start(11)
		timer.connect("timeout", self, "knock")
	elif !GameState.day_started:
		player.position = Vector2( 420, 269 )
		timer.start(3)
		timer.connect("timeout", self, "start_day")
	else:
		$YSort/Juan.visible = false
		$YSort/Lucas.visible = false
		exit_active = true
		if !door_sound.playing:
			door_sound.play()
	
	if GameState.poster_path != null and GameState.poster_path != "":
		$YSort/Poster.texture = load(GameState.poster_path)
	
func start_day():
	timer.disconnect("timeout", self, "start_day")
	
#	if GameState.current_day == 6:
#		$YSort/Juan.visible = true
#		$YSort/Juan/AnimatedSprite.playing = true
#	elif GameState.current_day == 7:
#		$YSort/Lucas.visible = true
#		$YSort/Lucas/AnimatedSprite.playing = true
		
	var dialogue = load("res://Dialogue//" + str(GameState.current_day) + ".tres")
	DialogueManager.show_example_dialogue_balloon("start", dialogue)
	exit_active = true
	
func knock():
	timer.disconnect("timeout", self, "knock")
	
	Sound.get_node("ApartmentMusic").stop()
	
	knock_sound.play()
	
	player.blink()
	
	timer.start(2.0)
	timer.connect("timeout", self, "meet_carlos")

func meet_carlos():
	timer.disconnect("timeout", self, "meet_carlos")
	
	var dialogue = load("res://Dialogue//1.tres")
	DialogueManager.show_example_dialogue_balloon("start", dialogue)
	exit_active = true

func activate_hud():
	$YSort/Player/Carlos/Shadow.visible = true
	$YSort/Player/Carlos/AnimatedSprite.visible = true
	$YSort/Player/Camera2D/HUD.visible = true

func _process(_delta):	
	if exit_active and exit.can_see_player():
		GameState.current_screen = "res://World/Apartment/Hallway/Hallway.tscn"
		GameState.previous_screen = "res://World/Apartment/303/Home.tscn"
		transition.transition_to("res://World/Apartment/Hallway/Hallway.tscn")

func _exit_tree():
#	Sound.get_node("ApartmentMusic").stop()
	$ExitArrow.queue_free()
	# make sure we aren't leaving w/ the trophy case still active
	GameState.book_active = false
