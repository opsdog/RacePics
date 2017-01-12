#include <stdio.h>
#include <strings.h>

extern char *RemoveSpaces(char *String);
char Result[2048];

char *RemoveSpaces(char *String)
{

  int Length, index, NewLength;

  Length=strlen(String);
  NewLength=0;

  for (index=0;index<Length;index++)
    if (String[index] != ' ') {
      Result[NewLength]=String[index];
      NewLength++;
    }

  Result[NewLength]='\0';

  return (Result);
}
