uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;
uniform vec2 textureResolution;

// Found this threshold map for a 4x4 matrix on wikipedia
// https://en.wikipedia.org/wiki/Ordered_dithering
const mat4 thresholdMap = mat4(
  vec4(0.0, 8.0, 2.0, 10.0),
  vec4(12.0, 4.0, 14.0, 6.0),
  vec4(3.0, 11.0, 1.0, 9.0),
  vec4(15.0, 7.0, 13.0, 5.0)
) * (1.0 / 16.0);

float luminosity(vec4 color) {
  return 0.2126*color.r + 0.7152*color.g + 0.0722*color.b;
}

float getGray(sampler2D tex, vec2 pos) {
  return luminosity(texture2D(tex, pos));
}

float access(mat4 M, vec2 pos) {
  vec2 p = floor(mod(pos, 4.0));
  return (
    (M[0][0] * float(p.y == 0.0 && p.x == 0.0)) +
    (M[0][1] * float(p.y == 0.0 && p.x == 1.0)) +
    (M[0][2] * float(p.y == 0.0 && p.x == 2.0)) +
    (M[0][3] * float(p.y == 0.0 && p.x == 3.0)) +
    (M[1][0] * float(p.y == 1.0 && p.x == 0.0)) +
    (M[1][1] * float(p.y == 1.0 && p.x == 1.0)) +
    (M[1][2] * float(p.y == 1.0 && p.x == 2.0)) +
    (M[1][3] * float(p.y == 1.0 && p.x == 3.0)) +
    (M[2][0] * float(p.y == 2.0 && p.x == 0.0)) +
    (M[2][1] * float(p.y == 2.0 && p.x == 1.0)) +
    (M[2][2] * float(p.y == 2.0 && p.x == 2.0)) +
    (M[2][3] * float(p.y == 2.0 && p.x == 3.0)) +
    (M[3][0] * float(p.y == 3.0 && p.x == 0.0)) +
    (M[3][1] * float(p.y == 3.0 && p.x == 1.0)) +
    (M[3][2] * float(p.y == 3.0 && p.x == 2.0)) +
    (M[3][3] * float(p.y == 3.0 && p.x == 3.0))
  );
}

vec4 applyBlackWhiteThresholdMap(vec2 fragCoord, vec2 pos, mat4 thresholdMap, sampler2D tex) {
  float l = getGray(tex, pos);
  float threshold = access(thresholdMap, fragCoord);

  return vec4(1.0) * float(l > threshold);
}

void main()	{
  vec2 screenPos = gl_FragCoord.xy/resolution.xy;
  vec2 scaleCamToWindow = resolution / textureResolution;
  vec2 adjustedCam = textureResolution * max(scaleCamToWindow.x, scaleCamToWindow.y);
  vec2 offset = vec2(
    (resolution.x - adjustedCam.x) / 2.0,
    (resolution.y - adjustedCam.y) / 2.0
  ) / resolution.xy;
  vec2 pos = gl_FragCoord.xy/adjustedCam.xy - offset;
  float distToCenter = distance(screenPos, vec2(0.5, 0.5)) * 1.0;

  vec4 color = texture2D(texture, pos);
  vec4 ditherColor = applyBlackWhiteThresholdMap(gl_FragCoord.xy, pos, thresholdMap, texture);

  color = mix(color, ditherColor, distToCenter);

  gl_FragColor = color;
}