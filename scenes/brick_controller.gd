# BrickController.gd
extends Node2D

signal game_over

const BRICK_SCENE = preload("res://scenes/Brick.tscn")
const BRICKS_PER_ROW = 7
const MAX_EMPTY_SPACES = 3
const BRICK_PADDING = 5
const BOTTOM_DANGER_Y = 800  # 852 - 25, matching ball launch height
const START_Y = 100  # Where first row appears
var BRICK_WIDTH = 45
var BRICK_HEIGHT = 45
	
@onready var stats_manager = get_node("../StatsManager")
@onready var wall_controller: Node2D = $"../WallController"


var rows = []  # Array of arrays, each inner array is a row of bricks

func _ready():
	var shape = $Brick/CollisionShape2D.shape
	if shape is RectangleShape2D:
		var BRICK_WIDTH = shape.size.x
		var BRICK_HEIGHT = shape.size.y
	create_initial_rows()

func create_initial_rows():
	create_new_row()

func create_new_row():
	var new_row = []
	var empty_spaces = randi_range(1, MAX_EMPTY_SPACES)
	var empty_positions = []
	
	
	# Choose random positions for empty spaces
	while empty_positions.size() <= empty_spaces:
		var pos = randi_range(0, BRICKS_PER_ROW - 1)
		if pos not in empty_positions:
			empty_positions.append(pos)
	
	var usable_width = BRICK_PADDING * (BRICKS_PER_ROW + 1) 
	var start_x = BRICK_PADDING + BRICK_WIDTH
	
	for i in range(BRICKS_PER_ROW):
		if i in empty_positions:
			new_row.append(null)
			continue
			
		var brick = BRICK_SCENE.instantiate()
		brick.stats_manager = stats_manager
		var x = start_x + (i * (BRICK_WIDTH + BRICK_PADDING))
		var y = START_Y
		brick.position = Vector2(x, y)
		
		# Set health based on stats_manager probability
		brick.set_health(stats_manager.get_brick_health())
		
		add_child(brick)
		new_row.append(brick)
	
	rows.insert(0, new_row)  # Add new row at start of array

func advance_rows():
	var need_game_over = false
	
	# Move all rows down
	for row_index in range(rows.size()):
		var row = rows[row_index]
		for brick in row:
			if brick != null:
				# Move brick down
				brick.position.y += BRICK_HEIGHT + BRICK_PADDING * 3
				# Check if brick is too low
				if brick.position.y >= BOTTOM_DANGER_Y:
					emit_signal("game_over")
					need_game_over = true
	
	# Create new row at top
	create_new_row()
	

	if need_game_over:
		emit_signal("game_over")

func _on_brick_destroyed(brick):
	# Find and remove brick from data structure
	for row in rows:
		var index = row.find(brick)
		if index != -1:
			row[index] = null
			break
