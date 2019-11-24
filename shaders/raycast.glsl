#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
const float EPSILON = 0.0000001;

float greaterThan(float a, float b) {
  return ceil((sign(a - b) + 1.0) / 2.0);
}

float lessThan(float a, float b) {
  return floor((sign(b - a) + 1.0) / 2.0);
}

float outsideEpsilon(float val) {
  return greaterThan(abs(val), EPSILON);
}

float inRange(float min, float max, float val) {
  return greaterThan(val, min) * lessThan(val, max);
}

// translated from https://en.wikipedia.org/wiki/M%C3%B6ller%E2%80%93Trumbore_intersection_algorithm
float rayIntersectsTriangle(
  vec3 rayOrigin,
  vec3 rayVector,
  vec3 vert0,
  vec3 vert1,
  vec3 vert2,
  out vec3 intersection
) {
  vec3 edge1, edge2, h, s, q;
  float a, f, u, v, flag;
  edge1 = vert1 - vert0;
  edge2 = vert2 - vert0;
  h = cross(rayVector, edge2);
  a = dot(edge1, h);
  flag = outsideEpsilon(a);
  f = 1.0/a;
  s = rayOrigin - vert0;
  u = f * dot(s, h);
  flag = flag * inRange(0.0, 1.0, u);
  q = cross(s, edge1);
  v = f * dot(rayVector, q);
  flag = flag * greaterThan(v, 0.0) * lessThan(u + v, 1.0);
  float t = f * dot(edge2, q);
  flag = flag * greaterThan(t, EPSILON) * lessThan(t, (1.0 / EPSILON));
  intersection = rayOrigin + rayVector * t;
  return flag;
}

vec4 drawTri(vec3 vert0, vec3 vert1, vec3 vert2, vec4 color) {
  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec3 intersection = vec3(0.0);
  float intersected = rayIntersectsTriangle(
    vec3(st, 0),
    vec3(0, 0, 1),
    vert0,
    vert1,
    vert2,
    intersection
  );
  return vec4(color.rgb * (1.0 - intersection.z) * intersected, color.a * intersected);
}

void main() {
  vec4 color = vec4(0.0, 0.5, 1.0, 1.0);
  vec4 baseColor = vec4(1.0, 1.0, 1.0, 1.0);
  vec4 triColor;

  triColor = drawTri(
    vec3(0.5, 0.5, 0),
    vec3(0.5, 0.75, 1),
    vec3(0.75, 0.5, 1),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  triColor = drawTri(
    vec3(0.5, 0.5, 0),
    vec3(0.75, 0.5, 1),
    vec3(0.5, 0.25, 1),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  triColor = drawTri(
    vec3(0.5, 0.5, 0),
    vec3(0.5, 0.25, 1),
    vec3(0.25, 0.5, 1),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  triColor = drawTri(
    vec3(0.5, 0.5, 0),
    vec3(0.25, 0.5, 1),
    vec3(0.5, 0.75, 1),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  triColor = drawTri(
    vec3(0.0, 1.0, 0),
    vec3(0.25, 1.0, (sin(u_time) + 1.0) / 2.0),
    vec3(0.0, 0.75, (cos(u_time) + 1.0) / 2.0),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  triColor = drawTri(
    vec3(1.0, 1.0, 0),
    vec3(1.0, 0.75, (sin(u_time) + 1.0) / 2.0),
    vec3(0.75, 1.0, (cos(u_time) + 1.0) / 2.0),
    baseColor
  );
  color = mix(color, triColor, triColor.a);
    
  triColor = drawTri(
    vec3(1.0, 0.0, 0),
    vec3(0.75, 0.0, (sin(u_time) + 1.0) / 2.0),
    vec3(1.0, 0.25, (cos(u_time) + 1.0) / 2.0),
    baseColor
  );
  color = mix(color, triColor, triColor.a);
    
  triColor = drawTri(
    vec3(0.0, 0.0, 0),
    vec3(0.0, 0.25, (sin(u_time) + 1.0) / 2.0),
    vec3(0.25, 0.0, (cos(u_time) + 1.0) / 2.0),
    baseColor
  );
  color = mix(color, triColor, triColor.a);

  gl_FragColor = color;
}
