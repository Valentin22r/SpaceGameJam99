extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/Lobby.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/Settings/Settings.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
