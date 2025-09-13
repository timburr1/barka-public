extends ColorRect

onready var scene_transition = $SceneTransition

func _ready():
	scene_transition.visible = true

func _on_YesButton_pressed():
	scene_transition.transition_to("res://CharacterCreation/NameAgeCountryMenu.tscn")

func _on_NoButton_pressed():
	scene_transition.transition_to("res://TitleMenu.tscn")
