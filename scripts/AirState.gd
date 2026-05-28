extends State

class_name AirState

@export var jump_velocity : float = -200.0
@export var ground_state : State

var has_double_jumped : bool = false

func state_process(delta):
	if character.is_on_floor():
		next_state = ground_state

func state_input(event : InputEvent):
	if event.is_action_pressed("JUMP_KEY") and not has_double_jumped:
		double_jump()

func double_jump():
	character.velocity.y = jump_velocity
	has_double_jumped = true

func on_exit():
	if next_state == ground_state:
		has_double_jumped = false
