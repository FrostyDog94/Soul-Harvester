extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_tree().get_root().get_node("World/YSort/Player")
var target
var conga_offset = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	


func _physics_process(delta):
	var dir = (target.position - position).normalized()
	if position.distance_to(target.position) > conga_offset:
		move_and_collide(dir * player.speed * delta)
	$AnimationPlayer.play("Float")
	
	if position.x > player.global_position.x:
		$Sprite.scale.x = 1
		
	if position.x < player.global_position.x:
		$Sprite.scale.x = -1
		
