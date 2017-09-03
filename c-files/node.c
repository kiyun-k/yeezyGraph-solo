#include "map.h"
#include "node.h"
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//n_init added

struct Node *initNode(char *name) {
	struct Node *new_node = malloc(sizeof(struct Node));
	new_node->name = name;
	new_node->visited = false;
	new_node->inNodes = m_init();
	new_node->outNodes = m_init();
	new_node->data = malloc(sizeof(void *));
	return new_node;
}

void setNodeData(struct Node *curr_node, void *data) {
	curr_node->data = data;
}


char *getNodeName(struct Node *curr_node) {
	return curr_node->name;

}

bool isVisited(struct Node *curr_node) {
	return curr_node->visited;

}

void setVisited(struct Node *curr_node, bool val){
	curr_node->visited = val;
	return;
}

struct List *getInNodes(struct Node *curr_node) {
	struct List *l = initList();
	for (int i = 0; i < curr_node->inNodes->size; i++) {

		char *key = m_key(curr_node->inNodes, i);
		l_add(l, key);
	}
	return l;
}

struct List *getOutNodes(struct Node *curr_node) {
	struct List *l = initList();
	for (int i = 0; i < curr_node->outNodes->size; i++) {
		char *key = m_key(curr_node->outNodes, i);
		l_add(l, key);
	}
	return l;
}

void *getNodeData(struct Node *curr_node) {
	return curr_node->data;
}

void printNode(struct Node *n) {
	printf("%s ", "node name: ");
	printf("%s\n", n->name);
	printf("%s ", "node visited: ");
	printf("%d\n", n->visited);
	printf("%s ", "node inNodes: ");
	print_map(n->inNodes);
	printf("%s ", "node outNodes: ");
	print_map(n->outNodes);

}
