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
extends SubViewportContainer
class_name GlowBorderEffectRenderer
# Collection of viewports and shaders to create the glowing border effect.
# The GlowBorderEffectRender configure the needed viewports and
# ViewportContainers to create the glowing border effect.

# Class documentation
## The [GlowBorderEffectRenderer] render an overlay of glowing borders for
## glowing objects.
##
## The GlowBorderEffectRenderer render an overlay of glowing borders for
## [GlowBorderEffectObject] with the glowing paramete set to true. See
## the [GlowBorderEffectObject] for details.
##
## The [GlowBorderEffectRenderer] use an internal camera for rendring of the
## glowing effect. This camera needs to be updated to match the current
## views camera transform. This can be done manually or automatically.
## To align automatically set the [member automatically_update_camera] to true.
## To align the internal cameras manually with the current camera of your
## scene call the [method camera_transform_changed] and [method set_camera_parameters].

@export_group("Rendering")

# Cull mask for cameras
## Set the cull mask used to view the visuall layer defined
## for the [GlowBorderEffectObject].
@export_flags_3d_render var effect_cull_mask = 0x00400 : set = set_effect_cull_mask # (int, LAYERS_3D_RENDER)

## Set the cull mask use to render the scene. Should
## not include the effect_cull_mask bit.
@export_flags_3d_render var scene_cull_mask = 0xffbff : set = set_scene_cull_mask # (int, LAYERS_3D_RENDER)

## Set the intensity of the border.
@export var intensity = 3.0 : set = set_intensity # (float, 0.0, 5.0, 0.1)


@export_group("Camera Handing")
## Select between manuall or automatically updating the internal Camera transforms.
## When set to true automatically update the internal camera on each process.
## When set to false manually update the effect by calling [method camera_transform_changed] and
## [method set_camera_parameters].
@export var automatically_update_camera : bool = true


# Create references to the internal cameras
## Internal camera used in the prepass. Use the [method set_camera_parameters] to
## set camera parameters or adjust parameters as needed to match the scene camera.
@onready var camera_prepass = %Camera3DPrepass

# Create references to the internal viewports
@onready var _view_prepass = $ViewportBlure/ViewportContainerBlureX/ViewportHalfBlure/ViewportContainerBlureY/ViewportPrepass
@onready var _view_blure = $ViewportBlure

# Create references to the internal viewport containers
@onready var _container_gaussian_y = $ViewportBlure/ViewportContainerBlureX/ViewportHalfBlure/ViewportContainerBlureY
@onready var _container_gaussian_x = $ViewportBlure/ViewportContainerBlureX


# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup the shader inputs
	material.set_shader_parameter("intensity", intensity)
	material.set_shader_parameter("view_prepass", _view_prepass.get_texture())
	material.set_shader_parameter("view_blure", _view_blure.get_texture())
	
	# Ensure that the internal cameras cull sceen and shadow objects
	camera_prepass.cull_mask = effect_cull_mask


## Setter function for the effect_cull_mask. Ensure update of prepass camera.
func set_effect_cull_mask(val):
	effect_cull_mask = val
	if camera_prepass:
		camera_prepass.cull_mask = effect_cull_mask


## Setter function for the effect_cull_mask. Ensure update of scene camera.
func set_scene_cull_mask(val):
	scene_cull_mask = val


## Setter function for the intensity. Enusre update of the internal shader.
func set_intensity(val):
	intensity = val
	material.set_shader_parameter("intensity", intensity)



## Call this function to align the internal cameras in the
## GlowBorderEffectRenderer with an external camera.
func camera_transform_changed(camera : Camera3D):
	var transform = camera.global_transform
	camera_prepass.global_transform = transform


## Call this function to update internal cameras with parameters
## from external camera.
func set_camera_parameters(camera : Camera3D):
	# No need to update the following camera parameters:
	# cull_mask as handled by separate functions
	# current, doppler_tracking as this dosn't affect the geometry of the rendering
	
	# Unhandled properties: attributes, doppler_tracking?
	
	# Update parameters effecting the rendering
	camera_prepass.far = camera.far
	
	camera_prepass.fov = camera.fov
	
	camera_prepass.frustum_offset = camera.frustum_offset
	
	camera_prepass.h_offset = camera.h_offset
	
	camera_prepass.keep_aspect = camera.keep_aspect
	
	camera_prepass.near = camera.near
	
	camera_prepass.projection = camera.projection
	
	camera_prepass.size = camera.size
	
	camera_prepass.v_offset = camera.v_offset


## Callback to update the current camera transform.
func _on_camera_transform_changed(camera : Camera3D):
	camera_transform_changed(camera)


# Automatically update the camera in the process step.
func _process(delta: float) -> void:
	if automatically_update_camera:
		var camera = get_viewport().get_camera_3d()
		set_camera_parameters(camera)
		camera_transform_changed(camera)
		camera.cull_mask &= scene_cull_mask
