pre {
	var Lifeline2ClassMap = Right!Class.all.mapBy(param|param.name);
	var Message2OperationMap = Right!Operation.all.mapBy(param|param.name);
	var Param2ParamMap = Right!Parameter.all.mapBy(param|param.name);
}
rule Lifeline2Class
match l : Left!Lifeline
with r : Right!Class
from : Lifeline2ClassMap.get(l.type) ?: Sequence{}
 {
	

	compare : l.type = r.name


}
rule Lifeline2Operation
match l : Left!Message
with r : Right!Class {
	

	compare : (l.`operation`.matchOperation(r.operations) or l.`operation`.matchOperation(r.superTypes.operations))


}
rule Param2Param
match l : Left!Parameter
with r : Right!Parameter
from : Param2ParamMap.get(l.name) ?: Sequence{}
 {
	

	compare : l.name = r.type.name and l.name = r.name


}
rule Message2Operation
match l : Left!Message
with r : Right!Operation
from : Message2OperationMap.get(l.`operation`) ?: Sequence{}
 {
	

	compare : l.`operation` = r.name and l.matches(r) and l.parameters.matches(r.parameters)


}
post {
	matchTrace.size().println("All Matches: ");
	matchTrace.reduced.size().println("Successful Matches: ");
}

operation String matchOperation(other : Collection(Right!Operation)) : Boolean {
	for (op : Right!Operation in other) {
		if (op.name == self) {
			return true;
		}
	}
	return false;
}