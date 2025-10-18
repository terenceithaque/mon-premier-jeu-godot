extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop() # Arrêter le timer du score (puisque 1 seconde = 1 point gagné)
	$MobTimer.stop()


func new_game():
	score = 0 # Initialiser le score
	$Player.start($StartPosition.position) # Initialiser la position du joueur
	$StartTimer.start() # Démarrer le timer de départ



# Fonction appelée quand le timer de départ est terminé
func _on_start_timer_timeout() -> void:
	$MobTimer.start() # Commencer l'apparition des mobs
	$ScoreTimer.start()



# Fonction appelée quand le timer du score est terminé
func _on_score_timer_timeout() -> void:
	score += 1 # Incrémenter le score

# Fonction appelée quand le timer d'apparition des mobs est terminé
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # Créer un premier mob
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation") # Récupérer la position de spawn du mob
	# Le progres ratio représente le pourcentage d'évolution du monstre sur le MobPath
	# On prend donc un point aléatoire entre le début et la fin de ce chemin.
	mob_spawn_location.progress_ratio = randf()
	
	# Direction du monstre
	# La rotation du MobPath change en fonction de la direction
	# Cette ligne permet de définir la direction comme perpendiculaire au point d'apparition
	# du mob
	var direction = mob_spawn_location.rotation + PI / 2;
	
	mob.position = mob_spawn_location.position;
	
	# Choisir une vitesse aléatoire différente pour chaque mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob) # Ajouter l'instance du monstre à la scène
