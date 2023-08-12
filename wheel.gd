@tool
extends Node2D

# scene root node
@onready var wheel_of_fortune = get_parent()

#            dark red,          red,              purple,           dark purple,      dark blue,        blue,              turquoise,        dark turquoise,    dark green,         green,              yellow,            orange,           dark orange,      blood red 
var colors = [Color("#C0392B"), Color("#E74C3C"), Color("#9b59b6"), Color("#8e44ad"), Color("#2980b9"), Color("#3498db"),  Color("#1abc9c"), Color("#16a085"),  Color("#27ae60"),   Color("#2ecc71"),   Color("#f1c40f"),  Color("#f39c12"), Color("#e67e22"), Color("#d35400")] 

var font = preload('res://assets/fonts/Virgil.woff2')
var labels: Array[Label] = []

func _ready():
	update_labels()
	
func update_labels():
	print("update labels")
	colors.shuffle()
	# Create new Labels
	
	if labels.size() > 0:
		for label in labels:
			remove_child(label)
			
		labels = []

	for option in wheel_of_fortune.options:
		var label = Label.new()
		label.text = option.name
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", font)
		# Add label to the scene
		labels.push_back(label)
		add_child(label)

func _draw():
	var last_angle = 0.0
	for i in wheel_of_fortune.options.size():
		var option = wheel_of_fortune.options[i]
		var color = option.color if option.has('color') else colors[i]
		var angle = option.chance * 360
		draw_circle_arc_poly(Vector2(0, 0), wheel_of_fortune.circle_radius, last_angle, last_angle + angle, color)
	
		var middle_angle = last_angle + angle / 2 - 90
		var label = labels[i]

		var label_size = label.get_theme_font('font').get_string_size(label.text)
		
		label.pivot_offset = Vector2(-(wheel_of_fortune.circle_radius - wheel_of_fortune.text_offset - label_size.x), label_size.y / 2)
		label.scale = Vector2(1, 1)
		label.position = Vector2(-label.pivot_offset.x, -label_size.y / 2)
		label.rotation = deg_to_rad(middle_angle)

		last_angle += angle

func random_color():
	return colors[randi() % colors.size()]

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
