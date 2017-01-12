/*

Returns a list of humans, ordered by name

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

  /* get the humans */

  strcpy(Command,"select id, name from human order by name");
  CommandLength=strlen(Command);

  if (mysql_real_query(&RacepicsDB, Command, CommandLength)) {
    fprintf(stderr,"Command %s failed: %s\n",Command,
	    mysql_error(&RacepicsDB));
    exit(-1);
  }

  HumanResult=mysql_use_result(&RacepicsDB);

  if ( (HumanRow=mysql_fetch_row(HumanResult)) != NULL ) {
    while (HumanRow != NULL) {
      printf("%s %s\n",HumanRow[0],RemoveSpaces(HumanRow[1]));
      HumanRow=mysql_fetch_row(HumanResult);
    }  /* while non-NULL row */
  }  /* if non-NULL row */

  /* clean up and get out */

  mysql_free_result(HumanResult);
  mysql_close(&RacepicsDB);



}


