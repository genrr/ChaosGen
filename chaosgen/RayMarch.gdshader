shader_type canvas_item;

uniform float w=2.555;
uniform vec3 orig=vec3(-1.92,-0.015,-0.005);
float sdf(vec3 p){
	return length(p)-1.;
}
bool march(vec3 dir,vec3 origin,out vec3 N){
	int maxSteps=1000;
	vec3 p=origin;
	float dist=0.;
	for(int i=0;i<maxSteps;i++){
		dist=sdf(p)+dist;
		p=origin+dir*dist;
		if(sdf(p)<0.001){
			N=normalize(p);
			return true;
		}
	}
	
	return false;
}
uniform vec3 L=vec3(0.605,10.125,10.455);
void fragment() {
	COLOR=mix(vec4(0.4,.4,0.7,0.7),vec4(0.8,0.8,0.8,1),UV.y);

	vec3 dir=normalize(vec3(1,(UV.x-0.5)*w,(UV.y-0.5)*w));
	vec3 N;
	bool hit=march(dir,orig,N);
	if(hit){

		float NdotL=(dot(N,normalize(-L))+1.)/2.;
		COLOR=vec4(NdotL,NdotL,NdotL,1);
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
