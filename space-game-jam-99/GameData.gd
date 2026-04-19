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

var sound_volume_db: float = 0.0


# -------------------------
# Sauvegarde / Chargement
# -------------------------

func save():
	var data = {
		"money": money,
		"flags": flags,
		"sound_volume_db": sound_volume_db
	}

	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))


func load_data():
	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())

		money = data.get("money", 0)
		flags = data.get("flags", flags)
		sound_volume_db = data.get("sound_volume_db", 0.0)

		# Applique le volume au bus Master
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			sound_volume_db
		)


func reset_data():
	money = 0
	flags = {
		"speed": false,
		"jump": false,
		"double_xp": false
	}
	sound_volume_db = 0.0
	save()


func _ready():
	load_data()


# -------------------------
# Fonctions argent
# -------------------------

signal money_changed

func add_money(amount: int):
	money += amount
	save()
	money_changed.emit()

func remove_money(amount: int):
	money = max(0, money - amount)
	save()
	money_changed.emit()

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


# -------------------------
# Fonctions son
# -------------------------

func set_sound_volume_db(value: float):
	# Clamp entre -80 et 24 dB
	sound_volume_db = clamp(value, -80.0, 24.0)

	# Applique immédiatement au bus Master
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		sound_volume_db
	)

	save()


func get_sound_volume_db() -> float:
	return sound_volume_db
