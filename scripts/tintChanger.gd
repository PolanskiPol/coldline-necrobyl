extends Area2D

var tint
var tintOldColor
var white
var black

# Called when the node enters the scene tree for the first time.
func _ready():
	tint = get_parent().get_parent().get_node("tint")
	tintOldColor = tint.color
	white = Color(1, 1, 1)
	black = Color(0.2, 0.2, 0.2)
	
# cambiar tinte a oscuro cuando se entra en un espacio cerrado
func _on_tintChanger_entered(body):
	if(body.name == "player"): # solo si entra el jugador
		$Tween.stop_all()
		tintOldColor = tint.color
		$Tween.interpolate_property(tint, "color", tintOldColor, black, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.start()
		body.get_node("flashlight").visible = true
		body.get_node("flashlightSound").play(0)

# cambiar tinte a claro cuando se entra en un espacio cerrado
func _on_tintChanger_exited(body):
	if(body.name == "player"): # solo si entra el jugador
		$Tween.stop_all()
		tintOldColor = tint.color
		$Tween.interpolate_property(tint, "color", tintOldColor, white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
		$Tween.start()
		body.get_node("flashlight").visible = false
		body.get_node("flashlightSound").play(0)
