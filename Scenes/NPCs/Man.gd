extends KinematicBody2D


onready var player = get_tree().get_root().get_node("World/YSort/Player")
onready var sprite = $icon
var dir
var state_machine
var speed
onready var timer = $Timer
var soulObj = preload("res://Scenes/Soul/Soul.tscn")
var isDead

func _ready():
	isDead = false
	set_physics_process(true)
	state_machine = $AnimationTree.get("parameters/playback")
	timer.set_wait_time(1)
	randomize()


func _physics_process(delta):
	if position.distance_to(player.position) < 100:
		if isDead == false:
			dir = ((player.position - position).normalized()) * -1	
			move_and_collide(dir * 75 * delta)
			state_machine.travel("Run")
			if position.x > player.global_position.x:
				sprite.scale.x = -1
			if position.x < player.global_position.x:
				sprite.scale.x = 1
	else:
		state_machine.travel("Idle")
		move_and_collide(Vector2.ZERO)

func die():
	isDead = true
	move_and_collide(Vector2.ZERO)
	state_machine.travel("Die")
	$Particles2D.emitting = true
	timer.start()
	


func _on_Timer_timeout():
	self.queue_free()
