uniform vec2 resolution;
uniform float time;
uniform float inputWidth;
uniform float inputHeight;
uniform float isPolar;
uniform float isDistance;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;
const float EPSILON = 0.0000001;

vec2 polarSpace(vec2 pos, vec2 center) {
  vec2 posCenter = center - pos;
  float angle = ((atan(posCenter.y, posCenter.x) / TAU) + 1.0) / 2.0;
  float radius = length(posCenter) * 2.0;
  return vec2(angle, radius);
}

float gridDistance(vec2 pos, float width, float height) {
  vec2 scaledPos = pos * vec2(width, height) + 0.5;
  vec2 closestPoint = floor(scaledPos + 0.5);
  return distance(scaledPos, closestPoint);
}

float isGridPoint(vec2 pos, float width, float height) {
  return float(gridDistance(pos, width, height) < 0.1);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  pos = ((1.0 - isPolar) * pos) + ( isPolar * polarSpace(pos, vec2(0.5)));
  float isPoint = isGridPoint(pos, inputWidth, inputHeight);
  float gridDist = gridDistance(pos, inputWidth, inputHeight);
  vec4 color = vec4(1.0);

  gl_FragColor = ((1.0 - isDistance) * color * isPoint) + (isDistance * color * gridDist);
}