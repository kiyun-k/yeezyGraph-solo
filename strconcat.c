#include <string.h>
#include <stdio.h>


char * strconcat(char *a, char *b)
{
  char *result = strcat(a, b);
  return result;
}


#ifdef BUILD_TEST
int main()
{
  char *foo = "hello";
  char *bar = "world";
  char *full = strconcat(foo, bar);
  print(full);
}
#endif
