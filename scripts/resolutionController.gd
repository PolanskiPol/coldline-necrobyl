extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_res1_pressed():
	$res2.pressed = false
	$res3.pressed = false
	OS.window_size = Vector2(1280, 720)


func _on_res2_pressed():
	$res1.pressed = false
	$res3.pressed = false
	OS.window_size = Vector2(1366, 768)


func _on_res3_pressed():
	$res1.pressed = false
	$res2.pressed = false
	OS.window_size = Vector2(1920, 1080)
