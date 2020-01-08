#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec4 drawNumber(float num, vec2 pos, float size, vec4 color) {

}

vec4 drawDigit(float digit, vec2 pos, float size, vec4 color) {

}

vec4 drawSevenSegmentDisplay(int display, vec2 pos, float size, vec4 color) {
  
}

vec4 drawSpindle(vec2 start, vec2 end, float size, vec4 color) {
  vec2 pos = gl_FragCoord.xy/u_resolution.xy;
}

void main() {
  vec4 mainColor = vec4(1.0);
  vec4 color = drawSpindle(vec2(0.5, 0.25), vec2(0.5, 0.75), 1.0, mainColor);

  gl_FragColor = color;
}