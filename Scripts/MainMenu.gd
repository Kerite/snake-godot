extends Node

var config_data = preload("res://Scripts/ConfigData.gd")

func _ready():
	pass

func _on_BackButton_pressed():
	$Menu.visible = true
	$ColorRect/BackButton.visible = false

func _on_OptionMenu_pressed():
	$Menu.visible = false
	$ColorRect/BackButton.visible = true
	$Options.visible = true

func _on_StartGame_pressed():
	get_tree().change_scene("res://SnakeMainScene.tscn")


func _on_BoadrSizeSlider_value_changed(value):
	$Options/BoardSizeLabel.text = str(value)
	ConfigData.board_size = int(value)


func _on_BombNumSlider_value_changed(value):
	$Options/BombNumLabel.text = str(value)
	ConfigData.bomb_num = int(value)
