extends RigidBody3D

func _ready():
	contact_monitor = true
	max_contacts_reported = 2

func _on_body_entered(body):

	if body.is_in_group("CORE") or (body is RigidBody3D and body.freeze):
		perform_freeze()

func perform_freeze():
	# On tue la vitesse (avant même le freeze)

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	call_deferred("freeze_now")

func freeze_now():
	freeze = true
	add_to_group("CORE")
	
