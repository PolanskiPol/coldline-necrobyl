extends Area2D

var tint
var tintOldColor
var white

# Called when the node enters the scene tree for the first time.
func _ready():
	tint = get_parent().get_parent().get_node("tint")
	tintOldColor = tint.color
	white = Color(1, 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_tintChanger_entered(body):
	$Tween.interpolate_property(tint, "color", white, tintOldColor, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	print("EN ", tint.color)

func _on_tintChanger_exited(body):
	$Tween.interpolate_property(tint, "color", tintOldColor, white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	print("EX ", tint.color)
