extends Node2D

var flying_birds:bool = true
var player:Birds
var block

func _ready() -> void:
	randomize()
	player = Birds.new(1,["C1",null,null])
	$BirdSpawner.add_child(player)
	player.is_blocked.connect(_on_bird_is_blocked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.lives < 1:
		game_over()
	if not flying_birds:
		$BirdSpawner.add_child(spawn_random_bird())

func spawn_random_bird() -> Birds:
	flying_birds = true
	var random_number = randi_range(1,3)
	var random_colors:Array
	for x in range(0,random_number):
		random_colors.append(Globals.available_colors.pick_random())
	random_colors.resize(3)
	var player:Birds = Birds.new(random_number,random_colors)
	player.is_blocked.connect(_on_bird_is_blocked)
	return player
	
func game_over() -> void:
	pass

func _on_death_zone_body_exited(body: Node2D) -> void:
	body.queue_free()
	flying_birds = false
	Globals.lives -= 1

func _on_bird_is_blocked(colors: Array, bird:Birds) -> void:
	flying_birds = false
	bird.reparent(%IdleBirds)
	sum_global_colors(colors)
	check_matching()
	
func check_matching() -> void:	
	for x in $IdleBirds.get_children():
		var area_H:Area2D = Area2D.new()
		var collision_shape_H:RectangleShape2D = RectangleShape2D.new()
		collision_shape_H.size = Vector2(42,4)
		var collision_H:CollisionShape2D = CollisionShape2D.new()
		collision_H.shape = collision_shape_H
		area_H.add_child(collision_H)
		x.get_node("CenterCollision").add_child(area_H)
		area_H.body_shape_entered.connect(_on_area_2d_body_shape_entered)
		#Necesitaria un timer para hacer un OneShot area, como si fuese ray casting.
		#x.clear_bird()
		#print(x)
		pass

func sum_global_colors(colors: Array) -> void:
	for x in colors.size(): 
		if colors[x] != null:
			if colors[x] == "C1":
				Globals.c1_quantity = Globals.c1_quantity + 1
			if colors[x] == "C2":
				Globals.c2_quantity = Globals.c2_quantity + 1
			if colors[x] == "C3":
				Globals.c3_quantity = Globals.c3_quantity + 1
			if colors[x] == "C4":
				Globals.c4_quantity = Globals.c4_quantity + 1
			if colors[x] == "C5":
				Globals.c5_quantity = Globals.c5_quantity + 1
			if colors[x] == "C6":
				Globals.c6_quantity = Globals.c6_quantity + 1
#para debuguear
		$Label.text = "C1: " + var_to_str(Globals.c1_quantity) + " C2: " + var_to_str(Globals.c2_quantity) + " C3: " + var_to_str(Globals.c3_quantity) + " C4: " + var_to_str(Globals.c4_quantity) + " C5: " + var_to_str(Globals.c5_quantity) + " C6: " + var_to_str(Globals.c6_quantity)


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var shape = body.get_child(body_shape_index)
	print(shape.editor_description)
	pass # Replace with function body.
