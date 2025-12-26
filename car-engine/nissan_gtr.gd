extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE = 300

func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta): # Added underscore and changed to physics_process
	# Steering logic
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 2.5)
	
	# Engine logic
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE
