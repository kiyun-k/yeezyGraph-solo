#include "map.h"
#include "graph.h"
#include "linkedlist.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//g_init, addNode added

extern struct Graph *initGraph() {
	struct Graph *new_graph = malloc(sizeof(struct Graph));
	struct List *new_list = initList();
	new_graph->nodes = new_list;
	new_graph->size = 0;
	return new_graph;
}

extern void addNode (struct Graph* g, struct Node *n) {
	for (int i = 0; i < g->size; i++) {
		struct Node *no = (struct Node *)((l_get(g->nodes, i))->data);
		if (no->name == n->name) {
			return;
		}
	}
	struct ListNode *temp = malloc(sizeof(void *));
	temp -> data = n;
	l_add(g->nodes, temp);
	g->size++;
}

extern void removeNode (struct Graph* g, struct Node *n) {
	for (int i = 0; i < g->size; i++) {
		struct Node *no = (struct Node *)((l_get(g->nodes, i))->data);
		if (strcmp(no->name, n->name) == 0) {
			struct ListNode *listnode = l_get(g->nodes, i);
			l_remove(g->nodes, i);
			g->size--;
		}
	}

	for (int i = 0; i < g->size; i++) {
		struct Node *no = (struct Node *)((l_get(g->nodes, i))->data);
		if (m_get(no->inNodes, n->name) != -1) {
			m_remove(no->inNodes, n->name);
		}
		if (m_get(no->outNodes, n->name) != -1) {
			m_remove(no->outNodes, n->name);
		}
	}
}

extern void addEdge(struct Graph* g, struct Node *n1, struct Node *n2, int weight) {
	// check that n1 and n2 exist
	bool n1exist = false;
	int n1index = -1;
	bool n2exist = false;
	int n2index = -1;
	for (int i = 0; i < g->size; i++) {
		struct Node *no = (struct Node *)(l_get(g->nodes, i))->data;
		if (no->name == n1->name) {
			n1exist = true;
			n1index = i;
		}
		if (no->name == n2->name) {
			n2exist = true;
			n2index = i;
		}
	}
	if (n1exist && n2exist != true) {
		return;
	}

	struct Node *no1 = (struct Node *)(l_get(g->nodes, n1index))->data;
	struct Node *no2 = (struct Node *)(l_get(g->nodes, n2index))->data;


	// add to outNodes of n1
	m_insert(no1->outNodes, n2->name, weight);

	// add to inNodes of n1
	m_insert(no2->inNodes, n1->name, weight);

}

extern void removeEdge(struct Graph* g, struct Node *n1, struct Node *n2) {
	// check that n1 and n2 exist
	bool n1exist = false;
	int n1index = -1;
	bool n2exist = false;
	int n2index = -1;
	for (int i = 0; i < g->size; i++) {
		struct Node *no = (struct Node *)(l_get(g->nodes, i))->data;
		if (no->name == n1->name) {
			n1exist = true;
			n1index = i;
		}
		if (no->name == n2->name) {
			n2exist = true;
			n2index = i;
		}
	}
	if (n1exist && n2exist != true) {
		return;
	}

	struct Node *no1 = (struct Node *)(l_get(g->nodes, n1index))->data;
	struct Node *no2 = (struct Node *)(l_get(g->nodes, n2index))->data;


	//check outNodes of n1
	int weight1 = m_get(no1->outNodes, no2->name);
	int weight2 = m_get(no1->outNodes, no2->name);
	if(weight1 != -1 && weight1 == weight2) {
		m_remove(no1->outNodes, no2->name);
		m_remove(no2->inNodes, no1->name);
	}
}


extern int getWeight(struct Graph* g, struct Node *n1, struct Node *n2) {
	struct map *m = n1->outNodes;
	int result = m_get(m, n2->name);
	if (result != INFINITY) {
		return result;
	}
	else return INFINITY;

}


extern struct Node *getNodeByIndex(struct Graph* g, int index) {
	struct ListNode *listnode = l_get(g->nodes, index);
	return listnode->data;
}

void removeAllNodes(struct Graph* g) {
	for (int i = 0; i < g->size; i++) {
		struct ListNode *listnode = l_get(g->nodes, i);
		struct Node *no = listnode->data;
		removeNode(g, no);
	}
}


void freeGraph(struct Graph* g) {
	for (int i = 0; i < g->size; i++) {
		struct ListNode *listnode = l_get(g->nodes, i);
		free(listnode->data);
		free(listnode);
	}
	free(g->nodes);
	free(g);
}

void printGraph(struct Graph* g) {
	printf("%s\n", "graph: ");
	for (int i = 0; i < g->size; i++) {
		struct ListNode *listnode = l_get(g->nodes, i);
		struct Node *nod = (struct Node *)listnode->data;
		printNode(nod);
		printf("%s", "\n");
	}

}


bool isEmpty(struct Graph* g) {
	if (g->size == 0) {
		return true;
	}
	else return false;
}

int size(struct Graph* g) {
	return g->size;
}

bool contains(struct Graph* g, char *name) {
	int size = g->size;
	for (int i = 0; i < size; i++) {
		struct Node *no = (struct Node *)((l_get(g->nodes, i))-> data);
		if (no->name == name ){
			return true;
		}
	}
	return false;

}

struct Node *getNodeByName(struct Graph* g, char *name) {
	int size = g->size;
	for (int i = 0; i < size; i++) {
		struct Node *no = (struct Node *)((l_get(g->nodes, i))-> data);
		if (no->name == name ){
			return no;
		}
	}
	return NULL;

}
