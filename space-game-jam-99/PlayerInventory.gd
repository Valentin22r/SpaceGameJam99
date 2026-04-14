extends Node

var items: Array = []

func add_item(item_name: String):
	items.append(item_name)

func get_items() -> Array:
	return items
