extends Control

onready var transition = $SceneTransition

func _ready() -> void:
	transition.visible = true

func _on_Button_pressed():
	transition.transition_to("res://TitleMenu.tscn")
