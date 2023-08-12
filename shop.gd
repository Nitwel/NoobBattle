extends Node2D

signal finish_shopping

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_button_pressed():
	finish_shopping.emit()


func _on_wand_button_pressed():
	var player = Game.get_current_player()
	if player.money >= 70:
		player.money -= 70
		player.health += 100


func _on_dunno_button_pressed():
	pass # Replace with function body.


func _on_boots_button_pressed():
	var player = Game.get_current_player()
	if player.money >= 30:
		player.money -= 30
		player.speed += 10


func _on_sword_button_pressed():
	var player = Game.get_current_player()
	if player.money >= 40:
		player.money -= 40
		player.damage += 20

func _on_armor_button_pressed():
	var player = Game.get_current_player()
	if player.money >= 35:
		player.money -= 35
		player.armor += 15


func _on_chest_button_pressed():
	pass
