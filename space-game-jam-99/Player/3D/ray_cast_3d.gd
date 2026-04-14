extends RayCast3D

var last_obj = null

func _physics_process(_delta):
	if is_colliding():
		var obj = get_collider()  # plus besoin de get_parent()

		if obj != last_obj:
			if last_obj and last_obj.has_method("set_looked_at"):
				last_obj.set_looked_at(false)

		if obj.has_method("set_looked_at"):
			obj.set_looked_at(true)

		last_obj = obj
	else:
		if last_obj and last_obj.has_method("set_looked_at"):
			last_obj.set_looked_at(false)
		last_obj = null
