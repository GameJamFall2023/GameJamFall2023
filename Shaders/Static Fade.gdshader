shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float static = 0.0;
uniform vec2 screenSize = vec2(480.0, 270.0);

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec2 scale = screenSize - vec2(0.00001, 0.0001);
	vec2 pixel = SCREEN_UV * scale;
	vec2 nearPixel = floor(pixel);
	vec2 pixelOffset = nearPixel + vec2(0.5, 0.5);

	float stat = random((pixelOffset / scale) * vec2(TIME, TIME * 13.0));
	stat *= 0.25;
	stat += 0.375;
	COLOR = vec4(stat, stat, stat, static);
}