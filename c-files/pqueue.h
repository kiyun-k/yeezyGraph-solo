#ifndef __Pqueue_H__
#define __Pqueue_H__

#include "linkedlist.h"
#include "map.h"
#include "node.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


extern struct Pqueue *initPqueue();

extern void pq_push(struct Pqueue *pq, struct Node *n);

extern struct Node *pq_pop(struct Pqueue *pq);

extern bool pq_isEmpty(struct Pqueue *pq);

extern int pq_size(struct Pqueue *pq);


#endif
