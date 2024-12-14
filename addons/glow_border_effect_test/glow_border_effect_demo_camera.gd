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
extends Camera3D


# Sort the exports under this category
@export_category("Glow Boarder Effect Camera")

## Reference to the glow border effect renderer for update of
## camera parameters and transforms.
@export var glow_border_effect_renderer : GlowBorderEffectRenderer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Update the internal cameras in the glow border effect renderer.
	#glow_border_effect_renderer.set_camera_parameters(self)
	
	# Turn on notification for camera transform changes.
	#set_notify_transform(true)
	pass


# Called when the node receive notifications.
func _notification(what):
	# Update the camera transform each time the camera transform change.
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		#glow_border_effect_renderer.camera_transform_changed(self)
		pass
