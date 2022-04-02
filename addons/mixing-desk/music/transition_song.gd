extends Node

#internal vars
var song_type = "transition"
var fading_out : bool = false
var fading_in : bool = false
var muted_tracks = []
var concats : Array
var ignore = true

#external properties
@export var tempo: int
@export var bars: int
@export var beats_in_bar: int
@export var target_song: NodePath
@export var transition_beats: float
@export var auto_transition: bool
@export var auto_signal_node: NodePath
@export var auto_signal: String
@export var transition_type: String, "Beat", "Bar"
@export var bus: String = "Music"

func _ready():
	if auto_transition:
		var sig_node = get_node(auto_signal_node)
		sig_node.connect(auto_signal, self, "_transition", [transition_type])
	var busnum = AudioServer.get_bus_index(bus)
	if busnum == -1:
		var new_bus = AudioServer.add_bus(AudioServer.bus_count)
		AudioServer.set_bus_name(AudioServer.bus_count - 1, bus)
		if bus != "Music":
			AudioServer.set_bus_send(AudioServer.get_bus_index(bus),"Music")
	for i in get_children():
		for o in i.get_children():
			o.set_bus(bus)

func _transition(type):
	match type:
		"Beat":
			get_parent().queue_beat_transition(name)
		"Bar":
			get_parent().queue_bar_transition(name)

func _get_core():
	for i in get_children():
		if i.cont == "core":
			return i
