extends Resource

class_name inventory

@export var items : Array[invitem]


signal update

func insert(item : invitem):
	var itemslots = items.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		return
	else:
		var emptyslots = items.filter(func(slot): return slot.item == null)
		if not emptyslots.is_empty():
			emptyslots[0].item = item
	update.emit()


func additem(item : invitem):
	items.push_back(item)
	update.emit()
