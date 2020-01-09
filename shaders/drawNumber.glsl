#ifdef GL_ES
precision mediump float;
#endif
#define PI 3.14159265359

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// START Utils
float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float inRange(float min, float max, float val) {
  return greaterThan(val, min) * lessThan(val, max);
}

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

// END Utils

float inCone(vec2 from, vec2 to) {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    vec2 diff = to - from;
    float angle = atan(diff.y, diff.x);
    
    vec2 offset = pos - from;
    offset = rotate2d(angle - (PI / 4.0)) * offset;
    
    return greaterThan(offset.x, 0.0) * greaterThan(offset.y, 0.0);
}

vec4 drawSpindle(vec2 start, vec2 end, float size, vec4 color) {
  // need to get the distance to the line from the point
  // if the distance is less than the size, draw the line
  // this will result in round line caps, but i want pointed line caps
  // can do math to find out if the point is within the line cap
  vec2 pos = gl_FragCoord.xy/u_resolution.xy;

  float distanceToLine = abs((end.y - start.y) * pos.x - (end.x - start.x) * pos.y + end.x * start.y - end.y * start.x) / distance(start, end);
  float inLine = lessThan(distanceToLine, size);
	float inStartCap = inCone(start, end);
  float inEndCap = inCone(end, start);

  return color * inLine * inStartCap * inEndCap;
}

vec4 drawSevenSegmentDisplay(float display, vec2 pos, float size, vec4 color) {
  // need to fix the display calculation
  float seg_1_display = greaterThan(display / pow(2.0, 6.0), 0.0);
  float seg_2_display = greaterThan(display / pow(2.0, 5.0), 0.0);
  float seg_3_display = greaterThan(display / pow(2.0, 4.0), 0.0);
  float seg_4_display = greaterThan(display / pow(2.0, 3.0), 0.0);
  float seg_5_display = greaterThan(display / pow(2.0, 2.0), 0.0);
  float seg_6_display = greaterThan(display / pow(2.0, 1.0), 0.0);
  float seg_7_display = greaterThan(display / pow(2.0, 0.0), 0.0);

  vec4 seg_1 = drawSpindle(vec2(0.1, 0.3), vec2(0.2, 0.3), 0.01, color) * seg_1_display;
  vec4 seg_2 = drawSpindle(vec2(0.2, 0.3), vec2(0.2, 0.2), 0.01, color) * seg_2_display;
  vec4 seg_3 = drawSpindle(vec2(0.2, 0.2), vec2(0.2, 0.1), 0.01, color) * seg_3_display;
  vec4 seg_4 = drawSpindle(vec2(0.2, 0.1), vec2(0.1, 0.1), 0.01, color) * seg_4_display;
  vec4 seg_5 = drawSpindle(vec2(0.1, 0.1), vec2(0.1, 0.2), 0.01, color) * seg_5_display;
  vec4 seg_6 = drawSpindle(vec2(0.1, 0.2), vec2(0.1, 0.3), 0.01, color) * seg_6_display;
  vec4 seg_7 = drawSpindle(vec2(0.1, 0.2), vec2(0.2, 0.2), 0.01, color) * seg_7_display;
  
  color = mix(seg_1, seg_2, seg_2.a);
  color = mix(color, seg_3, seg_3.a);
  color = mix(color, seg_4, seg_4.a);
  color = mix(color, seg_5, seg_5.a);
  color = mix(color, seg_6, seg_6.a);
  color = mix(color, seg_7, seg_7.a);

  return color;
}

vec4 drawDigit(float digit, vec2 pos, float size, vec4 color) {
  return color;
}

vec4 drawNumber(float num, vec2 pos, float size, vec4 color) {
  return color;
}

void main() {
  vec4 mainColor = vec4(1.0);
	vec4 color = drawSevenSegmentDisplay(1., vec2(0.1, 0.9), 0.1, mainColor);

  gl_FragColor = color;
}