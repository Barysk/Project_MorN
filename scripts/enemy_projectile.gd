extends Area2D

@export var SPEED: int = 100
@onready var projectile_live = $ProjectileLive

enum type{
	DEFAULT,	# player can break
	STRONG,		# player cannot break +probably I need to add one more collision
}

func _ready():
	projectile_live.start()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()

func _on_projectile_live_timeout():
	destroy()
