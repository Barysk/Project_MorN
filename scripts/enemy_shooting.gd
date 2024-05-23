extends Node2D

var ESHealth: int = 3
var ESMana: int = 100

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_tree_state = animation_tree.get("parameters/playback")
@onready var hurt_box = $HurtBox
@onready var detecting_area = $DetectingArea
@onready var shooting_rate = $ShootingRate

const ENEMY_PROJECTILE = preload("res://scenes/enemy_projectile.tscn")

var ES_STATE = State.IDLE
var ES_ATTACK_TYPE = AttackType.FOUR

# Attack type
# look at notes
enum AttackType{
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
}

# States
enum State{
	IDLE,
	ATTACK,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot_projectile_pattern_4():
	if ENEMY_PROJECTILE:
		var projectile = ENEMY_PROJECTILE.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = self.global_position
		projectile.rotation = self.rotation
		projectile.speed = self.projectile_speed
		shooting_rate.start()


func _on_shooting_rate_timeout():
	pass # Replace with function body.
