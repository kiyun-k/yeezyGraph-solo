#ifndef __NODE_H__
#define __NODE_H__

#include "map.h"
#include "linkedlist.h"
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


struct Node {
	char *name;
	bool visited;
	struct map *inNodes;
	struct map *outNodes;
	void *data;
};


struct Node *initNode(char *name);

char *getNodeName(struct Node *curr_node);

void setNodeData(struct Node *curr_node, void *data);


bool isVisited(struct Node *curr_node);

void setVisited(struct Node *curr_node, bool val);

struct List *getInNodes(struct Node *curr_node);

struct List *getOutNodes(struct Node *curr_node);

void *getNodeData(struct Node *curr_node);

void printNode(struct Node *node);

#endif