extends Control


enum tokenType{
	number,star,plus,minus,openbracket,id,equals
	
}
class token:
	var token:String
	var type:tokenType
var numsS=['1','2','3','4','5','6','7','8','9','0','.']
var idS=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','o','ä','ö','å','1','2','3','4','5','6','7','8','9','0']
var ptr=0
func readNum(code):

	var num=""
	while ptr<len(code) and code[ptr] in numsS:
		num+=code[ptr]
		ptr+=1
	return num
func readID(code):
	var id=""
	while ptr<len(code) and code[ptr].to_lower() in idS:
		id+=code[ptr]
		ptr+=1
	return id
func lexicalAnalysis():
	var code=$CodeEdit.text
	ptr=0
	var tokens=[]
	while ptr<len(code):
		if(code[ptr] in numsS):
			var a=token.new()
			a.token=readNum(code)
			a.type=tokenType.number
			tokens.append(a)
			continue
		if(code[ptr]=='+'):
			var a=token.new()
			a.token=code[ptr]
			ptr+=1
			a.type=tokenType.plus
			tokens.append(a)
			continue
		if(code[ptr]=='*'):
			var a=token.new()
			a.token=code[ptr]
			ptr+=1
			a.type=tokenType.star
			tokens.append(a)
			continue
		if(code[ptr]=='-'):
			var a=token.new()
			a.token=code[ptr]
			ptr+=1
			a.type=tokenType.minus
			tokens.append(a)
			continue
		if(code[ptr]=='='):
			var a=token.new()
			a.token=code[ptr]
			ptr+=1
			a.type=tokenType.equals
			tokens.append(a)
			continue
		if(code[ptr] in idS):
			var a=token.new()
			a.token=readID(code)
			a.type=tokenType.id
			tokens.append(a)
			continue
		push_error("Unrecognized symbol ",code[ptr])
		break
			
	for i in tokens:
		print(i.token,",",tokenType.keys()[i.type])
	return tokens
func Parse(toks):
	return
func transpile(AST):
	var src="""shader_type canvas_item;

uniform float w=2.555;
uniform vec3 orig=vec3(-1.92,-0.015,-0.005);
float sdf(vec3 p){"""
	#return length(p)-1.;
	src+=$CodeEdit.text;
	src+="""}
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
"""
	var shader = Shader.new()
	shader.code=src
	$view.material.shader=shader
func compile():
	lexicalAnalysis()
	transpile("")
func _process(delta: float) -> void:
	$view.material.set_shader_parameter("rotation", $cam.rot)
	$view.material.set_shader_parameter("radius", $cam.radius)

			
		
		
