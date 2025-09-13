extends CanvasLayer

func _ready():
	$HighScores/NameGameScore.text = "Name Game: " + str(GameState.high_scores["Flashcards"])
	$HighScores/NumberCruncherScore.text = "Number Cruncher: " + str(GameState.high_scores["Numbers"])
	$HighScores/SortingGameScore.text = "Sorting Scramble: " + str(GameState.high_scores["Sorting"])
	$HighScores/SwimmingGameScore.text = "Swim Time: " + str(GameState.high_scores["Swimming"])
	$HighScores/KickoffGameScore.text = "Kickoff: " + str(GameState.high_scores["Kickoff"])
	$HighScores/SimonSaysScore.text = "Simón Dice: " + str(GameState.high_scores["SimonSays"])

func _on_Button_pressed():
	GameState.book_active = false
	queue_free()
