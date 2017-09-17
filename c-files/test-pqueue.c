#include "pqueue.h"


int main() {
	struct Pqueue *p = initPqueue();
	if(p == NULL){
		print("FAILED TO INITIAIZE PQUEUE");
	}

	if(!pq_isEmpty(p)) {
		print("PQUEUE SHOULD BE EMPTY ON INITIALIZATION");
	}

	struct Node *n = initNode("foo");

	pq_push(p, n);

	if(!pq_isEmpty(p)|| pq_size(p) != 1) {
		print("PQUEUE SHOULD HAVE ONE ELEMENT AFTER PUSHING ONE NODE");
	}

	pq_pop(p);

	if(!pq_isEmpty(p)){
		print("PQUEUE SHOULD BE EMPTY AFTER POP");
	}

	return 0;
}
