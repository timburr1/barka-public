extends Node

export(bool) var practice_mode = false

export(String) var current_screen = "res://World/Apartment/303/Home.tscn"
export(String) var previous_screen = "res://World/Apartment/303/Home.tscn"
export(Vector2) var player_position = Vector2(420, 69)

export(String) var player_name = "Pierre"
export(String) var sprite_path = "res://Player/Sprites/01.png"
export(String) var gender = "Male"
export(int) var age = 14
export(String) var home_country = "Estados Unidos"
export(String) var favorite_color = "Green"
export(String) var favorite_food = "French Fries"
export(String) var favorite_activity = "Caminando"

#TODO: TESTING ONLY
#export(Array, String) var friends = ["Ángel", "Carlos Segundo", "Febrero", 
#"Federico", "Juan", "Lucas", "Lucía", "Malik", "Mercedes", "Pirata", 
#"Teo", "Valeria", "Zoé"]
#export(Dictionary) var birthplace_map = { "Ángel": true, 
#"Carlos Segundo": true, "Febrero": true, "Federico": true, 
#"Juan": true, "Lucas": true, "Lucía": true, "Malik": true, 
#"Mercedes": true, "Pirata": true, "Teo": true, 
#"Valeria": true, "Zoé": true }

export(Array, String) var friends = []
export(Dictionary) var age_map = {}
export(Dictionary) var birthplace_map = {}
export(Dictionary) var fav_color_map = {}
export(Dictionary) var fav_food_map = {}
export var current_day = 1

const MIN_LOVE = 0
const MAX_LOVE = 100
export(int) var carlos_love = 75

export(bool) var day_started = false
export(bool) var played_grocery_minigame_today = false
export(bool) var just_finished_grocery_minigame = false
export(bool) var played_clothing_minigame_today = false
export(bool) var just_finished_clothing_minigame = false
export(bool) var played_pharmacy_minigame_today = false
export(bool) var just_finished_pharmacy_minigame = false
export(bool) var end_day = false

export(bool) var dialogue_active = false
export(bool) var menu_active = false
export(bool) var book_active = false

export(Array, String) var active_quests = []

func activate_quest(key:String) -> void:
	if active_quests.count(key) < 1:
		active_quests.append(key)

func deactivate_quest(key:String) -> void:
	if !active_quests.has(key):
		print("WARNING: List of active quests does not include " + key)
	active_quests.erase(key)
	get_tree().current_scene.get_node("YSort/Player/Camera2D/HUD/QuestMenu").populate()

export(bool) var finished_meatball_quest = false
export(bool) var has_visited_beach = false
export(bool) var bought_sunblock = false
export(bool) var delivered_sunblock = false
export(bool) var just_won_swimming_game = false
export(bool) var just_lost_swimming_game = false

export(bool) var started_painting_quest = false
export(bool) var finished_painting_quest = false
export(String) var poster_path = null
export(bool) var started_lunchbox_quest = false
export(bool) var found_lunchbox = false
export(bool) var finished_lunchbox_quest = false
export(bool) var just_finished_numbers_game = false
export(bool) var just_finished_coloring = false

export(bool) var pancake_time = false
export(bool) var got_flowers = false
export(bool) var finished_flower_quest = false
export(bool) var got_book_quest = false
export(bool) var found_book = false
export(bool) var finished_book_quest = false

export(bool) var india_missing = false
export(bool) var found_india = false

export(bool) var has_visited_stadium = false
export(bool) var got_red_jersey = false
export(bool) var found_yellow_jersey = false
export(Dictionary) var halftime_conversations = {}
export(String) var soccer_game_result = ""

export(bool) var started_nurse_quest = false
export(bool) var finished_nurse_quest = false
export(Dictionary) var patient_map = {}

export(bool) var finished_activity_quest = false
export(bool) var found_ham = false
export(bool) var finished_ham_quest = false

