uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;
uniform vec2 inputPosition;
uniform float inputDirection;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;

float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

vec2 getReflectedPosition(vec2 pos, vec2 reflectionStart, float direction) {
  return pos * lessThan(pos.x, reflectionStart.x) + (pos - vec2(pos.x - reflectionStart.x, 0.0) * 2.0) * greaterThan(pos.x, reflectionStart.x);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec2 reflectedPosition = getReflectedPosition(pos, inputPosition, inputDirection * TAU);
  vec4 tex = texture2D(texture, reflectedPosition);

  gl_FragColor = tex;
}