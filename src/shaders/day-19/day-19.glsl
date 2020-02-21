uniform vec2 resolution;
uniform float time;
uniform sampler2D texture;
uniform vec2 inputPosition;
uniform float inputDirection;
const float PI = 3.14159265359;
const float TAU = PI * 2.0;
const float EPSILON = 0.0000001;

float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

mat2 rotate2d(float _angle){
  return mat2(cos(_angle), -sin(_angle),
              sin(_angle), cos(_angle));
}

float lineCrossProduct(vec2 pos, vec2 lineA, vec2 lineB) {
  float dx1 = lineB.x - lineA.x;
  float dy1 = lineB.y - lineA.y;
  float dx2 = pos.x - lineB.x;
  float dy2 = pos.y - lineB.y;
  
  return (dx1 * dy2) - (dy1 * dx2);
}

float signNoZero(float num) {
  return float(num >= 0.0) * 1.0 + float(num < 0.0) * -1.0;
}

float avoidZero(float num) {
  float aboveEpsilon = float(abs(num) >= EPSILON);
  float belowEpsilon = float(abs(num) < EPSILON);
  float signedEpsilon = EPSILON * signNoZero(num);

  return (num * aboveEpsilon) + (signedEpsilon * belowEpsilon);
}

vec2 getReflectedPosition(vec2 pos, vec2 lineStart, float direction) {
  vec2 lineEnd = lineStart + vec2(cos(direction), sin(direction));
  float slope = (lineEnd.y - lineStart.y) / avoidZero(lineEnd.x - lineStart.x);
  float yIntercept = - (slope * lineStart.x - lineStart.y);

  float rX = ((1.0 - pow(slope, 2.0)) * pos.x + 2.0 * slope * pos.y - 2.0 * slope * yIntercept) / (pow(slope, 2.0) + 1.0);
  float rY = ((pow(slope, 2.0) - 1.0) * pos.y + 2.0 * slope * pos.x + 2.0 * yIntercept) / (pow(slope, 2.0) + 1.0);
  vec2 reflectedPosition = vec2(rX, rY);
  float insideOutsideReflection = lineCrossProduct(pos, lineStart, lineEnd);
  float outsideReflection = float(insideOutsideReflection <= 0.0);
  float insideReflection = float(insideOutsideReflection > 0.0);

  return (pos * outsideReflection) + (reflectedPosition * insideReflection);
}

void main() {
  vec2 pos = gl_FragCoord.xy/resolution.xy;
  vec2 reflectedPosition = getReflectedPosition(pos, inputPosition, inputDirection * TAU);
  vec4 tex = texture2D(texture, reflectedPosition);

  gl_FragColor = tex;
}