export(Dictionary) var high_scores = {
	"Flashcards": 0,
	"Sorting": 0,
	"Swimming": 0,
	"Numbers": 0,
	"Kickoff": 0,
	"SimonSays": 0
}

#################################################################
# INVENTORY
#################################################################
export(int) var money = 0
export(Array, Resource) var inventory = [
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null,
	null, null, null, null, null
]

var drag_data = null

signal items_changed(indexes)

func set_item(item_index:int, item):
	var previous_item = GameState.inventory[item_index]
	GameState.inventory[item_index] = item
	emit_signal("items_changed", [item_index])
	return previous_item
	
func swap_items(item_index:int, target_index:int) -> void:
	var item = GameState.inventory[item_index]
	var target = GameState.inventory[target_index]	
	GameState.inventory[target_index] = item
	GameState.inventory[item_index] = target	
	emit_signal("items_changed", [item_index, target_index])
	
func remove_item_idx(item_index:int):
	var previous_item = GameState.inventory[item_index]
	GameState.inventory[item_index] = null
	emit_signal("items_changed", [item_index])
	return previous_item

func make_items_unique() -> void:
	var unique_items = []
	for item in inventory:
		if item is InventoryItem:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	inventory = unique_items

func count_item(name:String) -> int:
	var sum = 0
	for item in inventory:
		if item is InventoryItem and item.item_name == name:
			sum += item.amount	
	return sum

# These helper functions seem dumb, but they are necessary b/c
# DialogueManager can't access the array methods directly.
func add_friend(name:String) -> void:
	friends.append(name)
	birthplace_map[name] = false
	fav_color_map[name] = false
	fav_food_map[name] = false
	
func friends_with(name:String) -> bool:
	return friends.find(name) >= 0

func count_friends() -> int:
	return friends.size()

func learned_age(name:String) -> void:
	age_map[name] = true
	
func learned_birthplace(name:String) -> void:
	birthplace_map[name] = true

func learned_fav_color(name:String) -> void:
	fav_color_map[name] = true
	
func learned_fav_food(name:String) -> void:
	fav_food_map[name] = true
		
func check_friends(scene:String) -> void:
	# let's not load the dialogue file unless we have to
	if friends.size() == 6 and scene == "Apartment": 
		var dialogue = load("res://Dialogue//1.tres")
		DialogueManager.show_example_dialogue_balloon("apartment_finished", dialogue)
	elif friends.size() == 13 and scene == "Park":
		var dialogue = load("res://Dialogue//1.tres")
		DialogueManager.show_example_dialogue_balloon("mission_accomplished", dialogue)

func add_halftime_conversation(name:String) -> void:
	halftime_conversations[name] = true
	
	if halftime_conversations.size() >= 5:
		var scene_transition = get_tree().get_current_scene().get_node("SceneTransition")
		if scene_transition == null:
			var SceneTransition = preload("res://SceneTransition.tscn")
			scene_transition = SceneTransition.instance()
		scene_transition.blink()
		
		var dialogue = load("res://Dialogue//9.tres")
		DialogueManager.show_example_dialogue_balloon("second_half", dialogue)		

func visited_patient(name:String) -> void:
	patient_map[name] = true
	
func check_patients() -> bool:
	return patient_map.size() >= 5

func change_scene(scene:String) -> void:
	stop_music()
	var scene_transition = get_tree().get_current_scene().get_node("SceneTransition")
	if scene_transition == null:
		var SceneTransition = preload("res://SceneTransition.tscn")
		scene_transition = SceneTransition.instance()
	
	scene_transition.transition_to(scene)
	
