extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 150
const FRICTION = 500

enum {
	MOVE, CHECK_PHONE, BLINK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var audio_stream_player = $AudioStreamPlayer
onready var sprite = $Sprite
onready var carlos = $Carlos
onready var carlos_sprite = $Carlos/AnimatedSprite

onready var camera = $Camera2D

onready var up_button = $Camera2D/HUD/ControlPad/UpButton
onready var down_button = $Camera2D/HUD/ControlPad/DownButton
onready var left_button = $Camera2D/HUD/ControlPad/LeftButton
onready var right_button = $Camera2D/HUD/ControlPad/RightButton

func _ready():
	randomize()
	sprite.texture = load(GameState.sprite_path)
	carlos_sprite.animation = "SitLeft"
	carlos_sprite.playing = true
	animation_tree.active = true
	update_love_meter()

func update_love_meter():
	$Camera2D/HUD/LoveMeter.rect_size.x = GameState.carlos_love * 3
	
func _physics_process(_delta):
	match state:
		MOVE: move()
		CHECK_PHONE: check_phone()
		BLINK: blink()
	
var facing_right = true

func move():
	if Input.is_action_just_pressed("menu1"):
		_on_TextureButton_pressed()
	elif Input.is_action_just_pressed("menu2"):
		_on_TextureButton2_pressed()
	elif Input.is_action_just_pressed("menu3"):
		_on_TextureButton3_pressed()
	elif Input.is_action_just_pressed("menu4"):
		_on_TextureButton4_pressed()
	elif Input.is_action_just_pressed("menu5"):
		_on_TextureButton5_pressed()
	elif Input.is_action_just_pressed("esc"):
		if GameState.menu_active:
			GameState.menu_active = false
			reset_menus()
		else: # launch options menu
			_on_TextureButton5_pressed()
			
	if GameState.menu_active or GameState.dialogue_active or GameState.book_active:
		animation_state.travel("Idle")
		audio_stream_player.stop()
		return
	
	var input_vector = Vector2.ZERO
	if up_button.pressed:
		input_vector.y = -1
	elif down_button.pressed:
		input_vector.y = 1
	elif left_button.pressed:
		input_vector.x = -1
	elif right_button.pressed:
		input_vector.x = 1
	else:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")		
		input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Walk")
		carlos_sprite.playing = true
		if !audio_stream_player.is_playing():
			audio_stream_player.play()
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		
		if input_vector.x < 0:
			facing_right = false
			carlos_sprite.animation = "WalkLeft"
		elif input_vector.x > 0:
			facing_right = true
			carlos_sprite.animation = "WalkRight"
		elif input_vector.y < 0:
			carlos_sprite.animation = "WalkUp"
		else:
			carlos_sprite.animation = "WalkDown"
			
		GameState.player_position = position
	else:
		animation_state.travel("Idle")
		if facing_right:
			carlos_sprite.animation = "SitRight"
		else:
			carlos_sprite.animation = "SitLeft"
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	velocity = move_and_slide(velocity)
	GameState.player_position = position
		
func check_phone():
	velocity = Vector2.ZERO
	animation_state.travel("CheckPhone")

func blink():
	velocity = Vector2.ZERO
	animation_state.travel("Blink")
	
func blink_animation_finished():
	state = MOVE
	
func _on_TextureButton_pressed():	
	if $Camera2D/HUD/FriendsMenu.visible:
		GameState.menu_active = false
		reset_menus()
	else:
		GameState.menu_active = true
		reset_menus()
		$Camera2D/HUD/FriendsMenu.populate()    
		$Camera2D/HUD/FriendsMenu.visible = true
		
func _on_TextureButton2_pressed():	
	if $Camera2D/HUD/Dictionary.visible:
		GameState.menu_active = false
		reset_menus()
	else:
		GameState.menu_active = true
		reset_menus()
		$Camera2D/HUD/Dictionary.populate()    
		$Camera2D/HUD/Dictionary.visible = true

func _on_TextureButton3_pressed():	
	if $Camera2D/HUD/Inventory.visible:
		GameState.menu_active = false
		reset_menus()
	else:
		GameState.menu_active = true
		reset_menus()  
		$Camera2D/HUD/Inventory._ready()
		$Camera2D/HUD/Inventory/FileOverlay3/ColorRect/CenterContainer/InventoryDisplay._ready()
		$Camera2D/HUD/Inventory.visible = true
		
func _on_TextureButton4_pressed():	
	if $Camera2D/HUD/QuestMenu.visible:
		GameState.menu_active = false
		reset_menus()
	else:
		GameState.menu_active = true
		reset_menus()   
		$Camera2D/HUD/QuestMenu.populate() 
		$Camera2D/HUD/QuestMenu.visible = true

func _on_TextureButton5_pressed():	
	if $Camera2D/HUD/GameMenu.visible:
		GameState.menu_active = false
		reset_menus()
	else:
		GameState.menu_active = true
		reset_menus()   
		$Camera2D/HUD/GameMenu.visible = true
		
func reset_menus():
	$Camera2D/HUD/FriendsMenu.visible = false
	$Camera2D/HUD/Dictionary.visible = false
	$Camera2D/HUD/Inventory.visible = false
	$Camera2D/HUD/QuestMenu.visible = false
	$Camera2D/HUD/GameMenu.visible = false

#func _on_UpButton_pressed():
#	Input.action_press("ui_up")
#
#func _on_DownButton_pressed():
#	Input.action_press("ui_down")
#
#func _on_LeftButton_pressed():
#	Input.action_press("ui_left")
#
#func _on_RightButton_pressed():
#	Input.action_press("ui_right")
