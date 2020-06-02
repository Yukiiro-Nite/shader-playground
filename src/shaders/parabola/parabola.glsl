uniform vec2 resolution;
uniform float time;
uniform vec4 fillColor;
uniform vec4 strokeColor;
uniform float strokeWidth;

void main() {
  vec2 pos = gl_FragCoord.xy / resolution.xy;
  float distance = pos.y - (-4.0 * pow(pos.x - 0.5, 2.0) + 1.0);

  float halfWidth = strokeWidth / 2.0;
  vec4 stroke = strokeColor * float(distance <= halfWidth && distance >= -halfWidth);
  vec4 fill = fillColor * float(distance <= 0.0);

  gl_FragColor = mix(fill, stroke, stroke.a);
}