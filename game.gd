extends Node

var players = [
	Player.new("Nils", Vector2(0, 0)),
	Player.new("Paul", Vector2(0, 0)),
	Player.new("Pia", Vector2(0, 0)),
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

func get_current_player():
	return players[turn]

class Player:
	var name: String
	var money: int
	var speed: int
	var armor: int
	var damage: int
	var health: int
	var node: Map.MOVE_NODES
	var offset: Vector2

	func _init(player_name: String, offset: Vector2):
		self.name = player_name
		self.money = 0
		self.speed = 10
		self.armor = 20
		self.damage = 10
		self.health = 100
		self.node = Map.MOVE_NODES.start
		self.offset = offset
