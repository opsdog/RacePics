/*

Returns a list of vehicle numbers, sorted

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

  strcpy(Command,"select num from vehicle order by num");
  CommandLength=strlen(Command);

  if (mysql_real_query(&RacepicsDB, Command, CommandLength)) {
    fprintf(stderr,"Command %s failed: %s\n",Command,
	    mysql_error(&RacepicsDB));
    exit(-1);
  }

  VehicleResult=mysql_use_result(&RacepicsDB);

  if ( (VehicleRow=mysql_fetch_row(VehicleResult)) != NULL ) {
    while (VehicleRow != NULL) {
      printf("%s\n",RemoveSpaces(VehicleRow[0]));
      VehicleRow=mysql_fetch_row(VehicleResult);
    }  /* while non-NULL row */
  }  /* if non-NULL row */

  /* clean up and get out */

  mysql_free_result(VehicleResult);
  mysql_close(&RacepicsDB);
}
