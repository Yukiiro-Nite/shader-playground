uniform vec2 resolution;
uniform float time;
const float PI = 3.14159265359;
uniform sampler2D texture;

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec2 center = vec2(0.5, 0.5);
  float frequency = 20.0;
  float amplitude = 0.1;
  float dist = distance(center, pos) * frequency;
  float ripple = (sin(dist - time) + 1.0) / 2.0;
  vec2 ripplePosition = pos + ((pos - center) * ripple * amplitude);
  vec4 color = texture2D(texture, ripplePosition);

  gl_FragColor = color;
}