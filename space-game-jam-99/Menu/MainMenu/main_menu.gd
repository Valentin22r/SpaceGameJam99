extends Control

@onready var slider := $SoundVolume

func _on_play_pressed() -> void:
	$Effet.play()
	$TimerPlay.start()

func _on_settings_pressed() -> void:
	$Effet.play()
	$TimerControle.start()

func _on_quit_pressed() -> void:
	$Effet.play()
	$TimerQuit.start()

func _ready():
	GameData.load_data()
	var vol_db = GameData.get_sound_volume_db()
	slider.value = vol_db

func _on_sound_volume_value_changed(value: float) -> void:
	GameData.set_sound_volume_db(value)

func _on_timer_play_timeout() -> void:
	get_tree().change_scene_to_file("res://Level/Lobby/Lobby.tscn")

func _on_timer_controle_timeout() -> void:
	get_tree().change_scene_to_file("res://Menu/Settings/Settings.tscn")

func _on_timer_quit_timeout() -> void:
	get_tree().quit()
