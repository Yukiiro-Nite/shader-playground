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

// https://timcoster.com/2020/02/11/raymarching-shader-pt1-glsl/
float GetDist(vec3 p)
{
    vec3 s = vec3(0,1,6. + sin(time)*3.0); //Sphere. xyz is position w is radius
    float sphereDist = sphere(p - s, 1.0);
    float planeDist = plane(p, vec3(0.0, 1.0, 0.0), 0.0);
    float leftDist = plane(p, vec3(1.0, 0.0, 0.0), 2.0);
    float rightDist = plane(p, vec3(-1.0, 0.0, 0.0), 2.0);
    float ceilDist = plane(p, vec3(0.0, -1.0, 0.0), 2.0);
    float d = min(sphereDist, planeDist);
    d = min(d, leftDist);
    d = min(d, rightDist);
    d = min(d, ceilDist);
 
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