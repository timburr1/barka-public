extends Control

onready var transition = $SceneTransition

func _ready():
	transition.visible = true

func _on_FlashcardGameButton_pressed():
	start_game("res://Minigames/FlashCards/FlashcardGameInstructions.tscn")

func _on_NumbersGameButton_pressed():
	start_game("res://Minigames/Numbers/NumbersGameInstructions.tscn")
	
func _on_SortingGameButton_pressed():
	start_game("res://Minigames/Sorting/SortingSubMenu.tscn")

func _on_SwimmingGameButton_pressed():	
	start_game("res://Minigames/Swimming/SwimmingGameInstructions.tscn")

func _on_KickoffGameButton_pressed():
	start_game("res://Minigames/Kickoff/KickoffInstructions.tscn")

func _on_SimonSaysGameButton_pressed():
	start_game("res://Minigames/SimonSays/SimonSaysInstructions.tscn")
		
func _on_BackButton_pressed():
	transition.transition_to("res://TitleMenu.tscn")

func start_game(path):
	Sound.get_node("TitleMusic").stop()
	GameState.practice_mode = true
	transition.transition_to(path)
