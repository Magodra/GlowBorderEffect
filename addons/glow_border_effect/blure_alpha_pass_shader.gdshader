shader_type canvas_item;
render_mode blend_premul_alpha;

const float weights[] = {0.02,0.06,0.08,0.11,0.14,0.18,0.14,0.11,0.08,0.06,0.02};

// Use (1,0) for X pass
// Use (0,1) for Y pass
uniform vec2 sampleOffset;

// Blurs the screen in the X/Y-direction.
void fragment() {
	vec4 sum = vec4(0.0, 0.0, 0.0, 0.0);
	vec2 baseOffset = -5.0*sampleOffset;
	vec2 offset = baseOffset;
	for (int s = 0; s < 11; ++s)
	{
		vec4 c = texture(TEXTURE, UV + offset*SCREEN_PIXEL_SIZE);
		sum += c*weights[s];
		offset += sampleOffset;
	}
	COLOR = sum;
}