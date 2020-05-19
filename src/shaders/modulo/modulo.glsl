uniform vec2 resolution;
uniform float time;

void main() {
  float num = gl_FragCoord.x + gl_FragCoord.y * resolution.x;

  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) * mod(num, time)/time;
}