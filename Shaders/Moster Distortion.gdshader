shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float bleedAmountX = 10;
uniform float bleedAmountY = 0.0;
uniform vec2 mons = vec2(0.0, 0.0);
uniform float updateDistance = 50;
uniform vec2 screenSize = vec2(480.0, 270.0);
uniform float static = 0.0;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	vec2 scale = screenSize - vec2(0.00001, 0.0001);
	vec2 pixel = SCREEN_UV * scale;
	vec2 nearPixel = floor(pixel);
	vec2 pixelOffset = nearPixel + vec2(0.5, 0.5);
	float distanc = distance(mons, pixelOffset);
	
	if (distanc <= updateDistance) {
		float close = updateDistance - distanc;
		float bleedX = sin(sin(TIME / 2.0) * 3.0 * (close / 100.0)) * (20.0 + (close / 2.0));
		float bleedY = cos(sin(TIME / 2.0) * 3.0 * (close / 100.0)) * (20.0 + (close / 2.0));
		float opacity = pow(E, -distanc / (updateDistance / 2.0));
		
	    vec4 middle = textureLod(screen_texture, SCREEN_UV, 0.0);
		vec4 bleedLeft = textureLod(screen_texture, SCREEN_UV - vec2(bleedX * SCREEN_PIXEL_SIZE.x, bleedY * SCREEN_PIXEL_SIZE.y), 0.0);
		vec4 bleedRight = textureLod(screen_texture, SCREEN_UV + vec2(bleedX * SCREEN_PIXEL_SIZE.x, bleedY * SCREEN_PIXEL_SIZE.y), 0.0);
		
		COLOR = vec4(bleedLeft.r, middle.g, bleedRight.b, middle.a) * opacity + middle * (1.0 - opacity);
	
	} else {
		vec4 middle = textureLod(screen_texture, SCREEN_UV, 0.0);
		COLOR = middle;
	}
}