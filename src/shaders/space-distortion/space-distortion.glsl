uniform vec2 resolution;  // Width and height of the shader
uniform float time;  // Time elapsed
 
// Constants
#define PI 3.1415925359
#define TWO_PI 6.2831852
#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURFACE_DIST .01

// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sphere(vec3 pos, float radius) {
  return length(pos) - radius;
}

float plane(vec3 pos, vec3 norm, float h) {
  return dot(pos, norm) + h;
}

float capsule(vec3 pos, vec3 start, vec3 end, float radius) {
  vec3 posToStart = pos - start;
  vec3 startToEnd = end - start;

  float h = clamp(dot(posToStart, startToEnd) / dot(startToEnd, startToEnd), 0.0, 1.0);

  return length(posToStart - startToEnd * h) - radius;
}

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

// https://timcoster.com/2020/02/11/raymarching-shader-pt1-glsl/
float GetDist(vec3 p)
{
  vec3 spherePos = vec3(1.5, 1.0, 8.0);
  float xWave = ((sin(abs(spherePos.x - p.x) + time) + 1.0) / 4.0) + ((cos(p.y * 16.0 + time * 8.0) + 1.0) / 4.0) + 0.25;
  vec3 s = (p - spherePos) / vec3(xWave, 1.0, xWave);

  vec3 treeStart = vec3(-1.5, 0.0, 8.0);
  float wind = sin(time) / 10.0 + sin(time / 1.3) / 11.0;
  vec3 treeEnd = vec3(-1.5, 3.0, 8.0) + vec3(wind, 0.0, 0.0);
  float treeWave = ((1.0 - fract(p.y * 2.0)) / 2.0 + 0.5) * (1.0 - fract(p.y / ((treeEnd - treeStart).y + 1.0)));

  float sphereDist = sphere(s, 1.0);
  float floorDist = plane(p, vec3(0.0, 1.0, 0.0), 0.0);
  float treeDist = capsule(p, treeStart, treeEnd, treeWave);

  float d = opUnion(sphereDist, floorDist);
  d = opUnion(d, treeDist);

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