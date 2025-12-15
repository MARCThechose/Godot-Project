extends Node2D

const CELL_SIZE = 20
const SCREEN_WIDTH = 32
const SCREEN_HEIGHT = 24

var snake
var food
var score = 0
var is_game_over = false

@onready var snake_scene = preload("res://scenes/player/snake.tscn")
@onready var food_scene = preload("res://scenes/food/food.tscn")

func _ready():
	get_tree().root.set_size(Vector2(SCREEN_WIDTH * CELL_SIZE, SCREEN_HEIGHT * CELL_SIZE))
	new_game()

func new_game():
	is_game_over = false
	score = 0
	$ScoreLabel.text = "Score: 0"
	$GameOverLabel.hide()
	
	# Clear previous game nodes
	if snake:
		snake.queue_free()
	if food:
		food.queue_free()

	snake = snake_scene.instantiate()
	add_child(snake)
	
	spawn_food()

func spawn_food():
	if food:
		food.queue_free()
		
	food = food_scene.instantiate()
	
	# Keep trying new positions until we find one that isn't inside the snake
	var in_snake = true
	while(in_snake):
		var new_pos = Vector2(randi() % SCREEN_WIDTH, randi() % SCREEN_HEIGHT) * CELL_SIZE
		food.position = new_pos
		in_snake = false
		for segment in snake.body_segments:
			if segment.position == new_pos:
				in_snake = true
				break
	
	add_child(food)

func _process(delta):
	if is_game_over:
		if Input.is_action_just_pressed("ui_accept"):
			new_game()
		return
		
	# Check for eating food
	if snake.get_head_position() == food.position:
		snake.grow()
		score += 1
		$ScoreLabel.text = "Score: " + str(score)
		spawn_food()

func game_over():
	is_game_over = true
	$GameOverLabel.show()
