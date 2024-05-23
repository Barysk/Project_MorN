extends CharacterBody2D

## Loads
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_tree_state = animation_tree.get("parameters/playback")
@onready var hurt_box = $HurtBox
@onready var detecting_area = $DetectingArea
@onready var shooting_rate = $ShootingRate
@onready var player = $"../Player"

const ENEMY_PROJECTILE = preload("res://scenes/enemy_projectile.tscn")

## Signals
signal ESHealth_changed()

## Vars
var ESHealth: int = 3:
	set(new_health):
		ESHealth = clamp(new_health, 0, 3)
		ESHealth_changed.emit()

var ESMana: int = 100
var ESSpeed:int = 32
var enemy_rotation_direction: Vector2 = Vector2.ZERO
var projectile_speed: int = 32
var projectile_rotation: float = 0
var projectile_rotation_is_different: bool = false	# false - plus, true - minus
@export var projectile_pattern: int:
	set(val):
		match val:
			1:
				projectile_speed += ESSpeed
				shooting_rate.wait_time = 0.1
				projectile_pattern = val
			2:
				projectile_speed += ESSpeed
				shooting_rate.wait_time = 0.1
				projectile_pattern = val
			3:
				projectile_speed = 25
				shooting_rate.wait_time = 0.4
				projectile_pattern = val
			4:
				projectile_speed = 25
				shooting_rate.wait_time = 0.4
				projectile_pattern = val
		pass

var ES_STATE = State.IDLE

# States
enum State{
	IDLE,
	ATTACK,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_pattern = randi_range(1, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not player:
		return
	
	if ES_STATE == State.ATTACK:
		animation_tree_state.travel("attack")
	elif ES_STATE == State.IDLE:
		animation_tree_state.travel("idle")
		velocity = Vector2.ZERO
		
	if ES_STATE == State.ATTACK and shooting_rate.is_stopped():
		shoot_projectile_with_pattern(projectile_pattern)
	
	move_and_slide()



func shoot_projectile_with_pattern(pattern_num: int):
	match pattern_num:
		1:
			if ENEMY_PROJECTILE:
				var projectile = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile)
				projectile.global_position = self.global_position
				projectile.rotation = self.rotation + projectile_rotation
				projectile.SPEED = self.projectile_speed
				
				move_to_player()
		
		2:
			if ENEMY_PROJECTILE:
				var projectile = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile)
				projectile.global_position = self.global_position
				projectile.rotation = self.rotation + projectile_rotation
				projectile.SPEED = self.projectile_speed
				
				var projectile1 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile1)
				projectile1.global_position = self.global_position
				projectile1.rotation = self.rotation + deg_to_rad(30) + projectile_rotation
				projectile1.SPEED = self.projectile_speed
			
				var projectile2 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile2)
				projectile2.global_position = self.global_position
				projectile2.rotation = self.rotation + deg_to_rad(330) + projectile_rotation
				projectile2.SPEED = self.projectile_speed
				
				move_to_player()

		3:
			if ENEMY_PROJECTILE:
				if projectile_rotation_is_different == false:
					projectile_rotation += 9
					if projectile_rotation > 90:
						projectile_rotation_is_different = true
				elif projectile_rotation_is_different == true:
					projectile_rotation -= 9
					if projectile_rotation < 0:
						projectile_rotation_is_different = false
				
				var projectile = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile)
				projectile.global_position = self.global_position
				projectile.rotation = self.rotation + deg_to_rad(projectile_rotation)
				projectile.SPEED = self.projectile_speed
			
				var projectile1 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile1)
				projectile1.global_position = self.global_position
				projectile1.rotation = self.rotation + deg_to_rad(90) + deg_to_rad(projectile_rotation)
				projectile1.SPEED = self.projectile_speed
			
				var projectile2 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile2)
				projectile2.global_position = self.global_position
				projectile2.rotation = self.rotation + deg_to_rad(180) + deg_to_rad(projectile_rotation)
				projectile2.SPEED = self.projectile_speed

				
				var projectile3 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile3)
				projectile3.global_position = self.global_position
				projectile3.rotation = self.rotation + deg_to_rad(270) + deg_to_rad(projectile_rotation)
				projectile3.SPEED = self.projectile_speed

		4:
			if ENEMY_PROJECTILE:
				projectile_rotation += 9
				
				if projectile_rotation >= 180:
					projectile_rotation = 0
					
				var projectile = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile)
				projectile.global_position = self.global_position
				projectile.rotation = self.rotation + deg_to_rad(projectile_rotation)
				projectile.SPEED = self.projectile_speed
			
				var projectile1 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile1)
				projectile1.global_position = self.global_position
				projectile1.rotation = self.rotation + deg_to_rad(90) + deg_to_rad(projectile_rotation)
				projectile1.SPEED = self.projectile_speed
			
				var projectile2 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile2)
				projectile2.global_position = self.global_position
				projectile2.rotation = self.rotation + deg_to_rad(180) + deg_to_rad(projectile_rotation)
				projectile2.SPEED = self.projectile_speed

				
				var projectile3 = ENEMY_PROJECTILE.instantiate()
				get_tree().current_scene.add_child(projectile3)
				projectile3.global_position = self.global_position
				projectile3.rotation = self.rotation + deg_to_rad(270) + deg_to_rad(projectile_rotation)
				projectile3.SPEED = self.projectile_speed
	shooting_rate.start()

func move_to_player():
	velocity = (player.position - position).normalized() * ESSpeed
	turn_to_player_direction()

func turn_to_player_direction():
	projectile_rotation = enemy_rotation_direction.angle_to_point(velocity)


func _on_detecting_area_area_entered(area):
	
	ES_STATE = State.ATTACK
	projectile_pattern = randi_range(1, 4)
	#print("Attacking")


func _on_detecting_area_area_exited(area):
	
	ES_STATE = State.IDLE
	#print("Idle")


func _on_hurt_box_area_entered(area):
	ESHealth -= 1


func _on_es_health_changed():
	if ESHealth == 0:
		queue_free()
