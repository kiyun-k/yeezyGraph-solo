#include "linkedlist.h"
#include <stdio.h>

int main(){
	struct List *list = initList();
	if( list == NULL ) {
		print("FAIL - INITLIST");
		return;
	}
	if(!l_isEmpty(list)){
		print("FAIL - LIST SHOULD BE EMPTY ON INIT");
	}

	struct ListNode *n1 = malloc(sizeof(struct ListNode));
	n1 -> data = "foo";
	struct ListNode *n2 = malloc(sizeof(struct ListNode));
	n2 -> data = "bar";

	l_add(list, n1);
	if(l_isEmpty(list)){
		print("FAIL - ISEMPTY SHOULD RETURN FALSE");
	}
	if(l_size(list) != 1) {
		print("FAIL - SIZE SHOULD BE 1");
	}

	l_insert(list, n2, 1);
	if(l_size(list) != 2){
		print("FAIL - SIZE SHOULD BE 2");
	}
	
	return 0;
}