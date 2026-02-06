extends Node3D

var mouse_sensitivity = 0.03

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		#rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		rotation.x = clamp(rotation.x, deg_to_rad(-50), deg_to_rad(50))
