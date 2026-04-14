extends Area3D

@export var item_name: String = ""

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if area.name == "PlayerArea":
		PlayerInventory.add_item(item_name)
		print("Item ramassé : " + item_name)

		# Notifie tous les PNJ qu'un item a été ramassé
		get_tree().call_group("quest_system", "on_item_picked", item_name)

		queue_free()
