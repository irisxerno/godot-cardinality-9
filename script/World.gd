extends Control

signal select_tile

var tiles = []
var tile_rsize = 125
var tile_csize = 100


func world_from_data(world):
	var tile_scene = preload("res://scene/Tile.tscn")
	var card_scene = preload("res://scene/Card.tscn")
	var row = 0
	var col = 0 
	for dat in world:
		var tile = tile_scene.instance()
		tile.cards = dat["cards"]
		tile.armories = dat["armories"]
		tile.reward = dat["reward"]
		tile.row = row
		tile.col = col
		tile.rect_position += Vector2(tile_rsize*row + tile_rsize/2*col, -tile_csize*col)
		if col == 0:
			tile.state = "show"
		tile.connect("request_select", self, "request_select")
		add_child(tile)
		tiles.append(tile)
		row += 1
		if row > 4-col:
			row = 0
			col += 1


func ccount():
	var minc = 0
	var maxc = 0
	for tile in tiles:
		if tile.state == "defeated" or tile.state == "hide":
			continue
		if tile.col < minc:
			minc = tile.col
		if tile.col > maxc:
			maxc = tile.col
	var ccount = maxc - minc + 1
	return ccount


func request_select(inst):
	emit_signal("select_tile", inst)


func defeat(inst):
	inst.state = "defeated"
	inst.update()
	for tile in tiles:
		if tile.row > inst.row - 2 and tile.row < inst.row + 2 and tile.col > inst.col - 2 and tile.col < inst.col + 2:
			if not (tile.row - inst.row == tile.col - inst.col):
				tile.advance_state()
