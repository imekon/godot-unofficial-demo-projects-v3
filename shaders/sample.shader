shader_type canvas_item;

float plot(vec2 st, float pct)
{
	return smoothstep(pct - 0.02, pct, st.y) -
		smoothstep(pct, pct + 0.02, st.y);
}

void fragment()
{
	//COLOR = vec4(1.0, 0.0, 1.0, 1.0);
	//COLOR = vec4(abs(sin(TIME / 2.0)), 0.0, 0.0, 1.0);
	vec2 st = FRAGCOORD.xy / vec2(1400.0, 400.0);
	float y = smoothstep(0.1, 0.9, st.x);
	vec3 color = vec3(y);
	
	float pct = plot(st, y);
	color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);
	
	COLOR = vec4(color, 1.0);
}
