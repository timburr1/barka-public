extends Location

var exit_flag = false

onready var Flower = preload("res://World/Park/Flower.tscn")

func _ready():	
	transition.visible = true
	GameState.current_screen = "res://World/Park/Park.tscn"

	$YSort/Axel/AnimatedSprite.playing = true
	$YSort/Angel/AnimatedSprite.playing = true
	$YSort/Pirata/AnimatedSprite.playing = true
	$YSort/Febrero/AnimatedSprite.playing = true
	$YSort/Zoe/AnimatedSprite.playing = true
	$YSort/Malik/AnimatedSprite.playing = true
	$YSort/Valeria/AnimatedSprite.playing = true
	$YSort/Federico/AnimatedSprite.playing = true
	$YSort/ModernExteriorsSinglesFountain32X322.playing = true
	
	$YSort/Player/AudioStreamPlayer.stream = load("res://Audio/SFX/Footsteps/Grass Running.wav")
	
	if GameState.current_day == 6:
		spawn_flowers()
	if GameState.current_day >= 6 and !GameState.found_book:
		$YSort/LibraryBook.visible = true
	
	Sound.get_node("ParkMusic").play()

const X_MIN = 32
const X_MAX = 1374
const Y_MIN = 134
const Y_MAX = 984

func spawn_flowers():
	for _i in range(0, 16):
		var this_flower = Flower.instance()
		var rand_x = X_MIN + randi() % (X_MAX - X_MIN)
		var rand_y = Y_MIN + randi() % (Y_MAX - Y_MIN)
		
		# don't spawn in the lake:
		while rand_x > 135 and rand_x < 527 and rand_y > 226 and rand_y < 696:
			rand_x = X_MIN + randi() % (X_MAX - X_MIN)
			rand_y = Y_MIN + randi() % (Y_MAX - Y_MIN)
			
		this_flower.position.x = rand_x
		this_flower.position.y = rand_y
		
		var die_roll = randi() % 3
		match die_roll:
			0: pass #default sprite
			1: this_flower.get_node("Sprite").texture = preload("res://World/Park/Flower2.png")
			2: this_flower.get_node("Sprite").texture = preload("res://World/Park/Flower3.png")
		
		get_node("YSort").add_child(this_flower)

const END_DAY = "end_day"
func _process(_delta):
	if exit.can_see_player() and !exit_flag:
		exit_flag = true
		if GameState.count_friends() < 13:
			var dialog = load("res://Dialogue//1.tres")
			DialogueManager.show_example_dialogue_balloon("stop", dialog)
		elif GameState.current_day == 9 and !GameState.end_day:
			var dialogue = load("res://Dialogue//9.tres")
			DialogueManager.show_example_dialogue_balloon("not_time_yet", dialogue)
		elif GameState.current_day == 9 and GameState.end_day:
			var dialogue = load("res://Dialogue//9.tres")
			DialogueManager.show_example_dialogue_balloon("leave_for_stadium", dialogue)
		elif GameState.end_day:
			var dialogue = load("res://Dialogue//" + str(GameState.current_day) + ".tres")		
			var temp = DialogueManager.get_line(END_DAY, dialogue, [])
			if temp != null:
				DialogueManager.show_example_dialogue_balloon(END_DAY, dialogue)
			else:
				var default = load("res://Dialogue//Default.tres")
				DialogueManager.show_example_dialogue_balloon(END_DAY, default)
		else:
			GameState.current_screen = "res://World/WorldMap/WorldMap.tscn"
			GameState.previous_screen = "res://World/Park/Park.tscn"
			transition.transition_to("res://World/WorldMap/WorldMap.tscn")
	elif !exit.can_see_player():
		exit_flag = false

func _exit_tree():
	GameState.stop_music()