func next_day() -> void:
	var scene_transition = get_tree().get_current_scene().get_node("SceneTransition")
	if scene_transition == null:
		var SceneTransition = preload("res://SceneTransition.tscn")
		scene_transition = SceneTransition.instance()
	
	if current_day >= 10:
		_fire_Steam_Achievement("END")
		scene_transition.transition_to("res://GameOver.tscn")
		
	stop_music()	
	current_day += 1
	carlos_love -= 20
	played_grocery_minigame_today = false
	played_clothing_minigame_today = false
	played_pharmacy_minigame_today = false
	day_started = false
	end_day = false
	current_screen = "res://World/Apartment/303/Home.tscn"	
	#save_game()	
	scene_transition.next_day()
	
func modify_carlos_love(val:int) -> void:
	carlos_love += val
	carlos_love = min(carlos_love, 100)
	carlos_love = max(carlos_love, 0)
	
	get_tree().get_current_scene().get_node("YSort/Player").update_love_meter()
	
func launch_book(path:String) -> void:
	var BookOverlay = load("res://Books/BookOverlay.tscn")
	var book_overlay = BookOverlay.instance()
	book_overlay.load_book(path)
	book_overlay.connect("tree_exited", self, "finished_reading")	
	get_tree().current_scene.get_node("YSort/Player/Camera2D").add_child(book_overlay)
	book_active = true

func finished_reading() -> void:
	book_active = false
	var dialog = load("res://Dialogue//" + str(current_day) + ".tres")
	DialogueManager.show_example_dialogue_balloon("book_finished", dialog)

func launch_coloring_menu() -> void:
	var ColoringMenuOverlay = load("res://World/Fountain/ColoringMenu.tscn")
	var coloring_menu_overlay = ColoringMenuOverlay.instance()
	get_tree().current_scene.get_node("YSort/Player/Camera2D").add_child(coloring_menu_overlay)
	menu_active = true
	
#TODO: merge these functions
func buy_item(item_name:String, amount:int, total_cost:int) -> void:	
	money -= total_cost
	var null_idx
	# if the item already exists, increase amount and return
	for i in range(inventory.size()):
		if inventory[i] is InventoryItem and inventory[i].item_name == item_name:
			inventory[i].amount += amount
			return
		elif inventory[i] == null and null_idx == null:
			null_idx = i
	# otherwise, create a new entry
	var item = load("res://UI/InventoryItems/" + item_name + ".tres")
	item.amount = amount
	inventory[null_idx] = item

func buy_colored_item(item_name:String, color:String, amount:int, total_cost:int) -> void:	
	money -= total_cost
	var null_idx
	# if the item already exists, increase amount and return
	for i in range(inventory.size()):
		if inventory[i] is ColorableItem and inventory[i].item_name == item_name: # and inventory[i].color == color:
			inventory[i].amount += amount
			return
		elif inventory[i] == null and null_idx == null:
			null_idx = i
	# otherwise, create a new entry
	var item = load("res://UI/InventoryItems/" + item_name + "/" + item_name + ".tres")
	item.item_name = item_name
	item.color = color
	item.amount = amount
	item.texture = load("res://UI/InventoryItems/" + item_name + "/" + color + ".png")
	inventory[null_idx] = item

func remove_item(item_name:String, amount:int=-1) -> void:
	for i in range(inventory.size()):
		if inventory[i] is InventoryItem and inventory[i].item_name == item_name:
			if amount < 0 or amount - inventory[i].amount <= 0:
				inventory[i] = null
			else:
				inventory[i].amount -= amount
				
func play_sound(node_name:String, stop_music:bool=false) -> void:
	if stop_music:
		stop_music()
	Sound.get_node(node_name).play()

