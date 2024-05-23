extends CharacterBody2D

var SPEED = 5000

## Probably will implement later
# var MAX_SPEED = 7000
# var ACCELERATION = 100
# a = (vf − vi) / Δt;

var HEALTH: int = 3
var STAMINA: int = 100

var LAST_MOVE: int = 0	# last move direction
# var IS_ATTACKING : bool = false

@onready var stamina_regen_timer = $StaminaRegenTimer
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_tree_state = animation_tree.get("parameters/playback")

@onready var hitbox_collision = $Hitbox/CollisionShape2D



#state machine

var STATE = IDLE

enum {
	IDLE,
	MOVE,
	ATTACK,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(GameManager.add_score())
	hitbox_collision.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	## Moving in directions
	var direction : Vector2 
	direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	

	
	if direction:
		# both animation tree setters are here, becouse we need to remember the
		# position where are we facing
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Run/blend_position", direction)
		velocity = direction * SPEED * delta
		animation_tree_state.travel("Run")
	else:
		velocity = Vector2.ZERO
		animation_tree_state.travel("Idle")

	move_and_slide()
	
	if Input.is_action_pressed("attack"):
		stamina_regen_timer.start()
		if STAMINA > 0:
			STAMINA -= 1
			animation_tree_state.travel("Attack")


func _on_stamina_regen_timer_timeout():
	if STAMINA < 100:
		stamina_regen_timer.start()
		STAMINA += 11
		STAMINA = clamp(STAMINA, 0, 100)
