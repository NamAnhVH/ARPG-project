extends Node

@onready var music_audio_stream : AudioStreamPlayer2D = $BackgroundMusic

var is_music_on : bool = true

func play_start_game_background_music():
	music_audio_stream.stream = ResourceManager.get_music("start_game")
	if is_music_on:
		music_audio_stream.volume_db = -10
		music_audio_stream.pitch_scale = 1
		music_audio_stream.play()
	else:
		music_audio_stream.stop()

func play_in_game_background_music():
	music_audio_stream.stream = ResourceManager.get_music("in_game")
	if is_music_on:
		music_audio_stream.volume_db = -15
		music_audio_stream.pitch_scale = 0.8
		music_audio_stream.play()
	else:
		music_audio_stream.stop()
