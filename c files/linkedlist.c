#include "linkedlist.h"
#include <stdio.h>
#include <stdlib.h>

struct List *initList() {
	struct List* list = (struct List *) malloc(sizeof(struct List));
	list -> head = NULL;
	return list;
}

void printList(struct List *list){
	printf("%s", "{");
	struct ListNode *current = list -> head;
	while(current != NULL){
		printf("%s", (char *)(current -> data));
		if(current -> next) {
			printf("%s", ",");
		}
		current = current -> next;
	}
	printf("%s", "}");
}

struct ListNode *getNode(struct List *list, int index) {
	int i = 0;
	struct ListNode *current = list -> head;
	while(i < index) {
		current = current -> next;
		i++;
	}
	return current;
}

void addNode(struct List* list, int index, struct ListNode *node){
	int count = 0;
	struct ListNode *current = list -> head;
	struct ListNode *next, *prev;
	while(count < index) {
		prev = current -> prev;
		current = current -> next;
	}

	node -> prev = prev;
	node -> next = current;

}

void removeNode(struct List *list, int index){
	int count = 0;
	struct ListNode *current = list -> head;
	struct ListNode *next, *prev;
	while(count < index) {
		prev = current -> prev;
		current = current -> next;
		next = current -> next;
	}
	free(current);
	prev -> next = next;
	next -> prev = prev;
}

void appendNode(struct List *list, struct ListNode *node){
	struct ListNode *current = list -> head;
	struct ListNode *prev;
	while(current != NULL){
		prev = current;
		current = current -> next;
	}

	prev -> next = node;
}

void removeAll(struct List *list){
	struct ListNode *current = list -> head -> next;
	struct ListNode *next;
	while(current != NULL){
		next = current -> next;
		free(current);
		current = next;
	}
}

int isEmpty(struct List *list){
	return list -> head == NULL;
}

int size(struct List *list){
	int count = 0;
	struct ListNode *current = list -> head;
	while(current != NULL) {
		count++;
		current = current -> next;
	}
	return count;
}
