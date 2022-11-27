extends Node


signal return_cards
signal update
signal card_data
signal reset


var savable = false

var stats
var armory
var world
var generator
var color

var saves = []

var magic = 1040447947


func archive():
	print("# TODO: scoreboard functionality")


func start():
	var save_game = File.new()
	var dir = Directory.new()
	if dir.file_exists("user://save"):
		save_game.open_compressed("user://save", File.READ, File.COMPRESSION_GZIP)
		var savefile = parse_json(save_game.get_line())
		if typeof(savefile) == 18 and "magic" in savefile:
			var svmg = savefile["magic"]
			if magic == svmg:
				saves = savefile["saves"]
		save_game.close()
	emit_signal("update", saves)

	if len(saves) > 0:
		load_next(-1)
	else:
		load_next(false)


func cards_to_data(c):
	var data = []
	for inst in c:
		data.append({
			"value": inst.value,
			"suit": inst.suit
		})
	return data


func get_cards(cards):
	if savable:
		save(cards)
	emit_signal("return_cards", cards)


func list_saves():
	var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.begins_with("save"):
			files.append(file)

	dir.list_dir_end()

	return files


func save_file():
	while len(saves) > 5:
		saves.pop_front()

	var save_game = File.new()
	save_game.open_compressed("user://save", File.WRITE, File.COMPRESSION_GZIP)
	var savefile = {}
	savefile["saves"] = saves
	savefile["magic"] = magic
	save_game.store_line(to_json(savefile))


func save(cards):
	var card_data = cards_to_data(cards)
	var armory_data = armory.to_data()
	var stat_data = stats.to_data()
	var world_data = world.to_data()

	var data = {
		"color": color,
		"cards": card_data,
		"armories": armory_data,
		"stats": stat_data,
		"world": world_data,
		"world_num": world.num,
		"rng_seed": generator.seed_value,
		"rng_state": generator.rng.state
	}
	saves.append(data)
	save_file()
	emit_signal("update", saves)


func load_save(i):
	savable = false
	emit_signal("reset", i)


func load_next(i):
	if typeof(i) < 2:
		generator.new_game()
		return
	var data = saves[i]
	
	emit_signal("card_data", data["cards"])
	armory.from_data(data["armories"])
	stats.from_data(data["stats"])
	world.from_data(data["world"], data["world_num"])
	
	generator.seed_value = data["rng_seed"]
	generator.rng.seed = generator.seed_value
	generator.rng.state = data["rng_state"]

	color = data["color"]


func color(c):
	color = c


func newgame():
	load_save(false)
