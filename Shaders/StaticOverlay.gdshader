shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR = color * random(SCREEN_UV * vec2(TIME, TIME * 13.0));
}