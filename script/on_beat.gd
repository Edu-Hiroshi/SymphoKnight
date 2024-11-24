extends Node2D

# List of beat times in seconds
var beat_times = [0.150, 1.011, 2.405, 3.276, 4.496, 5.437, 6.657, 7.668, 8.819, 9.725, 11.014,
12.060, 13.190, 14.200, 15.406, 16.278, 17.463, 18.500, 34.960, 35.760, 37.160, 38.000, 39.320,
40.120, 41.520, 42.360, 43.680, 44.480, 45.840, 46.680, 48.040, 48.440, 50.240, 51.080]

var current_beat_index = 0
var tolerance = 0.05  # Buffer to account for small timing mismatches
# var is_white = true

var r = Color(1, 0, 0)
var g = Color(0, 1, 0)
var b = Color(0, 0, 1)
var w = Color(1, 1, 1)
var beat_colors = [r, g, b, r, g, b, r, g, b, r, g, b, r, g, b, r, g, w,
b, r, r, g, b, r, g, b, r, g, b, r, g, b, r, g]

@onready var song = $AudioStreamPlayer
@onready var color_rect = $ColorRect

func _ready():
	song.play()

func _process(_delta):
	# Get the current playback time of the song
	var current_time = song.get_playback_position()

	# Check if there are more beats to process
	if current_beat_index < beat_times.size():
		var next_beat_time = beat_times[current_beat_index] - 0.05

		# Check if we're within the tolerance range of the next beat
		if current_time >= next_beat_time - tolerance:
			change_color()
			global.boss_on_beat = true
			$beatTimer.start()
			current_beat_index += 1

func change_color():
	color_rect.color = beat_colors[current_beat_index] # Set to color
	global.boss_attack_type = beat_colors[current_beat_index]
	
	#if is_white:
		#color_rect.color = beat_colors[current_beat_index] # Set to color
		#global.attack_type = beat_colors[current_beat_index]
	#else:
		#color_rect.color = Color(1, 1, 1)  # Set to white
	#is_white = !is_white

func _on_audio_stream_player_finished():
	# Reset everything for looping
	#is_white = true
	current_beat_index = 0
	color_rect.color = Color(1, 1, 1)  # Reset to white
	song.play()


func _on_beat_timer_timeout() -> void:
	global.boss_on_beat = false
	global.boss_current_attack = false
