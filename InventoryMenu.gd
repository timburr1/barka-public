extends CanvasLayer

onready var money_label = $FileOverlay3/Money

func _ready():
	money_label.text = "€" + str(GameState.money)
