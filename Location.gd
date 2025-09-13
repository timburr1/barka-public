extends Node2D

class_name Location

###########################################
# Make sure to add a _ready() function that 
# updates GameScreen.current_screen	
###########################################

onready var player = $YSort/Player
onready var transition = $SceneTransition
onready var exit = $Exit

func leave():
	transition.transition_to("res://World/World Map.tscn")
	
