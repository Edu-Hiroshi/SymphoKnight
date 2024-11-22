extends Node2D

# List of beat times in seconds
var beat_times = [0.150, 1.011, 2.405, 3.276, 4.496, 5.437, 6.657, 7.668, 8.819, 9.725, 11.014, 12.060, 13.210, 14.430, 
15.406, 16.278, 17.463]
var current_beat_index = 0
var tolerance = 0.05  # Buffer to account for small timing mismatches
var is_white = true

@onready var song = $AudioStreamPlayer
@onready var color_rect = $ColorRect

func _ready():
	song.play()

func _process(delta):
	# Get the current playback time of the song
	var current_time = song.get_playback_position()

	# Check if there are more beats to process
	if current_beat_index < beat_times.size():
		var next_beat_time = beat_times[current_beat_index] - 0.05

		# Check if we're within the tolerance range of the next beat
		if current_time >= next_beat_time - tolerance:
			change_color()
			current_beat_index += 1

func change_color():
	if is_white:
		color_rect.color = Color(1, 0, 0)  # Set to red
	else:
		color_rect.color = Color(1, 1, 1)  # Set to white
	is_white = !is_white

func _on_audio_stream_player_finished():
		# Reset everything for looping
	current_beat_index = 0
	is_white = true
	color_rect.color = Color(1, 1, 1)  # Reset to white
	song.play()
