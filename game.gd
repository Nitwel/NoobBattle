extends Node

var players = [
	Player.new("Nils"),
	Player.new("Paul"),
	Player.new("Pia"),
]
var turn = 0

signal stats_changed

func next_turn():
	turn = (turn + 1) % players.size()


func _ready():
	pass # Replace with function body.

func get_player(player_name: String):
	for player in players:
		if player.name.to_lower() == player_name.to_lower():
			return player
	return null

class Player:
	var name: String
	var money: int
	var speed: int
	var armor: int
	var damage: int
	var health: int
	var position: Map.MOVE_NODES

	func _init(player_name: String):
		self.name = player_name
		self.money = 0
		self.speed = 10
		self.armor = 20
		self.damage = 10
		self.health = 100
		self.position = Map.MOVE_NODES.start
