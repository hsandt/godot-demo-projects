extends Area2D

var in_area = []
var from_player


# Called from the animation.
func explode():
	if not is_network_master():
		# Explode only on master.
		return
	for p in in_area:
		if p.has_method("exploded"):
			# Checks if there is wall in between bomb and the object
			var world_state = get_world_2d().direct_space_state
			var result  = world_state.intersect_ray(position, p.position)
			if not result.collider is TileMap:
				# Exploded has a master keyword, so it will only be received by the master.
				p.rpc("exploded", from_player)


func done():
	queue_free()


func _on_bomb_body_enter(body):
	if not body in in_area:
		in_area.append(body)


func _on_bomb_body_exit(body):
	in_area.erase(body)
