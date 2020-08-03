extends Node2D

var tile_script = preload("res://Scripts/Tile.gd")

export(NodePath) var map_node_path
var _map

export(NodePath) var ally_selected_state_path
var _ally_selected_state

export(NodePath) var baddy_turn_state_path
var _baddy_turn_state

export(NodePath) var pathfinder_path
var _pathfinder

var enabled = false

func _ready():
	_map = get_node(map_node_path)
	_ally_selected_state = get_node(ally_selected_state_path)
	_baddy_turn_state = get_node(baddy_turn_state_path)
	_pathfinder = get_node(pathfinder_path)

func enter():
	enabled = true
	
	var allies = _map.get_allies()
	var selectable_count = allies.size()
	for ally in allies:
		if not ally.selectable:
			selectable_count -= 1
	
	if selectable_count == 0:
		enabled = false
		_pathfinder.clear_search()
		_baddy_turn_state.enter()
	
	

func _input(event):
	if not enabled:
		return
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if not _map.is_valid_world_position(event.position):
			return
			
		var tile = _map.get_tile_from_world(event.position)
		
		if tile.current_state == tile_script.State.UNIT_ALLY:
			var ally = tile.unit
			if ally.selectable:
				enabled = false
				_ally_selected_state.enter(ally)
	
	"""
	TEMPORARY reversal testing
	"""
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		print("CLci")
		if not _map.is_valid_world_position(event.position):
			return
			
		var tile = _map.get_tile_from_world(event.position)
		print("valid tile")
		if tile.current_state == tile_script.State.UNIT_ALLY:
			print("ally")
			var ally = tile.unit
			if not ally.selectable:
				print("ally selectable")
				ally.reverse()
