extends Node2D

var flying_birds = 1

func _ready() -> void:
	var player:Birds = Birds.new(3)
	print(player)
	$BirdSpawner.add_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
