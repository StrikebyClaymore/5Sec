shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;

void fragment()
{
	float bolt = abs(UV.y + progress);
	
	vec4 display = vec4(bolt);
	
	COLOR = display;
	//COLOR = texture(TEXTURE, UV) * progress;
}