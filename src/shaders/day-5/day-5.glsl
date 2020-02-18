uniform vec2 resolution;
uniform float time;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float inCone(vec2 from, vec2 to) {
    vec2 pos = gl_FragCoord.xy/resolution.xy;
    vec2 diff = to - from;
    float angle = atan(diff.y, diff.x);
    
    vec2 offset = pos - from;
    offset = rotate2d(angle - (PI / 4.0)) * offset;
    
    return greaterThan(offset.x, 0.0) * greaterThan(offset.y, 0.0);
}

vec4 drawLine(vec2 start, vec2 end, float size, vec4 color) {
  vec2 pos = gl_FragCoord.xy/resolution.xy;

  float distanceToLine = abs((end.y - start.y) * pos.x - (end.x - start.x) * pos.y + end.x * start.y - end.y * start.x) / distance(start, end);
  float inLine = lessThan(distanceToLine, size);
	float inStartCap = inCone(start, end);
  float inEndCap = inCone(end, start);

  return color * inLine * inStartCap * inEndCap;
}

vec4 fillSphere(vec2 center, float radius, vec4 color) {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  float dist = distance(center, pos);
  
  return color * float(dist < radius);
}

void main() {
    vec2 st = gl_FragCoord.xy/resolution.xy;
    float minuteRadians = (time * -TAU / 60.0) + PI / 2.0;
    vec2 timeTransform = vec2(cos(minuteRadians), sin(minuteRadians)) * 0.25;
    vec4 color = drawLine(vec2(0.5, 0.5), vec2(0.5, 0.5) + timeTransform, 0.01, vec4(1.0));

    gl_FragColor = color;
}