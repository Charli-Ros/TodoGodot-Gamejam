class_name Birds
extends CharacterBody2D

static var yellow_idle = Rect2(4, 7, 14, 17)
static var yellow_flying = Rect2(121, 6, 17, 18)
static var red_idle = Rect2(4, 31, 14, 17)
static var red_flying = Rect2(121, 30, 17, 18)
static var pink_idle = Rect2(4, 55, 14, 17)
static var pink_flying = Rect2(121, 54, 17, 18)
static var green_idle = Rect2(4, 78, 14, 18)
static var green_flying = Rect2(121, 77, 17, 19)
static var grey_idle = Rect2(4, 103, 14, 17)
static var grey_flying = Rect2(121, 102, 17, 18)
static var blue_idle = Rect2(4, 126, 14, 18)
static var blue_flying = Rect2(121, 125, 17, 19)

#Recursos prefabricados para armar la escena del player 
@onready var birds_collision = preload("res://Scenes/bird_collision.tres")
@onready var birds_sprites = preload("res://Scenes/player.tres")
#Props para el constructor
var is_flying:bool = true
var birds_count:int = 1
var colors:Array = ["C1", "C2", "C3"]

#Constantes para el balance de gameplay, podrian ser export para el remote debugging.
const SPEED = 150.0
const FLAP_VELOCITY = -150.0
const GRAVITY_MOD = 0.5

var animation_is_playing = false
signal is_blocked

func _init(_birds_count:int = 1, _colors:Array = ["C1", "C2", "C3"], _is_flying:bool = true) -> void:
	birds_count = _birds_count
	colors = _colors
	is_flying = _is_flying

func _to_string() -> String:
	return "There are %d Birds\nLeft Color: %s\nCenter Color: %s\nRight Color: %s\nIs Flying? %s" % [birds_count, colors[0], colors[1], colors[2], is_flying]
	
func _ready() -> void:
	_create_collision_shapes(birds_count)
	_create_sprites(birds_count, colors)
	var death_signal = get_parent().get_parent().get_node("DeathZone")
	death_signal.body_exited.connect(_on_death_zone_body_exited)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MOD * delta
		
		if Input.is_action_just_pressed("flap"):
			#Intento fallido de animacion de sprites para que vuele.
			if not animation_is_playing:
				for x in self.get_child_count():
					var node = self.get_child(x)
					if node.name.contains("Sprite2D"):
						animate(node)
					
			velocity.y = FLAP_VELOCITY

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
		velocity.y = 0
		is_flying = false
		is_blocked.emit(colors)
		set_physics_process(false)
	
	if is_on_ceiling():
		print("Estas muerto!")
		
	move_and_slide()
	
func _create_collision_shapes(birds_count) -> void:
	#Aqui tengo que crear las colisiones dependiendo de cuantos pajaros hay que crear.
	var collision1:CollisionShape2D = CollisionShape2D.new()
	collision1.shape = birds_collision
	self.add_child(collision1)
	if birds_count != 1:
		var collision2:CollisionShape2D = CollisionShape2D.new()
		collision2.shape = birds_collision
		collision2.position = Vector2(-18,0)
		self.add_child(collision2)
		if birds_count == 3:
			var collision3:CollisionShape2D = CollisionShape2D.new()
			collision3.shape = birds_collision
			collision3.position = Vector2(18,0)
			self.add_child(collision3)
	
func _create_sprites(birds_count, colors) -> void:
	#Funcion para agregar los sprites correspondientes a los colores designados.
	
	var sprite1:Sprite2D = Sprite2D.new()
	sprite1.texture = birds_sprites.duplicate()
	sprite1.texture.region = yellow_idle
	sprite1.texture.resource_local_to_scene = true
	sprite1.position = Vector2(0.5,-1.0)
	sprite1.editor_description = colors[0]
	self.add_child(sprite1)
	if birds_count != 1:
		var sprite2:Sprite2D = Sprite2D.new()
		sprite2.texture = birds_sprites.duplicate()
		sprite2.texture.region = Rect2(4, 103, 14, 17)
		sprite2.texture.resource_local_to_scene = true
		sprite2.position = Vector2(-17.5,-1.0)
		self.add_child(sprite2)
		if birds_count == 3:
			var sprite3:Sprite2D = Sprite2D.new()
			sprite3.texture = birds_sprites.duplicate()
			sprite3.texture.region = Rect2(4, 31, 14, 17)
			sprite3.texture.resource_local_to_scene = true
			sprite3.position = Vector2(18.5,-1.0)
			self.add_child(sprite3)
	#detuve el codigo aca porque se me esta dificultando hacer que cada sprite sea unico
	#tengo que revisar la forma de crear recursos y reutilizarlos
	
func _on_death_zone_body_exited(body: Node2D) -> void:
		is_flying = false
		print("Estas muerto!")
		
func animate(sprite) -> void:
	#Anima correctamente pero no reconozco el color
	animation_is_playing = true
	var reset_animation = sprite.texture.region
	sprite.texture.region = yellow_flying
	await get_tree().create_timer(0.1).timeout
	sprite.texture.region = reset_animation
	animation_is_playing = false
