extends Control

onready var transition = $SceneTransition

func _ready():
	transition.visible = true
	
	# enable buttons for visited locations:
	if GameState.current_day > 1:
		$Library.disabled = false
	if GameState.current_day > 2:
		$Restaurant.disabled = false
		$Market.disabled = false
	if GameState.current_day > 3:
		$Beach.disabled = false
	if GameState.current_day > 4:
		$Museum.disabled = false
	if GameState.current_day > 6:
		$Fountain.disabled = false
	if GameState.current_day > 7:
		$Stadium.disabled = false
	if GameState.current_day > 9:
		$Hospital.disabled = false
		
func _on_Apartment_pressed():
	fast_travel("res://World/Apartment/Hallway/Hallway.tscn")

func _on_Park_pressed():
	fast_travel("res://World/Park/Park.tscn")

func _on_Library_pressed():
	fast_travel("res://World/Library/Library.tscn")

func _on_Market_pressed():
	fast_travel("res://World/Market/Market.tscn")

func _on_Restaurant_pressed():
	fast_travel("res://World/Restaurant/Restaurant.tscn")

func _on_Beach_pressed():
	fast_travel("res://World/Beach/Beach.tscn")

func _on_Museum_pressed():
	fast_travel("res://World/Museum/Museum.tscn")
	
func _on_Fountain_pressed():
	fast_travel("res://World/Fountain/Fountain.tscn")

func _on_Stadium_pressed():
	fast_travel("res://World/Stadium/Stadium.tscn")

func _on_Church_pressed():
	fast_travel("res://World/Church/Church.tscn")

func _on_Hospital_pressed():
	fast_travel("res://World/Hospital/Hospital.tscn")
	
func fast_travel(scene):
	GameState.previous_screen = "res://World/WorldMap/WorldMap.tscn"
	GameState.current_screen = scene
	transition.transition_to(scene)
