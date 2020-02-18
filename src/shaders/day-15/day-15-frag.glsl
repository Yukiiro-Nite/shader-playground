uniform vec2 resolution;
uniform float time;
uniform sampler2D prevTexture;
const float PI = 3.14159265359;

vec4 fillSphere(vec2 pos, vec2 center, float radius, vec4 color) {
    float dist = distance(center, pos);
    float clampedDist = clamp(dist, 0.0, radius);
    float distRange = mix(PI / 2.0, 0.0, clampedDist / radius);
    
    return color * sin(distRange);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec4 prevColor = texture2D(prevTexture, pos);
  vec4 color = fillSphere(
    pos,
    (vec2(sin(time), cos(time)) * 0.1) + vec2(0.5),
    0.1,
    vec4(1.0, 1.0, 1.0, 1.0)
  );

  gl_FragColor = mix(prevColor, color, color.a);
}
