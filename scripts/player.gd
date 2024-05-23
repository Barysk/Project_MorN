extends CharacterBody2D

## Probably will implement later
# var MAX_SPEED = 7000
# var ACCELERATION = 100
# a = (vf − vi) / Δt;

## Signals
signal health_changed()
signal stamina_changed()

## Vars
var SPEED = 5000

var MAX_HEALTH: int = 3
var HEALTH: int = 3:
	set(new_health):
		HEALTH = clamp(new_health, 0, MAX_HEALTH)
		health_changed.emit()

var MAX_STAMINA: int = 100
var STAMINA: int = 100:
	set(new_stamina):
		STAMINA = clamp(new_stamina, 0, MAX_STAMINA)
		stamina_changed.emit()

var LAST_MOVE: int = 0	# last move direction
# var IS_ATTACKING : bool = false

@onready var stamina_regen_timer = $StaminaRegenTimer
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_tree_state = animation_tree.get("parameters/playback")
@onready var health_and_mana_debug = $HealthAndManaDebug

@onready var hitbox_collision = $Hitbox/CollisionShape2D

## State machines
var STATE = IDLE

enum {
	IDLE,
	MOVE,
	ATTACK,
}

## Setters and Getters
#func _set_health():
	#pass
#
#func _get_health():
	#pass

## Godot functions
func _ready():
	#print(GameManager.add_score())
	update_ui()
	hitbox_collision.disabled = true

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

## Other functions

func update_ui():
	health_and_mana_debug.text = "HP: " + str(HEALTH) + "\nST:" + str(STAMINA)

## Signals
func _on_stamina_regen_timer_timeout():
	if STAMINA < 100:
		stamina_regen_timer.start()
		STAMINA += 11
		STAMINA = clamp(STAMINA, 0, 100)

func _on_health_changed():
	update_ui()

func _on_stamina_changed():
	update_ui()

func _on_hurtbox_area_entered(area):
	HEALTH -= 1
	
