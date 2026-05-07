extends Node
var player : Node #for convenience
var playerpos : Vector2

var editing : bool = true

var egg_visible : bool = false # only 1 egg can be shown at a time for pickup
var the_egg : Node = null
var inventoryslotprefix : String = "invenslot"
var stopfuncinvloop : int = 0
var slotnum : int = 0

var phantomitem : invitem = null
var phantomowner : Control = null

var time = 0
var prevtime = time
const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const ingame_to_real_minute_duration = (2*PI) / MINUTES_PER_DAY
var INGAME_SPEED = 20
var INITIAL_HOUR = 5:
	set(h):
		INITIAL_HOUR = h
		time = ingame_to_real_minute_duration * INITIAL_HOUR * MINUTES_PER_HOUR

var days = 0
var truetime : float = 0
var isnight : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	time = ingame_to_real_minute_duration * INITIAL_HOUR * 60


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if time >= 5.5 and prevtime < 5.5:
		days += 1
	
	prevtime = time
	#time stuff
	time += delta / INGAME_SPEED
	if time >= 6:
		time = 0
	
	truetime = time * 4 #lasts 6 for some reason, so mult by 4
	
	#for night detection
	isnight = (truetime > 20 or truetime < 4)
	stopfuncinvloop = 0
	
	


func recalculate_time() -> void:
	var total_minutes = int(time/ ingame_to_real_minute_duration)
	
	var day  = int(total_minutes / MINUTES_PER_DAY)
	
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)




#attack on chibi global code for day and night cycle yoinking

#extends Node
#var playerpos : Vector2
#var kills : float = 0
#var eyecandy : bool = true
#var quality : bool = true
#var clouds : bool = false
#var playertext : String = ""
#var playertalking : bool = false
#var playertextdex : float = 0
#var playertalkto : String = "Joe Bob"
#var difficulty : float = 0
#var playerinventory : Array = ["potion"]
#var playertitanpos : Vector2
#var playerhorseypos : Vector2
#var playervelocity : Vector2
#var playertextamount = 0
#var time = 0
#var prevtime = time
#const MINUTES_PER_DAY = 1440
#const MINUTES_PER_HOUR = 60
#const ingame_to_real_minute_duration = (2*PI) / MINUTES_PER_DAY
#var INGAME_SPEED = 20
#var INITIAL_HOUR = 0:
	#set(h):
		#INITIAL_HOUR = h
		#time = ingame_to_real_minute_duration * INITIAL_HOUR * MINUTES_PER_HOUR
#
#var days = 0
## Called when the node enters the scene tree for the first time.
#func _ready():
	#time = ingame_to_real_minute_duration * INITIAL_HOUR * 60
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#
	#if time >= 5.5 and prevtime < 5.5:
		#days += 1
	#if time >= 11 and prevtime < 11:
		#days += 1
	#
	#prevtime = time
	#playertextdex += 0.001
	##time stuff
	#time += delta / INGAME_SPEED
	#if time >= 12:
		#time = 0
		#
		#
	#
	#if playertextamount < len(playertext):
		#playertextamount += 1.2
	#
	#
#func recalculate_time() -> void:
	#var total_minutes = int(time/ ingame_to_real_minute_duration)
	#
	#var day  = int(total_minutes / MINUTES_PER_DAY)
	#
	#var current_day_minutes = total_minutes % MINUTES_PER_DAY
	#
	#var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	#var minute = int(current_day_minutes % MINUTES_PER_HOUR)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("edit"):
		editing = not editing
