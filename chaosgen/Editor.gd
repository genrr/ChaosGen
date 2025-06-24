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
func transpile(AST):
	return
func compile():
	lexicalAnalysis()
	

			
		
		
