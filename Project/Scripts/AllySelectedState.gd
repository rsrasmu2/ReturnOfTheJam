extends Node2D


export(NodePath) var map_node_path
var _map

export(NodePath) var pathfinder_node_path
var _pathfinder

export(NodePath) var ally_moving_state_path
var _ally_moving_state

export(NodePath) var ally_ability_selection_state_patch
var _ally_ability_selection_state

var _ally
var enabled = false

func _ready():
	_map = get_node(map_node_path)
	_pathfinder = get_node(pathfinder_node_path)
	_ally_moving_state = get_node(ally_moving_state_path)
	_ally_ability_selection_state = get_node(ally_ability_selection_state_patch)

func enter(ally):
	enabled = true
	_ally = ally
	_ally.selectable = false
	_pathfinder.set_starting_tile(_ally.current_tile)

func _input(event):
	if not enabled:
		return
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if _map.is_valid_world_position(event.position):
			var tile = _map.get_tile_from_world(event.position)
			if tile == _ally.current_tile:
				_pathfinder.clear_search()
				enabled = false
				_ally_ability_selection_state.enter(_ally)
				return
			
			var path = _pathfinder.get_path_from_tile(tile)
			if path.size() == 0:
				return
			
			enabled = false
			_ally_moving_state.enter(_ally, path)
		
	if event is InputEventMouseMotion:
		if _map.is_valid_world_position(event.position):
			var tile = _map.get_tile_from_world(event.position)
			var path = _pathfinder.get_path_from_tile(tile)
			_pathfinder.display_path(path)