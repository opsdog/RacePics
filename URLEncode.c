#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{

  int Length, index, NewLength;
  char *String;
  char Result[1024];

  if ( argc != 2 ) {
    printf("I need a string, dipshit\n");
    exit(-1);
  }

  Length = strlen(argv[1]);
  NewLength = 0;
  String = (char *)malloc(Length);
  strcpy(String,argv[1]);

  for (index=0;index<Length;index++)
    if (String[index] == ' ') {
      Result[NewLength]='%';
      NewLength++;
      Result[NewLength]='2';
      NewLength++;
      Result[NewLength]='0';
      NewLength++;
    } 
    else if (String[index] == '/') {
      Result[NewLength]='-';
      NewLength++;
    } else {
      Result[NewLength]=String[index];
      NewLength++;
    }

  Result[NewLength]='\0';

  printf("%s\n",Result);

  return (0);
}
