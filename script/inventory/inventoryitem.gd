extends Resource

class_name invitem

@export var name : String = ""
@export var texture : Texture2D
@export var stackable : bool = false
@export var consumable : bool = false
@export var building : bool = false
@export var phantom_texture : Texture2D #if building
@export var phantom_scale : Vector2
