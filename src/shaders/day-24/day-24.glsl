uniform vec2 resolution;
uniform float time;
const float PI = 3.14159265359;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))
                 * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

vec4 generateRain(vec2 pos, vec4 rainColor, float size) {
  float r = noise(pos);
  float isDrop = float(r >= (1.0 - size) || r <= size);

  return rainColor * isDrop;
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec4 rainColor = vec4(1.0);
  vec4 bgColor = vec4(0.0);
  
  float size = 0.04;
  float space = 10.0;
  float distance = 0.0;
  vec2 rainPos = pos;
  vec4 dropColor = vec4(0.0);

  for(float i = 1.0; i <= 10.0; i += 1.0) {
    distance = i / 10.0;
    rainPos = pos * space;
    rainPos.y = rainPos.y + time * (space + distance * space) * 2.0;
    rainPos.x = rainPos.x - (space * distance / 2.0);
    dropColor = generateRain(rainPos, rainColor * (1.0 - distance), size * (1.0 - distance));
    bgColor = mix(bgColor, dropColor, dropColor.a);
  }

  gl_FragColor = bgColor;
}