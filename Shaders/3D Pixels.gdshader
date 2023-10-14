shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 screenSize = vec2(1.0, 1.0);

void fragment() {
	vec2 scale = screenSize - vec2(0.00001, 0.0001);
	vec2 pixel = SCREEN_UV * scale;
	vec2 nearPixel = floor(pixel);
	vec2 pixelOffset = nearPixel + vec2(0.5, 0.5);
	
	vec4 screen = textureLod(screen_texture, pixelOffset / scale, 0.0);
	
	COLOR = screen;
}