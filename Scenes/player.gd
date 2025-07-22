extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -150.0
const GRAVITY_MOD = 0.5



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * GRAVITY_MOD * delta

	# Handle jump.
	if Input.is_action_just_pressed("flap"):
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_death_zone_body_exited(body: Node2D) -> void:
	#This reset is intended for testing purposes only.
	position.x = 141
	position.y = 427
	velocity = Vector2(0,0)
