class_name Birds
extends CharacterBody2D

#Estas cantidades las quisiera usar para mejorar las probabilidades de
#colores que se necesitan en pantalla.
static var c1_quantity:int = 0
static var c2_quantity:int = 0
static var c3_quantity:int = 0
static var c4_quantity:int = 0
static var c5_quantity:int = 0
static var c6_quantity:int = 0

var is_flying:bool = true
var birds_count:int = 1
var colors:Array = ["C1", "C2", "C3"]

const speed = 200.0
const flap_velocity = -200.0

func _init(_birds_count:int = 1, _colors:Array = ["C1", "C2", "C3"], _is_flying:bool = true) -> void:
	birds_count = _birds_count
	colors = _colors
	is_flying = _is_flying

func _to_string() -> String:
	return "Algun string que sirva para debuguear..."
	
func _ready() -> void:
	#Se llamaran las funciones para crear sprites y colisiones.
	#Creo que deberia agregar los connect a las signals aca tambien??
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("flap"):
			velocity.y = flap_velocity

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = 0
		velocity.y = 0
		is_flying = false
		
	move_and_slide()
	
func _create_collision_shapes(birds_count) -> void:
	#Aqui tengo que crear las colisiones dependiendo de cuantos pajaros hay que crear.
	var collision1:CollisionShape2D = CollisionShape2D.new()
	collision1.shape = RectangleShape2D.new()
	pass

func _create_sprites(birds_count, colors) -> void:
	#Funcion para agregar los sprites correspondientes a los colores designados.
	pass
