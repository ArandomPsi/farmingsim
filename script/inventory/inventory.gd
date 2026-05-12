extends Resource

class_name inventory

@export var items : Array[invslot]


signal update

#old stuff
#func insert(item : invitem):
	#var itemslots = items.filter(func(slot): return slot.item == item)
	#if !itemslots.is_empty() and itemslots[0].item.stackable:
		#itemslots[0].amount += 1
	#else:
		#var emptyslots = items.filter(func(slot): return slot.item == null)
		#if not emptyslots.is_empty():
			#emptyslots[0].item = item
	#update.emit()

func additem(item : invitem, amount : int = 1) -> bool:
	if amount <= 0:
		return false
	#blah blah stack
	for slot in items:
		if slot == null:
			continue
		if slot.item == item and item.stackable:
			slot.amount += amount
			update.emit()
			return true
	#first avalible slot
	for slot in items:
		if slot == null:
			continue
		if slot.item == null:
			slot.item = item
			slot.amount = amount
			update.emit()
			return true
	# inventory full
	return false


#func additem(item : invitem):
	#for i in range(items.size()):
		#if items[i].item == null:
			#items[i].item = item
			#update.emit()
			#return true
	#print("yea")
