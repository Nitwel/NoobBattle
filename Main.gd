extends Node2D

@onready
var wheel = $wheel
@onready var label = $Label

func _on_wheel_spin_finished(option):
	label.text = option