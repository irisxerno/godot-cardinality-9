extends Control


var tiles = []
var tile_size = 150


func world_from_data(world):
	var tile_scene = preload("res://scene/Tile.tscn")
	var card_scene = preload("res://scene/Card.tscn")
	var row = 0
	var col = 0 
	for dat in world:
		var tile = tile_scene.instance()
		tile.cards = dat["cards"]
		tile.armories = dat["armories"]
		tile.rect_position += Vector2(tile_size*row + tile_size/2*col, -tile_size*col)
		tile.connect("request_select", self, "request_select")
		add_child(tile)
		tiles.append(tile)
		row += 1
		if row > 4-col:
			row = 0
			col += 1
