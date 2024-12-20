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
@icon("res://addons/glow_border_effect/internal/glow_border_effect_object_icon.svg")
class_name GlowBorderEffectObject
extends Node3D
## Class to apply to object that shall glow.
##
## Apply the GlowBorderEffectObject as a parent to a spatial node that hold
## GeometryInstances ("Shadow meshes") and that should have the
## glowing border effect applied either statically through editor
## or dynamically by setting the [member glow_border_effect].

## Configuration of the glow color.
@export var glow_color : Color = Color.YELLOW

## Configuration of the visual layer to use for drawing of shadow meshes.
@export_flags_3d_render var effect_layer = 0x400 # (int, LAYERS_3D_RENDER)

## Enable or disable the glow effect, either through
## editor value or through the setter method [method set_glow_border_effect].
@export var glow_border_effect : bool = false : set = set_glow_border_effect

# Hold reference to created shadow objects used for glow rendering.
var _glow_shadow_objects : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	var glow_material = StandardMaterial3D.new()
	glow_material.albedo_color = glow_color
	
	# Create shadow meshes for all GeometryInstances
	# for glow effect rendering.
	_create_shadow_meshes(self, glow_material)


func set_glow_border_effect(val : bool):
	glow_border_effect = val
	for glow_object in _glow_shadow_objects:
		glow_object.set_visible(val)


# Create shadow meshes for all GeometryInstances
# for glow effect rendering.
func _create_shadow_meshes(obj, glow_material):
	# Recurse down the stucture in case
	# GeometryInstance3D exists as childs
	for child in obj.get_children():
		_create_shadow_meshes(child, glow_material)
	
	# Create shadow meshes for GeometryInstances
	if obj is GeometryInstance3D:
		var new_name = "GlowObjectShadow_" + obj.name
		var exist = find_child(new_name)
		if exist:
			_glow_shadow_objects.append(exist)
		else:
			var glow_object = obj.duplicate()
			glow_object.set_name(new_name)
			glow_object.layers = effect_layer
			glow_object.set_material_override(glow_material)
			
			# Clean up and remove children
			for sub in glow_object.get_children():
				glow_object.remove_child(sub)
			
			# Remove scripts
			glow_object.set_script(null)
			
			# Remove transformation
			glow_object.transform = Transform3D.IDENTITY
			
			# Ensure objects glow according setting
			glow_object.set_visible(glow_border_effect)
			
			# Now add the new shadow object to the tree
			obj.add_child(glow_object)
			_glow_shadow_objects.append(glow_object)
