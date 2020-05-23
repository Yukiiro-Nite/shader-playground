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

    float secondsInClock = 60.0;
    float secondRadians = (time * -TAU / secondsInClock) + PI / 2.0;
    vec2 secondTransform = vec2(cos(secondRadians), sin(secondRadians)) * 0.25;
    vec4 secondHand = drawLine(vec2(0.5, 0.5), vec2(0.5, 0.5) + secondTransform, 0.005, vec4(1.0, 0.0, 0.0, 1.0));

    float minutesInClock = secondsInClock * 60.0;
    float minuteRadians = (time * -TAU / minutesInClock) + PI / 2.0;
    vec2 minuteTransform = vec2(cos(minuteRadians), sin(minuteRadians)) * 0.3;
    vec4 minuteHand = drawLine(vec2(0.5, 0.5), vec2(0.5, 0.5) + minuteTransform, 0.01, vec4(0.8, 0.8, 0.8, 1.0));

    float hoursInClock = minutesInClock * 12.0;
    float hourRadians = (time * -TAU / hoursInClock) + PI / 2.0;
    vec2 hourTransform = vec2(cos(hourRadians), sin(hourRadians)) * 0.2;
    vec4 hourHand = drawLine(vec2(0.5, 0.5), vec2(0.5, 0.5) + hourTransform, 0.02, vec4(1.0));

    vec4 color = mix(secondHand, minuteHand, minuteHand.a);
    color = mix(color, hourHand, hourHand.a);

    gl_FragColor = color;
}