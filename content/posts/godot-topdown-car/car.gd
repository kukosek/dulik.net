extends KinematicBody2D

const max_speed_forward = 40000
const max_speed_backwards = 15000

const accel = 0.5
const deaccel = 0.4
const deaccel_break = 0.7


var current_direction = Vector2(0, -1)

var rotation_speed = 5

var current_speed = 0

var current_turn = 0

func perpendicular_vector(vec: Vector2):
	return Vector2(vec.y, -vec.x)

func _physics_process(delta):
	# Change forward velocity based on up and down input
	if Input.is_action_pressed("ui_down"):
		if current_speed < 0: # When we go forward
			current_speed += deaccel_break * delta
		elif current_speed < 1: # When we go backwards
			current_speed += accel * delta
	elif Input.is_action_pressed("ui_up"):
		if current_speed > -1:
			current_speed -= accel * delta
	else: # When player isn't holding anything, deaccelerate
		if current_speed < -0.01: # When we go forward
			current_speed += deaccel * delta
		elif current_speed > 0.01: # When we go backwards
			current_speed -= deaccel * delta
		else: # STOP
			current_speed = 0

	# Setting the current turn direction
	if Input.is_action_pressed("ui_left"):
		current_turn = delta
	elif Input.is_action_pressed("ui_right"):
		current_turn = -delta
	else:
		current_turn = 0

	# Add a scaled down perpendicular vector of current dirrection to the direction.
	# This will result in changing the direction vector each frame when player is holding
	# right/left keys
	# Multypling by current speed is optional (This way you prevent turning around on one place)
	current_direction += perpendicular_vector(current_direction) * current_turn * rotation_speed * -current_speed

	# Normalize the vector, so the direction is preserved but size remains the same.
	# This prevents acceleration bug
	current_direction = current_direction.normalized()

	# Visual rotation of our kinematic body. I add 90 because of the direction my car sprite is turned
	rotation_degrees = rad2deg(current_direction.angle()) + 90

	# Application of the result movement
	var move_vector = current_direction * -current_speed * delta
	if current_speed > 0:
        move_vector *= max_speed_backwards
	else:
        move_vector *= max_speed_forward
    move_and_slide(move_vector)
