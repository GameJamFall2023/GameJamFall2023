shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D fixedColor : repeat_disable, filter_nearest;
uniform vec2 screenSize = vec2(480.0, 270.0);


vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec2 scale = screenSize - vec2(0.00001, 0.0001);
	vec2 pixel = SCREEN_UV * scale;
	vec2 nearPixel = floor(pixel);
	vec2 pixelOffset = nearPixel + vec2(0.5, 0.5);
	
	vec4 screen = textureLod(screen_texture, pixelOffset / scale, 0.0);
	float brightness = rgb2hsv(screen.rgb).z;
	vec4 newColor = textureLod(fixedColor, vec2(brightness, 0.75), 0.0);
	
	COLOR = vec4(newColor.rgb, screen.a);
}