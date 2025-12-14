extends Node2D

var body_segments = []
var direction = Vector2.RIGHT
var segment_scene = preload("res://scenes/player/segment.tscn")
var is_alive = true

const CELL_SIZE = 20
const MOVE_SPEED = 0.15 # Time in seconds between moves

var move_timer = 0

func _ready():
	# Set a timer to control movement speed
	$MoveTimer.wait_time = MOVE_SPEED
	$MoveTimer.start()
	
	# Initial snake
	create_snake()

func create_snake():
	is_alive = true
	# Clear any old segments
	for segment in body_segments:
		segment.queue_free()
	body_segments.clear()
	
	# Create a new snake
	add_segment(get_parent().get_node("StartPosition").position)
	grow()
	grow()

func _process(delta):
	if !is_alive:
		return
	handle_input()
	
func handle_input():
	if Input.is_action_just_pressed("ui_right") and direction != Vector2.LEFT:
		direction = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left") and direction != Vector2.RIGHT:
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_up") and direction != Vector2.DOWN:
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down") and direction != Vector2.UP:
		direction = Vector2.DOWN

func move():
	if !is_alive:
		return

	var old_head_pos = body_segments[0].position
	var new_head_pos = old_head_pos + direction * CELL_SIZE
	
	# Check for wall collision
	if new_head_pos.x < 0 or new_head_pos.x >= get_viewport_rect().size.x or \
	   new_head_pos.y < 0 or new_head_pos.y >= get_viewport_rect().size.y:
		die()
		return

	# Check for self collision
	for i in range(1, body_segments.size()):
		if body_segments[i].position == new_head_pos:
			die()
			return
	
	# Move the snake
	var tail = body_segments.pop_back()
	tail.position = new_head_pos
	body_segments.insert(0, tail)

func add_segment(pos):
	var new_segment = segment_scene.instance()
	new_segment.position = pos
	get_parent().add_child(new_segment) # Add to the main scene, not the snake node
	body_segments.append(new_segment)

func grow():
	var tail = body_segments[body_segments.size() - 1]
	var new_segment = segment_scene.instance()
	new_segment.position = tail.position # It will be correctly placed on next move
	get_parent().add_child(new_segment)
	body_segments.append(new_segment)

func get_head_position():
	return body_segments[0].position

func die():
	is_alive = false
	get_parent().game_over()

func _on_MoveTimer_timeout():
	move()