#ifndef __GRAPH_H__
#define __GRAPH_H__


#include "node.h"
#include "map.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "linkedlist.h"

struct Graph {
	struct List *nodes;
	int size;
};


extern struct Graph *initGraph();

extern void addNode (struct Graph* g, struct Node *n);

extern void removeNode (struct Graph* g, struct Node *n);

extern void addEdge(struct Graph* g, struct Node *n1, struct Node *n2, int weight);

extern void removeEdge(struct Graph* g, struct Node *n1, struct Node *n2);

extern int getWeight(struct Graph* g, struct Node *n1, struct Node *n2);

extern struct Node *getNodeByIndex(struct Graph* g, int index);

void freeGraph(struct Graph* g);

void removeAllNodes(struct Graph* g);

void printGraph(struct Graph* g);

bool isEmpty(struct Graph* g);

int size(struct Graph* g);

bool contains(struct Graph* g, char *name);

struct Node *getNodeByName(struct Graph* g, char *name);




#endif
