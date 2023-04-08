model Left driver EMF{
nsuri = "SequenceDiagram"
};

model Right driver EMF{
nsuri = "cd"
};

pre {
}

rule Lifeline2Class
	match l : Left!Lifeline
	with r : Right!Class {
	compare : l.type = r.name 
}

rule Lifeline2Operation
	match l : Left!Message
	with r : Right!Class {
	compare : (l.`operation`.matchOperation(r.operations) or l.`operation`.matchOperation(r.superTypes.operations))
}

rule Message2Operation
	match l : Left!Message
	with r : Right!Operation {
	
	compare : l.`operation` = r.name 
		and l.matches(r) and l.parameters.matches(r.parameters)
}

rule Param2Param 
	match l: Left!Parameter
	with r: Right!Parameter {
	
	compare : l.name = r.type.name and l.name = r.name
}

operation String matchOperation(other : Collection<Right!Operation>) : Boolean {
    for (op : Right!Operation  in other) {
    	if(op.name == self)
    	return true;
    	}
    	return false;
    
}

post {
	matchTrace.size().println("All Matches: ");
	matchTrace.reduced.size().println("Successful Matches: ");
}