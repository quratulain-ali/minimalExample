model Left driver EMF{
nsuri = "www.sequenceDiagram.com"
};

model Right driver EMF{
nsuri = "www.classdiagram.com"
};

pre {
}

rule Lifeline2Class
	match l : Left!Lifeline
	with r : Right!Class {
	compare : (l.ownerObject = r.name and (l.elements.matches(r.operations)
	or 
	l.elements.matches(r.superClass.operations)))
}

rule Message2Operation
	match l : Left!Message
	with r : Right!Operation {
	
	compare : l.action = r.name 
		and l.op.matches(r)
}

rule Operation2Operation 
	match l: Left!Operation
	with r: Right!Operation {
	
	compare : l.returnType = r.returnType and l.param.matches(r.parameters)
}

rule Param2Param 
	match l: Left!Param
	with r: Right!Parameter {
	
	compare : l.argType = r.type
}
post {
	matchTrace.size().println("All Matches: ");
	matchTrace.reduced.size().println("Successful Matches: ");
}