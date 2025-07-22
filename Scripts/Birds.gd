class_name Birds
extends CharacterBody2D

#Estas cantidades las quisiera usar para mejorar las probabilidades de
#colores que se necesitan en pantalla //// SERIAN GLOBALS?
static var c1_quantity:int = 0
static var c2_quantity:int = 0
static var c3_quantity:int = 0
static var c4_quantity:int = 0
static var c5_quantity:int = 0
static var c6_quantity:int = 0

#Las collision shapes prefab creo que 
#las puedo cargar como recursos aqui arriba en vez de crearlas todo el tiempo.

#Props para el constructor
var is_flying:bool = true
var birds_count:int = 1
var colors:Array = ["C1", "C2", "C3"]

#Constantes para el balance de gameplay, podrian ser export para el remote debugging.
const SPEED = 150.0
const FLAP_VELOCITY = -150.0
const GRAVITY_MOD = 0.5

func _init(_birds_count:int = 1, _colors:Array = ["C1", "C2", "C3"], _is_flying:bool = true) -> void:
	birds_count = _birds_count
	colors = _colors
	is_flying = _is_flying

func _to_string() -> String:
	return "There are %d Birds\nLeft Color: %s\nCenter Color: %s\nRight Color: %s\nIs Flying? %s" % [birds_count, colors[0], colors[1], colors[2], is_flying]
	
func _ready() -> void:
	_create_collision_shapes(birds_count)
	_create_sprites(birds_count, colors)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MOD * delta
		
		if Input.is_action_just_pressed("flap"):
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
		
	move_and_slide()
	
func _create_collision_shapes(birds_count) -> void:
	#Aqui tengo que crear las colisiones dependiendo de cuantos pajaros hay que crear.
	var collision_shape:RectangleShape2D = RectangleShape2D.new()
	collision_shape.size = Vector2(16, 16)
	var collision1:CollisionShape2D = CollisionShape2D.new()
	collision1.shape = collision_shape
	self.add_child(collision1)
	if birds_count != 1:
		var collision2:CollisionShape2D = CollisionShape2D.new()
		collision2.shape = collision_shape
		collision2.position = Vector2(-18,0)
		self.add_child(collision2)
		if birds_count == 3:
			var collision3:CollisionShape2D = CollisionShape2D.new()
			collision3.shape = collision_shape
			collision3.position = Vector2(18,0)
			self.add_child(collision3)
	
func _create_sprites(birds_count, colors) -> void:
	#Funcion para agregar los sprites correspondientes a los colores designados.
	pass
