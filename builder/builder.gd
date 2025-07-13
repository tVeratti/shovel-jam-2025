class_name Builder
extends GridMap


const GRID_CELL_SIZE:float = 1.0


var build_area_width:int = 5
var build_area_height:int = 5


@onready var highlighter:MeshInstance3D = %Highlighter


func _process(delta):
	highlight_mouse_position()


func highlight_mouse_position() -> void:
	var coordinates: = get_mouse_coordinates()
	if get_used_cells().has(coordinates):
		highlighter.show()
		var position_real: = map_to_local(coordinates)
		highlighter.global_position = Vector3(position_real.x, 0, position_real.z)
	else:
		pass


## Convert mouse global position to grid coordinates.
func get_mouse_coordinates() -> Vector3i:
	var mouse_position: = _get_mouse_position()
	var map_real: = local_to_map(mouse_position)
	return Vector3(map_real.x, 0, map_real.z)


func _get_mouse_position() -> Vector3:
	var viewport: = get_viewport()
	var mouse_position: = viewport.get_mouse_position()
	var camera: = viewport.get_camera_3d()
	
	if camera:
		var ray_origin: = camera.project_ray_origin(mouse_position)
		var ray_direction: = camera.project_ray_normal(mouse_position)
		var ray_length: = camera.far
		var ray_end: = ray_origin + ray_direction * ray_length

		var space_state: = get_world_3d().direct_space_state
		var query: = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var result: = space_state.intersect_ray(query)

		if result:
			return result.get("position", ray_end)
		else:
			return ray_end
	else:
		return Vector3.ZERO
