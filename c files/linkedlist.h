#ifndef __LINKEDLIST_H__
#define __LINKEDLIST_H__

struct ListNode {
	void *data;
	struct ListNode *next;
	struct ListNode *prev;
};

struct List {
	struct ListNode *head;
};

struct List *initList();

void printList(struct List *list);

struct ListNode *getNode(struct List *list, int index);

void addNode(struct List *list, int index, struct ListNode *node);

void removeNode(struct List *list, int index);

void appendNode(struct List *list, struct ListNode *node);

void removeAll(struct List *list);

int isEmpty(struct List *list);

int size(struct List *list);

#endif
