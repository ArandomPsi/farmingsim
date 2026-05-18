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


func inventoryhas(item : invitem, amount : int = 1, returnamount : bool = false):
	if amount == 0:
		return true #for redundant items bc i'm a bad coder
	for slot in items:
		if slot == null:
			continue #the slot dies
		
		#if the slot has the item
		if slot.item == item:
			if slot.amount >= amount: #check if the slot has the amount
				
				if returnamount:
					return slot.amount
				else:
					return true #return ture :D
	if returnamount:
		return 0 #yeah ur broke
	else:
		return false #broke boi
	

func removeitem(item : invitem, amount : int = 0): #basically the same as the checker, but it takes away items
	for slot in items:
		if slot == null:
			continue
		
		#if the slot has the item
		if slot.item == item:
			
			if not slot.item.stackable: slot.item = null; return #bruh
			
			#else do all this jazz
			slot.amount -= amount
			if slot.amount < 1:
				slot.item = null
			return #then return so tha there are no bugs
	update.emit()

func get_data(item : invitem, data_wanted : Array[int]) -> Dictionary: #no idea what's going on in inventory has lol so delete this if u want
	var data : Dictionary = {}
	for i in data_wanted:
		match i:
			0:
				data["name"] = item.name
			1:
				data["texture"] = item.texture
			2:
				data["stackable"] = item.stackable
			3:
				data["consumable"] = item.consumable
			4:
				data["building"] = item.building
			5:
				data["phantom_texture"] = item.phantom_texture
			6:
				data["phantom_scale"] = item.phantom_scale
	return data

#func additem(item : invitem):
	#for i in range(items.size()):
		#if items[i].item == null:
			#items[i].item = item
			#update.emit()
			#return true
	#print("yea")
