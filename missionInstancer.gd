extends Area2D

export (PackedScene) var mission = null

var missionInstance
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_missionInstancer_body_entered(body):
	if(body.name == "player"):
		missionInstance = mission.instance()
		get_parent().get_parent().add_child(missionInstance)
		get_parent().get_parent().enterExploreMusic()
		
func _on_missionInstancer_body_exited(body):
	if(body.name == "player"):
		get_parent().get_parent().remove_child(missionInstance)
		missionInstance = null
		get_parent().get_parent().enterActionMusic()
