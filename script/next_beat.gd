extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var index_0: TextureRect = $"HBoxContainer/index0"
@onready var index_1: TextureRect = $"HBoxContainer/index1"
@onready var index_2: TextureRect = $"HBoxContainer/index2"

var red = preload("res://sprites/ui/inconRED.png")
var green = preload("res://sprites/ui/inconGREEN.png")
var blue = preload("res://sprites/ui/inconBLUE.png")

var r = Color(1, 0, 0)
var g = Color(0, 1, 0)
var b = Color(0, 0, 1)
var w = Color(1, 1, 1)

var color_map = {
	r: red,
	g: green,
	b: blue
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var next_beats = global.next_beats
	
	if next_beats:
		for beat_index in range(next_beats.size()):
			var beat_color = next_beats[beat_index]
			if beat_index == 0:
				index_0.texture = color_map[beat_color]
			elif beat_index == 1:
				index_1.texture = color_map[beat_color]
			elif  beat_index == 2:
				index_2.texture = color_map[beat_color] 
			
			
	
		
	
