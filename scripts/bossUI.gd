extends Control

# la interfaz se actualiza con los cambios que ocurren en "gameController.gd"

var health

# Called when the node enters the scene tree for the first time.
func _ready():
#	health es la barra de vida del jefe, un ProgressVar (la verde)
	health = $playerUI/health
#	ProgressBar tiene un minimo,un maximo y un actual
	health.min_value = 0
	health.max_value = get_parent().get_parent().get_node("enemies/boss").health

# actualizar el value actual de la vida
func _process(delta):
	health.value = get_parent().get_parent().get_node("enemies/boss").health
	print(get_parent().get_parent().get_node("enemies/boss").health)

