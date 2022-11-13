shader_type canvas_item;

float circle(vec2 position, float radius, float borderThickness, float feather)
{
	float d = dot(position, position);
	return 1.0 - smoothstep(0.0, borderThickness, abs(radius - d));
}

vec3 ring(vec2 coords, vec2 center, float radius, float thickness, vec3 bgColor) {
	float calculatedRadius = length(coords - center);
	float innerRadius = radius - thickness;
	float blur = 0.005;
	vec3 ringColor = vec3(176.0, 255.0, 74.0)/255.0;

	float pctOuterCircle = 1.0 - smoothstep(radius - blur, radius + blur, calculatedRadius);
	vec3 outerCirclePaint = mix(bgColor, ringColor, pctOuterCircle);
	
	float pctInnerCircle = 1.0 - smoothstep(innerRadius - blur, innerRadius + blur, calculatedRadius);
	vec3 innerCirclePaint = mix(outerCirclePaint, bgColor, pctInnerCircle);

	return innerCirclePaint;
}

void fragment() {
	// Place fragment code here.
	COLOR.rgb = ring(UV, vec2(0.5, 0.5), 0.5, 0.1, vec3(0.5, 0.5, 0.5));
}
