#ifdef GL_ES
precision mediump float;
#endif

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
// END Utils

vec4 drawNumber(float num, vec2 pos, float size, vec4 color) {
  return color;
}

vec4 drawDigit(float digit, vec2 pos, float size, vec4 color) {
  return color;
}

vec4 drawSevenSegmentDisplay(int display, vec2 pos, float size, vec4 color) {
  return color;
}

vec4 drawSpindle(vec2 start, vec2 end, float size, vec4 color) {
  vec2 pos = gl_FragCoord.xy/u_resolution.xy;
  float distanceToLine = abs((end.y - start.y) * pos.x - (end.x - start.x) * pos.y + end.x * start.y - end.y * start.x) / distance(start, end);
  float inLine = lessThan(distanceToLine, size);

  return color * inLine;
}

void main() {
  vec4 mainColor = vec4(1.0);
  vec4 color = drawSpindle(vec2(0.5, 0.25), vec2(0.5, 0.75), 0.05, mainColor);

  gl_FragColor = color;
}