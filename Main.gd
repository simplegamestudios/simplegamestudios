extends Node

var Planet = preload("res://Main Game Objects/Planet.tscn")
var Jumper = preload("res://Main Game Objects/Jumper.tscn")

var player
var score = 0 setget set_score
var level = 0
var highscore = 0

func _ready():
	randomize()
	load_score()
	$HUD.hide()
	
func new_game():
	Settings.hide_ad_banner()
	self.score = 0
	level = 1
	$HUD.update_score(score)
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "_on_Jumper_died")
	spawn_planet($StartPosition.position)
	$HUD.show()
	$HUD.show_message("Go")
	if Settings.enable_music:
		$Audio.play()
	
func spawn_planet(_position=null):
	var c = Planet.instance()
	if !_position:
		var x = rand_range(-250, 450)
		var y = rand_range(-1000, -750)
		_position =  player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)
	
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_planet")
	self.score += 1

func set_score(value):
	score = value
	$HUD.update_score(score)
	if score > 0 and score %  Settings.planets_per_level == 0:
		level += 1
		$HUD.show_message("L %s" % str(level))
	
func _on_Jumper_died():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().call_group("Planets", "Explode")
	$Screens.game_over(score, highscore)
	$HUD.hide()
	if Settings.enable_music:
		$Audio.stop()
		Settings.show_intersitial()
		
func load_score():
	var f = File.new()
	if f.file_exists(Settings.score_file):
		f.open(Settings.score_file, File.READ)
		highscore = f.get_var()
		f.close()

func save_score():
	var f = File.new()
	f.open(Settings.score_file, File.WRITE)
	f.store_var(highscore)
	f.close()

