extends CanvasLayer

onready var red_button = $ColorButtons/RedButton
onready var orange_button = $ColorButtons/OrangeButton
onready var yellow_button = $ColorButtons/YellowButton
onready var green_button = $ColorButtons/GreenButton
onready var blue_button = $ColorButtons/BlueButton
onready var purple_button = $ColorButtons/PurpleButton
onready var pink_button = $ColorButtons/PinkButton
onready var grey_button = $ColorButtons/GreyButton

onready var jersey_button = $ItemButtons/JerseyButton
onready var seashell_button = $ItemButtons/SeashellButton
onready var yoyo_button = $ItemButtons/YoyoButton

onready var fountain = $Background/Fountain
onready var item_buttons = $ItemButtons
onready var sorry_label = $Label

var selected_color
var selected_item

func _ready():
	fountain.playing = true
	
	var count = 0
			
	if GameState.count_item("Jersey") > 0:
		jersey_button.visible = true
		count += 1
	else:
		jersey_button.visible = false
		
	if GameState.count_item("Seashell") > 0:
		seashell_button.visible = true
		count += 1
	else:
		seashell_button.visible = false
			
	if GameState.count_item("Yoyo") > 0:
		yoyo_button.visible = true
		count += 1
	else:
		yoyo_button.visible = false
				
	if count == 0:
		$ColorButtons.visible = false
		sorry_label.visible = true


const X_MIN = 140
const X_MAX = 860
const Y_MIN = 160
const Y_MAX = 250
	
func reset_item_buttons() -> void:
	jersey_button.pressed = false
	seashell_button.pressed = false
	yoyo_button.pressed = false
	
func reset_color_buttons() -> void:
	red_button.pressed = false
	orange_button.pressed = false
	yellow_button.pressed = false
	green_button.pressed = false
	blue_button.pressed = false
	purple_button.pressed = false
	pink_button.pressed = false
	grey_button.pressed = false

func _on_RedButton_pressed():
	selected_color = "Red"
	reset_color_buttons()
	red_button.pressed = true

func _on_OrangeButton_pressed():
	selected_color = "Orange"
	reset_color_buttons()
	orange_button.pressed = true

func _on_YellowButton_pressed():
	selected_color = "Yellow"
	reset_color_buttons()
	yellow_button.pressed = true

func _on_GreenButton_pressed():
	selected_color = "Green"
	reset_color_buttons()
	green_button.pressed = true

func _on_BlueButton_pressed():
	selected_color = "Blue"
	reset_color_buttons()
	blue_button.pressed = true
	
func _on_PurpleButton_pressed():
	selected_color = "Purple"
	reset_color_buttons()
	purple_button.pressed = true

func _on_PinkButton_pressed():
	selected_color = "Pink"
	reset_color_buttons()
	pink_button.pressed = true

func _on_GreyButton_pressed():
	selected_color = "Grey"
	reset_color_buttons()
	grey_button.pressed = true

func _on_DoneButton_pressed():
	GameState.menu_active = false
	queue_free()


func _on_YoyoButton_pressed():
	reset_item_buttons()
	yoyo_button.pressed = true
	selected_item = "Yoyo"

func _on_SeashellButton_pressed():
	reset_item_buttons()
	seashell_button.pressed = true
	selected_item = "Seashell"

func _on_JerseyButton_pressed():
	reset_item_buttons()
	jersey_button.pressed = true
	selected_item = "Jersey"

func _on_RunButton_pressed():
	Sound.get_node("MagicMallet").play()
	if selected_color != null and selected_item != null:
		for item in GameState.inventory:
			if item != null and item.item_name == selected_item:
				item.color = selected_color
				item.load_texture()
				GameState._fire_Steam_Achievement("FOUNTAIN")
				break
				
	if selected_color == "Yellow" and selected_item == "Jersey":
		GameState.found_yellow_jersey = true
	elif selected_item == "Jersey":
		GameState.found_yellow_jersey = false
