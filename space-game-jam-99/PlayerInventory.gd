extends Node

var items := {}

func add_item(item_name: String):
	if not items.has(item_name):
		items[item_name] = 0
	items[item_name] += 1
	print("Inventaire : ", items)

func get_item_count(item_name: String) -> int:
	if items.has(item_name):
		return items[item_name]
	return 0

func get_items() -> Dictionary:
	return items
