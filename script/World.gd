extends Node2D

var tiles = []
var tile_size = 150

func world_from_data(world):
	var enemy_scene = preload("res://scene/Tile.tscn")
	var card_scene = preload("res://scene/Card.tscn")
	var row = 0
	var col = 0 
	for dat in world:
		var enemy = enemy_scene.instance()
		for c_dat in dat["cards"]:
			var card = card_scene.instance()
			card.value = c_dat["value"]
			card.suit = c_dat["suit"]
			card.face_up = false
			enemy.cards.append(card)
		for k in dat["armories"]:
			# TODO: create armory node2d
			pass
		enemy.position += Vector2(tile_size*row + tile_size/2*col, -tile_size*col)
		add_child(enemy)
		row += 1
		if row > 4-col:
			row = 0
			col += 1

