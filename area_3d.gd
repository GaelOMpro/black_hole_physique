extends Area3D

# Puissance d'attraction globale
@export var gravity_strength : float = 3000.0

# PLAFOND DE FORCE
@export var max_gravity_force : float = 3000.0

@export var min_distance : float = 1.0
@export var max_speed : float = 20.0
@export var drag_factor : float = 2.0
@export var stop_pulling_distance : float = 2.0

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody3D and not body.freeze:
			pull_and_stabilize(body, delta)

func pull_and_stabilize(body: RigidBody3D, delta):
	var direction_vector = global_position - body.global_position
	var distance = direction_vector.length()
	
	# --- ZONE DE GLU ---
	if distance < stop_pulling_distance:

		body.linear_velocity = body.linear_velocity.lerp(Vector3.ZERO, 10.0 * delta)
		body.angular_velocity = body.angular_velocity.lerp(Vector3.ZERO, 10.0 * delta)
		return

	# --- CALCUL DE LA GRAVITÉ ---
	var direction_normalized = direction_vector.normalized()
	var effective_distance = max(distance, min_distance)
	
	var raw_force = gravity_strength / (effective_distance * effective_distance)
	
	var final_force = min(raw_force, max_gravity_force)
	
	body.apply_central_force(direction_normalized * final_force)
	
	# --- STABILISATION ---

	var damp_strength = clamp(drag_factor * delta, 0.0, 1.0)
	body.linear_velocity = body.linear_velocity.lerp(Vector3.ZERO, damp_strength)
	
	if body.linear_velocity.length() > max_speed:
		body.linear_velocity = body.linear_velocity.normalized() * max_speed
