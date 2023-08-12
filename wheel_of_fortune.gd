@tool
extends Node2D

@export
var options = [
	{ "name": "Option 1", "chance": 0.3},
	{ "name": "Option 2", "chance": 0.2},
	{ "name": "Option 3", "chance": 0.1},
	{ "name": "Option 4", "chance": 0.4},
] :
	get:
		return options
	set(value):
		options = value
		var totalChance = 0
		for option in options:
			totalChance += option.chance
		for option in options:
			option.chance /= totalChance
		
		wheel.update_labels()
	


var text_offset = 70
var circle_radius = 310
@export
var speed = 0.0
var is_spin_finished = true
@onready var wheel = $wheel

signal spin_finished(option: String)

func _process(delta):
	if speed > 0:
		wheel.rotate(speed * delta)
		speed = max(0, speed - 2 * max(0.1, speed * 0.3) * delta)
	elif not is_spin_finished:
		var angle = int(wheel.get_rotation_degrees()) % 360
		is_spin_finished = true
		print(angle)

		var option = get_option((360 + 90 - angle) % 360)

		print(option)
		
		if option.has('callback'):
			option.get('callback').call()

		if option != null:
			emit_signal('spin_finished', option.name)

func spin():
	if speed > 0: return
	
	is_spin_finished = false
	speed = 20 + randf() * 40

func get_option(angle):
	var last_angle = 0.0
	for i in options.size():
		var option = options[i]
		var angle_option = option.chance * 360
		if angle >= last_angle and angle < last_angle + angle_option:
			return option
		last_angle += angle_option
	return null




func _on_button_pressed():
	spin()
