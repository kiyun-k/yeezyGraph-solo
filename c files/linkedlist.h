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

struct ListNode *l_get(struct List *list, int index);

void l_insert(struct List *list, int index, struct ListNode *node);

void l_remove(struct List *list, int index);

void l_add(struct List *list, struct ListNode *node);

void removeAll(struct List *list);

int l_isEmpty(struct List *list);

int l_size(struct List *list);

#endif
