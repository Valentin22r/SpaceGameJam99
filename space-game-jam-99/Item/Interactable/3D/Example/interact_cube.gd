extends StaticBody3D

@onready var mesh := $Mesh
var is_looked_at := false
var mat = null

func _ready():
	# On récupère le matériau du mesh
	mat = mesh.get_active_material(0)

	# Si le matériau n'existe pas, on en crée un
	if mat == null:
		mat = StandardMaterial3D.new()
		mesh.set_surface_override_material(0, mat)
	else:
		# On duplique pour éviter de modifier le matériau partagé
		mat = mat.duplicate()
		mesh.set_surface_override_material(0, mat)
	mat.albedo_color = Color(1, 0, 0)

func set_looked_at(state: bool):
	is_looked_at = state
	update_visual()

func update_visual():
	if is_looked_at:
		mat.albedo_color = Color(1, 1, 0) # vert
	else:
		mat.albedo_color = Color(1, 0, 0) # rouge
