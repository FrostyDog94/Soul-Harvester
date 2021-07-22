extends KinematicBody2D

var friction = 800
var accel = 500
var speed  = 175
var dashSpeed = 1500
var velocity = Vector2.ZERO
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
var state_machine
var souls = []
var root = get_parent()
var soulObj = preload("res://Scenes/Soul/Soul.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	set_process(true)
	state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
		sprite.scale.x = 1
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
		sprite.scale.x = -1
		
	
		
	if input_vector != Vector2.ZERO:
		state_machine.travel("Run")
		velocity += input_vector * accel * delta
		velocity = velocity.clamped(speed)
		velocity.normalized()
		
	else:
		state_machine.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	
	move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_interact"):
		state_machine.travel("Attack")
		
		
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.travel("Dash")
		if sprite.scale.x > 0:
			move_and_slide(Vector2.LEFT * dashSpeed)
		elif sprite.scale.x < 0:
			move_and_slide(Vector2.RIGHT * dashSpeed)
			



func _on_leftArea_body_entered(body):
	if body.is_in_group("NPC") and body.isDead == false:
		var soulInstance = soulObj.instance()
		soulInstance.position = body.position
		get_tree().get_root().add_child(soulInstance)
		souls.append(soulInstance)
		if souls.size() == 1:
			soulInstance.target = self
		elif souls.size() > 1:
			soulInstance.target = souls[souls.size() - 2]
		body.die()
		print(soulInstance.target)


	
func _add_soul(soul):
	souls.append(soul)
