#include "node.h"

int main(){
	struct Node *n = initNode("foo");
	int *d = 15

	if(isVisited(n)){
		print("FAILED TO SET VISITED TO FALSE");
	}

	setNodeData(n, d);

	int *i = (int *)getNodeData(n);

	if(*i != *d){
		print("FAILED TO CORRECTLY SET OR GET NODE DATA");
	}

	if(getNodeName(n) != "foo") {
		print("FAILED TO SET NAME PROPERLY");
	}

	setVisited(n, true);
	if(!isVisited(n)){
		print("FAILED TO SET VISITED TO TRUE");
	}


	return 0;
}