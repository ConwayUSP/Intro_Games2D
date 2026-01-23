extends Node3D

@export var wall_scene: PackedScene
@export var floor_scene: PackedScene
@export var prize_scene: PackedScene

var width = Manager.current_level_size
var height = Manager.current_level_size
var spacing = 2.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if not wall_scene:
		print("Error: Configure a `Wall Scene` no Inspetor")
		return
		
	if not floor_scene:
		print("Error: Configure a `Floor Scene` no Inspetor")
		return
		
	if not prize_scene:
		print("Error: Configure a `Prize Scene` no Inspetor")
		return

	generate_maze()

func generate_maze():
	# Cria matriz de booleanos
	var grid = []
	for x in range(width):
		grid.append([])
		for y in range(height):
			grid[x].append(true) # True significa parede

	# "Escavamos" um caminho
	carve_path(1, 1, grid)

	# Instanciamos fisicamente as paredes, o chao e o teto
	for x in range(width):
		for z in range(height):
			# Chão
			var f = floor_scene.instantiate()
			add_child(f)
			f.position = Vector3(x * spacing, 0, z * spacing)

			# Teto
			var c = floor_scene.instantiate()
			add_child(c)
			c.position = Vector3(x * spacing, 4.0, z * spacing)

			# Parede
			if grid[x][z]:
				var w = wall_scene.instantiate()
				add_child(w)
				w.position = Vector3(x * spacing, 1.5, z * spacing)
				
	spawn_prize(width - 2, height-2, grid)

func carve_path(x, z, grid):
	grid[x][z] = false # 
	
	# [Direita, Esquerda, Cima, Baixo]
	var directions = [Vector2(0, 2), Vector2(0, -2), Vector2(2, 0), Vector2(-2, 0)]
	directions.shuffle() # Embaralha o array

	for dir in directions:
		var nx = x + dir.x
		var nz = z + dir.y
		
		# Se há espaco/não chegou nas bordas
		if nx > 0 and nx < width-1 and nz > 0 and nz < height-1:
			if grid[nx][nz]:
				# Remove a parede entre a célula atual e o vizinho
				grid[x + dir.x/2][z + dir.y/2] = false
				carve_path(nx, nz, grid)

func spawn_prize(target_x, target_z, grid):
	if grid[target_x][target_z] == true:
		for x in range(target_x, 1, -1):
			for z in range(target_z, 1, -1):
				if grid[x][z] == false:
					target_x = x
					target_z = z
					break

	var prize = prize_scene.instantiate()
	add_child(prize)
	prize.position = Vector3(target_x * spacing, 1.0, target_z * spacing)
