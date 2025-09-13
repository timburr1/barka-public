extends CanvasLayer

var quests

onready var list_container = $FileOverlay4/ScrollContainer/VBoxContainer

func _ready():
	var file = File.new()
	var path = "res://UI/QuestMenu/Quests.json"
	if not file.file_exists(path):
		print("Could not load quests from file: " + path)
				
	file.open(path, file.READ)
	var text = file.get_as_text()
	quests = parse_json(text)
	file.close()	
	

func populate():
	# clear list
	for item in list_container.get_children():
		list_container.remove_child(item)
		item.queue_free()
	
	var QuestContainer = preload("res://UI/QuestMenu/QuestContainer.tscn")
	
	for key in GameState.active_quests:
		var value = quests[key]
		var quest_container = QuestContainer.instance()
		quest_container.get_node("Portrait").texture = load(value.sprite_path)
		quest_container.get_node("Description").text = value.reminder_text
		
		list_container.add_child(quest_container)
	
	list_container.rect_min_size.y = 50 + GameState.active_quests.size() * 140
