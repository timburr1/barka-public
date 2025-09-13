extends CanvasLayer

const npc_map = {
	"Carlos Segundo": {
		"home": "Barkelona, España",
		"age": 2,
		"color": "Rojo",
		"food": "Albóndigas"
	},
	"Juan": {
		"home": "México",
		"age": 55,
		"color": "",
		"food": "Tamales"
	},
	"Mercedes": {
		"home": "Barkelona, España",
		"age": 78,
		"color": "Morado",
		"food": "Pan"
	},
	"Lucía": {
		"home": "Madrid, España",
		"age": 21,
		"color": "Verde",
		"food": "Pescado"
	},
	"Teo": {
		"home": "Madrid, España",
		"age": 21,
		"color": "Verde",
		"food": "Pescado"
	},
	"Lucas": {
		"home": "Estados Unidos de America",
		"age": 25,
		"color": "Amarillo",
		"food": "Huevos"
	},
	"Pirata": {
		"home": "Valencia, España",
		"age": 3,
		"color": "Blanco",
		"food": "Albóndigas"
	},
	"Ángel": {
		"home": "Canadá",
		"age": 8,
		"color": "Azul",
		"food": "Lechuga"
	},	
	"Febrero": {
		"home": "Burgos, España",
		"age": 5,
		"color": "Rosado",
		"food": "Queso"
	},
	"Zoé": {
		"home": "Perú",
		"age": 9,
		"color": "Anaranjado",
		"food": "Panqueques"
	},
	"Axel": {
		"home": "Alemania",
		"age": 4,
		"color": "Negro",
		"food": "Carne"
	},
	"Malik": {
		"home": "Pakistán",
		"age": 32,
		"color": "Gris",
		"food": "Pollo"
	},
	"Valeria": {
		"home": "Argentina",
		"age": 24,
		"color": "Rosado",
		"food": "Tofu"
	},
	"Federico": {
		"home": "Argentina",
		"age": 5,
		"color": "Verde",
		"food": "Brócoli"
	},
	"Azulejo": {
		"home": "Portugal",
		"age": 11,
		"color": "Azul",
		"food": "Pescado"
	},
	"Gilda": {
		"home": "Francia",
		"age": 9,
		"color": "Blanco",
		"food": "Dulces"
	},
	"Chef Antonio": {
		"home": "Italia",
		"age": 52,
		"color": "Verde",
		"food": "Ensalada"
	},
	"Javi": {
		"home": "Valencia, España",
		"age": 29,
		"color": "Morado",
		"food": "Pescado"
	},
	"Dante": {
		"home": "Estados Unidos de America",
		"age": 6,
		"color": "Rojo",
		"food": "Pastel"
	},
	"Ximena": {
		"home": "Salamanca, España",
		"age": 64,
		"color": "Amarillo",
		"food": "Queso"
	},
	"Tobi": {
		"home": "Australia",
		"age": 8,
		"color": "Café",
		"food": "Bistec"
	},
	"Hugo": {
		"home": "Barkelona, España",
		"age": 5,
		"color": "Anaranjado",
		"food": "Zanahorias"
	},
	"Gabriela": {
		"home": "Burgos, España",
		"age": 33,
		"color": "Azul",
		"food": "Jamón"
	},
	"Maya": {
		"home": "Japón",
		"age": 25,
		"color": "Blanco",
		"food": "Fideos"
	},
	"Mariposa": {
		"home": "Chile",
		"age": 4,
		"color": "Rosado",
		"food": "Helado"
	},
	"Livia": {
		"home": "Italia",
		"age": 10,
		"color": "Rosado",
		"food": "Helado"
	},
	"Marisol": {
		"home": "Guatemala",
		"age": 43,
		"color": "Amarillo",
		"food": "Papas fritas"
	},
	"Rafa": {
		"home": "Uruguay",
		"age": 31,
		"color": "Azul",
		"food": "Bistec"
	},
	"Claudio": {
		"home": "Cuenca, España",
		"age": 66,
		"color": "Café",
		"food": "Arroz con pollo"
	},
	"Pilar": {
		"home": "Guinea Ecuatorial",
		"age": 27,
		"color": "Rojo",
		"food": "Plátanos"
	},
	"Fiel": {
		"home": "Barkelona, España",
		"age": 5,
		"color": "Anaranjado",
		"food": "Tocino"
	},
	"Carmen": {
		"home": "Salamanca, España",
		"age": 23,
		"color": "Rojo",
		"food": "Arroz con pollo"
	},
	"Enrique": {
		"home": "Estados Unidos",
		"age": 2,
		"color": "Blanco",
		"food": "Jamón"
	},
	"Chicharito": {
		"home": "México",
		"age": 5,
		"color": "Rojo",
		"food": "Jamón"
	},
	"Álvaro": {
		"home": "Nicaragua",
		"age": 47,
		"color": "Amarillo",
		"food": "Frijoles"
	},
	"Doctora Calista": {
		"home": "Estados Unidos",
		"age": 6,
		"color": "Morado",
		"food": "Huevos fritos"
	},
	"Martín": {
		"home": "Barkelona, España",
		"age": 9,
		"color": "Amarillo",
		"food": "Helado"
	},
	"Silvia": {
		"home": "Venezuela",
		"age": 12,
		"color": "Anaranjado",
		"food": "Pastelito"
	},
	"Aitana": {
		"home": "Colombia",
		"age": 5,
		"color": "Rosado",
		"food": "Fresa"
	},
	"Oscar": {
		"home": "República Dominicana",
		"age": 59,
		"color": "Verde",
		"food": "Naranja"
	}
}

onready var list_container = $FileOverlay1/ScrollContainer/VBoxContainer

func populate():	
	# clear list
	for item in list_container.get_children():
		list_container.remove_child(item)
		item.queue_free()
	
	var friendContainer = preload("res://UI/FriendContainer.tscn")
	for f in GameState.friends:		
		var friend_container = friendContainer.instance()
		var info = npc_map[f]
		friend_container.get_node("Portrait").texture = load("res://NPCs/Portraits/" + f + ".png")
		friend_container.get_node("Name").text = f
		if GameState.birthplace_map[f] != null and GameState.birthplace_map[f]:
			friend_container.get_node("Home").text = info.home
		else:
			friend_container.get_node("Home").text = "???"
		friend_container.get_node("Age").text = str(info.age)
		
		if GameState.fav_color_map[f] != null and GameState.fav_color_map[f]:
			friend_container.get_node("Color").text = info.color
		else:
			friend_container.get_node("Color").text = "???"
		
		if GameState.fav_food_map[f] != null and GameState.fav_food_map[f]:
			friend_container.get_node("Food").text = info.food
		else:
			friend_container.get_node("Food").text = "???" 
			
		list_container.add_child(friend_container)

	list_container.rect_min_size.y = 50 + GameState.friends.size() * 140
