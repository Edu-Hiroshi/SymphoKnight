extends Node2D

# List of beat times in seconds
var beat_times = [0.06965986,0.60371882,1.13777778,1.67183673,2.20589569,2.7631746
,3.29723356,3.87773243,4.41179138,4.94585034,5.4799093,6.03718821
,6.57124717,7.12852608,7.68580499,8.26630385,8.77714286,9.33442177
,9.86848073,10.40253968,10.95981859,11.51709751,12.05115646,12.58521542
,13.14249433,13.67655329,14.21061224,14.76789116,15.30195011,15.85922902
,16.39328798,16.92734694,17.48462585,18.01868481,18.57596372,19.11002268
,19.66730159,20.20136054,20.75863946,21.29269841,21.84997732,22.38403628
,22.94131519,23.47537415,24.03265306,24.56671202,25.12399093,25.65804989
,26.2153288,26.74938776,27.30666667,27.84072562,28.39800454,28.93206349
,29.4893424,30.02340136,30.58068027,31.13795918,31.67201814,32.2060771
,32.69369615,33.15809524,33.64571429,34.13333333,34.66739229,35.20145125
,35.75873016,36.29278912,36.82684807,37.38412698,37.9414059,38.47546485
,39.03274376,39.56680272,40.12408163,40.65814059,41.19219955,41.74947846
,42.30675737,42.84081633,43.39809524,43.9321542,44.48943311,45.02349206
,45.58077098,46.11482993,46.67210884,47.2061678,47.76344671,48.29750567
,48.85478458,49.38884354,49.92290249,50.48018141,51.01424036,51.57151927
,52.12879819,52.6860771,53.22013605,53.75419501]
var current_beat_index = 0
var tolerance = 0.05  # Buffer to account for small timing mismatches
var is_white = true  # Track the current color state

# Assuming you have an AudioStreamPlayer node to play the song
@onready var song = $AudioStreamPlayer
@onready var color_rect = $ColorRect  # Reference to the ColorRect child node

func _ready():
	# Start playing the song
	song.play()

func _process(delta):
	# Get the current playback time of the song
	var current_time = song.get_playback_position()

	# Reset if song has looped
	if current_beat_index >= beat_times.size() or current_time < beat_times[current_beat_index]:
		current_beat_index = 0

	# Check if the playback time is close to the next beat time, with a tolerance buffer
	if current_beat_index < beat_times.size() and abs(current_time - beat_times[current_beat_index]) <= tolerance:
		change_color()
		current_beat_index += 1  # Move to the next beat

func change_color():
	# Toggle color between white and red
	if is_white:
		color_rect.color = Color(1, 0, 0)  # Set to red
	else:
		color_rect.color = Color(1, 1, 1)  # Set to white
	
	is_white = !is_white  # Toggle the color state
