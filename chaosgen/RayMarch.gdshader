shader_type canvas_item;

uniform float w=2.555;
uniform vec3 orig=vec3(-1.92,-0.015,-0.005);
uniform vec4 rotation=vec4(1,1,0,0);
uniform float radius=0;
float sdf(vec3 p){
	 vec3 q = abs(p) - 1.;
  	return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
	//return length(p)-1.;
}
vec3 estimateNormal(vec3 p) {
    const float delta = 0.0005;
    return normalize(vec3(
        sdf(p + vec3( delta, 0.0, 0.0)) - sdf(p - vec3( delta, 0.0, 0.0)),
        sdf(p + vec3(0.0,  delta, 0.0)) - sdf(p - vec3(0.0,  delta, 0.0)),
        sdf(p + vec3(0.0, 0.0,  delta)) - sdf(p - vec3(0.0, 0.0,  delta))
    ));
}
bool march(vec3 dir,vec3 origin,out vec3 N){
	int maxSteps=1000;
	vec3 p=origin;
	float dist=0.;
	for(int i=0;i<maxSteps;i++){
		dist=sdf(p)+dist;
		p=origin+dir*dist;
		if(sdf(p)<0.001){
			//N=normalize(cross((dFdx(p)),(dFdy(p))));
			N=estimateNormal(p);
			if (length(N) < 0.001) {
 			   N = vec3(0.0, 0.0, 1.0); // Default normal
			}
			N=normalize(N);
			return true;
		}
	}
	
	return false;
}
uniform vec3 L=vec3(0.605,10.125,10.455);
vec3 rotate_by_quaternion(vec3 v, vec4 q) {
    vec3 u = q.xyz;
    float s = q.w;

    return 2.0 * dot(u, v) * u
         + (s * s - dot(u, u)) * v
         + 2.0 * s * cross(u, v);
}
void fragment() {
	COLOR=mix(vec4(0.4,.4,0.7,0.7),vec4(0.8,0.8,0.8,1),UV.y);
	vec3 orig2=rotate_by_quaternion(vec3(orig.x+radius,orig.yz), rotation);
	vec3 dir=normalize(vec3(1,(UV.x-0.5)*w,(UV.y-0.5)*w));
	vec3 N;
	bool hit=march(rotate_by_quaternion(dir,rotation),orig2,N);
	if(hit){

		float NdotL=(dot(N,normalize(-L))+1.)/2.;
		COLOR=vec4(NdotL,NdotL,NdotL,1);
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
