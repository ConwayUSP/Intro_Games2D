extends Node3D

@export var wall_scene: PackedScene
@export var floor_scene: PackedScene

var width = 15
var height = 15
var spacing = 2.0

func _ready():
	# Safety check to prevent the crash you just had
	if not wall_scene:
		print("Error: Please assign Wall Scene in the Inspector!")
		return
		
	generate_maze()

func generate_maze():
	# 1. Create a grid of "visited" markers
	var grid = []
	for x in range(width):
		grid.append([])
		for y in range(height):
			grid[x].append(true) # True means "this is a wall"

	# 2. Run the backtracking algorithm
	_carve_path(1, 1, grid)

	# 3. Instantiate the physical walls and floors
	for x in range(width):
		for z in range(height):
			# Spawn Floor
			var f = floor_scene.instantiate()
			add_child(f)
			f.position = Vector3(x * spacing, 0, z * spacing)

			# Spawn Ceiling
			var c = floor_scene.instantiate()
			add_child(c)
			c.position = Vector3(x * spacing, 4.0, z * spacing)

			# Spawn Wall if the grid value is true
			if grid[x][z]:
				var w = wall_scene.instantiate()
				add_child(w)
				w.position = Vector3(x * spacing, 1.5, z * spacing)

func _carve_path(x, z, grid):
	grid[x][z] = false # Mark as empty path
	
	var directions = [Vector2(0, 2), Vector2(0, -2), Vector2(2, 0), Vector2(-2, 0)]
	directions.shuffle() # Randomize order

	for dir in directions:
		var nx = x + dir.x
		var nz = z + dir.y
		
		# Check if the neighbor is within bounds and is still a wall
		if nx > 0 and nx < width-1 and nz > 0 and nz < height-1:
			if grid[nx][nz]:
				# Remove the wall between the current cell and the neighbor
				grid[x + dir.x/2][z + dir.y/2] = false
				_carve_path(nx, nz, grid)
