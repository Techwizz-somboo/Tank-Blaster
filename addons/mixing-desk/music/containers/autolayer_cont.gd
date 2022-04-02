extends Node

enum play_mode {additive, single, pad}
@export var play_style: play_mode
@export var layer_min: int
@export var layer_max: int
@export var automate: bool = false
@export var target_node: NodePath
@export var target_property: String
@export var min_range: float = 0.0
@export var max_range: float = 1.0
@export var pad: int = 0
@export var invert: bool
@export var track_speed: float

var target
var num = 0.0
var t_layer
var cont = "autolayer"

func _ready():
	get_node(^"../..").connect(&"beat", self._update)
	target = get_node(target_node)
	init_layers()
	
func _update(beat):
	_set_layers_values()
	_fade_layers()
	
func init_layers():
	_set_layers_values()
	for i in range(get_child_count()):
		var child = get_child(i)
		if i != -1:
			if i < layer_min or i > layer_max:
				child.volume_db = -65
			else:
				child.volume_db = 0
	
func _set_layers_values():
	t_layer = layer_max
	if automate:
		num = target.get(target_property)
		if not invert:
			num -= min_range
		else:
			num *= -1
			num += max_range
		num /= abs(max_range - min_range)
		num *= (get_child_count())
		t_layer = clamp(floor(num), -1, get_child_count() - 1)
	match play_style:
		play_mode.additive:
			layer_min = -1
			layer_max = t_layer
		play_mode.single:
			layer_min = t_layer
			layer_max = t_layer
		play_mode.pad:
			if pad != 0:
				layer_min = t_layer - pad
				layer_max = t_layer + pad

func _fade_layers():
	for i in range(get_child_count()):
		var child = get_child(i)
		if i != -1:
			if i < layer_min or i > layer_max:
				_fade_to(child,-65)
			else:
				_fade_to(child,0)
				
func is_equal(a : float,b : float):
	return int(a) == int(b)

func _fade_to(target, vol):
	var is_match
	var cvol = target.volume_db
	var sum = vol - cvol
	is_match = is_equal(vol,cvol)
	if not is_match:
		if cvol > vol:
			if track_speed < 1.0:
				cvol -= 1.5 / (1.0 - track_speed )
			else:
				cvol = vol
		else:
			cvol = lerp(cvol,vol,track_speed)
		target.volume_db = cvol
	else:
		if vol == 0:
			if cvol != vol:
				target.volume_db = 0
		elif cvol != vol:
			target.volume_db = vol
