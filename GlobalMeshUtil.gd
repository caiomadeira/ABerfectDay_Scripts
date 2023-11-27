extends Node3D

var pressed: bool = false

func viewer_control():
	if GlobalScript.is_in_3d_viewer:
		if Input.is_action_just_pressed("click1"):
			pressed = true
		if Input.is_action_just_released("click1"):
			pressed = false

func viewer_input(event, mesh_instance: MeshInstance3D):
	if GlobalScript.is_in_3d_viewer and mesh_instance.mesh != null:
		if pressed and event is InputEventMouseMotion:
			mesh_instance.rotation.x += event.relative.y * 0.005
			mesh_instance.rotation.y += event.relative.x * 0.005
		if event is InputEventMouseButton:
			if event.pressed:
				match event.button_index:
					MOUSE_BUTTON_WHEEL_UP:
						mesh_instance.position.z = clamp(0.1, -0.5, -0.9)
					MOUSE_BUTTON_WHEEL_DOWN:
						mesh_instance.position.z = clamp(0.1, -0.9, -0.5)
	else:
		print("false or mesh null")

func viewer_exit(mesh_instance: MeshInstance3D):
	if Input.is_action_just_pressed("f - leave") and GlobalScript.is_in_3d_viewer:
		GlobalScript.is_mov_enable = true
		GlobalScript.is_in_3d_viewer = false
		GlobalScript.current_3dview_object = ""
		mesh_instance.queue_free()

func _get_rigidbody_mesh(interacted: Object) -> MeshInstance3D:
	var mesh = MeshInstance3D
	for _child in interacted.get_children():
		if _child is RigidBody3D:
			for __child in _child.get_children():
				if __child is MeshInstance3D:
					mesh = __child
	return mesh
