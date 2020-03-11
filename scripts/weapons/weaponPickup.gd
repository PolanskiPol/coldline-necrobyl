extends Area2D

export(PackedScene) var weaponToPick = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# hacer cura al entrar en el area
func _on_healthPickup_body_entered(body):
	if(body.name == "player"):
		body.addPlayerWeapon(weaponToPick.get_path())
		get_parent().remove_child(self)
