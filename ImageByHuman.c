/*

Returns a list of images given input of a person's name.

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
  int NumVehicles;
  int VehicleIndex;

  MYSQL RacepicsDB;
  MYSQL_RES *HumanResult,
    *ImageResult,
    *VehicleResult;
  MYSQL_ROW HumanRow,
    ImageRow,
    VehicleRow;
  MYSQL_FIELD *FieldDB;

  char Command[1024];
  char HumanIDstr[40];
  char Vehicle[20][15];  /* hopefully no one has more than 20 vehicles */

  /*  did we get enough args? */

  if (argc != 2 ) {
    printf("usage: %s name\n",argv[0]);
    printf("  name driver/owner name in quotes\n");
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


  /******************************************/
  /******************************************/
  /******************************************/
  /******************************************/
  /******************************************/
  /******************************************/

  /* get vehicles by human */

  strcpy(Command,"select vehicle.num from vehicle,human where human.name = '");
  strcat(Command,argv[1]);
  strcat(Command,"' and vehicle.humanid = human.id");
  CommandLength=strlen(Command);

  if (mysql_real_query(&RacepicsDB, Command, CommandLength)) {
    fprintf(stderr,"Command %s failed: %s\n",Command,
	    mysql_error(&RacepicsDB));
    exit(-1);
  }

  VehicleResult=mysql_use_result(&RacepicsDB);

  /* build an array of vehicle numbers */

  NumVehicles=0;
  if ( (VehicleRow=mysql_fetch_row(VehicleResult)) != NULL ) {
    while (VehicleRow != NULL) {
      strcpy(Vehicle[NumVehicles],VehicleRow[0]);
      NumVehicles++;
      VehicleRow=mysql_fetch_row(VehicleResult);
    }  /* while Vehicles */
  } else {  /* VehicleRow not NULL */
    printf("No vehicles found for %s\n",argv[1]);
    exit(-1);
  }  /* VehicleRow NULL */
  mysql_free_result(VehicleResult);

  /* get the images for each vehicle */

  for (VehicleIndex=0;VehicleIndex<NumVehicles;VehicleIndex++) {
    /* output images by vehicle */
    strcpy(Command,"select id from image where vehnum = '");
    strcat(Command,Vehicle[VehicleIndex]);
    strcat(Command,"'");
    CommandLength=strlen(Command);

    if (mysql_real_query(&RacepicsDB, Command, CommandLength)) {
      fprintf(stderr,"Command %s failed: %s\n",Command,
	      mysql_error(&RacepicsDB));
      exit(-1);
    }
    ImageResult=mysql_use_result(&RacepicsDB);
    if ( (ImageRow=mysql_fetch_row(ImageResult)) != NULL) {
      while (ImageRow != NULL) {
	printf("%s\n",ImageRow[0]);
	ImageRow=mysql_fetch_row(ImageResult);
      }  /* while images */
    }  /* if images */
    mysql_free_result(ImageResult);

  }  /* for vehicles loop */

  /* clean up and get out */

  mysql_close(&RacepicsDB);



}


