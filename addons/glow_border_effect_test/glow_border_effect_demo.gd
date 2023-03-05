extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().connect("size_changed", self, "resized")


# Callback for handling change in window size
func resized():
	$GlowBorderEffectRenderer.resize()
