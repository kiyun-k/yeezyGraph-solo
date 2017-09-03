#ifndef __QUEUE_H__
#define __QUEUE_H__

struct Node {
	void *data;
	struct Node *next;
};

struct Queue {
	struct Node *front;
	struct Node *rear;
	int size;
};

struct Queue *initQueue();
void enqueue(struct Queue *queue, void *data);
void dequeue(struct Queue *queue);
void *front(struct Queue *queue);
int q_size(struct Queue *queue);
 
#endif 