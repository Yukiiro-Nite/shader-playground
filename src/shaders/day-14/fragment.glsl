varying vec2 vUv;

uniform float time;
uniform vec2 resolution;
const float PI = 3.14159265359;

vec4 fillSphere(vec2 pos, vec2 center, float radius, vec4 color) {
    float dist = distance(center, pos);
    float clampedDist = clamp(dist, 0.0, radius);
    float distRange = mix(PI / 2.0, 0.0, clampedDist / radius);
    
    return color * sin(distRange);
}

float isInElipse(vec2 pos, vec2 c1, vec2 c2, float radius) {
    float dist1 = distance(c1, pos);
    float dist2 = distance(c2, pos);
    
    return float((dist1 + dist2) < radius);
}

void main()	{
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  pos = vec2(0.5) - pos;

  float shake = (0.5 * (sin(time * 64.0) + 1.0)) * 0.25;
  float inElipse = isInElipse(pos, vec2(-0.1, -0.1), vec2(0.1, 0.1) * shake, 0.25);
  vec4 elipseColor = vec4(0.0, 0.0, 1.0, 1.0) * inElipse;
  vec4 highlightColor = fillSphere(pos, vec2(0.08) * shake, 0.05 * shake, vec4(1.0));

  gl_FragColor = mix(elipseColor, highlightColor, highlightColor.a);
}