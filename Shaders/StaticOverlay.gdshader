shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float bleedAmountX = 0.0;
uniform float bleedAmountY = 0.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec4 color = textureLod(TEXTURE, UV, 0.0);
	COLOR = color * (random(UV * vec2(TIME, TIME)) / 2.0 + 0.5);
}