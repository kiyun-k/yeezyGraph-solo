#include "linkedlist.h"
#include "map.h"
#include "pqueue.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int initial_pq_size = 8;
int count;


struct Pqueue {
	struct Node **node_arr;
	int pq_size;
	int count;
};



struct Pqueue *initPqueue() {
	struct Pqueue *pq = malloc(sizeof(struct Pqueue));
	pq->count = 0;
	pq->pq_size = initial_pq_size;
	pq->node_arr = (struct Node **) malloc(sizeof(struct Node *) * initial_pq_size);
	return pq;
}


void pq_push(struct Pqueue *pq, struct Node *n)
{
	// Repq_size the heap if necessary
	if (pq->count == pq->pq_size)
	{
		pq->pq_size *= 2;
		pq->node_arr = realloc(pq->node_arr, sizeof(struct Node *) * pq->pq_size);
	}

	int new_node_data = *((int *) n->data);

 	int index = pq->count;
 	pq->count++;

 	// Find the correct queue index to insert the element
 	while (index > 0) {

 		int pq_node_data = *((int *) pq->node_arr[index - 1]->data);

 		if (new_node_data <= pq_node_data) {
 			break;
 		}
 		else {
 			index--;
 		}
 	}

 	// Shift the queue elements to the right of index by 1 space
 	for (int i = (pq->count) - 1; i >= index; i--) {
 		pq->node_arr[i] = pq->node_arr[i - 1];
 	}

 	pq->node_arr[index] = n;
}


struct Node *pq_pop(struct Pqueue *pq)
{
	struct Node *removed = pq->node_arr[--pq->count];
 	return removed;
}


bool pq_isEmpty(struct Pqueue *pq) {
	return pq->count == 0;
}


int pq_size(struct Pqueue *pq) {
	return pq->count;
}
