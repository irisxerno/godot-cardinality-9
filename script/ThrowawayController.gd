extends Node2D

func return_cards(cds):
	for c in cds:
		c.move_to(Vector2(0,0))
