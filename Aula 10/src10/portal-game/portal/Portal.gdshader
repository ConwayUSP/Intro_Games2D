shader_type spatial;

uniform float fade_out_distance_max = 10.0;
uniform float fade_out_distance_min = 8.0;
uniform vec4 fade_out_color = vec4(0.0);

uniform float border_thickness : hint_range(0.0, 0.5) = 0.05;
uniform float border_softness : hint_range(0.0, 0.2) = 0.02;
uniform float glow_intensity : hint_range(0.0, 10.0) = 2.0;

uniform sampler2D albedo: hint_default_black, source_color;

varying float pixel_distance;

void vertex() {
    vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    vec3 camera_position = (INV_VIEW_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
    
    pixel_distance = distance(world_position, camera_position);
}

void fragment() {
	// 1. Create the Oval Mask
    vec2 centered_uv = UV - vec2(0.5);
    float dist_from_center = length(centered_uv);
    
    float mask = smoothstep(0.5, 0.48, dist_from_center);

	// 2. Border Logic
	float border_inner_edge = 0.5 - border_thickness;
	float border_mask = smoothstep(border_inner_edge - border_softness, border_inner_edge, dist_from_center) - smoothstep(0.5 - border_softness, 0.5, dist_from_center);
    
	vec3 glow = fade_out_color.rgb * border_mask * glow_intensity;

	// 3. Color Logic
    vec3 portal_color = texture(albedo, SCREEN_UV).rgb;
    float t = smoothstep(fade_out_distance_min, fade_out_distance_max, pixel_distance);
    
    ALBEDO = mix(portal_color, fade_out_color.rgb, t);
	ALPHA = mask;
	EMISSION = glow;
}