func stop_music() -> void:
	Sound.get_node("TitleMusic").stop()
	Sound.get_node("ApartmentMusic").stop()
	Sound.get_node("BeachMusic").stop()
	Sound.get_node("FountainMusic").stop()
	Sound.get_node("HospitalMusic").stop()
	Sound.get_node("LibraryMusic").stop()
	Sound.get_node("MarketMusic").stop()
	Sound.get_node("MuseumMusic").stop()	
	Sound.get_node("ParkMusic").stop()
	Sound.get_node("RestaurantMusic").stop()
	Sound.get_node("StadiumMusic").stop()
	
	Sound.get_node("Mozart").stop()
	Sound.get_node("FunkShowSong").stop()
	Sound.get_node("NextEpisodeSong").stop()
	Sound.get_node("SalsaCalienteSong").stop()
	Sound.get_node("StompRockSong").stop()
		
	Sound.get_node("FlashcardGameMusic").stop()
	Sound.get_node("NumbersGameMusic").stop()	
	Sound.get_node("SimonSaysGameMusic").stop()
	Sound.get_node("SortingGameMusic").stop()	
	Sound.get_node("SwimmingGameMusic").stop()
	
func show_arrow() -> void:
	var arrow:AnimatedSprite = get_tree().current_scene.get_node("ExitArrow")
	arrow.visible = true
	arrow.playing = true

func pickup_india() -> void:
	get_tree().current_scene.remove_india()
	buy_item("India", 1, 0)
	found_india = true
	
func return_india() -> void:
	get_tree().current_scene.return_india()
	remove_item("India")
	deactivate_quest("india_for_lucas")
	modify_carlos_love(5)
	end_day = true
	india_missing = false
	
func load_game(text:String) -> void:
	var data = parse_json(text)
	
	practice_mode = false
	player_name = data.player_name
	sprite_path = data.sprite_path
	gender = data.gender
	age = data.age
	friends = data.friends
	age_map = data.age_map
	birthplace_map = data.birthplace_map
	fav_color_map = data.fav_color_map
	fav_food_map = data.fav_food_map
	
	home_country = data.home_country
	current_day = data.current_day
	current_screen = data.current_screen
	carlos_love = data.carlos_love
	active_quests = data.active_quests
	day_started = data.day_started
	end_day = data.end_day
	
	played_grocery_minigame_today = data.played_grocery_minigame_today
	just_finished_grocery_minigame = data.just_finished_grocery_minigame
	played_clothing_minigame_today = data.played_clothing_minigame_today
	just_finished_clothing_minigame = data.just_finished_clothing_minigame
	played_pharmacy_minigame_today = data.played_pharmacy_minigame_today
	just_finished_pharmacy_minigame = data.just_finished_pharmacy_minigame
	just_finished_coloring = data.just_finished_coloring
	
	finished_meatball_quest = data.finished_meatball_quest
	has_visited_beach = data.has_visited_beach
	bought_sunblock = data.bought_sunblock
	delivered_sunblock = data.delivered_sunblock
	just_won_swimming_game = data.just_won_swimming_game
	just_lost_swimming_game = data.just_lost_swimming_game
	started_painting_quest = data.started_painting_quest
	finished_painting_quest = data.finished_painting_quest
	poster_path = data.poster_path
	started_lunchbox_quest = data.started_lunchbox_quest
	found_lunchbox = data.found_lunchbox
	finished_lunchbox_quest = data.finished_lunchbox_quest
	got_flowers = data.got_flowers
	finished_flower_quest = data.finished_flower_quest
	got_book_quest = data.got_book_quest
	found_book = data.found_book
	finished_book_quest = data.finished_book_quest
	india_missing = data.india_missing
	found_india = data.found_india
	has_visited_stadium = data.has_visited_stadium
	got_red_jersey = data.got_red_jersey
	found_yellow_jersey = data.found_yellow_jersey
	halftime_conversations = data.halftime_conversations
	soccer_game_result = data.soccer_game_result
	started_nurse_quest = data.started_nurse_quest
	finished_nurse_quest = data.finished_nurse_quest
	patient_map = data.patient_map
	finished_activity_quest = data.finished_activity_quest
	found_ham = data.found_ham
	finished_ham_quest = data.finished_ham_quest

	high_scores = data.high_scores
	money = data.money
	parse_inventory(data.inventory)
	
	dialogue_active = false
	menu_active = false
	book_active = false

	change_scene(current_screen)

