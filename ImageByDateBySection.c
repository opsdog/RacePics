/*

Returns a list of images given inputs of the date and gallery section.

Intended to be used by the create gallery scripts

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

  MYSQL RacepicsDB;
  MYSQL_RES *HumanResult,
    *ImageResult,
    *VehicleResult;
  MYSQL_ROW HumanRow,
    ImageRow,
    VehicleRow;
  MYSQL_FIELD *FieldDB;

  char Command[1024];

  /*  did we get enough args? */

  if (argc != 3 ) {
    printf("usage: %s date section\n",argv[0]);
    printf("  date in format yyyy-mm-dd or 'all'\n");
    printf("  section one of main, junior, special\n");
    exit(-1);
  }

  /* open the database */

  if (mysql_init(&RacepicsDB) == NULL) {
    fprintf(stderr,"RacepicsDB not initialized\n");
    exit(-1);
  }

  if (!mysql_real_connect(&RacepicsDB,"big-mac","doug","ILikeSex","racepics",
			  3306,NULL,0))
    {
      fprintf(stderr, "Connect failed: %s\n",mysql_error(&RacepicsDB));
      exit(-1);
    }

  /* get the images */

  strcpy(Command,"select id from image where ");
  if (strcmp(argv[1],"all") != 0) {
    strcat(Command,"taken = '");
    strcat(Command,argv[1]);
    strcat(Command,"' and ");
  }
  strcat(Command,"section = '");
  strcat(Command,argv[2]);
  strcat(Command,"' and venue = 'SW'");
  CommandLength=strlen(Command);

  /*  printf("Command: %s\n",Command);*/

  if (mysql_real_query(&RacepicsDB, Command, CommandLength)) {
    fprintf(stderr,"Command %s failed: %s\n",Command,
	    mysql_error(&RacepicsDB));
    exit(-1);
  }

  ImageResult=mysql_use_result(&RacepicsDB);

  if ( (ImageRow=mysql_fetch_row(ImageResult)) != NULL ) {
    while (ImageRow != NULL) {
      printf("%s\n",ImageRow[0]);
      ImageRow=mysql_fetch_row(ImageResult);
    }  /* while non-NULL row */
  }  /* if non-NULL row */

  /* clean up and get out */

  mysql_free_result(ImageResult);
  mysql_close(&RacepicsDB);



}


