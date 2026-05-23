extends CharacterBody2D

@export var speed : float = 300.0
@export var jump_velocity : float = -200.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var air_jumped : bool = false
var animation_locked : bool = false
var was_in_air : bool = false
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
		jump_fall()
	else:
		air_jumped = false
		if was_in_air:
			land()
		was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("JUMP_KEY"):
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("LEFT_KEY", "RIGHT_KEY", "UP_KEY", "DOWN_KEY")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	animation_update()
	update_facing_direction()
	
func animation_update():
	if not animation_locked:
		if is_on_floor():
			if direction.x != 0:
				animated_sprite_2d.play("walk")
			else:
				animated_sprite_2d.play("idle")

func update_facing_direction():
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true

func jump():
	velocity.y = jump_velocity
	if is_on_floor():
		animated_sprite_2d.play("jump_start")
	elif not air_jumped:
		animated_sprite_2d.play("jump_double")
		air_jumped = true
	
	animation_locked = true

func jump_fall():
	if not animation_locked:
		animated_sprite_2d.play("jump_loop")
	animation_locked = true

func land():
	animated_sprite_2d.play("jump_end")
	# animation_locked = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if(["jump_start", "jump_double", "jump_end"].has(animated_sprite_2d.animation)):
		animation_locked = false