func inventory_to_string() -> String:
	var result = "{"
	var count = 0
	for i in inventory:
		if i is ColorableItem and i.item_name != null and i.item_name != "":
			result += "\"" + i.item_name + "\": [\"" + i.color + "\", " + str(i.amount) + "],"
			count += 1
		elif i is InventoryItem and i.item_name != null and i.item_name != "":
			result += "\"" + i.item_name + "\": " + str(i.amount) + ","
			count += 1
			
	if count == 0:
		return "{}"
		
	# get rid of the last comma, then close the bracket 
	return result.substr(0, result.length()-1) + "}"

func parse_inventory(json:String) -> void:	
	# reset inventory
	inventory = [null, null, null, null, null, 
	null, null, null, null, null,
	null, null, null, null, null, 
	null, null, null, null, null]
	
	var inventory_map = parse_json(json)
	for item in inventory_map.keys():
		if inventory_map[item] is Array:
			buy_colored_item(item, inventory_map[item][0], inventory_map[item][1], 0)
		else:
			buy_item(item, inventory_map[item], 0)

func export_game_state() -> String:
	var data = {
		"practice_mode": practice_mode,
		
		"player_name": player_name,
		"sprite_path": sprite_path,
		"gender": gender,
		"age": age,
		"friends": friends,
		"age_map": age_map,
		"birthplace_map": birthplace_map,
		"fav_color_map": fav_color_map,
		"fav_food_map": fav_food_map,
		"home_country": home_country,
		"current_day": current_day,
		"current_screen": current_screen,
		"carlos_love": carlos_love,
		"active_quests": active_quests,		
		"day_started": day_started,
		"end_day": end_day,
		
		"played_grocery_minigame_today": played_grocery_minigame_today,
		"just_finished_grocery_minigame": just_finished_grocery_minigame,
		"played_clothing_minigame_today": played_clothing_minigame_today,
		"just_finished_clothing_minigame": just_finished_clothing_minigame,
		"played_pharmacy_minigame_today": played_pharmacy_minigame_today,
		"just_finished_pharmacy_minigame": just_finished_pharmacy_minigame,
		"just_finished_coloring": just_finished_coloring,
		
		"finished_meatball_quest": finished_meatball_quest,
		"has_visited_beach": has_visited_beach,
		"bought_sunblock": bought_sunblock,
		"delivered_sunblock": delivered_sunblock,
		"just_won_swimming_game": just_won_swimming_game,
		"just_lost_swimming_game": just_lost_swimming_game,
		"started_painting_quest": started_painting_quest,
		"finished_painting_quest": finished_painting_quest,
		"poster_path": poster_path,
		"started_lunchbox_quest": started_lunchbox_quest,
		"found_lunchbox": found_lunchbox,
		"finished_lunchbox_quest": finished_lunchbox_quest,
		"got_flowers": got_flowers,
		"finished_flower_quest": finished_flower_quest,
		"got_book_quest": got_book_quest,
		"found_book": found_book,
		"finished_book_quest": finished_book_quest,
		"india_missing": india_missing,
		"found_india": found_india,
		"has_visited_stadium": has_visited_stadium,
		"got_red_jersey": got_red_jersey,
		"found_yellow_jersey": found_yellow_jersey,
		"halftime_conversations": halftime_conversations,
		"soccer_game_result": soccer_game_result,
		"started_nurse_quest": started_nurse_quest,
		"finished_nurse_quest": finished_nurse_quest,
		"patient_map": patient_map,
		"finished_activity_quest": finished_activity_quest,
		"found_ham": found_ham,
		"finished_ham_quest":finished_ham_quest,
		
		"high_scores": high_scores,
		"money": money, 
		"inventory": inventory_to_string()
	}
	
	return to_json(data)
		
func _fire_Steam_Achievement(_value: String) -> void:
	pass

