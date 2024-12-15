# Copyright (c) 2022-2024 Anders Reggestad
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	
	# Scenes not supported as custom types yet!
	#add_custom_type("GlowBorderEffectRenderer","SubViewportContainer",preload("res://addons/glow_border_effect/glow_border_effect_renderer.gd"),preload("res://addons/glow_border_effect/glow_border_effect_renderer_icon.svg"))
	
	# Add the EffectObject as this is a script that is attached to an object.
	add_custom_type("GlowBorderEffectObject","Node3d",preload("res://addons/glow_border_effect/glow_border_effect_object.gd"),preload("res://addons/glow_border_effect/internal/glow_border_effect_object_icon.svg"))
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	
	# Maybe some time...
	#remove_custom_type("GlowBorderEffectRenderer")
	
	# Remove the scriopt
	remove_custom_type("GlowBorderEffectObject")
	pass
