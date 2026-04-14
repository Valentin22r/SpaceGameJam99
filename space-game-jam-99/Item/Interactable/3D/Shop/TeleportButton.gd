extends StaticBody3D

@export var destination = ""
@onready var mesh := $Mesh
var is_looked_at := false
var is_selected = false
var mat = null

func _ready():
	mat = mesh.get_active_material(0)

	if mat == null:
		mat = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, mat)
	else:
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)
	mat.albedo_color = Color(1, 0, 0)

func set_looked_at(state: bool):
	is_looked_at = state
	update()

func update():
	if is_looked_at:
		if is_selected == false :
			mat.albedo_color = Color(1, 1, 0.0, 1.0)
		if Input.is_action_just_pressed("interact"):
			if is_selected == false :
				is_selected = true
				mat.albedo_color = Color(0, 1, 0.0, 1.0)
				$Timer.start()
			else :
				is_selected = false
				$Timer.stop()
	else:
		if is_selected == false :
			mat.albedo_color = Color(1, 0, 0)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(destination)
