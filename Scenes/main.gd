extends Node2D

var flying_birds:bool = true
var player:Birds
var block

func _ready() -> void:
	player = Birds.new(1)
	print(player)
	$BirdSpawner.add_child(player)
	player.is_blocked.connect(_on_bird_is_blocked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not flying_birds:
		flying_birds = true
		var random_number = randi_range(1,3)
		var player:Birds = Birds.new(random_number)
		$BirdSpawner.add_child(player)
		player.is_blocked.connect(_on_bird_is_blocked)

func _on_death_zone_body_exited(body: Node2D) -> void:
	body.queue_free()
	flying_birds = false

func _on_bird_is_blocked() -> void:
	flying_birds = false
