#include <stdio.h>
#include <stdlib.h>
#include "queue.h"


int q_size(struct Queue* queue) {
	return queue->size;
}

struct Queue* initQueue() {
	struct Queue* new = (struct Queue*) malloc(sizeof(struct Queue));
	new->front = 0;
	new->rear = 0;
	new->size = 0;
	return new;
}

void enqueue(struct Queue *queue, void *data) {
	struct Node* temp = (struct Node*)malloc(sizeof(struct Node));
	temp -> data = data;
	temp -> next = NULL;
	if (queue->front == NULL && queue->rear == NULL) {
		queue->front = queue->rear = temp;
		queue->size++;
		return;
	}
	queue->rear->next = temp;
	queue->rear = temp;
	queue->size++;
}

void dequeue(struct Queue *queue) {
	struct Node* temp = queue->front;
	if (queue->front == NULL) {
		return;
	}
	if (queue->front==queue->rear) {
		queue->front = queue->rear = NULL;
	}
	else {
		queue->front = queue->front->next;
	}
	queue->size--;
	free(temp);
}

void *front(struct Queue *queue) {
	if(queue->front == NULL) {
		return NULL;
	}
	return queue->front->data;
}
