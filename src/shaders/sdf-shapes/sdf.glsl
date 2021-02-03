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

// sdf combinations
float union(float d1, float d2) {
  return min(d1, d2);
}

float subtract(float d1, float d2) {
  return max(-d1, d2);
}

float intersect(float d1, float d2) {
  return max(d1, d2);
}

// https://timcoster.com/2020/02/11/raymarching-shader-pt1-glsl/
float GetDist(vec3 p)
{
    float sphereDist = sphere(p - vec3(0.0, 1.0, 8.0), 1.0);
    float planeDist = plane(p, vec3(0.0, 1.0, 0.0), 0.0);
    float boxDist = box((p - vec3(-2.0, 1.0, 8.0)) * rotate3d(vec3(0.0, time, 0.0)), vec3(0.5, 0.5, 0.25));
    float ringDist = torus((p - vec3(2.0, 1.0, 8.0)) * rotate3d(vec3(PI / 2.0, 0.0, -time)), vec2(0.5, 0.25));
    float d = union(planeDist, sphereDist);
    d = union(d, boxDist);
    d = union(d, ringDist);
 
    return d;
}
 
float RayMarch(vec3 ro, vec3 rd) 
{
    float dO = 0.; //Distane Origin
    for(int i=0;i<MAX_STEPS;i++)
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
    d/= 10.;
    vec3 color = vec3(d);
     
    // Set the output color
    gl_FragColor = vec4(color,1.0);
}