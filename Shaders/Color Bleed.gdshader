shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float bleedAmountX = 0.0;
uniform float bleedAmountY = 0.0;

void fragment() {
    vec4 middle = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec4 bleedLeft = textureLod(screen_texture, SCREEN_UV - vec2(bleedAmountX * SCREEN_PIXEL_SIZE.x, bleedAmountY * SCREEN_PIXEL_SIZE.y), 0.0);
	vec4 bleedRight = textureLod(screen_texture, SCREEN_UV + vec2(bleedAmountX * SCREEN_PIXEL_SIZE.x, bleedAmountY * SCREEN_PIXEL_SIZE.y), 0.0);
	COLOR = vec4(bleedLeft.r, middle.g, bleedRight.b, middle.a);
}