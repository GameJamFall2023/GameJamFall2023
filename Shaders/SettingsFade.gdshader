shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float bleedAmountX = 10;
uniform float bleedAmountY = 0.0;
uniform float time = 0;
uniform float fadeTime = 2.5;
uniform vec2 mouse = vec2(0.0, 0.0);
uniform float updateDistance = 50;
uniform vec2 screenSize = vec2(480.0, 270.0);

void fragment() {
	vec2 scale = screenSize - vec2(0.00001, 0.0001);
	vec2 pixel = SCREEN_UV * scale;
	vec2 nearPixel = floor(pixel);
	vec2 pixelOffset = nearPixel + vec2(0.5, 0.5);
	float distanc = distance(mouse, pixelOffset);
	
	if (distanc <= updateDistance) {
		float bleedX = sin(TIME) * 20.0;
		float bleedY = cos(TIME) * 20.0;
		float opacity = pow(E, -distanc / (updateDistance / 4.0));
		
	    vec4 middle = textureLod(screen_texture, SCREEN_UV, 0.0);
		vec4 bleedLeft = textureLod(screen_texture, SCREEN_UV - vec2(bleedX * SCREEN_PIXEL_SIZE.x, bleedY * SCREEN_PIXEL_SIZE.y), 0.0);
		vec4 bleedRight = textureLod(screen_texture, SCREEN_UV + vec2(bleedX * SCREEN_PIXEL_SIZE.x, bleedY * SCREEN_PIXEL_SIZE.y), 0.0);
		COLOR = vec4(bleedLeft.r, middle.g, bleedRight.b, middle.a) * opacity + middle * (1.0 - opacity);
	} else {
		vec4 middle = textureLod(screen_texture, SCREEN_UV, 0.0);
		COLOR = middle;
	}
}