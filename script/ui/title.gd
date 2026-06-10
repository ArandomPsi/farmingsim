extends Control

var tutorialopened : bool = false
var settingsopened : bool = false


func _ready() -> void:
	$brokeboipanel/rtx.button_pressed = global.rtx
	$brokeboipanel/bloom.button_pressed = global.bloom
	$brokeboipanel/fps.button_pressed = global.fps
	$brokeboipanel/motion.button_pressed = global.motion
	$brokeboipanel/quests.button_pressed = global.quests

func _on_button_pressed() -> void: #play button
	#reset everything
	global.time = global.ingame_to_real_minute_duration * global.INITIAL_HOUR * 60
	global.days = 0
	global.chickenskilled = 0
	global.mutationskilled = []
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(25,25),0.6).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$Camera2D.zoom = Vector2(0.5,0.5)
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")
	CheckButton
	


func _process(delta: float) -> void:
	if tutorialopened:
		$idiotpanel.position.x = lerpf($idiotpanel.position.x,15,0.2)
	else:
		$idiotpanel.position.x = lerpf($idiotpanel.position.x,-430,0.2)
	
	if settingsopened:
		$brokeboipanel.position.y = lerpf($brokeboipanel.position.y,300,0.2)
	else:
		$brokeboipanel.position.y = lerpf($brokeboipanel.position.y,654.0,0.2)
	
	global.rtx = $brokeboipanel/rtx.button_pressed
	global.bloom = $brokeboipanel/bloom.button_pressed
	global.fps = $brokeboipanel/fps.button_pressed
	global.motion = $brokeboipanel/motion.button_pressed
	global.quests = $brokeboipanel/quests.button_pressed


func _on_button_4_pressed() -> void:
	tutorialopened = not tutorialopened


func _on_button_2_pressed() -> void:
	settingsopened = not settingsopened
