extends Area2D
# Un signal permet au joueur d'envoyer un message lorsqu'il entre en collision avec quelque chose
signal hit

# L'instruction @export crée une variable et l'affiche dans l'inspecteur
@export var speed = 400
var screen_size 

# La fonction _ready() s'exécute au lancement du jeu
func _ready():
	# Récupérer les dimensions de la fenêtre de jeu
	screen_size = get_viewport_rect().size
	# Cacher le joueur au départ
	hide()
	

func _process(delta):
	# delta fait référence au temps écoulé depuis la frame précédente
	# vélocité initialisée à zéro (déplacement nul)
	var velocity = Vector2.ZERO
	# Déplacement vers la droite du personnage
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	# Déplacement vers la gauche du personnage
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	# Déplacement vers le bas du personnage
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	# Déplacement vers le haut du personnage	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1	
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		$AnimatedSprite2D.play()
		# Équivaut à get_node("AnimatedSprite2D").play()		
	
	else:
		$AnimatedSprite2D.stop()	
	
	# Mise à jour de la position
	# Multiplication de la vélocité par le temps écoulé depuis la dernière frame
	position += velocity * delta		
	# On empêche le personnage de sortir de l'écran avec la méthode clamp()
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Animation de déplacement horizontal
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		# Faire un flip de l'animation pour la faire à l'horizontale
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	# Animation de déplacement vertical
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		
		


func _on_body_entered(body: Node2D) -> void:
	# Code en cas de collision avec une entité
	hide() # On fait disparaître le joueur s'il est touché
	hit.emit() # Émettre le signal "hit"
	# La méthode set_deferred() permet de désactiver le noeud quand on n'en a plus besoin.
	$CollisionShape2D.set_deferred("disabled", true) # Désactiver la boîte de collision du joueur


# Fonction d'initialisation du joueur
func start(pos):
	# Position de départ du joueur
	position = pos
	show() # Afficher le joueur
	$CollisionShape2D.disabled = false # Activer la boîte de collision du joueur
