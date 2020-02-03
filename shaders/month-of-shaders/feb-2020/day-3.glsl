#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_tex0;
const float PI = 3.14159265359;

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

vec4 closest(vec4 color, vec4 color1, vec4 color2, vec4 color3) {
  float dist1 = distance(color, color1);
  float dist2 = distance(color, color2);
  float dist3 = distance(color, color3);
  float color1Closer = lessThan(dist1, dist2) * lessThan(dist1, dist3);
  float color2Closer = lessThan(dist2, dist1) * lessThan(dist2, dist3);
  float color3Closer = lessThan(dist3, dist1) * lessThan(dist3, dist2);

  return (color1 * color1Closer)
    + (color2 * color2Closer)
    + (color3 * color3Closer);
}

void main() {
    vec2 pos = gl_FragCoord.xy/u_resolution.xy;
    vec4 color = texture2D(u_tex0, pos);
    color = closest(
      color,
      vec4(1.0, 0.95, 0.9, 1.0),
      vec4(1.0, 0.0, 0.0, 1.0),
      vec4(vec3(0.0), 1.0)
    );

    gl_FragColor = color;
}
