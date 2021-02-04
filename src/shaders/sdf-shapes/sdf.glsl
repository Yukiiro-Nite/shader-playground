uniform vec2 resolution;  // Width and height of the shader
uniform float time;  // Time elapsed
 
// Constants
#define PI 3.1415925359
#define TWO_PI 6.2831852
#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST .01

mat3 rotate3d(vec3 r) {
  // needed to flip x and z, equation was in a different order
  float rx = r.z;
  float ry = r.y;
  float rz = r.x;

  float f11 = cos(rx) * cos(ry);
  float f21 = cos(rx) * sin(ry) * sin(rz) - sin(rx) * cos(rz);
  float f31 = cos(rx) * sin(ry) * cos(rz) + sin(rx) * sin(rz);

  float f12 = sin(rx) * cos(ry);
  float f22 = sin(rx) * sin(ry) * sin(rz) + cos(rx) * cos(rz);
  float f32 = sin(rx) * sin(ry) * cos(rz) - cos(rx) * sin(rz);

  float f13 = -sin(ry);
  float f23 = cos(ry) * sin(rz);
  float f33 = cos(ry) * cos(rz);

  return mat3(
    vec3(f11, f21, f31),
    vec3(f12, f22, f32),
    vec3(f13, f23, f33)
  );
}

float cross(vec2 a, vec2 b) {
  return a.x * b.y - a.y * b.x;
}

// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
// sdf shapes
float sphere(vec3 pos, float radius) {
  return length(pos) - radius;
}

float plane(vec3 pos, vec3 norm, float h) {
  return dot(pos, norm) + h;
}

float box(vec3 pos, vec3 bounds) {
  vec3 q = abs(pos) - bounds;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float torus(vec3 pos, vec2 thickness) {
  vec2 q = vec2(length(pos.xz) - thickness.x, pos.y);
  return length(q) - thickness.y;
}

float cone(vec3 pos, vec2 angle, float height) {
  vec2 q = height * vec2(angle.x / angle.y, -1.0);

  vec2 w = vec2(length(pos.xz), pos.y);
  vec2 a = w - q * clamp(dot(w, q) / dot(q, q), 0.0, 1.0);
  vec2 b = w - q * vec2(clamp(w.x / q.x, 0.0, 1.0), 1.0);
  float k = sign(q.y);
  float d = min(dot(a, a), dot(b, b));
  float s = max(k * cross(w, q), k * (w.y - q.y));

  return sqrt(d) * sign(s);
}

// vec3 pa = p - a, ba = b - a;
//   float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
//   return length( pa - ba*h ) - r;

float capsule(vec3 pos, vec3 start, vec3 end, float radius) {
  vec3 posToStart = pos - start;
  vec3 startToEnd = end - start;

  float h = clamp(dot(posToStart, startToEnd) / dot(startToEnd, startToEnd), 0.0, 1.0);

  return length(posToStart - startToEnd * h) - radius;
}

// sdf combinations
float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float opSubtract(float d1, float d2) {
  return max(-d1, d2);
}

float opIntersect(float d1, float d2) {
  return max(d1, d2);
}

// https://timcoster.com/2020/02/11/raymarching-shader-pt1-glsl/
float GetDist(vec3 p)
{
  // define all of the shapes
  float sphereDist = sphere(p - vec3(0.0, 1.0, 8.0), 1.0);
  float planeDist = plane(p, vec3(0.0, 1.0, 0.0), 0.0);
  float boxDist = box((p - vec3(-2.0, 1.0, 8.0)) * rotate3d(vec3(0.0, time, 0.0)), vec3(0.5, 0.5, 0.25));
  float ringDist = torus((p - vec3(2.0, 1.0, 8.0)) * rotate3d(vec3(PI / 2.0, 0.0, -time)), vec2(0.5, 0.25));
  float coneDist = cone((p - vec3(0.0, 4.0, 8.0)), vec2(sin(PI / 8.0), cos(PI / 8.0)), 1.0);
  float capsuleDist = capsule(p, vec3(-3.0, 2.5, 8.0), vec3(3.0, 2.5, 8.0), 0.25);

  // put all of the shapes together
  float d = opUnion(planeDist, sphereDist);
  d = opUnion(d, boxDist);
  d = opUnion(d, ringDist);
  d = opUnion(d, coneDist);
  d = opUnion(d, capsuleDist);

  return d;
}
 
float RayMarch(vec3 ro, vec3 rd) 
{
  float dO = 0.; // Distance Origin
  for(int i=0; i<MAX_STEPS; i++)
  {
    vec3 p = ro + rd * dO;
    float ds = GetDist(p); // ds is Distance Scene
    dO += ds;
    if(dO > MAX_DIST || ds < SURFACE_DIST) break;
  }
  return dO;
}
 
void main()
{
    vec2 uv = (gl_FragCoord.xy-.5*resolution.xy)/resolution.y;
    vec3 ro = vec3(0,1,0); // Ray Origin/ Camera
    vec3 rd = normalize(vec3(uv.x,uv.y,1));
    float d = RayMarch(ro,rd); // Distance
    d /= 10.;
    vec3 color = vec3(d);
     
    // Set the output color
    gl_FragColor = vec4(color,1.0);
}