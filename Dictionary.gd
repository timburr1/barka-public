extends CanvasLayer

onready var list_container = $FileOverlay2/ScrollContainer/VBoxContainer
var dictionary = {}

func _ready():
	var file = File.new()
	var path 
	if GameState.current_day < 8:
		path = "res://UI/Dictionary/" + str(GameState.current_day) + ".json"
	else:
		path = "res://UI/Dictionary/8.json"
	if not file.file_exists(path):
		print("Could not load dictionary: " + path)
				
	file.open(path, file.READ)
	var text = file.get_as_text()
	dictionary = parse_json(text)
	file.close()	

func populate():
	for item in list_container.get_children():
		list_container.remove_child(item)
		item.queue_free()
	
	var dictionaryItem = preload("res://UI/Dictionary/DictionaryItem.tscn")
	var words = dictionary.keys()
	# words.sort()
	for word in words:		
		var this_item = dictionaryItem.instance()
		var definition = dictionary[word]
		if word.ends_with("?"):
			word = "¿" + word
		this_item.get_node("Label").text = word + " - " + definition
		list_container.add_child(this_item)

	list_container.rect_min_size.y = 10 + words.size() * 24
