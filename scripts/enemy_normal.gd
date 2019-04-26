extends KinematicBody2D

export var speed = 4
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	moveToPlayer()

func moveToPlayer():
	if(target):
		$wallBetween.cast_to = (target.position - position).normalized()
		rotation = (target.position - position).angle()
		move_and_collide((target.position - position).normalized()*speed)


func _on_vision_entered(body):
	if(body.name == "player"):
		target = body

func _on_vision_exited(body):
	if body == target:
		target = null

func _on_attack_entered(body):
	print("ATTACKING")

func _on_attack_exited(body):
	print("NOT ATTACKING")
