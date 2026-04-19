extends Node3D

@export var rising: bool = false
@export var rising_rate: float = 1.0

func _on_timer_timeout() -> void:
	if rising:
		translate(Vector3(0, rising_rate, 0))

func _on_area_3d_area_entered(_area: Area3D) -> void:
	get_tree().change_scene_to_file("res://Level/Lobby/Lobby.tscn")
