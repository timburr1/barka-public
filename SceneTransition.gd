extends CanvasLayer

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

onready var animation_player = $ColorRect/AnimationPlayer

func _ready():
	# Plays the animation backward to fade in
	animation_player.play_backwards("Fade")
	
func blink() -> void:
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	
func transition_to(_next_scene := next_scene_path) -> void:
	# Plays the Fade animation and wait until it finishes
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
	var _result = get_tree().change_scene(_next_scene)

func next_day() -> void:
	animation_player = $ColorRect/AnimationPlayer
	animation_player.play("Fade")
	yield(animation_player, "animation_finished")
			
	Sound.get_node("RoosterSFX").play()
	
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")

	var _result = get_tree().change_scene("res://World/Apartment/303/Home.tscn")
