extends Node

# -------------------------
# Données de la partie
# -------------------------

var money: int = 0

var flags := {
	"speed": false,
	"jump": false,
	"double_xp": false
}

# -------------------------
# Sauvegarde / Chargement
# -------------------------

func save():
	var data = {
		"money": money,
		"flags": flags
	}

	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_data():
	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())

		money = data["money"]
		flags = data["flags"]

func reset_data():
	money = 0
	flags = {
		"speed": false,
		"jump": false,
		"double_xp": false
	}
	save()

func _ready():
	load_data()

# -------------------------
# Fonctions argent
# -------------------------

func add_money(amount: int):
	money += amount
	save()

func remove_money(amount: int):
	money = max(0, money - amount)
	save()

func get_money() -> int:
	return money

# -------------------------
# Fonctions booléens
# -------------------------

func set_flag(_name: String, _value: bool):
	flags[_name] = _value
	save()

func get_flag(_name: String) -> bool:
	return flags.get(_name, false)
