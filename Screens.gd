extends Node

signal start_game

var sound_buttons = {true: preload("res://Assets/Buttons/Audio On.png"),
					 false: preload("res://Assets/Buttons/Audio Off.png")}
var music_buttons = {true: preload("res://Assets/Buttons/Music On.png"),
					 false: preload("res://Assets/Buttons/Music Off.png")}

var current_screen = null

func _ready():
	register_buttons()
	change_screen($TitleScreen)
	
func register_buttons():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])
		
func _on_button_pressed(Buttons):
	if Settings.enable_sound:
		$Click.play()
	match Buttons.name:
		"Home":
			change_screen($TitleScreen)
		"Play":
			change_screen(null)
			yield(get_tree().create_timer(0.5), "timeout")
			emit_signal("start_game")
		"_Settings":
			change_screen($SettingsScreen)
		"Sound":
			Settings.enable_sound = !Settings.enable_sound
			Buttons.texture_normal = sound_buttons[Settings.enable_sound]
		"Music":
			Settings.enable_music = !Settings.enable_music
			Buttons.texture_normal = music_buttons[Settings.enable_music]
		"About":
			change_screen($AboutScreen)
		"Info":
			change_screen($InfoScreen)
			
func change_screen(new_screen):
	if current_screen:
		current_screen.disappear()
		yield(current_screen.tween, "tween_completed")
	current_screen = new_screen
	if new_screen:
		current_screen.appear()
		yield(current_screen.tween, "tween_completed")
		
func game_over(score, highscore):
	var score_box = $GameOverScreen/Scores
	score_box.get_node("Score").text = " %s" % score
	score_box.get_node("Best").text = " %s" % highscore
	change_screen($GameOverScreen)
		





