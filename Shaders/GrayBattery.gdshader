shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float gray = 0.0;

void fragment() {
    vec4 color = textureLod(TEXTURE, UV, 0.0);
	float grey = (color.r + color.g + color.b) / 3.0;
	COLOR = vec4(grey, grey, grey, color.a - 0.5) * gray + color * (1.0-gray);
}