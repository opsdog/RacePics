/*

  General query program

  Args:

    database
    query in quotes

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <my_global.h>
#include <mysql.h>
#include <my_sys.h>

main (int argc, char *argv[])
{
  int CommandLength;
  int NumFields;
  int FieldIndex;

  MYSQL QueryDB;
  MYSQL_RES *QueryResult;
  MYSQL_ROW QueryRow;
  MYSQL_FIELD *FieldDB;

  char Command[1024];
  char DBName[50];

  FILE *DBvip;
  char DBLocation[20];
  char DBHost[30];
  char DBUser[30];
  char DBPassword[30];

  /* did we get enough args? */

  if (argc != 3) {
    printf("usage: %s database query\n",argv[0]);
    printf("  database - name of the database to use\n");
    printf("  query - the database query in double quotes\n");
    exit(-1);
  }

  strcpy(DBName,argv[1]);
  strcpy(Command,argv[2]);
  CommandLength=strlen(Command);

  /*  where is the database?  */

  DBvip=fopen("/tmp/DBvip","r");
  fscanf(DBvip,"%s",DBLocation);

  /*  printf("Database is running on %s\n",DBLocation);*/

  if ( strcmp(DBLocation,"localhost")==0 ) {
    /*    printf("setting localhost variables...\n");*/
    strcpy(DBHost,"localhost");
    strcpy(DBUser,"doug");
    strcpy(DBPassword,"ILikeSex");
  }
  else 
    if ( strcmp(DBLocation,"big-mac")==0 ) {
      /*      printf("setting big-mac variables...\n");*/
      strcpy(DBHost,"big-mac");
      strcpy(DBUser,"doug");
      strcpy(DBPassword,"ILikeSex");
    } else {
      printf("Unknown database:  %s\n",DBLocation);
      exit(1);
    }

  fclose(DBvip);

  /* open the database */

  if (mysql_init(&QueryDB) == NULL) {
    fprintf(stderr,"Database not initialized\n");
    exit(-1);
  }
  /*  if (!mysql_real_connect(&QueryDB,"big-mac","doug","ILikeSex",DBName,*/
  if (!mysql_real_connect(&QueryDB,DBHost,DBUser,DBPassword,DBName,
			  3306,NULL,0))
    {
      fprintf(stderr, "Connect failed: %s\n",mysql_error(&QueryDB));
      exit(-1);
    }

  if (mysql_real_query(&QueryDB, Command, CommandLength)) {
    fprintf(stderr,"Command %s failed: %s\n",Command,
	    mysql_error(&QueryDB));
    exit(-1);
  }
  QueryResult=mysql_use_result(&QueryDB);

  if ( (QueryRow=mysql_fetch_row(QueryResult)) != NULL ) {

    /* how many fields did we get? */
    NumFields=0;
    while((FieldDB = mysql_fetch_field(QueryResult))) 
      NumFields++;

    while (QueryRow != NULL) {
      for (FieldIndex=0;FieldIndex<NumFields;FieldIndex++)
	printf("%s ",QueryRow[FieldIndex]);
      printf("\n");
      QueryRow=mysql_fetch_row(QueryResult);
    }  /* while non-NULL row */
  }  /* if non-NULL row */

  /* clean up and get out */

  mysql_free_result(QueryResult);
  mysql_close(&QueryDB);

}
