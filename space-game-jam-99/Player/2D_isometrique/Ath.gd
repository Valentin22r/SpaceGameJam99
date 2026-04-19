extends Node2D

func _ready() -> void:
	update_money_text()
	GameData.money_changed.connect(update_money_text)

func update_money_text() -> void:
	$MoneyText.text = "%s €" % GameData.get_money()
