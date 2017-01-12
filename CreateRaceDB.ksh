#!/bin/ksh
#!/usr/local/bin/ksh
#
#  Create the racepics database and tables
#

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/mysql/bin"
ProgPrefix=/Volumes/External300/DBProgs/RacePics

##
##  determine if we're running on big-mac or quarter-pounder
##  big-mac has to run against local DB
##  quarter-pounder can run against either local (itself) or big-mac
##

unset MYSQL
. /Volumes/External300/DBProgs/FSRServers/DougPerfData/SetDBCase.ksh

MyEMail="doug.greenwald@gmail.com"

${MYSQL} << EOF

drop database if exists racepics;
create database racepics;

use racepics;

create table image (
pkey    int auto_increment not null,
id	varchar(100) not null,
eventid int not null default -1,   #  FK into events
vehnum	varchar(30),               #  NHRA number - foreign key to vehicle
taken	date,                      #  date image taken
section enum ('main', 'junior', 'special', 'show') default 'main',  #  gallery section

#primary key (id, vehnum)

primary key (pkey),

index i_id (id),
index i_veh (vehnum),
index i_taken (taken)

)
engine = MyISAM
${DBdirClause}
;

create table commerce (
id      varchar(100) not null,         # image id
vehnum  varchar(30) default 'NULL',
caption varchar(512) default 'NULL',  # caption for web page
ikid    varchar(40) default 'NULL',   # imagekind image ID
cfbs    varchar(25) default 'NULL',   # cafepress bumper sticker
cfcl    varchar(25) default 'NULL',   # cafepress clock
cfmp    varchar(25) default 'NULL',   # cafepress mouse pad
rbid    varchar(60) default 'NULL',   # redbubble id
zfgal   varchar(25) default 'NULL',   # zenfolio gallery id
zfname  varchar(50) default 'NULL',   # zenfolio gallery name
zfid    varchar(25) default 'NULL',   # zenfolio id
zazmp   varchar(125) default 'NULL',  # zazzle mousepad
zazps   varchar(125) default 'NULL',  # zazzle postage stamp
zazcard varchar(125) default 'NULL',  # zazzle greeting card
zazmug  varchar(125) default 'NULL',  # zazzle mug - half and full
zazpost varchar(125) default 'NULL',  # zazzle poster

primary key (id),

index i_veh (vehnum)

)
engine = MyISAM
${DBdirClause}
;

create table keywords (
id      varchar(100) not null,         # image id
words   blob(2048),                   # the keywords, seperated by spaces
descrip blob(2048),                   # description

primary key (id)
)
engine = MyISAM
${DBdirClause}
;

create table zengallery (
gallid   varchar(20) not null primary key,
gallname varchar(50) default 'NULL'
)
engine = MyISAM
${DBdirClause}
;

create table bestof (
id      varchar(100) not null, 
section enum ('cars', 'burn-out', 'launch', 'junior'),

primary key (id)
)
engine = MyISAM
${DBdirClause}
;

create table event (
pkey      int not null auto_increment,
held      date,
descrip   varchar(512),
keywords  blob,
ikgal     varchar(50) default 'NULL',  #  ImageKind gallery for the event
webtext   blob(2048),     ##  HTML for the date gallery web page
venue     enum(
               'SW',      ##  SpeedWorld
               'N91',     ##  Northern & 91st
               'RRMD',    ##  Rock and Roll McDonalds
               'GSub',    ##  Gilbert Subway
               'PCON',    ##  Pelion Church of the Nazarene
               'SCPF',    ##  South Carolina Poultry Festival
               'SVHS'     ##  Spring Valley High School
              ) default 'SW',
class     enum('show', 'race') default 'race',
subclass  enum('car', 'bike', 'drag') default 'drag',
picdir    varchar(256),   ##  the directory that holds the master images to post

primary key (pkey),

index i_held (held)
)
engine = MyISAM
${DBdirClause}
;

create table vehicle (
num	varchar(30) not null,	#  NHRA number
year    int,                    #  vehicle year
make    varchar(25),            #  vehicle make
model   varchar(30),            #  vehicle model
name    varchar(150),            #  name or description of car
type    enum('bike', 'car', 'junior', 'jrcomp') default 'car',
class   enum ('junior', 'jrcomp', 'SG', 'bike', 'unknown') default 'unknown',
humanid	int default -1,		#  foreign key into table human
ikgal   varchar(50),            #  ImageKind gallery for the vehicle

primary key (num)
)
engine = MyISAM
${DBdirClause}
;

create table human (
id	int not null auto_increment,
name	varchar(100),
address	varchar(75),
city	varchar(50),
state	varchar(50),
zip	varchar(10),
email	varchar(60) default 'NULL',

primary key (ID)
)
engine = MyISAM
${DBdirClause}
;

create table expinfo (
id      varchar(100) not null primary key,
expose  varchar(255) default 'NULL'
)
engine = MyISAM
${DBdirClause}
;


#
#  populate tables
#

# event

insert into event (held, descrip, ikgal, webtext, keywords) values ('2007-01-07', 'Test-n-Tune, Junior Dragster', 'http://opsdog.imagekind.com/SpeedWorld-2007-01-07', '<h1 align=center>Speed World - January 7, 2007</h1><p>Images taken at Speed World Raceway Park on Januay 7, 2007.  This was my introduction to drag racing of any kind and I had a blast.</p><p>My thanks to the owners/drivers who took the time to talk to me and who let some random stranger take pictures of their cars. You all made me feel welcome into your world.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2007-02-04', 'West Coast Hot Rod Association - Heads Up Outlaw Classes', 'http://opsdog.imagekind.com/SpeedWorld-2007-02-04', '<h1 align=center>Speed World - February 4, 2007</h1><p>Images taken at Speed World Raceway Park on February 4, 2007.</p><p><a href="http://www.westcoasthotrod.com/">West Coast Hot Rod Association</a> - Heads Up Outlaw Classes and more</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2007-02-10', '<a href="http://www.metzcon.com/adra/">Arizona Drag Racing Association</a> (ADRA) Points Race - Super Pro and Pro Brackets, Junior Dragster', 'http://opsdog.imagekind.com/SpeedWorld-2007-02-10', '<h1 align=center>Speed World - February 10, 2007</h1><p>Images taken at Speed World Raceway Park on February 10, 2007.</p><p><a href="http://www.metzcon.com/adra/">Arizona Drag Racing Association</a> (ADRA) Points Race - Super Pro and Pro Brackets</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2007-03-04', 'Test-n-Tune, Junior Dragster, Kids on Trikes', 'http://opsdog.imagekind.com/SpeedWorld-2007-03-04', '<h1 align=center>Speed World - March 4, 2007</h1><p>Images taken at Speed World Raceway Park on March 4, 2007.</p><p>I took lots of pictures today so these are broken into sections.  First are the open runs.  The second section is the <a href="#Junior">Junior Dragster</a> event.  The third section is a special event for the <a href="#Kids">younger children</a>.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2007-10-07', 'Slick and Street Trophy Classes', 'http://opsdog.imagekind.com/SpeedWorld-2007-10-07', '<h1 align=center>Speed World - October 7, 2007</h1><p>Images taken at Speed World Raceway Park on October 7, 2007.</p><p>Slick and Street Trophy Classes.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2008-08-02', '<a href="http://www.nhra.com/">NHRA</a> Summit Racing ET Series #7 "Final Race:" Running Super Pro/ Pro/ Sportsman/MC & High School Class for points', 'http://opsdog.imagekind.com/SpeedWorld-2008-08-02', '<h1 align=center>Speed World - August 2, 2008</h1><h1 align=center><a hef="http://www.nhra.com/">NHRA</a> Summit Racing ET Series "Final Race"</h1><br clear=all><p>Images taken at Speed World Raceway Park on August 2, 2008.</p><p>It hass been almost a year since I was here taking pictures and I have missed the smell of burned rubber and the ear-pounding power of the cars.</p><p>This was my first attempt at taking pictures of racing at night.  I spent a while proving to myself that, yes, really, my poor several-years-old digital camera really is not fast enough to stop the motion of the cars launching from the starting line at night.</p><p>One of these attempts is interesting in that the light streaks show the front end rising while the rear end drops as the car takes off - <a href="_Main/_Screen/DSCN5180-Crop01-Sharp.JPG">see that one here</a>.  The rest are just blurry or the camera took so long to focus that the car was already gone :-)</p><p>So these images are mostly as you staged or in the lanes and pits.</p><p>Enjoy - I did :-)</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2008-08-16', 'Saturday Night Street Drags, PLUS.. "<a href="http://arizonasfasteststreetcars.com/">Arizonas Fastest Street Cars</a>"', 'http://opsdog.imagekind.com/SpeedWorld-2008-08-16', '<h1 align=center>Speed World - August 16, 2008</h1><p>Images taken at Speed World Raceway Park on August 16, 2008.</p><p>Saturday Night Street Drags, PLUS.. "<a href="http://www.arizonasfasteststreetcars.com/">Arizona Fastest Street Cars</a>"</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2008-09-05', 'Arizona Drag Racing Points Race & Time Only Lane', 'http://opsdog.imagekind.com/SpeedWorld-2008-09-05', '<h1 align=center>Speed World - September 5, 2008</h1><p>Images taken at Speed World Raceway Park on September 5, 2008.</p><p>Featuring the <a href="http://www.metzcon.com/adra/">Arizona Drag Racing Association</a> (ADRA) Points Race and a Time Only lane.</p><p>Not many pictures.  I was called back home for a family emergency.  I was there just long enough to determine that my flash is not as useful as I had hoped.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, ikgal, webtext, keywords) values ('2008-09-20', 'Junior Dragsters - Day 1, Trike Racing, and After9events presents the 5 Year Customer Appreciate Event', 'http://opsdog.imagekind.com/SpeedWorld-2008-09-20', '<h1 align=center>Speed World - September 20, 2008</h1><p>Images taken at Speed World Raceway Park on September 20, 2008.</p><p>Lots of activity today.  A couple of vehicles taking advantage of test-n-tune.  A big Junior Dragsters event.  More trike racing for the younger kids.  And the 5 Year Customer Appreciation event.</p><p>Scroll through the images or jump to a section:<br>&nbsp;&nbsp;&nbsp;<a href="#Junior">Junior Dragster Event Pictures</a><br>&nbsp;&nbsp;&nbsp;<a href="#Special">Trike Racing Pictures</a><br>&nbsp;&nbsp;&nbsp;<a href="#Show">Customer Appreciation Event Pictures</a></p><p>Click on an image to see it larger</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-10-04', 'NHRDA Desert Diesel Truck Nationals Presents the "MBRP Performance Exhaust Diesel Drag Race Series" and Saturday Night Street Drags', '<h1 align=center>Speed World - October 4, 2008</h1><p>Images taken at Speed World Raceway Park on October 4, 2008.</p><p>NHRDA Desert Diesel Truck Nationals Presents the "MBRP Performance Exhaust Diesel Drag Race Series," the Banks Power "Sidewinder" S-10, and Saturday Night Street Drags</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-10-11', 'Northern Arizona Shoot-Out 10 Class Bracket Racing plus Team Speedworld Junior Dragter Points Race', '<h1 align=center>Speed World - October 11, 2008</h1><p>Images taken at Speed World Raceway Park on October 11, 2008.</p><p>Three major events going on today.  Northern Arizona Shoot-Out 10 Class Bracket Racing, <a href="#Junior">Junior Dragsters</a>, and more <a href="#Kids">Kids on Trikes</a>.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-10-17', 'Arizona Drag Racing Association 2008 points series race #12. Join the ADRA and race with the best competitors in the state. Plus Speedworld will run a Test N Tune Lane & Street Trophy.', '<h1 align=center>Speed World - October 17, 2008</h1><p>Images taken at Speed World Raceway Park on October 17, 2008.</p><p>Arizona Drag Racing Association 2008 points series race #12.</p><p>Plus Street Trophy and test and tune.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-10-18', 'Speedworld Welcomes the "Arizona Fastest Street Cars" plus SUPER Street, Gas, and Comp Points Race and an open test lane.', '<h1 align=center>Speed World - October 18, 2008</h1><p>Images taken at Speed World Raceway Park on October 18, 2008.</p><p>"Arizona Fastest Street Cars"! Plus SUPER Street, Gas, and Comp Points Race. Also Open Test Lane.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-11-15', 'National Dragster Challenge Of the Wild West ET Showdown - "Wally Race," Running 5 Bracket Classes of Summit ET Series', '<h1 align=center>Speed World - November 15, 2008</h1><p>Images taken at Speed World Raceway Park on November 15, 2008.</p><p>National Dragster Challenge Of the Wild West ET Showdown - "Wally Race" Running 5 Bracket Classes of Summit ET Series.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2008-11-22', 'ADRA Memorial Race - Remembering our Fallen Racers, Test and Tune', '<h1 align=center>Speed World - November 22, 2008</h1><p>Images taken at Speed World Raceway Park on November 22, 2008.</p><p>ADRA Memorial Race - Remembering our Fallen Racers and open test lane.</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-01-01', 'Hang Over Nationals - Gambler Race, Junior Dragster Combo Class, Test and Tune', '<h1 align=center>Speed World - January 1, 2009</h1><p>No better way to spend New Years Day :-)</p><p>Images taken at Speed World Raceway Park on January 1, 2009.</p><p>Hang Over Nationals, Day 1 - Gambler Race, Junior Dragster Combo Class, and a Test and Tune lane.</p><p>Jump to the <a href="#Junior">Junior Dragster</a> event photos.<p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-01-03', 'Hang Over Nationals - Day 3, Test and Tune', '<h1 align=center>Speed World - January 3, 2009</h1><p>Images taken at Speed World Raceway Park on January 3, 2009.</p><p>Hang Over Nationals - Day 3</p><p>Another day at the track shortened by being called back home :-(</p><p>Comments, questions, and/or rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-01-31', 'Arizonas Fastest Street Cars - Test and Tune', '<h1 align=center>January 31, 2009</h1><p>Arizonas Fastest Street Cars and test-n-tune</p><p>Questions, comments, and rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a></p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-02-07', 'Arizona Drag Racing Assocation (ADRA) - Test and Tune', '<h1 align=center>February 7, 2009</h1><p>Images of ADRA racing and test-n-tune</p><p>Questions, comments, and rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a></p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-02-13', 'Huges Performance NHRA National Open - Junior Dragster - Junior Comp', '<h1 align=center>February 13, 2009</h1><p>Images of Hughes Performance NHRA National Open racing and <a href="#Junior">Junior Dragster</a>.</a><p>Also images of the new (to me anyway) <a href="#Special">Junior Comp</a> class racing.</p><p>Questions, comments, and rude remarks to <a href="mailto:${MyEMail}">${MyEMail}</a>.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-03-01', 'West Coast Hot Rod Eliminations', '<h1 align=center>March 1, 2009</h1><p>Images of the <a href="http://www.westcoasthotrod.com/">West Coast Hot Road Association</a>s elimination racing.</p><p>Plus the Keeter Ray Racing funny car.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-03-07', 'Junior Dragsters and NHRDA Diesel Nationals followed by Arizonas Fastest Street Cars', '<h1 align=center>March 7, 2009</h1><p>Lots of variety today with the NHRDA Desert Nationals running alongside the Junior Dragsters and test-n-tune.  Sundown saw the return of <a href="http://arizonasfasteststreetcars.com/">Arizonas Fastest Street Cars</a>.</p><p>Just when I think I have seen everything go down the track, something new shows up.  I can honestly say I never expected to see a <a href="http://speedworld.daemony.com/Galleries/Unkn097/">diesel funny car</a> - WAY COOL!! :-)</p><p>Scroll through the images or jump to:</p><ul><li><a href="#Junior">Junior Dragsters</a><li><a href="#Special">Trike Racing</a><li><a href="#Show">AFSC</a></ul>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-03-08', 'Junior Dragsters and Test and Tune', '<h1 align=center>March 8, 2009</h1><p>More <a href="#Junior">Junior Dragster</a> racing today and a variety of vehicles taking advantage of the test-n-tunes lanes.</p><p>Scroll through all the images or jump to:</p><ul><li><a href="#Junior">Junior Dragsters</a><li><a href="#Special">Trike Racing</a></ul>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-03-14', 'SouthWest Nostalgia Drags and Cruise In Car Show', '<h1 align=center>March 14, 2009</h1><p>Dramatic partly cloudy skies for the SouthWest Nostalgia Drags and Cruise In Car Show.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-03-21', 'ADRA "Ted Hoover" Memorial points race points race #3.  Special guest Michelle Hoover, daughter of Ted and Kathy Hoover.', '<h1 align=center>March 21, 2009</h1><p>ADRA "Ted Hoover" Memorial points race points race #3.  Special guest Michelle Hoover, daughter of Ted and Kathy Hoover.</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-09-26', '&nbsp;', '<h1 align=center>September 26, 2009</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-11-01', '&nbsp;', '<h1 align=center>November 1, 2009</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-11-14', '&nbsp;', '<h1 align=center>November 14, 2009</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2009-11-15', '&nbsp;', '<h1 align=center>November 15, 2009</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2010-01-09', '&nbsp;', '<h1 align=center>January 9, 2010</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2010-01-16', '&nbsp;', '<h1 align=center>January 16, 2010</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');
insert into event (held, descrip, webtext, keywords) values ('2010-01-30', '&nbsp;', '<h1 align=center>January 30, 2010</h1><p>&nbsp;</p>', 'dragstrip track drag race racing motor sport car automobile bike junior dragster phoenix surprise whittman az arizona speedworld');

##
##  car shows
##

insert into event (held, class, subclass, venue, descrip, webtext, keywords) values ('2004-11-15', 'show', 'car', 'RRMD', 'Classic Car Show at the Rock and Roll McDonalds', '&nbsp;', 'motor sport car automobile bike show scottsdale az arizona rock roll mcdonalds');
insert into event (held, class, subclass, venue, descrip, webtext, keywords) values ('2010-11-06', 'show', 'car', 'GSub', 'Car Show at the Gilbert Subway', '&nbsp;', 'motor sport car automobile bike show south carolina sc gilbert subway');
insert into event (held, class, subclass, venue, descrip, webtext, keywords) values ('2013-04-06', 'show', 'car', 'PCON', 'Naz Fest at the Pelion Church of the Nazarene', '&nbsp;', 'motor sport car automobile bike show south carolina sc pelion church nazarene');
insert into event (held, class, subclass, venue, descrip, webtext, keywords) values ('2013-05-11', 'show', 'car', 'SCPF', 'Car Show at the South Carolina Poultry Festival', '&nbsp;', 'motor sport car automobile bike show south carolina sc gilbert poultry festival');
insert into event (held, class, subclass, venue, descrip, webtext, keywords) values ('2013-05-25', 'show', 'car', 'SVHS', 'Spring Valley High School Fifth Annual Open Car and Truck Show', '&nbsp;', 'motor sport car automobile bike show south carolina sc columbia spring valley high school');

# human

insert into human (name, email) values ('AJ and Deb Schwichenberg', 'AJS@poBoxMTAonline.net');
insert into human (name, email) values ('Amy Eberwein', 'amy_eberwein@cox.net');
insert into human (name, email) values ('Andy Dawson', 'speedfreak@desertinet.com');
insert into human (name, email) values ('Sharyl Gill', 'burnout006999@aol.com');
insert into human (name, email) values ('Chev509', 'chev509@aol.com');
insert into human (name, email) values ('Chris Gibson', 'crispy@northlink.com,ringodragster@yahoo.com');
insert into human (name, email) values ('Clyde Williams', 'racing721@cox.net');
insert into human (name, email) values ('Cole Briggs', 'dodge440van@juno.com,Cole.Briggs@colorado.edu');
insert into human (name, email) values ('Dana', 'dndhd@cox.net');
insert into human (name, email) values ('Dick and Sally Low', 'dspayson@npgcable.com');
insert into human (name, email) values ('Don Lindsey', 'donlindsey@adelphia.net');
insert into human (name, email) values ('Doug Romfo', 'dougr@ottotrucking.com');
insert into human (name, email) values ('Carolyn Hills', 'dragenlady@excite.com');
insert into human (name, email) values ('Arlon Neilson', 'ghostriderp709@cox.net');
insert into human (name, email) values ('Kelly Harper', 'kharper@cutteraviation.aero');
insert into human (name, email) values ('Ken Passerby', 'kpasserby@mchsi.com');
insert into human (name, email) values ('Luquas', 'luquas@cox.net');
insert into human (name, email) values ('Richard Church', 'rechurch@cox.net');
insert into human (name, email) values ('Butch and Steph Warner', 'stephwarner1968@yahoo.com');
insert into human (name, email) values ('Tad Woods', 'wwoods3@cox.net');
insert into human (name, email) values ('Tail Gate Racing', 'ailgateracing@cox.net');
insert into human (name, email) values ('Christman Brothers Racing', 'rrcri59395@msm.com');
insert into human (name, email) values ('Mark Bevins', 'teambeav@aol.com');
insert into human (name, email) values ('Tim DeBrocke', 'tim@earnhardt.com');
insert into human (name, email) values ('Tom Iversen', 'tiverse@msm.com');
insert into human (name, email) values ('Trammell Racing', 'dtrammell@ed2.com');
insert into human (name, email) values ('Buddy Jensen', 'twopistons@aol.com');
insert into human (name) values ('John McMillan');
insert into human (name) values ('Larry Cravy');
insert into human (name, email) values ('Danny Hills', 'dragenlady@excite.com');
insert into human (name) values ('Bill Botelho');
insert into human (name, email) values ('Zimmerman Racing', 'zimmermanracingengines@msn.com');
insert into human (name, email) values ('Aaron Christman', 'rrcri59395@msm.com');
insert into human (name, email) values ('Shelby Eberwein', 'amy_eberwein@cox.net');
insert into human (name) values ('Eric Hasemann');
insert into human (name) values ('Mitch Cole');
insert into human (name, email) values ('Bryan Downing', 'bustinb1@cox.net');
insert into human (name) values ('Matt Rhoades');
insert into human (name) values ('Steve Paulauskis');
insert into human (name, email) values ('Kelly and Will and classicinlines.com', 'GT200@cox.net');
insert into human (name) values ('HCH');
insert into human (name) values ('Ryan Smith');
insert into human (name, email) values ('Scott Oxford', 'oxchevy@cox.net');
insert into human (name, email) values ('Robbie Racer', 'rgrangrade@cox.net');
insert into human (name, email) values ('Vic and LeAnn Brum', 'mmbrum@q.com');
insert into human (name) values ('Mike and Ann');
insert into human (name) values ('Dennis Jokela');
insert into human (name, email) values ('Chaz Glenn', 'streetwerx@hotmail.com');
insert into human (name) values ('Jack and Diane Dyer');
insert into human (name) values ('Aaron Sally');
insert into human (name, email) values ('Scott Hess', 'hesshs2@quest.net');
insert into human (name, email) values ('Dave Muller', 'dmother27@yahoo.com');
insert into human (name, email) values ('Tyler Christman', 'rrcri59395@msm.com');
insert into human (name, email) values ('Chuck Peckham', 'chuck@streetrodinc.com');
insert into human (name) values ('David Pitera');
insert into human (name) values ('Brandon Gant');
insert into human (name) values ('Randy Walker');
insert into human (name) values ('Gerry Holines');
insert into human (name) values ('Ben Kriegsfeld');
insert into human (name) values ('&nbsp;');  # polar bear rail
insert into human (name, email) values ('George Varao', 'gvarao@cox.net'); # T777
insert into human (name, email) values ('Jeff Young', 'fro.1957@hotmail.com'); # white 1970 chevy nova - purple zigzag side stripes
insert into human (name, email) values ('David Hrbal', 'dave7550@aol.com'); # 71 pontiace lemans - 78 malibu
insert into human (name, email) values ('Sonora Drywall Racing', 'art@sonoradrywall.com');
insert into human (name, email) values ('Angelo Phillips', 'gtxang68@aol.com');
insert into human (name) values ('Shaun Strickland');
insert into human (name) values ('Kent Goodyear');
insert into human (name) values ('Steve Dolan');
insert into human (name, email) values ('Larry Spitali', 'spitpin67@aol.com');
insert into human (name, email) values ('Darrin Olszewski', 'btenderd@yahoo.com');
insert into human (name) values ('Lin Smith');
insert into human (name) values ('Nick Marconi');
insert into human (name) values ('Alex Kadar');
insert into human (name, email) values ('Jeff Bomyea', 'jbomyea.coldmtnmech@cox.net');
insert into human (name, email) values ('sprnova', 'sprnova@cox.net');
insert into human (name, email) values ('Jeff Sanders', 'funboy626@aol.com');
insert into human (name, email) values ('Harris Motor Sports', 'harrismotorsports@live.com');
insert into human (name, email) values ('Larry Burgess', 'pegasusb781@yahoo.com');
insert into human (name, email) values ('Marc Ocampo', 'quickstang1@cox.net');
insert into human (name, email) values ('ryviper', 'ryviper@aol.com');
insert into human (name) values ('Frank');
insert into human (name, email) values ('Team Carter Racing', 'jim@teamcarterracing.com');
insert into human (name, email) values ('Paul Lorton', 'balancingacts@qwest.net');
insert into human (name) values ('Jim Wade');
insert into human (name, email) values ('Scott Kilbourn', 'kilbournracing@yahoo.com');
insert into human (name, email) values ('Randy Chacon', 'rchacon3@cox.net');
insert into human (name, email) values ('No Limitz Ind', 'nolimiitzind@gmail.com');
insert into human (name, email) values ('Tammy Grova', 'tamtam00@cox.net');
insert into human (name, email) values ('Jake "the Snake" Miller', 'snake_12682@hotmail.com');
insert into human (name, email) values ('Psykotic Cykles', 'psykoticcykles@yahoo.com');
insert into human (name, email) values ('Bill Webber', 'rayedda@hotmail.com');
insert into human (name, email) values ('Charlie Schmidt', 'pb2@citlink.com');
insert into human (name, email) values ('Sylvia', 'knuckiebutt1@sbcglobal.net');
insert into human (name, email) values ('Morgan Childs', 'childstoy5@cox.net');
insert into human (name, email) values ('George "Honker" Striegel', 'claysmithcams@aol.com');
insert into human (name, email) values ('JRT Motor Sports', 'JRTMotorSports@aol.com');
insert into human (name, email) values ('Bill Schibi', 'bschibi@npgcable.com');
insert into human (name, email) values ('Claudia', 'claudia@aztranny.com');
insert into human (name) values ('Team Bimbo');
insert into human (name) values ('Mike Theulen');
insert into human (name) values ('Manning Walton');
insert into human (name) values ('Straight Line Racing');
insert into human (name) values ('MJM Racing');
insert into human (name, email) values ('Chaz Lightner', 'chaz@gruber.com');
insert into human (name, email) values ('Iron Bull Bumpers', 'Jesse@ironbullbumpers.com');
insert into human (name, email) values ('Muley Racing', 'mike@mcspadden.cc');
insert into human (name, email) values ('Mike McSpadden', 'mike@mcspadden.cc');
insert into human (name) values ('Wes Anderson');
insert into human (name, email) values ('REF Unlimited', 'REFUnlimited@frontiernet.net');
insert into human (name) values ('Jeff Shaw');
insert into human (name, email) values ('Hunter Walker', 'etp749@earthlink.net');
insert into human (name) values ('Mike Hartigan');
insert into human (name) values ('Brien Giglio');
insert into human (name) values ('Bo Adams');
insert into human (name) values ('Joe Stadelman');
insert into human (name) values ('Daryl Nance');
insert into human (name, email) values ('Dee', 'dznutzracing@yahoo.com');
insert into human (name, email) values ('TS29', 'MHDrumCore@aol.com');
insert into human (name, email) values ('Rob and Zeita Papineau', 'robandzeita@hotmail.com');
insert into human (name, email) values ('&nbsp;', 'mbradberry@wdmanor.com');
insert into human (name, email) values ('Eddie Brown', 'eddieb798@msn.com');
insert into human (name, email) values ('Brian Goodwin', 'briangoodwin89@yahoo.com');
insert into human (name) values ('Tuffy Johns');
insert into human (name) values ('Scott Hall');
insert into human (name) values ('Ray Bondy');
insert into human (name) values ('Mark LaLonde');
insert into human (name) values ('Arizona BUG Company');
insert into human (name) values ('Mike Proctor');
insert into human (name) values ('Jim Gallatin');
insert into human (name) values ('Christina, Mystic, Shyla');
insert into human (name) values ('Toby Smith');
insert into human (name) values ('Blake and Denise');
insert into human (name) values ('Brandon');
insert into human (name, email) values ('Mike Bradberry', 'mbradberry@wdmanor.com');
insert into human (name) values ('Debbie');
insert into human (name) values ('Nick Micale');
insert into human (name) values ('Nick Alejandre');
insert into human (name) values ('Keith Manogue');
insert into human (name) values ('Desert Sports Center');
insert into human (name, email) values ('Donald Phelps', 'azphelps999@msn.com');
insert into human (name, email) values ('LP Excavating', 'lpexcavating@aol.com');
insert into human (name, email) values ('A Herrera', 'aherrera7678@sbcglobal.net');
insert into human (name, email) values ('Doug Fleetwood', 'q763df@cox.net');
insert into human (name, email) values ('Tara Bostrom', 'tbostrom7@gmail.com');
insert into human (name, email) values ('Victor', 'wwwnsibilla@qwest.net');
insert into human (name) values ('Gene');
insert into human (name, email) values ('Victoria Griffey', 'info@speedworlddragstrip.com');
insert into human (name) values ('Mark Darsow');
insert into human (name) values ('Russ Stryker');
insert into human (name) values ('Johnny Burke');
insert into human (name) values ('Lester Goff');
insert into human (name, email) values ('Jerry Martinez Jr.', 'lude99@aol.com');
insert into human (name) values ("Terry O'Donnell");
insert into human (name, email) values ('Joe Howard', 'chev509@hotmail.com');
insert into human (name) values ('Darell');
insert into human (name) values ('Andy Kimball');
insert into human (name) values ('David Johnston');
insert into human (name) values ('Dwight Downing');
insert into human (name, email) values ('Steve and Hank Pramov', 'hpramov@yahoo.com');
insert into human (name) values ('Ron Hildreth');
insert into human (name, email) values ('Erica and Darrell Shields', 'darrellshields@roadrunner.com');
insert into human (name) values ('Price Racing');
insert into human (name) values ('Guy Price');
insert into human (name) values ('Charlie Boyd');
insert into human (name) values ('Duane Roberts');
insert into human (name) values ('Terry');
insert into human (name) values ('Roy Broguiere');
insert into human (name, email) values ('Sam Benavidez', 'sbenavidez@rummelconstruction.com');
insert into human (name) values ('Stephanie Hyatt');
insert into human (name, email) values ('Tom and Elana', 'dodgeit@earthlink.net');
insert into human (name, email) values ('Tom Koemen', 'TomsCorner@aol.com');
insert into human (name, email) values ('Mickey Lowder', 'badbadthingz@cox.net');
insert into human (name, email) values ('Melvin and Clydeen Dick', 'jmdick@wildblue.net');
insert into human (name) values ('Doug Droll');
insert into human (name) values ('Dan Horan Racing');
insert into human (name) values ('Mitch Bowen');
insert into human (name) values ('Yale Rosen');
insert into human (name) values ('DaVinci Stone');
insert into human (name) values ('Modular Mustang Racing');
insert into human (name) values ('Lone Wolf Racing');
insert into human (name) values ('Stephanie');
insert into human (name) values ('Joey Leal');
insert into human (name) values ('Gabrielle');
insert into human (name) values ('Scott');
insert into human (name) values ('Dave Alves');
insert into human (name) values ('Craig Bichle');
insert into human (name) values ('Austin Greenwell');
insert into human (name) values ('Ryan Greenwell');
insert into human (name) values ('Mary Ann');
insert into human (name) values ('Dick Meierhenry');
insert into human (name) values ('Jason');
insert into human (name) values ('Rodger');
insert into human (name) values ('Jami Jones');
insert into human (name) values ('Dylan Horridge');
insert into human (name) values ('Bob Sherwood');
insert into human (name) values ('Captian Morgan');
insert into human (name) values ('George Clark');
insert into human (name) values ('Dash Farr');
insert into human (name) values ('Derek Frank Sanchez');
insert into human (name) values ('Jemma');
insert into human (name) values ('Kristie');
insert into human (name) values ('Kaitlyn');
insert into human (name) values ('Mark Faul');
insert into human (name) values ('Tommy Gaynor');
insert into human (name) values ('Jimmy Morosan');
insert into human (name) values ('Greenwell');
insert into human (name, email) values ('Dale Schroeder', 'schroeder1@q.com');
insert into human (name, email) values ('Les Ogden', 'ogdenranch@cccomm.net');
insert into human (name, email) values ('Murray Hawker', 'mhawker@actionparts.ca, actionparts@nucleus.com');
insert into human (name, email) values ('Nicklas Morey', 'NKMorey@aol.com');
insert into human (name, email) values ('Will Baty', 'willb@centerforce.com');
insert into human (name, email) values ('Doug Walton', 'WaltonDoug@hotmail.com');
insert into human (name, email) values ('Travis Allman', 'travisallman@gmail.com');
insert into human (name) values ('Keeter Ray');
insert into human (name) values ('Ron Shaw');
insert into human (name) values ('Chris and Julie Sauer');
insert into human (name) values ('John Robinson');
insert into human (name) values ('Amanda Mazeris');
insert into human (name) values ('Rick Proctor');
insert into human (name) values ('John Patton');
insert into human (name) values ('Deb Carter');
insert into human (name) values ('Mike Aaby');
insert into human (name, email) values ('BlackCanyon2', 'blackcanyon2@cox.net');
insert into human (name, email) values ('onothugs', 'onothugs@yahoo.com');
insert into human (name, email) values ('John Schurr', 'jjschurr@aol.com');
insert into human (name) values ('Keith Downing');
insert into human (name) values ('Bustin Loose Racing');
insert into human (name) values ('Nik Downing');
insert into human (name) values ('Tibor Kadar');
insert into human (name) values ('Michael Giacone');
insert into human (name) values ('Terry McGovern');
insert into human (name) values ('Ron Monroe');
insert into human (name) values ('Howard DeVore');
insert into human (name) values ('Seth Polvadore');
insert into human (name) values ('Cyndi and Bill Coniam');
insert into human (name) values ('Tom Nickels');
insert into human (name, email) values ('Angel Estevez', 'Angel.Estevez@ge.com');
insert into human (name, email) values ('duran75@cox.net', 'duran75@cox.net');
insert into human (name, email) values ('Craig/Josh Taylor', 'cd2jjtay@cox.net');
insert into human (name, email) values ('Shyann Desa', 'shyanndesa@yahoo.com');  ##  dad is Keoki - tag the image of her standing alone
insert into human (name) values ('Matt and Nanci Bong');
insert into human (name) values ('Dick Lechien');
insert into human (name) values ('Eric Mageary');

# vehicle

insert into vehicle (num, name) values ('Multi', 'Completely unidentifed vehicles');
insert into vehicle (num, name, humanid, year, make, model) values ('Unkn001', 'John McMillans 1984 Silver/Grey Corvette', 28, 1984, 'Chevy', 'Corvette');
insert into vehicle (num, name, humanid, year, make, model) values ('Z592', 'maroon', 8, 1978, 'Dodge', 'Tradesman');
insert into vehicle (num, name, humanid, make, model) values ('Unkn002', 'deep purple', 10, 'Olds', 'Cutlas');
insert into vehicle (num, name, humanid, make, model) values ('526', 'No Hemi Here', 12, 'Chevy', 'Camaro');
insert into vehicle (num, name, humanid, year, make, model) values ('T753', "Larry's Money", 29, 1972, 'Dodge', 'Duster');
insert into vehicle (num, name, humanid, year, make, model) values ('427', 'light blue', 1, 1957, 'Chevy', 'BelAir');
insert into vehicle (num, name, humanid, year, make, model) values ('Unkn004', 'grey', 1, 1963, 'Chevy', 'Corvette');
insert into vehicle (num, name, humanid, make, model) values ('Unkn005', 'Warpath', 11, 'Chevy', 'Corvette');
insert into vehicle (num, name, humanid, make, model, class) values ('721W', 'white , flame hood', 7, 'Chevy', 'Corvette', 'SG');
insert into vehicle (num, name, humanid) values ('7728', 'Silver with stripes', 15);
insert into vehicle (num, name, humanid, make, type) values ('XM81', 'orange and black', 9, 'Harley-Davidson', 'bike');
insert into vehicle (num, name, humanid, make) values ('666', 'SS, blue on blue', 17, 'Chevy');
insert into vehicle (num, name, humanid, year, make, model) values ('H730', 'Twisted Terror', 23, 1972, 'Plymouth', 'Duster');
insert into vehicle (num, name, humanid) values ('Unkn007', '24 Kt', 19);
insert into vehicle (num, name, humanid, make, model) values ('C735', 'red headlights', 21, 'Plymouth', 'Roadrunner');
## Joe Howard ## insert into vehicle (num, name, humanid) values ('Unkn008', 'Black with flames, purple chute', 5);
insert into vehicle (num, name, humanid) values ('7228', 'Dragen Lady', 13);
insert into vehicle (num, name, humanid) values ('7208', 'Stolen Moments', 30);
insert into vehicle (num, name, humanid) values ('798A', "Grandpa's Hot Wheels", 31);
insert into vehicle (num, name, humanid, make) values ('410', 'Timmys Toy, orange, low square ram', 24, 'Dodge');
insert into vehicle (num, name, humanid, make) values ('T708', 'Timmys Toy, orange, low square ram', 24, 'Dodge');
insert into vehicle (num, name, humanid, make, model) values ('P748SG', 'Skull and rusty rivets', 32, 'Ford', 'Mustang');
insert into vehicle (num, name, humanid, class, type) values ('7196', 'Aaron - Junior Dragster', 33, 'junior', 'junior');
insert into vehicle (num, name, humanid, class, type) values ('7505', 'Shelby, Flying Colors Surface Repair, Inc', 2, 'junior', 'junior');
insert into vehicle (num, name, humanid, make, model) values ('7881', 'Camaro Yenko-SC', 4, 'Chevy', 'Camaro-Yenko');
insert into vehicle (num, name, humanid, make) values ('S402', 'Just Plain Ugly', 35, 'Pontiac');
insert into vehicle (num, name, humanid, make, model) values ('Unkn011', 'blue/white', 36, 'Ford', 'Mustang');
insert into vehicle (num, name, humanid) values ('720', 'red/white hood stripe, Bill Luke Chrysler', 37);
insert into vehicle (num, name, humanid) values ('7416', 'Blue to white Monza', 38);
insert into vehicle (num, name, humanid, make, model) values ('G735', '1960s - black', 6, 'Ford', 'Mustang');
insert into vehicle (num, name, humanid) values ('750D', '23T altered, Hot Fuscia', 3);
insert into vehicle (num, name, humanid, class, type) values ('729', 'Skull junior dragster', 26, 'junior', 'junior');
insert into vehicle (num, name, humanid, year, make) values ('Y755ET', 'black, showcar', 18, 1955, 'Chevy');
insert into vehicle (num, name, humanid) values ('P751P', 'Blast From the Past', 55);
insert into vehicle (num, name, humanid) values ('P709', 'Ghost Rider', 14);
insert into vehicle (num, name, humanid, year, make, model) values ('Unkn018', 'bright yellow', 25, 1972, 'Ford', 'Pinto Wagon');
insert into vehicle (num, name, humanid, class, type) values ('Unkn019', 'Red junior dragster', 20, 'junior', 'junior');
insert into vehicle (num, name, humanid) values ('Kid01', 'Tricycle racer', 20);
insert into vehicle (num, name, humanid, make) values ('7733', 'Blue decaled SS', 16, 'Chevy');
insert into vehicle (num, name, humanid) values ('J773', 'Yellow with stripes', 16);
#insert into vehicle (num, name, humanid) values ('X716', 'Sons car', 16);
insert into vehicle (num, name, type, model) values ('Unkn023', 'Bike - Hayabusa, black', 'bike', 'Hayabusa');
insert into vehicle (num, name, type) values ('Unkn024', 'Bike - Full white cowling', 'bike');
insert into vehicle (num, name, type) values ('ET293', 'Bike - black with wheelie bar', 'bike');
insert into vehicle (num, name, make, model) values ('Unkn025', '1980s, black', 'Ford', 'Mustang');
insert into vehicle (num, name, class, type, humanid) values ('7154', 'Junior Dragster, maroon with blue stripes', 'junior', 'junior', 20);
insert into vehicle (num, name, humanid) values ('Unkn027', 'while/light blue w/stripes - cowl hood', 62);
insert into vehicle (num, name, make) values ('Unkn028', 'SS, light grey w/blue hood stripes', 'Chevy');
insert into vehicle (num, name, make, model) values ('Unkn029', 'burgundy, ram and cowl, red window net', 'Chevy', 'Nova SS');
insert into vehicle (num, name, make, model) values ('Unkn030', 'bright red, ? brothers, no juice', 'Chevy', 'Nova');
insert into vehicle (num, name, make) values ('Unkn031', 'SS, dark, John Deere front plate', 'Chevy');
insert into vehicle (num, name, make, model) values ('7096', 'blue w/white hood stipes, ram and cowl, C&O Auto', 'Chevy', 'Nova');
insert into vehicle (num, name, class, type) values ('793', 'Junior, dark, script on side', 'junior', 'junior');
insert into vehicle (num, name) values ('501', 'Unmarked, bright red');
insert into vehicle (num, name, make, model) values ('Unkn032', '1980s dark blue, blue window net, stock', 'Chevy', 'Camaro');
insert into vehicle (num, name, make, model) values ('Unkn033', '1980s, white w/black hood, stock', 'Chevy', 'Monte Carlo');
insert into vehicle (num, name, make, model) values ('Unkn034', 'ram hood, yellow with jagged stripes', 'Olds', '442');
insert into vehicle (num, name) values ('HOT1', 'Probe, bright yellow, ram hood, autoelectric.com');
insert into vehicle (num, name, make, model) values ('Unkn035', '1980s, red, white scoop stripe, white side stripes', 'Ford', 'Mustang');
insert into vehicle (num, name) values ('Unkn036', '1950s Chevy (maybe), bright yellow, cowl hood');
insert into vehicle (num, name, make) values ('TT68', '1960s Chevelle body, black front, red rear, ram hood', 'Chevy');
insert into vehicle (num, name) values ('73SC', 'Red Bill Luke Rail, Keith');
insert into vehicle (num, name, humanid, make) values ('Unkn038', 'Dodge, red, WFO ram hood, dual chutes, gold wheels', 39, 'Dodge');
insert into vehicle (num, name, humanid, year, model) values ('Unkn039', 'Older, white, classicinlines.com', 40, 1963, 'Falcon');
insert into vehicle (num, name, humanid, make) values ('706', 'white, HCH, ram hood', 41, 'Dodge');
insert into vehicle (num, name, humanid) values ('Unkn040', 'El Camino/Gran Turino, primer front, red rear, ram hood, side exhaust', 57);
insert into vehicle (num, name) values ('743M', 'Dark blue, light blue flames front, ram hood');
insert into vehicle (num, name, make, humanid, year, model) values ('F738', 'Mr. Magoo II, purple, low ram hood', 'Plymouth', 54, '1969', 'Valiant');
insert into vehicle (num, name) values ('M751P', 'White Mischief');
insert into vehicle (num, name) values ('F773', 'Yellow, old station wagon');
insert into vehicle (num, name) values ('7930', 'orange with mutlicolor stripes, ram hood');
insert into vehicle (num, name, humanid, make, model) values ('R797', 'white, dual orange top stripes', 52, 'Chevy', 'Camaro');
insert into vehicle (num, name, humanid, make, year, model) values ('H761', 'SS, white, dual orange trunk stripes, cowl hood, vinyl roof', 51, 'Chevy', 1970, 'Chevelle');
insert into vehicle (num, name) values ('Unkn041', 'older, boxy, blue, low square ram');
insert into vehicle (num, name, humanid) values ('790', 'Yellow rail', 131);
insert into vehicle (num, name, humanid, make) values ('A701', 'white, ram hood', 50, 'Dodge');
insert into vehicle (num, name, type) values ('Unkn042', 'Bike, black with green wheels', 'bike');
insert into vehicle (num, name, make, model, humanid) values ('U706', 'Red, yellow/red side stripes, "Headgames"', 'Chevy', 'Malibu', 137);
insert into vehicle (num, name, make, model) values ('N764', 'orange, black cowl, black headlights', 'Chevy', 'Camaro');
insert into vehicle (num, name) values ('R768', 'White, smallish');
insert into vehicle (num, name, humanid, make, model) values ('Unkn043', 'Just Plain Ugly V, yellow, small black ram', 49, 'Pontiac', 'Firebird');
insert into vehicle (num, name, type, humanid) values ('Unkn044', 'Bike, green splatter pattern - Ben', 'bike', 59);
insert into vehicle (num, name, humanid, make, model, year) values ('OPEN114', 'black, blue flame pinstriping, Rick James Bitch', 48, 'Chevy', 'Camaro Z28', 1969);
insert into vehicle (num, name, humanid, make, model, year) values ('770A', 'black, blue flame pinstriping, Rick James Bitch', 48, 'Chevy', 'Camaro Z28', 1969);
insert into vehicle (num, name, humanid, class, type) values ('7796', 'Junior, Tyler', 53, 'junior', 'junior');
insert into vehicle (num, name, make, model, humanid) values ('OPEN99', 'bright yellow', 'Chevy', 'El Camino', 77);
insert into vehicle (num, name, humanid) values ('6131', 'blue, low ram, needs paint', 47);
insert into vehicle (num, name, humanid, model) values ('N749', 'yellow, white hood stripe, cowl hood, black headlights', 46, 'Falcon');
insert into vehicle (num, name, make, model) values ('Unkn045', 'yellow, convertible, side exhaust', 'Chevy', 'Corvette');
insert into vehicle (num, name, humanid, make, year, model) values ('HotStreet6', 'SS, red, ram and cowl, black/red cowl stripes', 45, 'Chevy', 1970, 'Chevelle SS');
insert into vehicle (num, name, make, model) values ('J704', '1980s, silver/grey, cowl hood', 'Ford', 'Mustang');
insert into vehicle (num, name, humanid, make, model) values ('R729', 'ThunderHorse', 44, 'Ford', 'Mustang');
insert into vehicle (num, name, class, type) values ('7769', 'Junior, red with red flames top, white/black side stripes', 'junior', 'junior');
insert into vehicle (num, name) values ('722FC', 'Shakey Situation');
insert into vehicle (num, name, class, type, humanid) values ('7002', 'Junior, purple, Jake the Snake', 'junior', 'junior', 89);
insert into vehicle (num, name, make, model) values ('7080', 'red, Casa Nova', 'Chevy', 'Nova');
insert into vehicle (num, name) values ('Unkn046', 'Gran Turino, light grey, cowl hood, blue side stripe');
insert into vehicle (num, name, type, humanid) values ('PM117', 'Bike, black, wheelie bars', 'bike', 58);
insert into vehicle (num, name, type) values ('ET2250', 'Bike, black, no wheelie bars', 'bike');
insert into vehicle (num, name, humanid) values ('N718', 'Yellow, Scary Canary', 236);
insert into vehicle (num, name) values ('Unkn047', 'Electric pick-up');
insert into vehicle (num, name, humanid, year, make, model) values ('706X', 'bright red, clean', 27, 1967, 'Chevy', 'Camaro');
insert into vehicle (num, name, model) values ('268', 'dark green, stock', 'Charger');
insert into vehicle (num, name, make, humanid) values ('X716', 'SS, yellow, small side stripe, black vinyl top', 'Chevy', 16);
insert into vehicle (num, name, humanid, make, model, year) values ('T777', 'red, black low cowl, black vinyl top', 43, 'Chevy', 'Camaro rs', 1967);
insert into vehicle (num, name, make, humanid) values ('Q718', 'yellow, landaeu roof, stock', 'Dodge', 56);
insert into vehicle (num, name, make, model) values ('259', 'white', 'Chevy', 'Chevette');
insert into vehicle (num, name, humanid) values ('723R', 'Old station wagon, deep red, cowl hood', 42);
insert into vehicle (num, name, humanid, year) values ('7443', 'Bright mid blue, cowl hood', 111, 1973);
insert into vehicle (num, name, make) values ('Unkn050', 'white', 'Triumph');
insert into vehicle (num, name) values ('Unkn048', 'black, no hood, chromed engine, blower');
insert into vehicle (num, name) values ('Unkn049', 'blue, no hood, chromed engine, blower, double grill');
insert into vehicle (num, name, make) values ('7481', 'white, black hood, low square ram', 'Chevy');
insert into vehicle (num, name, make, model) values ('Unkn051', 'silver, dual chutes, extended trunk wing, side exhausts', 'Chevy', 'Camaro');
insert into vehicle (num, name) values ('W731', 'white, caprice?, black hood, clean');
insert into vehicle (num, name) values ('Unkn052', 'primer truck');
insert into vehicle (num, name, model) values ('270', 'primer Rambler', 'Rambler');
insert into vehicle (num, name) values ('Unkn053', 'Purple Dream, MY TOY license plate');
insert into vehicle (num, name, make, model, humanid) values ('O775', 'Green, yellow and orange side stripes, Zimmerman Racing', 'Ford', 'Mustang', 32);
insert into vehicle (num, name, make, model, humanid) values ('7524', 'black rear, yellow/orange flame front', 'Chevy', 'Vega Wagon', 67);
insert into vehicle (num, name, year, make, model, humanid) values ('788', 'Pegasus', '1965', 'Ford', 'Mustang', 78);
insert into vehicle (num, name, year, make, model, humanid) values ('N735', 'red and silver', '1978', 'Chevy', 'Malibu', 63);
insert into vehicle (num, name, year, make, model, humanid) values ('H736', 'copper, ram hood', '1971', 'Pontiac', 'LeMans', 63);
insert into vehicle (num, name, humanid) values ('M721', 'purple, low ram hood, clean', 66);
insert into vehicle (num, name, humanid) values ('P748', 'maroon rail', 32);
insert into vehicle (num, name, make) values ('Unkn054', 'maroon, clean', 'Pontiac');
insert into vehicle (num, name, humanid) values ('7542', 'rail, purple, blue and purple side stripes', 64);
insert into vehicle (num, name) values ('Unkn055', 'blue, clean, extended trunk lid, single chute');
insert into vehicle (num, name, humanid) values ('7388', 'rail - eagle side design', 64);

insert into vehicle (num, name) values ('Unkn056', 'white, firebird/trans-am/camaro - clean - johnny b');
insert into vehicle (num, name, make, model) values ('7090', 'black, clean, deep rear wheels, cowl hood', 'Chevy', 'Camaro Z28');
insert into vehicle (num, name) values ('Unkn057', 'blue, maverick, street tires and plate');
insert into vehicle (num, name, humanid) values ('1851', 'gold bottom, tan top, cowl hood', 68);
insert into vehicle (num, name) values ('B704', 'yellow, black band with bumble bee around rear');
insert into vehicle (num, name, humanid) values ('724P', 'primer black, el camino/gran turino', 234);
insert into vehicle (num, name, make, model) values ('Z767', 'light green, dark green roof', 'Pontiac', 'GTO');
insert into vehicle (num, name) values ('Unkn058', 'purple, clean, no rear plate, purple rear bumper');
insert into vehicle (num, name) values ('Unkn059', 'blue/purple, clean, street tires, rear plate 340 ZYK');
insert into vehicle (num, name, humanid) values ('R715', 'orange, maverick?', 241);
insert into vehicle (num, name, humanid) values ('783B', 'Black Cherry', 69);
insert into vehicle (num, name, humanid) values ('SP790', 'rail', 32);
insert into vehicle (num, name, humanid) values ('PRO77', 'Time Machine III/4', 70);
insert into vehicle (num, name, humanid, make, model) values ('K748', 'Hammer Time', 71, 'Chevy', 'Nova');
insert into vehicle (num, name, humanid) values ('P760', 'copper', 72);
insert into vehicle (num, name, humanid, make, model) values ('R767', 'blue, low cowl hood', 73, 'Pontiac', 'GTO');
insert into vehicle (num, name, make, model) values ('Z700', 'off-white, low black ram', 'Dodge', 'Dart');
insert into vehicle (num, name, humanid) values ('A783', 'silver, GTX', 65);
insert into vehicle (num, name, humanid, make, model) values ('OS55', 'red camaro, cowl hood', 74, 'Chevy', 'Camaro');
insert into vehicle (num, name, year, make, model, humanid) values ('ES34', 'gray, clean', '1970', 'Chevy', 'Nova', 75);
insert into vehicle (num, name, make, model, humanid) values ('R753', 'blue, flame ram hood', 'Ford', 'Mustang', 79);
insert into vehicle (num, name, year, make, model, humanid) values ('721TS', 'black, mirror finish, clean', '1967', 'Chevy', 'SS', 80);
insert into vehicle (num, name, make, humanid) values ('V3025', 'Small, raked truck', 'Ford', 81);
insert into vehicle (num, name, year, make, humanid) values ('Unkn062', 'Sweet Justice', '1957', 'Chevy', 82);
insert into vehicle (num, name, humanid) values ('725L', 'rail, blue front, white rear, intake has same pattern', 83);
insert into vehicle (num, name) values ('R748', 'Yellow, clean');
insert into vehicle (num, name, make, model) values ('OS46', 'Blue, low cowl hood', 'Ford', 'Mustang');
insert into vehicle (num, name, humanid, year, make, model) values ('782', 'black, fangs and flames', 76, '1988', 'Ford', 'Mustang');
insert into vehicle (num, name, type) values ('FB924', 'bike, blue with yellow rear accent', 'bike');
insert into vehicle (num, name, make, humanid) values ('729B', 'red white and blue, mopar ram scoop', 'Dodge', 84);
insert into vehicle (num, name, make, model, humanid) values ('7711', 'pale blue, bullet hole ram scoop', 'Chevy', 'Camaro', 85);
insert into vehicle (num, name, make, model, humanid) values ('D777', 'pale blue, bullet hole ram scoop', 'Chevy', 'Camaro', 85);
insert into vehicle (num, name, humanid) values ('A741', 'Sorry Charlie', 231);
insert into vehicle (num, name, humanid, year, make, model) values ('Q763', 'blue on blue, low flame cowl hood, Demons be Driven', 143, 1969, 'Chevy', 'Camaro');
insert into vehicle (num, name) values ('J713', 'Just Plain Ugly 6');
insert into vehicle (num, name, humanid) values ('Unkn063', 'Pyschotic Cykles', 90);
insert into vehicle (num, name, humanid) values ('Unkn064', 'No Limitz Blue Scion', 87);
insert into vehicle (num, name, humanid) values ('Unkn065', "It's 5 o'clock Somewhere", 86);
insert into vehicle (num, type, class, name) values ('7452', 'junior', 'junior', 'deep red, smoking woodpecker');
insert into vehicle (num, type, class, name, humanid) values ('7293', 'junior', 'junior', 'Team Bimbo - Raquel', 99);
insert into vehicle (num, type, class, name, humanid) values ('7604', 'junior', 'junior', 'Team Bimbo - Britney', 99);
insert into vehicle (num, type, class, name, humanid) values ('7042', 'junior', 'junior', 'dark, racebricks, brakes', 26);
insert into vehicle (num, type, class, name, humanid) values ('797', 'junior', 'junior', 'Arizona Commodity Traders, LLC', 96);
insert into vehicle (num, type, class, name) values ('7074', 'junior', 'junior', 'Hayden, blue with tribal pattern');
insert into vehicle (num, type, class, name) values ('7131', 'junior', 'junior', 'Taylor, blue with silver under cockpit');
insert into vehicle (num, type, class, name) values ('7130', 'junior', 'junior', 'Chelsea, red with white under cockpit');
insert into vehicle (num, type, class, name) values ('7886', 'junior', 'junior', 'Richies Express, stars under cockpit');
insert into vehicle (num, type, class, name) values ('7254', 'junior', 'junior', 'Ruckman Racing, Nash Ruckman, blue with flame pattern');
insert into vehicle (num, type, class, name, humanid) values ('7146', 'junior', 'junior', 'Kimberly Jimerson - shades of purple', 98);
insert into vehicle (num, type, class, name, humanid) values ('7106', 'junior', 'junior', 'Angelica Jimerson - teal and blue', 98);
insert into vehicle (num, type, class, name, humanid) values ('774', 'junior', 'junior', 'Tanner - Ray Hills Jr. Drag Racing School', 98);
insert into vehicle (num, type, class, name, humanid) values ('749', 'junior', 'junior', 'Chad Webber, white flame pattern', 91);
insert into vehicle (num, type, class, name, humanid) values ('7127', 'junior', 'junior', 'Cody Webber, dark red flame pattern', 91);
insert into vehicle (num, type, class, name) values ('7421', 'junior', 'junior', 'Soltz Racing, Andrew Madrid, Lucas Oil');
insert into vehicle (num, type, class, name, humanid) values ('7028', 'junior', 'junior', 'Dark body, red frame, chrome roll bars, green front wheels, blue helmet', 92);
insert into vehicle (num, type, class, name) values ('712', 'junior', 'junior', 'Dark body, blue frame, blue roll bars, cool chrome front wheels');
insert into vehicle (num, type, class, name) values ('7055', 'junior', 'junior', 'Brianna, dark body, dark purple roll bars');
insert into vehicle (num, type, class, name) values ('7026', 'junior', 'junior', 'White nose, black flame pattern');
insert into vehicle (num, type, class, name, humanid) values ('Unkn066', 'junior', 'junior', 'NWR, Nic Woods Racing, burgundy with top stripe pattern', 95);
insert into vehicle (num, type, class, name, humanid) values ('7039', 'junior', 'junior', 'Grova Racing, Tara Grova, Tammy Grova', 88);
insert into vehicle (num, type, class, name) values ('7824', 'junior', 'junior', 'Zack Attack, jester on top, slash pattern sides');
insert into vehicle (num, type, class, name) values ('7137', 'junior', 'junior', 'Blue top, checkered flag side');
insert into vehicle (num, type, class, name, humanid) values ('7121', 'junior', 'junior', 'California Kid', 93);
insert into vehicle (num, type, class, name) values ('7304', 'junior', 'junior', 'Black body, no markings');
insert into vehicle (num, type, class, name) values ('7149', 'junior', 'junior', 'Weston Racing - silver with red flame pattern');
insert into vehicle (num, type, class, name) values ('7134', 'junior', 'junior', 'Red top, silver side, blue flame side, D Bolwar Insurance');
insert into vehicle (num, type, class, name, humanid) values ('7040', 'junior', 'junior', 'Too Cold To Hold', 92);
insert into vehicle (num, type, class, name) values ('7644', 'junior', 'junior', 'Capt. Josh');
insert into vehicle (num, type, class, name) values ('7221', 'junior', 'junior', 'Blue with foam pattern');
insert into vehicle (num, name, humanid) values ('731H', 'Blue and fuchsia rail', 100);
insert into vehicle (num, name, humanid) values ('OPEN84', 'Stars and stripes on blue', 97);
insert into vehicle (num, name) values ('7174', 'Roadster, purple with flame front');
insert into vehicle (num, name, humanid, year, make, model) values ('ET7033', 'Blue, clean, ram hood', 101, 1971, 'Ford', 'Maverick');
insert into vehicle (num, type, name) values ('7003', 'bike', 'Purple and yellow');
insert into vehicle (num, type, class, name, humanid) values ('7168', 'junior', 'junior', 'Dark body, iron cross clips, black roll cage, flower on roll cage', 92);
insert into vehicle (num, name, humanid) values ('Unkn067', 'Orange and black truck', 104);
insert into vehicle (num, name, humanid) values ('Unkn068', 'Orange Jeep', 104);
insert into vehicle (num, name, humanid) values ('Unkn069', 'Iron Bull Bumper truck, grey', 105);
insert into vehicle (num, name, humanid) values ('Unkn070', 'Muley Racing truck', 106);
insert into vehicle (num, name, make) values ('Unkn071', 'RCETRUK, white, dual black bed stacks', 'Ford');
insert into vehicle (num, name) values ('Unkn072', 'Bully Doug Freightliner');
insert into vehicle (num, name, make) values ('Unkn073', 'Red, black wheel accents, dual black bed stacks', 'Dodge');
insert into vehicle (num, name) values ('DHRA999', 'white, pick-up, build with tools...');
insert into vehicle (num, name, humanid) values ('777A', 'Banks Power Sidewinder S-10', 108);
insert into vehicle (num, name, make, model) values ('4509', 'White pick-up, black spoke wheels, small chrome hub caps', 'Ford', 'F-250');
insert into vehicle (num, name, humanid) values ('777', 'Foolish Money', 220);
insert into vehicle (num, name, make, model) values ('TS6636', 'Red/Black with side stripes', 'Chevy', 'Corvette');
insert into vehicle (num, name, make, model) values ('741N', 'red Nova SS, low black cowl hood', 'Chevy', 'Nova SS');
insert into vehicle (num, name) values ('OS13', 'black primer, boxy, low cowl hood');
insert into vehicle (num, type, name, model) values ('Unkn074', 'bike', 'red, silver suited driver', 'Hayabusa');
insert into vehicle (num, name, make, model, humanid) values ('108TO', 'Green viper Corvette', 'Chevy', 'Corvette', 109);
insert into vehicle (num, name, make) values ('F757', 'Red AMC AMX, low ram with black inserts', 'AMC');
insert into vehicle (num, name, make, model) values ('Unkn076', 'Green mustang, rusty hood w/air filter cutout, vinyl roof', 'Ford', 'Mustang');
insert into vehicle (num, name) values ('D705', 'Bright blue, boxy, diamond screen grille, Cornwell Tools');
insert into vehicle (num, name) values ('Q707', 'Bright blue mustang, low cowl hood');
insert into vehicle (num, name, make) values ('439', 'Open engine roadster, bright yellow cockpit', 'Dodge');
insert into vehicle (num, name, make, model) values ('431', 'Orange camaro, white hood stripes, cowl hood', 'Chevy', 'Camaro');
insert into vehicle (num, name, make, model) values ('405', 'Red Mustang, louvered fastback, low black cowl hood', 'Ford', 'Mustang');
insert into vehicle (num, name, humanid, make, model) values ('443', 'Stage Fright, red on white on blue, large red and white ram', 116, 'Ford', 'Mustang');
insert into vehicle (num, name, humanid) values ('21X', 'Matte grey, ram hood', 110);
insert into vehicle (num, name, make, humanid) values ('L760', 'Multi-color sparkle paint, low ram hood', 'Plymouth', 114);
insert into vehicle (num, name, year, make, model, humanid) values ('M751', 'Red stingray Corvette, black nose and hood stripe, "Mischief Too"', 1974, 'Chevy', 'Corvette', 145);
insert into vehicle (num, name, make, model, humanid) values ('SG7728', '"The Mistress", matte, white nose, yellow flames, red body', 'Chevy', 'Vega Wagon', 112);
insert into vehicle (num, name) values ('P704', 'white nose, orange flames, blue body, cowl hood');
insert into vehicle (num, name, year, make, model) values ('P72', 'Dark red, dual grille, dual ram', 1972, 'Pontiac', 'Firebird');
insert into vehicle (num, name, make, humanid) values ('ET709', 'Buick, two tone - silver over white, smoked headlight covers', 'Buick', 136);
insert into vehicle (num, name) values ('C734', 'Blue, dual grilles, low ram hood');
insert into vehicle (num, name, model) values ('446', 'Yellow Cuda, matte black ram hood', 'Cuda');
insert into vehicle (num, name) values ('438', 'White with pale blue accents, Team Geriatric helmet');
insert into vehicle (num, name, make, model, humanid) values ('7696', 'Pale blue, white roll cage, clean, white nose band, cowl hood', 'Chevy', 'Camaro SS', 113);
insert into vehicle (num, name, make, model, humanid) values ('701J', 'red, clean', 'Ford', 'Mustang', 115);
insert into vehicle (num, name) values ('M5', '"Odd Rod", blue on orange, cowl hood, blue headlights');
insert into vehicle (num, name, make, model, humanid) values ('7508SC', 'Black and silver camaro, striped ram', 'Chevy', 'Camaro', 122);
insert into vehicle (num, name, make, model) values ('2324', 'Green/yellow, vinyl roof, black cowl, needs paint', 'Chevy', 'Nova');
insert into vehicle (num, name) values ('410-1', 'Green, cream cowl');
insert into vehicle (num, name, humanid, make, model) values ('M797', 'red, side molding, cowl hood', 123, 'Plymouth', 'Roadrunner');
insert into vehicle (num, name) values ('T729', '50s Chevy, mid blue');
insert into vehicle (num, name, make, model) values ('Q746', 'yellow nova wagon', 'Chevy', 'Nova Wagon');
insert into vehicle (num, name, humanid) values ('A761', 'Red, white striped cowl hood, clean', 124);
insert into vehicle (num, name) values ('B715', 'Orange on brown, big cowl, silver star rear quarter');
insert into vehicle (num, name, humanid, make) values ('7683', 'Red roadster, closed engine, Arizona BUG Company', 127, 'Chevy');
insert into vehicle (num, name) values ('P780', 'Black nose and flames into orange');
insert into vehicle (num, name, make) values ('G722', 'Black, DRAGUAR rear plate, chromed ram', 'Jaguar');
insert into vehicle (num, name, humanid) values ('R792', '"Natural Creation", off-white, low black cowl', 125);
insert into vehicle (num, name) values ('A737', '"Good Times Xpress", black, ram hood');
insert into vehicle (num, name, make, humanid) values ('R709', 'Green with yellow accents - low cowl', 'Chevy', 146);
insert into vehicle (num, name) values ('PRO44', 'matte black, dual red hood stripes, ram hood');
insert into vehicle (num, name, make, model, humanid) values ('7611', '"Bullet With A Name", yellow to blue, white ram', 'Pontiac', 'T-1000', 119);
insert into vehicle (num, name, make, model) values ('731W', 'Off-white 5.0, cowl hood', 'Ford', 'Mustang');
insert into vehicle (num, name, humanid) values ('7580', 'Bright yellow rail, Arizona BUG Company', 126);
insert into vehicle (num, name) values ('P660', 'Silver on blue');
insert into vehicle (num, name, make, model) values ('Unkn078', 'Purple nose and flames to orange, cowl hood', 'Chevy', 'Nova');
insert into vehicle (num, name) values ('787Q', 'light blue, clean, cowl hood');
insert into vehicle (num, name, make) values ('781', 'Red roadster, square collectors, orange ram', 'Chevy');
insert into vehicle (num, name, humanid) values ('702G', ' Red rail, black checker pattern at driver', 128);
insert into vehicle (num, name, humanid) values ('7314', 'Roadster, orange nose flames to blue', 83);
insert into vehicle (num, name, humanid, make, model) values ('759', 'Blue over silver', 129, 'Ford', 'Thunderbird');
insert into vehicle (num, name) values ('703', 'Rail, blue to white');
insert into vehicle (num, name) values ('3088', 'Rail, dark top, purple striped sides');
insert into vehicle (num, name) values ('7813', 'Rail, blue nose flames to black');
insert into vehicle (num, name) values ('7660', '"Olds Timer", blue roadster, closed engine, ram');
insert into vehicle (num, name, make, model, humanid) values ('796K', 'Pale blue, square ram hood', 'Ford', 'Mustang', 130);
insert into vehicle (num, name, make) values ('781G', 'Red to black roadster, closed engine, ram, moto-meter', 'Ford');
insert into vehicle (num, name) values ('7762', 'Rail, blue nose flames to black');
## Toby Smith ##insert into vehicle (num, name, humanid) values ('Unkn079', 'Rail, bright yellow top, checker sides', 131);
insert into vehicle (num, name, humanid) values ('7746', 'Rail, dark blue top, orange and white tribal sides', 132);
insert into vehicle (num, name, humanid) values ('7963', 'Rail, orange nose multi-stripes to green, sharp intake', 133);
insert into vehicle (num, name, humanid) values ('7072', 'Rail, black and orange geometric paint, Desert Sports Center', 134);
insert into vehicle (num, name, humanid) values ('763', 'Rail, black, Century 21', 135);
insert into vehicle (num, name, make, model) values ('ES11', 'Bright orange, cowl hood', 'Chevy', 'Nova SS');
insert into vehicle (num, name) values ('ES8', 'Maroon primer, white hood');
insert into vehicle (num, name) values ('717', 'Yellow with purple stripes, square ram hood');
insert into vehicle (num, name, make, model, humanid) values ('TS29', 'Red with black hood', 'Chevy', 'Camaro', 118);
insert into vehicle (num, name, make, model) values ('7490', 'Bright red, low cowl, clean, black vinyl roof', 'Chevy', 'Camaro');
insert into vehicle (num, name, year, make, model, humanid) values ('OS1', 'Teal, black ram and cowl hood', 1969, 'Chevy', 'Camaro', 117);
insert into vehicle (num, name, make, model) values ('OS9', 'Solid orange, cowl hood', 'Chevy', 'Camaro');
insert into vehicle (num, name) values ('N756', 'Dark red, white roof, black ram');
insert into vehicle (num, name) values ('7739', 'White on red roadster, open engine, chromed engine');
insert into vehicle (num, name, make, model, humanid) values ('7736', 'White, clean', 'Chevy', 'Nova SS', 138);
insert into vehicle (num, name, humanid) values ('798', 'Polar Racing rail', 121);
insert into vehicle (num, name, humanid, make, model) values ('7382', 'Orange Dodge Challenger - low black ram', 147, 'Dodge', 'Challenger');
insert into vehicle (num, name, year, humanid) values ('B743', 'Black, gray cowl, clean', 1968, 141);
insert into vehicle (num, name, humanid) values ('754', 'Yellow Hooters Rail', 148);
insert into vehicle (num, name, type, humanid) values ('7827', 'Yellow with blue accents', 'bike', 142);
insert into vehicle (num, name, humanid) values ('Y710', 'Deep red metallic, yellow/black side and ram stripes, clean', 149);
insert into vehicle (num, name) values ('330PRO', 'Dark red, no scoop, clean, older');
insert into vehicle (num, name, humanid) values ('B718', 'White, ram hood', 150);
insert into vehicle (num, name) values ('712J', 'Rail, yellow/red/purple multi-color');
insert into vehicle (num, name) values ('7940', '"The Butcher", PPG, blue to rust to gray');
insert into vehicle (num, name) values ('7987', 'Black roadster, dark flame paint');
insert into vehicle (num, name) values ('799', 'Roadster, open engine, dark green flame cockpit, orange stripe');
insert into vehicle (num, name, humanid) values ('7012', 'Green with purple bottom and gray top, ram hood', 151);
insert into vehicle (num, name) values ('M723', 'Blue with gold flames, very low cowl');
insert into vehicle (num, name, make, humanid) values ('C722', '"Hound Dog"', 'Chevy', 233);
insert into vehicle (num, name, type, class, humanid) values ('721', 'Blue, gold wheels', 'bike', 'bike', 152);
insert into vehicle (num, name, make, model, humanid) values ('D791', 'Silver/gray, skull and crossbones', 'Dodge', 'Charger', 238);
insert into vehicle (num, name) values ('7118', 'Bright tennis ball green, low dual rams');
insert into vehicle (num, name, humanid) values ('7502', 'Roadster, yellow, full radiator and ram, "Terrible Terry"', 153);
insert into vehicle (num, name, make, model, humanid) values ('7085', 'Black, purple chute assembly, flamed ram', 'Pontiac', 'Trans Am', 154);
insert into vehicle (num, name, humanid) values ('7462', '"Basket Case Racing" bright blue, small duct in hood, alien racing engines', 157);
insert into vehicle (num, name, make, model) values ('C744', 'White, black stripe cowl hood', 'Chevy', 'S10');
insert into vehicle (num, name, make, model) values ('704', 'Red, louvre front fenders', 'Chevy', 'Corvette');
insert into vehicle (num, name, humanid) values ('Unkn083', 'Rail, open, front engine, duct tape green light', 155);
insert into vehicle (num, name) values ('J713-1', 'white, black hand prints on trunk');
insert into vehicle (num, name, humanid, make, model) values ('7897', 'Flesh colored, older, 390 hood inserts', 156, 'Ford', 'Fairlane');
insert into vehicle (num, name, humanid) values ('7114', 'Rail, red with silver tribal markings - tall wing', 144);
insert into vehicle (num, name, humanid) values ('7142', 'Red, "Bustin Loose Jr."', 158);
insert into vehicle (num, name, humanid) values ('713', 'Rail, black, high-gloss, chromed engine and headers', 171);
insert into vehicle (num, name) values ('Unkn084', 'rail, black over blue with black flames, cromed engine and headers, 783B in shoe polish');
insert into vehicle (num, name, humanid, make, model, year) values ('716P', 'Red to white with checker fade, flat wing, ram hood, vega painted on hood', 159, 'Chevy', 'Vega', 1977);
insert into vehicle (num, name, class) values ('Unkn085', 'Silver/grey front wing, checker body, red cockpit, rear wheel baffles', 'junior');
insert into vehicle (num, name, class) values ('700M', 'Silver with blue cutouts, blue/orange flame helmet', 'junior');
insert into vehicle (num, name, make, model, humanid) values ('766H', 'Dark blue, dual silver stripe low cowl hood', 'Ford', 'Mustang', 169);
insert into vehicle (num, name, make, model) values ('E768', 'Maroon, clean', 'Ford', 'Mustang');
insert into vehicle (num, name, year, make, model, humanid) values ('950', 'mid-blue, clean, street legal, california', 1970, 'Dodge', 'Challenger', 170);
insert into vehicle (num, name, make, model, humanid) values ('7820', 'bright red, bright striped ram hood, bottom yellow stripe, flat wing', 'Pontiac', 'GTO', 160);
insert into vehicle (num, name, humanid, year, make, model) values ('Unkn086', 'Flag pattern, stars on hood, stripes down side, cowl hood', 161, 1972, 'Chevy', 'Nova');
insert into vehicle (num, name, make, humanid) values ('A707', 'White and gold, dual stripe ram hood, "Priceless One"', 'Pontiac', 162);
insert into vehicle (num, name, class) values ('787', 'Deep purple body, orange and white flames', 'junior');
insert into vehicle (num, name, class) values ('771', 'One Quick Chick, Alexis', 'junior');
insert into vehicle (num, name, class) values ('741', 'One Quick Chick, Morgan', 'junior');
insert into vehicle (num, name, class, humanid) values ('7129', 'Metallic grey with purple blobs', 'junior', 89);
insert into vehicle (num, name, class) values ('704J', 'Black, Fleetwood Racing, maroon frame and roll bars, Payton', 'junior');
insert into vehicle (num, name) values ('7306', 'small pick-up, biege, black bed bars');
insert into vehicle (num, name) values ('7170', 'primer and curvy, older roadster, custom body, ram hood, oversized wing');
insert into vehicle (num, name) values ('D712', 'purple with lightning down the sides, ram hood');
insert into vehicle (num, name, make, model) values ('765SS', 'black with yellow front sides, clean', 'Ford', 'Mustang');
insert into vehicle (num, name, make) values ('727E', 'Red, raised rear, big flat wing, red with silver stripe, ram hood', 'Chevy');
insert into vehicle (num, name) values ('Unkn060', 'Red, wheel-standing Bronco');
insert into vehicle (num, name, make, model) values ('P718', 'Light blue, ram hood, no front bumper', 'Chevy', 'Nova');
insert into vehicle (num, name, make) values ('T719', 'Maroon with wide silver stripes on top and sides', 'Dodge');
insert into vehicle (num, name, humanid) values ('N751', 'Moroon, plain, black headers', 164);
insert into vehicle (num, name, make, model) values ('Unkn087', 'White, AMCya, EXTINCT', 'AMC', 'Gremlin');
insert into vehicle (num, name, humanid) values ('7554', 'Red, white and blue', 165);
insert into vehicle (num, name, make, model) values ('7202', 'Red, cowl hood', 'Chevy', 'SS');
insert into vehicle (num, name) values ('733L', 'Red white and blue roadster');
insert into vehicle (num, name) values ('R787', 'Copper with black ram hood');
insert into vehicle (num, name) values ('7216S', 'Red 90s firebird/camaro ram hood');
insert into vehicle (num, name) values ('7330', 'Dark intake');
insert into vehicle (num, name) values ('7182', 'Orange over black, zigzag body pattern');
insert into vehicle (num, name) values ('171M', 'Dark body');
insert into vehicle (num, name, make, model) values ('7157', 'Red front, orange with checkered side stripe, flat wing', 'Dodge', 'Daytona');
insert into vehicle (num, name, humanid) values ('G740', 'Blue clean roadster', 166);
insert into vehicle (num, name, humanid, make) values ('767B', 'Black with yellow side stripes, square yellow ram', 167, 'Datsun');
insert into vehicle (num, name, make, model, humanid) values ('793T', 'Red/orange, ram through cowl hood', 'Chevy', 'Camaro Z28', 168);
insert into vehicle (num, name, make, model) values ('OS14', 'black, ram hood', 'Ford', 'Mustang');
insert into vehicle (num, name, year, make, humanid) values ('TS43', 'Bright yellow 1940 Willy', 1940, 'Willy', 172);
insert into vehicle (num, name, year, make, model, humanid) values ('N603', 'Copper Fuller RE', 1974, 'Fuller', 'RE', 173);
insert into vehicle (num, name, make, model) values ('7968', 'Blue with silver accents, ram hood', 'Chevy', 'Corvette');
insert into vehicle (num, name) values ('1953', '"Black Magic 2"');
insert into vehicle (num, name, make, humanid) values ('1969', '"The Gold Nugget"', 'Plymouth', 174);
insert into vehicle (num, name) values ('736A', 'Bright mid blue, ram hood, "Skyridge Custom Homes"');
insert into vehicle (num, name) values ('Unkn088', 'Flag motif, blue with stars on hood, stripes down the sides, professional paint');
insert into vehicle (num, name) values ('738', '"Colt of Arms"');
insert into vehicle (num, name, humanid) values ('Unkn089', 'Funny car, green with orange flames', 175);
insert into vehicle (num, name) values ('ES70', 'White with black low cowl hood');
insert into vehicle (num, name) values ('ES30', 'Flat black roadster');
insert into vehicle (num, name, humanid) values ('C751', '"Steppin Back", open engine roadster, maroon cockpit', 221);
insert into vehicle (num, name) values ('791', 'Front engine, blue flame cockpit, silver wheel baffles');
insert into vehicle (num, name, humanid) values ('7701', 'Funny car, gloss black, clean', 176);
insert into vehicle (num, name, humanid) values ('Unkn091', '"For a Few Dollars More 2" - 427 eagle on doors', 177);
insert into vehicle (num, name, make) values ('752A', 'Grey, pink baby shoes hanging from rear view, cowl hood', 'Chevy');
insert into vehicle (num, name, make, model) values ('T775', '"Luv Potion" - bright orange, ram hood', 'Chevy', 'Luv');
insert into vehicle (num, name, make, model) values ('700Y', 'Grey, clean, no pass headlight', 'Toyota', 'Supra');
insert into vehicle (num, name, humanid) values ('Unkn092', 'Rail, black to maroon, dual stacked intake', 178);
insert into vehicle (num, name, make, model, humanid) values ('702A', 'Black, cowl hood, mmr on doors', 'Ford', 'Mustang', 179);
insert into vehicle (num, name) values ('C776', 'Black, smaller, neon colored side stripes, tall ram hood');
insert into vehicle (num, name, humanid) values ('709', 'White with purple and blue stripes from hood to trunk, nose-like ram hood', 180);
insert into vehicle (num, name) values ('7613', 'Rail, red, for sale, black wing with single upright');
insert into vehicle (num, name) values ('706C', 'Grey, red and white side stripes, raked front, low cabin');
insert into vehicle (num, name, type, class, humanid) values ('7511', '"Mall Maddness" purple with shopping motif', 'junior', 'junior', 181);
insert into vehicle (num, name, type, class) values ('7001', '"Misstical" dark purple with anime', 'junior', 'junior');
insert into vehicle (num, name, type, class, humanid) values ('7158', 'Black, orange flame helmet', 'junior', 'junior', 182);
insert into vehicle (num, name, type, class) values ('7924', 'Bright mid blue', 'junior', 'junior');
insert into vehicle (num, name, make, humanid, year, model) values ('74GTEA', 'Blue, clean, red and white accents', 'Pontiac', 202, '1998', 'Grand Am');
insert into vehicle (num, name, humanid) values ('7806', 'Rail, red top', 185);
insert into vehicle (num, name, humanid) values ('6028', 'Bright yellow, square ram hood, clean', 186);
insert into vehicle (num, name, humanid) values ('7184', 'Roadster, orange with flames and purple, chromed engine, side cockpit', 199);
insert into vehicle (num, name, type, class, humanid) values ('7637', '"Lil Dude" maroon nose flamed to orange', 'junior', 'junior', 187);
insert into vehicle (num, name, make, model, humanid) values ('Unkn093', 'White, red and blue side stripes to a Cobra', 'Ford', 'Mustang', 211);
insert into vehicle (num, name) values ('7848', 'Red, cowl hood, flat wing');
insert into vehicle (num, name, make, model, humanid) values ('7375', 'Black, fastback, clean, low ram hood', 'Ford', 'Mustang', 235);
insert into vehicle (num, name, type, class) values ('7636', '"Ryno" purple horned nose flamed to orange', 'junior', 'junior');
insert into vehicle (num, name, type, class) values ('615', 'Maroon, sword on top - Visions Race Cars', 'junior', 'junior');
insert into vehicle (num, name, humanid, make) values ('6111', 'Pale blue, dual white stripe hood, clean', 189, 'Chevy');
insert into vehicle (num, name, make) values ('5335', 'Yellow, very clean', 'Pontiac');
insert into vehicle (num, name, humanid) values ('7330SC', 'Rail, copper nose, pale flamed to black, Ogden Ranch', 208);
insert into vehicle (num, name, humanid) values ('7628', 'White top, red sides', 190);
insert into vehicle (num, name, humanid) values ('6748', 'White, red flame pattern, shorter body', 209);
insert into vehicle (num, name, type, class, humanid) values ('747', 'Orange nose flamed to black', 'junior', 'junior', 191);
insert into vehicle (num, name, humanid) values ('7774', '"Mail From Home"', 192);
insert into vehicle (num, name, humanid) values ('5544', 'Red, clean', 193);
insert into vehicle (num, name, type, class, humanid) values ('7266', 'Black', 'junior', 'junior', 194);
insert into vehicle (num, name, humanid) values ('5453', 'Sculpted ram hood', 195);
insert into vehicle (num, name, humanid) values ('5093', 'Blue top, green under cockpit', 196);
insert into vehicle (num, name, humanid) values ('7791', 'Maroon with highlights, black wing dual uprights, "Re-Captured Youth"', 197);
insert into vehicle (num, name, type, class) values ('7752', 'Bars Leaks', 'jrcomp', 'jrcomp');
insert into vehicle (num, name) values ('SC750', 'Dark purple classic, orange flames from front wheels, tall squared ram, "Joe Kid"');
insert into vehicle (num, name, make) values ('704D', 'Blue, clean', 'Chevy');
insert into vehicle (num, name, type, class, humanid) values ('769', 'Tennis ball green, "Grandpas Legacy"', 'junior', 'junior', 198);
insert into vehicle (num, name, type, class, humanid) values ('796', 'Blue with orange accents', 'junior', 'junior', 200);
insert into vehicle (num, name, type, class, humanid) values ('7823', 'Red with orange accents, checker top', 'jrcomp', 'jrcomp', 201);
insert into vehicle (num, name, type, class, humanid) values ('7496', 'White with red accents', 'jrcomp', 'jrcomp', 202);
insert into vehicle (num, name, type, class, humanid) values ('7044', 'Copper to blue to white', 'junior', 'junior', 205);
insert into vehicle (num, name, humanid) values ('Unkn094', 'Bright yellow roadster, chopped top, suicide doors', 207);
insert into vehicle (num, name) values ('518', 'Red with orange side accents, Green Racing');
insert into vehicle (num, name, type, class, humanid) values ('757', 'Red and black with red windscreen, with and without wheelie bars', 'bike', 'bike', 210);
insert into vehicle (num, name, make, model) values ('Unkn095', 'West Virginia Hooker, bright yellow Corvette', 'Chevy', 'Corvette');
insert into vehicle (num, name, make, model) values ('OPEN22', 'White nose, white/yellow flames to blue body - cowl hood', 'Chevy', 'Camaro SS');
insert into vehicle (num, name, make, model) values ('7775', 'Blue Camaro, louvre hood, clean', 'Chevy', 'Camaro');
insert into vehicle (num, name, humanid) values ('7976', 'Keeter Ray Racing funny car, black with silver cockpit', 214);
insert into vehicle (num, name) values ('7998', 'Silver, classic station wagon');
insert into vehicle (num, name, make, model, humanid) values ('7070', 'Blue Mustang', 'Ford', 'Mustang', 215);
insert into vehicle (num, name, make, model) values ('721-1', 'Pontiac GTO, pale blue, small ram hood', 'Pontiac', 'GTO');
insert into vehicle (num, name, make, model) values ('PRO11', 'Red, ram hood, dual black top stripes', 'Chevy', 'Camaro Z28');
insert into vehicle (num, name, make) values ('7448', 'Cream and dark red pick-up truck, fake wood bed cover', 'Chevy');
insert into vehicle (num, name, humanid) values ('788C', 'Purple, ram hood', 216);
insert into vehicle (num, name) values ('B762', 'Black, cowl hood with intake through it');
insert into vehicle (num, name) values ('WILD20', 'Red with yellow side stripes, cowl hood, round intake between lights'); 
insert into vehicle (num, name, make, model) values ('PRO8', 'Black Corvette, black wing, side exhausts', 'Chevy', 'Corvette');
insert into vehicle (num, name) values ('TT5-1', 'Silver, cowl and ram hood');
insert into vehicle (num, name) values ('Unkn096', 'Rat Rod - Meticulously crafted to look thrown together');
insert into vehicle (num, name, humanid) values ('Unkn097', 'Texas Diesel Power funny car', 217);
insert into vehicle (num, name, make) values ('X701', 'Deep red with blue and yellow side stripes, ram hood', 'Chevy');
insert into vehicle (num, name, type, class, humanid) values ('7052', 'Red top, blue flames to grey sides', 'Junior', 'Junior', 218);
insert into vehicle (num, name, type, class) values ('1340', 'Yellow flames over black, rear extension', 'Bike', 'Bike');
insert into vehicle (num, name) values ('7718', 'Classic pick-up, deep red "Temporary Insanity"');
insert into vehicle (num, name, make, model) values ('P766', 'Green, yellow and white ram, yellow and white side accents, "Spoiled Rotten"', 'Ford', 'Mustang');
insert into vehicle (num, name, humanid) values ('P773', 'White, red ram, red roof and pillars', 219);
insert into vehicle (num, name) values ('706K', 'Burnt orange flat paint, intake through hood, tall wing');
insert into vehicle (num, name) values ('548', 'Yellow roadster, open engine, small bed, "Rollin Rice Bowl"');
insert into vehicle (num, name) values ('F783', 'Roadster, open engine');
insert into vehicle (num, name) values ('Unkn100', 'Car Show 3/14 - Purple and White');
insert into vehicle (num, name, humanid) values ('Unkn101', 'Car Show 3/14 - Green and Black', 223);
insert into vehicle (num, name, humanid) values ('7699', 'Black, front engine', 222);
insert into vehicle (num, name, make) values ('Unkn102', 'Ford pick-up, blue, tribal-like side stripes', 'Ford');
insert into vehicle (num, name, year, make, model, humanid) values ('Unkn103', '1968 Chevy Chevelle, red, black ram hood', '1968', 'Chevy', 'Chevelle', 213);
insert into vehicle (num, name, year, make, model, humanid) values ('Unkn104', '1989 Ford Mustang, white, white ram hood', '1989', 'Ford', 'Mustang', 213);
insert into vehicle (num, name, make, model, humanid) values ('Q775', 'Green Mustang with bee in the back', 'Ford', 'Mustang', 224);
insert into vehicle (num, name, make) values ('2352', 'Silver grey Chevy, large ram, flat wing', 'Chevy');
insert into vehicle (num, name, make, model) values ('F774', 'Black primer Trans Am, cowl hood', 'Pontiac', 'Trans Am');
insert into vehicle (num, name) values ('718K', 'Dark blue rail, squarish ram');
insert into vehicle (num, name, make, model) values ('2311', 'Blue Pontiac Catalina', 'Pontiac', 'Catalina');
insert into vehicle (num, name) values ('D732', 'Pale yellow, inner yellow headlights');
insert into vehicle (num, name, model) values ('715R', 'Pale blue Maverick, small side rams, primer and rust hood', 'Maverick');
insert into vehicle (num, name, make, model) values ('737M', 'Blue top, cream sides, black primer cowl hood', 'Chevy', 'Chevelle');
insert into vehicle (num, name, year, make, model, humanid) values ('PRO793', 'Dark blue, tight blue flame pattern from nose, cowl hood', 1967, 'Chevy', 'Camaro', 168);
insert into vehicle (num, name, humanid) values ('783', 'Red sedan, white ram hood, "Bustin Loose"', 226);
insert into vehicle (num, name, humanid ) values ('720D', 'Red body, white top, red roof', 228);
insert into vehicle (num, name) values ('5963', 'Orange, dual white stripe hood, ducted intake through hood');
insert into vehicle (num, name, make, model, humanid) values ('7402', 'White Pontiac Firebird, clean', 'Pontiac', 'Firebird', 229);
insert into vehicle (num, name, model) values ('K736', 'Blue Maverick, clean', 'Maverick');
insert into vehicle (num, name) values ('D772', 'Silver, older, El Camino like');
insert into vehicle (num, name) values ('G708', 'Blue with stars front, red and white flag stripes sides and roof, blue painted headlights, square ram');
insert into vehicle (num, name) values ('W707', 'Purple, clean, air intake through hood, "Purple Dream"');
insert into vehicle (num, name) values ('6860', 'Light grey, ram hood, flat wing');
insert into vehicle (num, name, model, humanid) values ('G774', 'Dark purple Fairlane', 'Fairlane', 230);
insert into vehicle (num, name) values ('7086', 'Blue front, purple roof and body, blue and orange arrows on sides, square ram');
insert into vehicle (num, name, humanid) values ('R780', 'Bright dark blue, cowl hood', 232);
insert into vehicle (num, name, make) values ('Unkn105', 'Classic Chevy, dark purple with purple flames, aeroplane hood ornament', 'Chevy');
insert into vehicle (num, name, humanid, type, class) values ('Unkn106', 'Red racing ATV', 237, 'bike', 'bike');
insert into vehicle (num, name, make, model) values ('F769', 'Blue and white Plymouth Duster, "Portuguese Man-O-War"', 'Plymouth', 'Duster');
insert into vehicle (num, name) values ('777TD', 'Orange rail');
insert into vehicle (num, name, make, humanid) values ('Z767S', 'White Pontiac', 'Pontiac', 229);
insert into vehicle (num, name) values ('7891', 'White, ram hood, red roll cage');
insert into vehicle (num, name, make, model) values ('W712', 'White, Mustang, fastback', 'Ford', 'Mustang');
insert into vehicle (num, name) values ('M734', 'Black');
insert into vehicle (num, name, make, model) values ('T701', 'White, Mustang, very clean', 'Ford', 'Mustang');
insert into vehicle (num, name) values ('Unkn107', 'Red, silver fin, black trunk accents, very clean');
insert into vehicle (num, name) values ('Unkn108', 'Red SS with black trunk stripes, ram hood, black bottom stipe, 454 on door');
insert into vehicle (num, name) values ('Unkn109', 'Bike - blue, silver front cowling, wheelie bars');
insert into vehicle (num, name, type, class) values ('737', 'Junior - dark with flame drops', 'Junior', 'Junior');
insert into vehicle (num, name, type, class) values ('721-2', 'Junior - Kiki Desa', 'Junior', 'Junior');
insert into vehicle (num, name) values ('Unkn110', 'Front engine, bright yellow with blue flame pattern');
insert into vehicle (num, name, type, class) values ('7274', 'Purple', 'Junior', 'Junior');


# image

# posters

insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-01', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-02', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-03', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-04', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-05', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-06', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-G740-07', 'G740');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-950-01', '950');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-950-02', '950');
insert into image (eventid, taken, section, id, vehnum) values (1, '2009-01-03', 'main', 'Poster-950-03', '950');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-Roadster01', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld01', '788');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld01', 'R753');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld01', 'ES34');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld01', 'OS55');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld02', '7733');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld02', '721TS');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld02', '666');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld02', '706X');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld03', '725L');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld03', 'Y755ET');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld03', 'V3025');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld03', '706X');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld04', 'Multi');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld05', '7127');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld05', '7505');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld05', '7137');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-08-02', 'main', 'Poster-SpeedWorld05', '7149');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5360-Fract01', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5360-Fract02', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5360-Fract03', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5513-Fract01', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5513-Fract02', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'main', 'Poster-DSCN5513-Fract03', '7174');
insert into image (eventid, taken, section, id, vehnum) values (1, '2008-09-20', 'junior', 'Poster-DSCN5520-Fract01', '7196');

# 2007-01-07

source ImageInserts/SW-20070107.sql;

# 2007-02-04

source ImageInserts/SW-20070204.sql;

# 2007-02-10

source ImageInserts/SW-20070210.sql;

# 2007-03-04

source ImageInserts/SW-20070304.sql;

# 2007-10-07

source ImageInserts/SW-20071007.sql;

# 2008-08-02

source ImageInserts/SW-20080802.sql;

# 2008-08-16

source ImageInserts/SW-20080816.sql;

# 2008-09-05

source ImageInserts/SW-20080905.sql;

# 2008-09-20

source ImageInserts/SW-20080920.sql;

# 2008-10-04

source ImageInserts/SW-20081004.sql;

# 2008-10-11

source ImageInserts/SW-20081011.sql;

# 2008-10-17

source ImageInserts/SW-20081017.sql;

# 2008-10-18

source ImageInserts/SW-20081018.sql;

# 2008-11-15

source ImageInserts/SW-20081115.sql;

# 2008-11-22

source ImageInserts/SW-20081122.sql;

# 2009-01-01

source ImageInserts/SW-20090101.sql;

# 2009-01-03

source ImageInserts/SW-20090103.sql;

# 2009-01-31

source ImageInserts/SW-20090131.sql;

# 2009-02-07

source ImageInserts/SW-20090207.sql;

# 2009-02-13

source ImageInserts/SW-20090213.sql;

# 2009-03-01

source ImageInserts/SW-20090301.sql;

#2009-03-07

source ImageInserts/SW-20090307.sql;

# 2009-03-08

source ImageInserts/SW-20090308.sql;

# 2009-03-14

source ImageInserts/SW-20090314.sql;

# 2009-03-21

source ImageInserts/SW-20090321.sql;

## 2009-09-26

source ImageInserts/SW-20090926.sql;

## 2009-11-01

source ImageInserts/SW-20091101.sql;

## 2009-11-14

source ImageInserts/SW-20091114.sql;

## 2009-11-15

source ImageInserts/SW-20091115.sql;





#  commerce

insert into commerce (id, ikid) values ('DSCN5113-Sharp', '33b2cb55-069c-4cf1-ac0d-fa8d32e70ef4');
insert into commerce (id, ikid) values ('DSCN5114-Sharp', 'bd4cf63b-1906-4fca-b58d-b60c6909dbc6');
insert into commerce (id, ikid, rbid, cfmp, caption) values ('DSCN5100', '9bbdfd69-33c9-4c52-9e51-4eef6a320425', '1603491-1-silhoutted-burn-out', '301660866', 'Silhoutted Burn-Out');
insert into commerce (id, ikid) values ('DSCN5279-Sharp', '1b9240ee-3a49-452c-a52b-ac2cd6eb7e59');
insert into commerce (id, ikid) values ('DSCN5280-Sharp', 'd80932eb-4c03-4087-aa3c-8c72809e7574');
insert into commerce (id, ikid) values ('DSCN5281-Sharp', '9f66dc28-a2d8-49c4-8097-72fab742b1d4');
insert into commerce (id, ikid) values ('DSCN5276-Sharp', 'f5d6f5a9-653b-4939-a448-692c1b9a4960');
insert into commerce (id, ikid, rbid) values ('DSCN5277-Sharp', 'eeca71f8-92d1-4a42-8b0b-40fbb32d1638', '1622266-3-red-camaro');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5184-Sharp', '03505c74-6f38-42a6-91c0-bf4341aa91bc', '297082427', 'http://www.zazzle.com/hammer_time_mousepad-144936232075002142');
insert into commerce (id, cfmp, zazmp) values ('DSCN5188-Sharp', '297071585', 'http://www.zazzle.com/pontiac_lemans_mousepad-144772646223299710');
insert into commerce (id, cfmp, ikid, zazmp) values ('DSCN5117-Sharp', '297093376', '691be458-8f00-4c6d-bf75-e6addd77dcbc', 'http://www.zazzle.com/lemans_mousepad-144171967501782684');
insert into commerce (id, cfmp, ikid, zazmp) values ('DSCN5181-Sharp', '297094765', '57073353-4195-4ab4-84d8-5c147512665e', 'http://www.zazzle.com/time_machine_iii_mousepad-144421960535784483');
insert into commerce (id, cfmp, zazmp, caption) values ('DSCN5213-Sharp', '297098241', 'http://www.zazzle.com/rail_at_rest_mousepad-144084022582004810', 'Rail at Rest');
insert into commerce (id, ikid, cfmp, rbid, caption, zazmp) values ('DSCN5211-Scrub-Sharp', '0741dab1-30a0-40f7-b8c0-d39830611635', '297100018', '1622206-2-rail-under-blue-sky', 'Rail from Rear', 'http://www.zazzle.com/rail_from_rear_mousepad-144173792162524782');
insert into commerce (id, cfmp, zazmp) values ('DSCN5198-Sharp', '297101165', 'http://www.zazzle.com/classic_camaro_mousepad-144964243766125203');
insert into commerce (id, ikid) values ('0368199-R3-055-26', 'fd52ddd2-ff13-4e01-b9db-3890d4bdd082');
insert into commerce (id, ikid, cfmp) values ('DSCN3800-S-Crop01-8x10-Sharp', '9fbcb9e4-4b82-4545-9455-9ea179302f9e', '297332915');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN3800-S-Sharp', '9fbcb9e4-4b82-4545-9455-9ea179302f9e', '297332915', 'http://www.zazzle.com/richard_church_mousepad-144874014296642706');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070162FV100-FFCrop-Sharp', 'b02fbca4-18ad-4565-b534-7da0545f4853', '297336819', 'http://www.zazzle.com/classic_camaro_mousepad-144945249176271262');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070166FV100-FFCrop-Sharp', 'b6ccca83-245c-471d-9020-8a234da5a1ca', '297343169', 'http://www.zazzle.com/classic_camaro_mousepad-144978683660870891');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070174FV100-FFCrop-Sharp', '284a56d4-357a-45bb-887b-d9e27c0923ad', '297350276', 'http://www.zazzle.com/classic_camaro_mousepad-144030979754781969');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070173FV100-FFCrop-Sharp', '060c20a7-9cfc-4dbd-87cc-4a5c6e4bcae7', '297353361', 'http://www.zazzle.com/classic_camaro_mousepad-144649863604474013');
insert into commerce (id, ikid) values ('DSCN3814-Crop01-8x10-Sharp', '83396aab-6fbc-46d9-ad6a-14c1e57a57e6');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN3815-S-Crop01-8x10-Sharp', '1d3b60fc-8a80-4266-8c34-cf7f961b2399', '297356526', 'http://www.zazzle.com/junior_dragster_mousepad-144311798555893086');
insert into commerce (id, cfmp, zazmp) values ('DSCN5194-Sharp', '297361882', 'http://www.zazzle.com/mustang_rear_view_mousepad-144881508215142913');
insert into commerce (id, ikid) values ('DSCN5284-Sharp', 'a856d6e8-6a6d-4373-ab5f-322872e89b99');
insert into commerce (id, ikid, cfmp, rbid, zazmp, caption) values ('DSCN5216-Sharp', '68dd5f7b-a07a-4296-bf7f-c646eeae7f37', '297367002', '1622228-2-rail-self-reflection', 'http://www.zazzle.com/rail_self_reflection_mousepad-144222878625172047', 'Rail Self-Reflection');
insert into commerce (id, ikid, rbid, caption) values ('DSCN5214-Sharp', '361b0932-6ec7-4cd7-b332-f7b148e26701', '1603514-2-rail-at-rest', 'Rail at Rest');
insert into commerce (id, ikid) values ('DSCN3748-Crop01-8x10-Sharp', '16e9b038-3f14-4361-be13-4b4c088525d3');
insert into commerce (id, cfmp, zazmp) values ('DSCN3748-Sharp', '298113542', 'http://www.zazzle.com/camaro_yenko_mousepad-144459461716419804');
insert into commerce (id, ikid) values ('DSCN3781-Crop01-8x10-Sharp', '36ec5aea-737d-486e-ae80-d59523c9d308');
insert into commerce (id, cfmp, zazmp) values ('DSCN3781-Sharp', '298117277', 'http://www.zazzle.com/cole_briggs_mousepad-144261055494323507');
insert into commerce (id, ikid) values ('DSCN3757-Crop01-8x10-Sharp', 'fdd2fd12-dc2c-4e77-8604-66655322d60a');
insert into commerce (id, cfmp, zazmp) values ('DSCN3757-Sharp', '298119531', 'http://www.zazzle.com/drag_racing_mousepad-144724258707553535');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070100FV-Crop01-8x10-Sharp', '5854f1fe-68ea-49da-aaea-1cd1e82a7b69', '298161404', 'http://www.zazzle.com/stolen_moments_mousepad-144635944332100242');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070103FV-Crop01-8x10-Sharp', '2bd244bb-e94d-4264-9c5a-c2145cdc81b4', '298164421', 'http://www.zazzle.com/dragen_lady_mousepad-144297460101736313');
insert into commerce (id, ikid, cfmp, caption, zazmp) values ('2024695-R2-045-21', 'a3a208c1-5f6d-4d0c-917b-a010c5080751', '298545518', 'Corvette Burn-Out', 'http://www.zazzle.com/corvette_burn_out_mousepad-144110290232792304');
insert into commerce (id, ikid) values ('DSCN3738-Crop01-8x10-Sharp', '7b981a45-1244-497f-8f1f-6ab0e127d9fe');
insert into commerce (id, cfmp) values ('DSCN3738-Sharp', '298549933');
insert into commerce (id, ikid, cfmp, caption, zazmp) values ('2024695-R1-075-36', 'c4dca479-209b-4a4c-83d9-ad10ecde5920', '298554273', 'Nose Up', 'http://www.zazzle.com/nose_up_mousepad-144154364287404046');
insert into commerce (id, ikid, cfmp, zazmp) values ('SW0002N04-GRM-FFCrop-Sharp', 'f3f1c3f0-d872-4488-99ea-84e0e065bc66', '298711111', 'http://www.zazzle.com/proudly_gm_mousepad-144424798957009165');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070035FV-FFCrop-Sharp', 'aeb2d509-9024-46b8-9e9c-430f12110952', '298717856', 'http://www.zazzle.com/larry_launches_mousepad-144656971705357702');
insert into commerce (id, ikid) values ('20070034-FFCrop-Sharp', 'b726cb38-1269-4b77-a73b-85381848e06f');
insert into commerce (id, ikid) values ('SW0001N37-GRM-FFCrop-Sharp', '2e9c83a7-4190-471e-b6aa-41cd0da3f1ec');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070002FV-FFCrop-Sharp', 'd70eed5c-5d9a-48a1-b7ed-970485c69d59', '298727029', 'http://www.zazzle.com/drag_racing_cutlas_mousepad-144632387856960008');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN3709-Sharp', '436af040-31cf-4804-922e-9c9dc0743601', '298731047', 'http://www.zazzle.com/classic_cutlas_mousepad-144151780981516537');
insert into commerce (id, ikid, cfmp, zazmp) values ('SW0002N01-GRM-FFCrop-Sharp', 'c7da661f-4b71-4ab0-b401-42b93a52521b', '298779694', 'http://www.zazzle.com/mustang_mousepad-144767581400893920');
insert into commerce (id, ikid, cfmp, zazmp) values ('SW0003N04-GRM-FFCrop-Sharp', 'd03959c5-57a8-4ad5-873c-961cc7e55538', '298780440', 'http://www.zazzle.com/van_wheelie_mousepad-144529126442955439');
insert into commerce (id, ikid) values ('SW0001N23-GRM-Crop01-8x10-Sharp', '4bff0463-5f20-4e9f-ba5b-933e88f40cb3');
insert into commerce (id, cfmp, zazmp) values ('SW0001N23-GRM-FFCrop-Sharp', '298784162', 'http://www.zazzle.com/van_wheelie_mousepad-144065444510351235');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070032FV-FFCrop-Sharp', 'feba7a94-f307-4bb1-92f0-4be67b96f1d7', '298786005', 'http://www.zazzle.com/silver_burn_out_mousepad-144220451844345613');
insert into commerce (id, ikid) values ('SW0001N01-GRM-Crop01-8x10-Sharp', '9f4fcd3d-1c60-4423-9e3c-e02917d234e1');
insert into commerce (id, cfmp, zazmp) values ('SW0001N01-GRM-FFCrop-Sharp', '298797497', 'http://www.zazzle.com/van_wheelie_mousepad-144302993283949336');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5315-Sharp', '8cb8b808-72fb-4661-828e-90f461f07e42', '305913843', 'http://www.zazzle.com/night_drag_racing_mousepad-144258128479639516');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5317-Sharp', '6a91a4a9-daec-42b8-a554-e07c512d0d7a', '305915605', 'http://www.zazzle.com/night_drag_racing_mousepad-144666080831544251');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5318-Sharp', '8d1a3f53-359c-40c1-b968-3096511a02ad', '305917740', 'http://www.zazzle.com/night_drag_racing_mousepad-144319892850576061');
insert into commerce (id, ikid, cfmp, caption, zazmp) values ('DSCN5319-Sharp', '22cf9515-f465-4b1d-8adf-0d518558c276', '305919840', 'Zimmerman Racing', 'http://www.zazzle.com/zimmerman_racing_mousepad-144536739581924317');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5320-Sharp', 'eb178436-e45b-4bd1-80fb-f62281ebc172', '305971484', 'http://www.zazzle.com/night_drag_racing_mousepad-144598262312364727');
insert into commerce (id, ikid, cfmp, zazmp, caption) values ('DSCN5321-Sharp', '1a992912-7db6-4b54-9c82-c226ed488659', '305972974', 'http://www.zazzle.com/mr_magoo_ii_night_start_mousepad-144651045479861769', 'Mr. Magoo II Night Start');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5288-Sharp-Scrub-B-Fract01', 'c9190f83-8f54-4bd1-8be8-04ebef59e46e', '306171371', 'http://www.zazzle.com/drag_racing_mousepad-144687428858707230');
insert into commerce (id, ikid, rbid) values ('DSCN5284-Sharp-Fract01', 'bf98a110-4e96-4db1-94cd-c0b99c675bb2', '1686745-2-blue-mustang');
insert into commerce (id, ikid, rbid) values ('DSCN5281-Sharp-Fract02', '9ff24c46-1b30-4f20-82dc-f34900e661b1', '1686734-2-nova-glow');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5273-Sharp-Fract01', 'd703301e-5241-47cd-95ac-8eba00da72e8', '306212713', 'http://www.zazzle.com/classic_camaro_mousepad-144218570701681793');
insert into commerce (id, caption, zazmp) values ('DSCN5211-Scrub-Sharp-Fract01', 'Rail From Rear, Sketch', 'http://www.zazzle.com/rail_from_rear_sketch_mousepad-144308315315305504');
insert into commerce (id, caption, zazmp) values ('DSCN5211-Scrub-Sharp-Fract02', 'Rail From Rear, Charcoal Sketch', 'http://www.zazzle.com/rail_from_rear_charcoal_mousepad-144282451488791338');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5211-Scrub-Sharp-Fract03', '34cf1df7-5ba5-411c-a3bd-e7fbcb36a224', '306214889', 'http://www.zazzle.com/drag_racing_rail_mousepad-144855748399202377');
insert into commerce (id, ikid, cfmp, zazmp) values ('DSCN5207-Scrub-Sharp-Fract01', '2ba516c3-c7b7-4a0c-ba35-dcd99547c9ce', '306216637', 'http://www.zazzle.com/drag_racing_truck_mousepad-144369156504798556');
insert into commerce (id, caption, zazmp) values ('DSCN5207-Scrub-Sharp-Fract02', 'Custom Bronco, Glow', 'http://www.zazzle.com/custom_bronco_mousepad-144164001244865096');
insert into commerce (id, ikid) values ('DSCN5161-Sharp-Fract02', 'ca21b58b-a878-4bd6-b041-563de9d34d4e');
insert into commerce (id, ikid) values ('DSCN5113-Sharp-Fract01', 'faad3f4c-b360-4a16-9822-6f66a4676b32');
insert into commerce (id, ikid) values ('DSCN3799-Sharp-Fract01', 'd54fe94d-acd9-47ef-8b8d-a872d5e248ef');
insert into commerce (id, ikid) values ('DSCN3795-Sharp-Fract01', 'b09622b5-18fd-42a1-9970-93432f4f8627');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070166FV100-FFCrop-Sharp-Fract01', '84a98230-d940-4e71-988e-c000a159886a', '306228744', 'http://www.zazzle.com/classic_camaro_headlight_mousepad-144785804868207916');
insert into commerce (id, ikid, cfmp, zazmp) values ('20070162FV100-FFCrop-Sharp-Fract01', '533003f6-901f-4196-9f6a-f1cb3ae710f4', '306232806', 'http://www.zazzle.com/classic_camaro_mousepad-144635208208663605');
insert into commerce (id, caption) values ('20070033FV-FFCrop-Sharp-B', "Let's race!!<br>January 7, 2007");
insert into commerce (id, caption) values ('DSCN4474-Sharp', 'Trailer graphic created by <a href="http://www.Kartoons.com">Kartoons.com</a><br>October 10, 2007');
insert into commerce (id, caption, ikid, cfmp, rbid, zazps) values ('DSCN1956-PS-Fract01', 'NULL', '15bedeea-9581-46b0-a194-9df5d3486233', 'NULL', 'NULL', 'http://www.zazzle.com/rose_over_black_abstract_postage-172580266170652842?rf=238464886039593743');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4591-Filter01-Fract01', 'Gothic Rose', '57b4f912-282f-4929-b207-f59076eea708', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('R0080N15A-FFCrop-Fract01', 'NULL', '0e57c7ef-e548-425e-8f48-a04fb2f2bcf9', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('R0144N26-FFCrop-Fract01', 'NULL', '88d6df49-a16e-476d-a395-28c37477db7d', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('R0144N26-FFCrop-Fract02', 'NULL', 'e03119ea-8802-439b-b9eb-fe471ec2b6df', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN0457-PS-Fract04', 'NULL', '7a8242d2-8335-405e-9aa2-3fa34bc2a944', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN0457-PS-Fract03', 'NULL', '99fdf6df-a0e8-4136-83c1-bea57682057c', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040443P100-FFCrop-Fract01', 'Supercharger', '16403b43-617e-4262-8325-14e4cdc447a7', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040413P100-FFCrop-Fract02', 'Handle and Intake', 'f0b040e7-df37-41d0-82a2-18c4aa0b77f7', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040385P100-FFCrop-Fract01', 'Fender Blaze', '9a75d636-a217-42a7-aa8b-0995bcb098fb', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040390P100-FFCrop-Scrub-Fract01', 'Chrome Engine', '24dc6379-7c79-45bb-ae06-d19d07c8747c', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040390P100-FFCrop-Scrub-Fract02', 'Chrome Engine BW', '9e22dd33-d970-442b-9161-267dfa40de45', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('20040407P100-HC-FFCrop-B-Fract01', 'Headlight Assembly', 'e37aad81-5cc8-4564-bef1-2bcd12d07a54', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid, zazps) values ('DSCN1895-PS-Fract01', 'Praying Hands', '6a0b3ba3-d521-4bb5-8967-54eea202b659', 'NULL', 'NULL', 'http://www.zazzle.com/praying_hands_abstract_postage-172919281501233599?rf=238464886039593743');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940289FV-Crop01', 'NULL', '714ec69d-b21a-4a9d-8882-be197f8b04af', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940263FV-FFCrop', 'NULL', '1297fcf8-d135-4cbf-9f9b-2b216d173e78', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940174FV-FFCrop', 'NULL', '914e98e7-08bd-4071-a9e0-e0d99abdd2cb', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940170FV-FFCrop', 'NULL', 'ee456d2c-a1b3-4fa3-bbbf-e8c845bb4451', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940080FV-Crop02', 'NULL', 'd3875b4d-952a-425c-8d12-e570b6d6bbfb', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940080FV-Crop01', 'NULL', '8f9844fc-f93a-4c15-a38b-8f887587aa8d', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940076KL100-FFCrop', 'NULL', 'f348e031-bbe5-4420-87ac-0fe3750ec1bd', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940070KL100-Crop01', 'NULL', '5497ee90-0458-4175-8fd7-ab13be13a277', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940290FV-FFCrop', 'NULL', '6c08f8f6-7d40-4d0b-ac18-46d6c4e982ca', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940341K64-FFCrop', 'NULL', 'd9e1f010-70f6-4c49-a7e4-31586938007b', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940465FV-FFCrop', 'NULL', '45b0c9e7-5f20-44e0-9ac6-68e4b06f0e11', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940485FV-FFCrop', 'NULL', 'b5e749d1-bd45-48ec-a1c0-18d4359ea670', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19950034K25-FFCrop', 'NULL', 'dde524d4-9f4b-4ad8-ab5c-63418fa31c40', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3850-Sharp', 'NULL', 'e1c1a364-dd08-4816-9677-aabfcb6f35cc', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940144FV-FFCrop', 'NULL', '813c9337-1601-452f-ad37-4e5c800eaccc', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19950093FV-FFCrop-OP', 'NULL', '212f79ff-9111-4ab3-96fa-cc779d4eeb63', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19950102FV-FFCrop', 'NULL', '02f9c5f3-203f-418e-b790-d5afe5fc6dfa', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3826-Sharp', 'NULL', '9348f38c-27be-4d63-8905-21c008f92183', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3827-Sharp', 'NULL', '9f71d9b2-1f53-4688-baba-b45c02400c04', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3833-Pop-Sharp', 'NULL', 'ec8bdec6-26bc-41b4-844b-b0b30ea2440f', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3835-Black-Sharp', 'False Color Blossoms', 'd3884a5a-07ce-40eb-9d64-005e750672bc', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3835-WhiteRed-Sharp', 'False Color Blossoms', '1e5d53ce-eb25-4e8e-afa7-7b8b369a27bd', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3839-Sharp', 'NULL', 'fbf6a982-5bcf-4268-8654-660d8dbe86fb', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3840-Sharp', 'NULL', '669a6e12-ea27-4af5-b56b-145ec37f336a', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3865-Sharp', 'NULL', '6f679303-f0eb-4a5b-b844-e43ba9a2cc08', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4591-Filter01', 'Wilted Glory', '67d91760-ae94-43a4-aa32-74180402db5a', 'NULL', '1758425-2-wilted-glory');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('FieryGalaxy', 'Fiery Galaxy Fractal', '467bed8d-6b0e-45ff-a4a9-e65914579a0a', 'NULL', '1603359-2-fiery-galaxy');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('LizardOnEgg-Orange-8x10', 'Lizard and Egg. Flame fractal incorporating shapes of a lizard and an egg. Is this the lizard hatching from the egg or the lizard keeping watch over it?', '5089aea5-fe56-4a58-a117-1a1f4817950f', 'NULL', '1603388-3-lizard-and-egg');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('LizardOnEgg-Orange', 'NULL', '5089aea5-fe56-4a58-a117-1a1f4817950f', 'NULL', '1603388-3-lizard-and-egg');
insert into commerce (id, caption, ikid, rbid) values ('FireSwoosh', 'Fire Swoosh', 'ee2b59cc-8793-4df4-9b3d-9c8a515bc12d', '2018420-3-fire-swoosh');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('Seq05-0016-6000-VGA.values-CMap10', 'NULL', '1be35ff6-1b58-41c4-b311-f6537cbbedeb', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('Seq05-0016-6000-VGA.values-CMap05', 'NULL', '34e92179-9884-4260-a503-f2d3603a494d', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('Seq05-0014-6000-VGA.values-CMap10', 'NULL', 'ce2593d9-b0d1-45f3-a040-f2486246c6f0', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4816-Print', 'NULL', '309d2065-52dd-4064-a4c0-6e18f99926f7', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4861-Adjust-Print', 'NULL', '82f7adb2-a6e2-48a1-b9a0-623b0989786d', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('HDR-4879_80_81_82_tonemapped', 'NULL', 'b4de4c0e-534d-41c9-9d31-45ccec2279d5', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4805', 'NULL', '0e82df61-a3aa-49a1-a83d-ef0ae60bf730', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4815-S-Print', 'NULL', '170e9b7a-aed7-4599-b8e8-315663bb0284', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4832-S-Print', 'NULL', '9cc63ac5-8300-4157-bbf4-d44e921f446c', 'NULL', 'NULL');
#insert into commerce (id, caption, ikid, cfmp, rbid) values ('##DSCN4842-S-Print', 'NULL', '2c63796e-e4c1-4e39-9dfe-09d0ac41d293', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4844-Adjust-Print', 'NULL', '6722b6dd-40f9-452a-8409-c5c12bde32f3', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4848-Adjust-S-Print', 'NULL', '37d9d2d3-e8b9-444f-a7cd-63f1a3454b96', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4863-S-Print', 'NULL', 'cdacd3e3-b9b8-429d-bbf5-f07faa304fac', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4877-Adjust-S-Print', 'NULL', 'e97e1a6e-9ca4-4b0c-9f55-e7cf40eb4c87', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('HDR-4883_4_5_6_7_tonemapped', 'NULL', '25d7bec2-7745-4911-b851-12c8fc71f2dd', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('HDR-4902_3_4_5_6_7_tonemapped', 'NULL', '09c47445-ce03-4ce6-aef2-3e4119c5a59e', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4807', 'NULL', 'b77f70dd-2637-43bb-81d3-685cfa30e87d', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4810-Scrub', 'NULL', '5d40089d-b9d9-4a44-8811-db4489c5efb3', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4808', 'NULL', '8ceca77f-45a9-4169-9a1c-2a4122fbe2b9', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4806', 'NULL', '1d8b473c-48a7-4f05-aa79-b492bf7e44ba', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4803-S-Scrub', 'NULL', 'b5644031-fb48-4ce6-9f79-9fbe266fb668', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('HDR-4897_898_899_900_901_tonemapped', 'NULL', 'b69b008a-e686-4fa8-89b9-9957cd24415a', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('HDR-4888_89_90_91_92_93_tonemapped', 'NULL', '8546931a-aa03-436b-82a7-69e2b78ea6d8', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4852-S-Print-IK', 'NULL', 'b4831c2d-e11d-4742-9e36-99c0eb0ec601', 'NULL', 'NULL');
#insert into commerce (id, caption, ikid, cfmp, rbid) values ('##DSCN4847-S', 'NULL', '6b78a24a-70f7-4171-acd8-c660665ffcc7', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4811', 'NULL', '54052006-cc2f-435b-8112-d23e61da2148', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4836', 'NULL', '0c14e4b5-96ec-4535-bd66-6c39c4405fcc', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4879-Sharp', 'Holy Light', '1f177221-4485-4a19-99ba-5ab9a2b98cd3', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('19940100FV-FFCrop-B', 'Dark Data', '11de40c5-ba48-42ea-87a7-4b19a3432c79', 'NULL', '2935680-2-dark-data');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3937-Sharp', 'Center Chip', '86a64c68-03ed-4cb5-9504-a49beb71e5ed', 'NULL', '2935702-2-center-chip');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4209-Sharp', 'NULL', 'd0b63bae-7f32-46bd-8e17-4fbc1b13db9c', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4167-Sharp', 'NULL', '8bd70689-b6a5-4d41-96a4-eebad411af5a', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4142-Sharp', 'NULL', 'e5b592a1-f5fd-4cd2-8236-3b2c654e1452', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4138-Sharp', 'NULL', '8809b071-13a8-400b-862a-d673c5bc1bfc', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4054-Sharp', 'NULL', 'e81bc67e-2f85-482d-bcde-ec7ea8051e9e', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4040-Crazed-Sharp', 'NULL', '8da486d4-c94f-4926-99f2-34bc3f307846', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN4003-Sharp', 'NULL', '65ffbc89-98da-44f0-92fc-e51e0658742c', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3960-Sharp', 'NULL', '07e142f4-4aeb-4b09-a484-dee311230041', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, cfmp, rbid) values ('DSCN3950-Sharp', 'NULL', '91596961-a79a-437e-8fa1-b5dda7500830', 'NULL', 'NULL');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1908-PS-Fract01', 'Statue and Rose', 'e8559898-8c3c-4877-9faa-4def532389ce', '1623638-2-statue-and-rose');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1967-PS-Scrub-Garish-Fract01', 'Nightmare Over Graves', '134f2c39-055f-41e0-a899-84cd6b380e32', '1623675-2-nightmare-over-graves');
insert into commerce (id, caption, ikid, rbid) values ('DSCN2084-PS-Scrub-Fract01', 'Tower Path', '8e88319f-d129-4b3d-9bf4-e7a54ae893d3', '1623710-2-tower-path');
insert into commerce (id, caption, ikid, rbid, zazps) values ('DSCN1983-PS-Fract01', 'Sit With Me', '1524c368-7087-43a9-b19e-a4363e157d0a', '1627661-2-sit-with-me', 'http://www.zazzle.com/sit_with_me_postage-172443056751011552?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid) values ('DSCN2103-PS-S-Fract01', 'Cross Glow', '7bab8bac-519b-486c-a121-f70b687188c6', '1627644-2-cross-glow');
insert into commerce (id, caption, ikid, rbid) values ('19950063KL100-Crop01-B-Fract01', 'Tulip Stained Glass', 'ce7363d9-6c3b-4c8b-9511-9f88b38de4b6', '1627793-2-tulip-stained-glass');

insert into commerce (id, caption, ikid) values ('20040407P100-HC-Crop01', 'Sportscar Headlights', 'd686eb80-8fcb-4a0a-91dc-088c2a97ac50');
insert into commerce (id, caption, ikid) values ('20040411P100-FFCrop', 'Metal Gills', '83ed7456-153a-43e1-81d1-c95d2339086c');
insert into commerce (id, caption, ikid) values ('20040418P100-FFCrop', 'Roadster Engine', '5b143e4a-256c-40f7-a1c1-73842dcb431e');
insert into commerce (id, caption, ikid) values ('20040394P100-Crop02', 'Roadster Headlight', '361f0fff-83fc-4162-a9b4-23a54d55f2fa');
insert into commerce (id, caption, ikid) values ('20040385P100-FFCrop', 'Orange Flame Fender', 'c1e837fc-96c1-4027-b0ac-d3221a7f071a');
insert into commerce (id, caption, ikid) values ('20040456XFV100-Crop01', 'Grille and Lights', 'a7ba602a-3b2b-43e1-ac07-be369d235638');
insert into commerce (id, caption, ikid) values ('20040456XFV100-FFCrop', 'Grille and Lights', 'a7ba602a-3b2b-43e1-ac07-be369d235638');
insert into commerce (id, caption, ikid) values ('20040443P100-FFCrop', 'Flame Supercharger', '13f01220-be4b-48b9-96e9-de3f53f8102f');
insert into commerce (id, caption, ikid) values ('20040430P100-FFCrop', 'Headlight and Chrome', 'b30e3ea6-51a4-48ac-ad30-353e995bff8c');
insert into commerce (id, caption, ikid) values ('20040413P100-FFCrop', 'Handle and Intake', 'cfe48aa3-4acc-4d24-b837-5e5c0266332b');
insert into commerce (id, caption, ikid) values ('20040407P100-HC-FFCrop-B', 'Headlights', 'f3ccb6a6-87bc-4231-8cc6-53412c39fc24');
insert into commerce (id, caption, ikid) values ('20040399P100-FFCrop', 'Car Side', 'cc6967f5-d1df-4232-87dc-fc94f64b4ce6');
insert into commerce (id, caption, ikid) values ('20040391P100-FFCrop', 'Chromed Engine', 'd38a3d76-6145-4056-b9a4-29acc68c7e11');
insert into commerce (id, caption, ikid, cfmp, zazmp) values ('DSCN0984-PS-S-Scrub-Fract04', 'Faux Venice Scene', 'eaca344d-6ee3-4f49-9483-dc3a392bd609', '304184433', 'http://www.zazzle.com/faux_venice_mousepad-144431421163609369');
insert into commerce (id, caption, ikid, cfmp, zazmp) values ('DSCN0984-PS-S-Scrub-Fract02', 'Faux Venice Scene', '14c73cfd-aa83-4639-a03b-abbb2d6ad5f9', '304187934', 'http://www.zazzle.com/faux_venice_canal_mousepad-144838259236917641');
insert into commerce (id, caption, ikid) values ('DSCN0988-PS-Fract03', 'Wynn Glow', 'b8fc3ad3-30bb-45a1-9b47-86414f35265c');
insert into commerce (id, caption, ikid, cfmp, zazmp) values ('R0171N29-Crop01-8x10-Sharp-Fract01', 'Electric Flower', '8e859b51-cbda-4f29-8490-9687e389066e', '306133338', 'http://www.zazzle.com/electric_orange_flower_mousepad-144003323313405049');
insert into commerce (id, caption, ikid, cfmp) values ('306137412', 'Dandelion Study', '3fa9966e-319c-40c7-b497-563dfb0b25b9', '306137412');
insert into commerce (id, caption, ikid) values ('R0140N02-FFCrop-Fract02', 'Glowing Iris', 'bdfd5db3-5e6d-471c-b103-082f29c7a53d');
insert into commerce (id, caption, ikid, cfmp, zazmp, zazps) values ('DSCN4574-Sharp-Fract01', 'Rose Study', '2e7ff210-9fd7-466e-9bc8-1217a0fa0146', '306143219', 'http://www.zazzle.com/rose_sketch_mousepad-144410977690972221', 'http://www.zazzle.com/abstract_rose_postage_stamp-172654973521054434?rf=238464886039593743');
insert into commerce (id, caption, ikid, zazps) values ('19950105K25-FFCrop-B-Fract01', 'Hibiscus Glow', '3a143109-e3c6-407d-9ed2-44c620f7cdff', 'http://www.zazzle.com/abstract_hibiscus_postage-172960592464649160');
insert into commerce (id, caption, ikid, cfmp, zazmp, zazps) values ('19950102FV-FFCrop-B-Fract02', 'Glowing Bud', '92a0ae0d-6ca1-44af-a280-4241e224bd35', '306147731', 'http://www.zazzle.com/glowing_bud_mousepad-144538949974601253', 'http://www.zazzle.com/red_bud_and_flower_postage_stamp-172705737423295495?rf=238464886039593743');
insert into commerce (id, caption, ikid, cfmp, zazmp, zazps) values ('19940290FV-FFCrop-Fract01', 'Bright Leaves', 'b9f1ba78-ca70-49d8-8812-9ea64fa24710', '306151844', 'http://www.zazzle.com/bright_leaves_mousepad-144037116130894286', 'http://www.zazzle.com/deep_green_leaves_stamp_postage-172244506207439868?rf=238464886039593743');
insert into commerce (id, caption, ikid, cfmp, zazmp, zazps) values ('R0144N11-None-FFCrop-Fract02', 'Dandelion Study', '3fa9966e-319c-40c7-b497-563dfb0b25b9', '306137412', 'http://www.zazzle.com/dandelion_abstract_mousepad-144970556479324265', 'http://www.zazzle.com/seeded_dandelion_abstract_postage_stamp-172970976711173498?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid) values ('19940461KL100-FFCrop', 'In Sync', '0822a902-16ae-4d42-a388-a9f016a67149', '1694132-2-in-sync');
insert into commerce (id, caption, ikid, rbid) values ('19950223K25-FFCrop', 'Ocean Sunset', '9fbae911-dff4-490f-a069-c153e6d31076', '1694227-2-ocean-sunset');
insert into commerce (id, caption, ikid, rbid) values ('19940024FV-FFCrop', 'Retroreflectors', '1163533b-7b4a-4aa5-9a35-7281eaf10f4c', '1694372-2-retroreflectors');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1258-PS', 'Woman on Pier', '9d89277a-4dff-48ac-a87f-e307c5c95ad5', '1694422-2-woman-on-pier');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1365-PS', 'Waiting for You', '57697b45-1ea0-4987-a3a1-42050a366433', '1694452-2-waiting-for-you');
insert into commerce (id, caption, ikid, rbid) values ('20040218E200-FFCrop', 'Sit and Enjoy', '3e726454-09d5-414f-9d7b-09dab912f9ec', '1694536-2-sit-and-enjoy');
insert into commerce (id, caption, ikid, rbid, zazmp, zazps) values ('DSCN1590-PS-Fract01', 'Saguaro Glow', 'e32f4c68-fc7e-4b64-a44a-1c882c26e051', '1698039-2-saguaro-glow', 'http://www.zazzle.com/saguaro_glow_mousepad-144388420210096655', 'http://www.zazzle.com/saguaro_glow_postage_stamp-172173288047845950?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid, zazps) values ('20030154FV-FFCrop', 'Cross and Sky', '3df3b73b-8353-47d5-9393-efaaa309c29e', '1698106-2-cross-and-sky', 'http://www.zazzle.com/cross_and_sky_postage-172146420960114531?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid) values ('R0147N26-FFCrop-Sharp', 'Old Chips', 'd997d80a-c86a-4911-a8d0-d45c184a50d9', '1698179-2-old-chips');
insert into commerce (id, caption, ikid, rbid) values ('R0322N13-FFCrop-Sharp', 'Building the Mothership', '41196087-d8f1-41da-8b4b-ecef9b49e8a9', '1698264-2-building-the-mothership');
insert into commerce (id, caption, ikid, rbid) values ('R0144N26-FFCrop-Sharp', 'Pink Azaleas', 'e11fc14e-da11-4643-91d6-ff3229bbaf5c', '1698429-2-pink-azaleas');
insert into commerce (id, caption, ikid, rbid, zazps) values ('R0140N02-FFCrop-Sharp', 'Iris Portrait', '1b058c43-756e-4043-9684-5885c5664335', '1698524-2-iris-portrait', 'http://www.zazzle.com/iris_portrait_postage-172462631123177268?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid) values ('20050010FV-FFCrop-Sharp', 'New York New York Hotel', 'e284c98d-dd06-4004-a336-006ff9cc74fa', '1698724-2-new-york-new-york-hotel');
insert into commerce (id, caption, ikid, rbid, cfmp, zazmp, zazps) values ('20050043FV-FFCrop-Sharp', 'House on the Hill', '4c8b4ce4-b755-46ef-b224-d85fedd0aa7b', '1703173-2-house-on-the-hill', '307302318', 'http://www.zazzle.com/house_on_the_hill_mousepad-144053075610709683', 'http://www.zazzle.com/white_house_on_forest_hill_postage_stamp-172149265491746792?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid, zazps) values ('20030151FV-Crop01', 'Fellowship', 'f9615786-b540-4149-a8ad-2ab753d1bd6b', '1703847-2-fellowship', 'http://www.zazzle.com/fellowship_and_cross_postage-172814084885013570?rf=238464886039593743');
insert into commerce (id, caption, ikid, rbid, cfmp, zazmp, zazps) values ('20040248FV100-FFCrop', 'Blue Footed Boobies', '534e7c5c-c6fa-4cca-a265-896fc2339404', '1703940-2-blue-footed-boobies', '307365089', 'http://www.zazzle.com/blue_footed_boobies_mousepad-144596886434097488', 'http://www.zazzle.com/blue_footed_boobies_postage_stamp-172386203021558706?rf=238464886039593743');
insert into commerce (id, caption, ikid) values ('0368199-R1-053-25', 'Classic Black Mustang', '26a9ccbc-fb20-4246-9cec-80bd884e2873');
insert into commerce (id, caption, ikid) values ('0368199-R1-075-36', 'Reverse Guides', '337d7b44-7cea-4312-8c78-103bece27eea');
insert into commerce (id, caption, ikid) values ('0368199-R1-077-37', 'Alone for a Quarter Mile', 'a00c90c9-41fa-40a7-a56b-436c096b2121');
insert into commerce (id, caption, ikid) values ('0368199-R2-013-5', 'Junior Dragster', 'c9454fe6-7703-4e41-b42f-25bb803ac28d');
insert into commerce (id, caption, ikid) values ('0368199-R4-011-4', 'Red Eyes and Smoke', 'f4107fa8-d5cc-4730-b69f-5b299c30ebb0');
insert into commerce (id, caption, ikid) values ('0368199-R4-039-18', 'Z28', '2fd4053a-eb88-472d-9e6a-e6e93e64fd2a');
insert into commerce (id, caption, ikid) values ('0368199-R4-041-19', 'Smokin Z28', '6c11c092-7144-4305-9909-137754c5af83');
insert into commerce (id, caption, ikid) values ('0368199-R4-071-34', 'Wheelie Start', 'fa58d760-bbee-4fd3-90e2-536af22b7851');
insert into commerce (id, caption, ikid) values ('0368199-R5-047-22', 'Junior Dragster', 'dc090315-b8ae-40f2-937f-29e9079ca32a');
insert into commerce (id, caption, ikid) values ('0368199-R5-053-25', 'Junior Dragster', 'a04747f4-3c4d-4919-a8c1-1b744d9e7fb6');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3794-Sharp', 'Fuchsia 23T', 'd31f8599-aa9c-4b84-9c7d-0b7d28985278', '1705201-2-fuchsia-23t');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3799-Crop01-8x10-Sharp', 'Pretty', 'ed7c7f83-e91e-49d9-ad31-f24d3d191a87', '1705226-2-pretty');
insert into commerce (id, caption, ikid, rbid) values ('20040219E200-Crop01', 'View Through', '43e15f57-046b-4fe1-bde8-357a0524eeb7', '1705293-2-view-through');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-SpeedWorld01', 'Night Cars', '3591752c-127e-4563-8c27-a8cf058021c3', '1737062-2-night-cars', 'http://www.zazzle.com/night_cars_print-228613230748984061');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-SpeedWorld02', 'Classic American Muscle', 'be02044b-2254-416d-86fc-cec15b960e8b', '1754462-2-classic-american-muscle', 'http://www.zazzle.com/classic_american_muscle_print-228369750277904090');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-SpeedWorld03', 'Mixed Racers', '5beae644-b942-4418-92e1-7627126831de', '1737230-3-classic-and-custom', 'http://www.zazzle.com/classic_and_custom_print-228995805150497324');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-Roadster01', 'Roadster Poster', 'e53f06f3-d7d1-4d13-aef9-76b38ecdec3c', '1754555-2-roadster-poster', 'http://www.zazzle.com/roadster_poster_print-228174060361081839');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5513-Sharp-Fract01', 'Roadster at the Start, Dark', 'e2658d4c-aaf0-448e-bf00-cae38ae0010f', '1754900-2-roadster-at-the-start-dark');
insert into commerce (id, caption, ikid, rbid) values ('DSCN4054-Fract01', 'Ghost in the Machine', '5d443b24-19b5-40ed-9bab-47346efe5c4f', '1756236-2-ghost-in-the-machine');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5360-Sharp-Fract01', 'Roadster Front Flames', '82685fa9-96aa-4cc3-8f60-3a0880b3a742', '1756281-2-roadster-front-flames');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5342-Sharp', 'Patriotic Dragster', '311403542', 'http://www.zazzle.com/patriotic_dragster_mousepad-144135788368968322');
insert into commerce (id, caption, cfmp) values ('DSCN5345-Sharp', 'Junior Dragster', '311404947');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5346-Sharp', 'Junior Dragster', '311405675', 'http://www.zazzle.com/junior_dragster_mousepad-144067139485352605');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5347-Sharp', 'Junior Dragster', '311407192', 'http://www.zazzle.com/junior_dragster_mousepad-144605876096274506');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5348-Sharp', 'Trike Racer', '311409045', 'http://www.zazzle.com/trike_racer_mousepad-144706303505386163');
insert into commerce (id, caption, cfmp) values ('DSCN5428-Sharp', 'Junior Dragster', '312180540');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-SpeedWorld04', 'Trike Racers', '5e29e2d0-e54c-4bb7-93cb-c59a408d5984', '1771120-2-trike-racing-poster', 'http://www.zazzle.com/trike_racing_poster_print-228853434453231207');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-SpeedWorld05', 'Junior Dragsters', '37798b1a-6944-4f02-b76b-808e365a9b64', '1771163-2-junior-dragsters', 'http://www.zazzle.com/junior_dragsters_print-228422831323346806');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5520-Sharp-Fract01', 'Junior Dragster', 'bdc4958a-2199-4e98-80ae-066b6888cbc1', '1777114-2-junior-dragster');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN5345-Sharp-Fract01', 'Junior Dragster', 'b450f626-3419-4414-b8b1-0cbb7373c661', '1777514-2-junior-dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144976668987500990');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5482-Sharp', 'We Racing?', '00a93cb8-d94e-4280-be54-ed5ee33f8b3d', '1777923-2-we-racing');
insert into commerce (id, caption) values ('DSCN5051-NR', 'The bride approaches');
insert into commerce (id, caption) values ('DSCN5054-NR', "Laura receives Dan's vow.");
insert into commerce (id, caption) values ('DSCN5055-NR', "Dan receives Laura's vow");
insert into commerce (id, caption) values ('DSCN5056-S-NR', "I've got the rings here somewhere");
insert into commerce (id, caption) values ('DSCN5065-NR', 'Elementary school Art class skills come haunting');
insert into commerce (id, caption) values ('DSCN5073-S-NR', 'Mr. and Mrs. Chachko');
insert into commerce (id, caption) values ('DSCN5075-NR', 'Finally Married!!');
insert into commerce (id, caption) values ('DSCN5076-NR', 'Faces of Love');
insert into commerce (id, caption) values ('DSCN5082-S', 'Formal moose');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-DSCN5360-Fract01', 'Roadster Front Flames', '776efc4f-9a55-4125-ab38-55fcab9f7440', '1789901-2-roadster-front-flames', 'http://www.zazzle.com/roadster_front_flames_print-228869141480360745');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-DSCN5513-Fract01', 'Roadster at the Start, Dark', 'd423b054-01bb-41b5-93a2-e6a77c662fc7', '1789972-2-roadster-at-the-start-dark', 'http://www.zazzle.com/roadster_at_the_start_dark_print-228256768987527763');
insert into commerce (id, caption, ikid, rbid, zazpost) values ('Poster-DSCN5520-Fract01', 'Junior Dragster', 'bdab26b2-aa78-4648-8b2c-835b94ff579b', '1789993-2-junior-dragster', 'http://www.zazzle.com/junior_dragster_print-228356853296927918');
insert into commerce (id, caption, ikid, rbid) values ('19940076KL100-FFCrop-Fract01', 'Silver Vase Bromeliad', 'b9e19f07-d3ec-45d9-964f-ecced0475a13', '1797723-2-silver-vase-bromeliad');
insert into commerce (id, caption, ikid, rbid) values ('19940289FV-Crop01-Fract02', 'Evening Primrose', 'e0367740-97a3-4661-a877-fb1c5344ed70', '1797821-2-evening-primrose');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1936-PS-Fract01', 'Rose and Sky', '7d3bc572-64c4-42db-932c-35fbf7c76787', '1797856-2-rose-and-sky');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1937-PS-Fract01', 'Yellow Red Glowing Rose', '0b799c0a-72a3-4601-8aae-2858e10d072a', '1797897-2-yellow-red-glowing-rose');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1937-PS-Fract03', 'Yellow Red Rose Blur', 'a575742e-f713-4b60-bf21-eb425c92df6d', '1797917-2-yellow-red-rose-blur');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1999-PS-Fract02', 'Yellow Rose and Sky', 'ee9d241c-f259-4316-b5c6-1b12d9c34bea', '1797950-2-yellow-rose-and-sky');
insert into commerce (id, caption, ikid, rbid) values ('20040334XFP100-Crop01-16x9-Fract03', 'Christmas House Glow', '1b814479-1411-4b89-bfbf-7e392a5a2859', '1825328-2-christmas-house-glow');
insert into commerce (id, caption, ikid, rbid) values ('20030168FV-FFCrop-Fract01', 'Christmas Lights', '5a68f0fd-751d-4ecc-b086-0b0e281be5c3', '1825380-2-christmas-lights');
insert into commerce (id, caption, ikid, rbid) values ('20030171FV-Crop01-Fract01', 'Christmas Lights', 'c654a192-1945-47e3-a1db-28b8d2139e6b', '1825410-2-christmas-lights');
insert into commerce (id, caption, ikid, rbid) values ('20040344XFV-Crop01-Fract01', 'Christmas Abstract', '259e1bbf-4c5e-4def-a0ee-96f081f8b138', '1825493-2-christmas-abstract');
insert into commerce (id, caption, ikid, rbid) values ('20040476XFV100-S-FFCrop-Fract01', 'Christmas Entry, Dark Sketch', '64bdffb8-bc1b-4e9d-b2fd-c6d9fb884047', '1825590-2-christmas-entry-dark-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0606-PS-Fract02', 'Christmas Entryway, Glow', '9fb5fd5b-184b-440e-a5fa-136826fb91ba', '1825636-2-christmas-entryway-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0689-PS-Fract02', 'Christmas at Night', 'f2ed727a-80de-4c77-ac10-f9a16c4a4487', '1825657-2-christmas-at-night');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0692-PS-Fract01', 'Christmas Entry', 'b6207c85-04ff-4cb3-b826-f7b878e457c0', '1825679-2-christmas-entry');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0693-PS-S-Fract01', 'Christmas Entry Sketch', '5074f8c5-e775-4d5c-a474-509cb6b99c2e', '1825728-2-christmas-entry-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0697-PS-Fract02', 'Christmas Entry, Sketch', 'bca2a062-b846-42ce-92e6-baec06f89c3e', '1825754-2-christmas-entry-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0711-PS-Fract01', 'Entry Reflections, Glow', '2e2d8880-940e-40f8-b93f-fbba7f25dbeb', '1864833-2-entry-reflections-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0713-PS-Crop01-S-Fract01', 'Decorated Entryway, Charcoal', '42810d29-8a0f-43e5-97d3-65ffba46ee8b', '1864891-2-decorated-entryway-charcoal');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0745-PS-Fract01', 'Reindeer Entryway, Charcoal', 'f7c1463d-c13e-45f4-82a1-3dca8df7f513', '1864950-2-reindeer-entryway-charcoal');
insert into commerce (id, caption, ikid, rbid) values ('DSCN2988-PS-Fract01', 'Column and Lightpost, Electric', '7280514b-1e05-47b4-9946-a08946642508', '1865027-2-column-and-lightpost-electric');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3017-PS-Fract02', 'Oversized Lights, Dark Glow', 'bbb899da-6f83-4173-a0ed-145dfea3e36d', '1865063-3-dark-glowing-oversized-lights');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3021-PS-Fract01', 'Oversized Lights, Soft Glow', '228491f8-e2f1-48b4-a4af-e97e3cdeffa6', '1865095-2-oversized-lights-soft-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3025-PS-Fract01', 'Oversized Lights, Soft Glow', '26cec5fa-55be-47c0-95ff-0dda3289b740', '1865133-2-oversized-lights-soft-glow');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6093-Sharp', 'Camaro Nose', 'http://www.zazzle.com/camaro_nose_mousepad-144019048527867981', '0a17670f-1f77-41b6-b6e6-2709bac15ae4', '1901509-2-camaro-nose');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6092-Sharp', 'Camaro Hood and Fender', 'http://www.zazzle.com/camaro_hood_and_fender_mousepad-144776694033510058', 'fcec34d2-65ff-4d7c-95dd-1a7dd87c11da', '1901537-2-camaro-hood-and-fender');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6089-Sharp', 'Patriotic Drag Racer', 'http://www.zazzle.com/bill_schibi_mousepad-144673980015539509', 'f052941a-ab36-4cb2-b17d-9e628c95a879', '1908387-2-patriotic-drag-racer');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6087-Sharp', 'Scary Canary', 'http://www.zazzle.com/scary_canary_mousepad-144483548905376080', '239ac52a-86f2-4270-a718-6e43dc656dd7', '1908412-2-scary-canary');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6084-Sharp', 'AMC/AMX Up Close', 'http://www.zazzle.com/amc_amx_up_close_mousepad-144930903163500267', '4af752e4-469d-41de-8811-76e42e434e0f', '1908530-2-amx-grille');
insert into commerce (id, caption, zazmp, ikid, rbid) values ('DSCN6083-Sharp', 'AMC/AMX in Profile', 'http://www.zazzle.com/amc_amx_in_profile_mousepad-144868202277374565', '26fea53e-8026-439a-a060-d923f28001a3', '1908547-2-drag-racing-amc-amx');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6098-Sharp', 'Green Viper Corvette, Rear Fender', '093ea732-edb9-4049-ae38-66de01c4ac14', '1901193-2-green-viper-corvette-rear-fender');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6097-S-Sharp', 'Green Viper Corvette - 3/4 View', '8d8746c2-b997-4243-b5e6-e5fb575ed777', '1901407-2-green-viper-corvette-3-4-view');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6094-Sharp-Crop01', 'Green Viper Corvette', 'ca11a006-cb5e-4e30-b871-82a404b63cec', '1901448-2-green-viper-corvette');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6091-Sharp', 'Classic Chevy Camaro', '117e821b-4343-44aa-a308-fe5dd371e5c0', '1901568-2-classic-chevy-camaro');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6090-S-Sharp', 'Classic Camaro, Top View', '32c231b7-2413-453e-99dc-abc3ac7c770a', '1901590-2-classic-camaro-top-view');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6085-Sharp', 'M751 Corvette Stingray', '6f4064f6-ae05-4820-9081-7854f82f09b4', '1908448-2-m751-corvette-stingray');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6081-Sharp', 'Custom Bronco Drag Racer', '1a16dfd3-6adf-4071-a72e-21d7fa17659d', '1908579-2-custom-bronco-drag-racer');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5989-Sharp-Fract01', 'Blue Camaro Sketch', 'ee97eb85-ad5b-4571-830b-51e30ace2fd4', '1982843-2-blue-camaro-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5995-S-Sharp-Fract02', '"The Mistress" Hood View, Bright Sketch', 'd8429243-1737-45fb-9a8f-ce04998ac80f', '1982901-2-the-mistress-hood-view-bright-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5995-S-Sharp-Fract03', '"The Mistress" Hood View, Dark Glow', '6f27a6b9-a9b5-40f3-a91f-17d367339221', '1983079-2-the-mistress-hood-view-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6033-S-Sharp-Fract01', 'Junior Dragster Sketch', 'b380bba8-a8fd-495e-b67f-37fa4bbaf6e3', '1983153-2-junior-dragster-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5999-Sharp-Fract01', 'Drag Racer Sketch', '694c98d8-4876-47b0-aeeb-ea6e08f79503', '1983431-2-drag-racer-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6020-Sharp-Fract01', '"Stage Fright" Close View, Sketch', '08c9210d-c5ed-4add-99c0-e184899ce0c5', '1983492-2-stage-fright-close-view-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6139-Sharp', 'Night Camaro', '20b6beae-35ee-4f12-b36f-134a896b548d', '1986669-2-night-camaro');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6390-S-Sharp', 'Classic American Muscle Rear View', '6a840cb9-ff87-46cb-8482-a85e7ff57372', '1986889-2-classic-american-muscle-rear-view');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6384-Sharp', 'Drag Racing Corvette', '814327ae-2f08-4e6b-9131-8d1eac04cedc', '1987306-2-drag-racing-corvette');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN6382-Sharp', 'Drag Racing Corvette', 'fc5ac4b6-9658-4d13-b9cb-2c70bb689566', '1987363-2-drag-racing-corvette', 'http://www.zazzle.com/racing_corvette_mousepad-144026634741834832');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6379-Sharp', 'Drag Racing Roadster', 'e9f5d105-a738-4e66-b429-0628da9fd158', '1987416-2-drag-racing-roadster');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN6375-S-Sharp', 'Preparing to Race', '45df11a8-e4d2-4503-9574-b4567c8ef759', '1987512-2-preparing-to-race', 'http://www.zazzle.com/brandon_racing_mousepad-144292194139260294');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN6373-Sharp', 'Mike Prepares to Race', 'ded06985-04c4-47ad-9912-557ea7dd93e7', '1987624-2-mike-prepares-to-race', 'http://www.zazzle.com/mike_prepares_mousepad-144677990584953051');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6372-Sharp', 'The Long View', '13ee3522-4b1d-4adc-b6be-2c8f8393f856', '1987817-2-the-long-view');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6366-Sharp', 'Red Roadster Moto-Meter', '0fa486b0-f33f-41e1-b872-61d3def4686d', '1988165-2-red-roadster-moto-meter');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6360-Sharp', 'Cockpit and Intake', '86125769-6859-4ce8-974b-80be37c1db6e', '1988200-2-cockpit-and-intake');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN6358-Sharp', "Mike's Rail", 'c3ef3720-aeb5-43e0-92b3-2bbc07eda105', '1988286-2-mikes-rail', 'http://www.zazzle.com/mikes_rail_mousepad-144455709845141478');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6356-Sharp', 'Engine Backward S', '973a6ca8-5ca3-4655-8e15-b9a3261c4574', '1988339-2-engine-backward-s');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6354-Sharp', 'Red Flamed Roadster', '5880fb8f-2f83-4a8d-a742-6164b75c272c', '1988562-2-red-flamed-roadster');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6346-Sharp', '"Headgames" Drag Racer', 'b59cf4d2-4507-4375-b837-43fd8613da9b', '1988654-2-headgames-drag-racer');
insert into commerce (id, caption, ikid, rbid, zazmp) values ('DSCN6344-Sharp', 'Drag Racer', '57049d24-4f98-4391-a7c5-8bd76ea5c92b', '1988761-2-drag-racer', 'http://www.zazzle.com/bright_yellow_dragster_mousepad-144951983952299789');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6342-Sharp', 'Purple Stripes on Yellow', '4417b88a-8eb7-4c55-aed1-12718c71b7b9', '1988797-2-purple-stripes-on-yellow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6384-Sharp-Fract02', 'Corvette Under Blue Sky Glow', 'bb1f7cc3-c816-4455-a41e-ea6dd28f0c97', '2011539-2-corvette-under-blue-sky-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6384-Sharp-Fract03', 'Corvette Under a Clear Sky B&W Sketch', '2c076b43-595b-4692-a59d-71c3fed438b7', '2011601-2-corvette-under-a-clear-sky-bandw-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6386-Sharp-Fract01', 'Classic Corvette Badge', '9bbac52d-f1cb-4e73-947a-31e6882968b4', '2011645-2-classic-corvette-badge');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6386-Sharp-Fract03', 'Classic Corvette Badge', '0b5d3828-7b1e-4492-87af-f63a405a983e', '2011719-2-classic-corvette-badge');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6298-Sharp-Fract01', 'Classic Orange Camaro Sketch', '67143697-5e2c-4e11-bb25-244caa146007', '2011877-2-classic-orange-camaro-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6298-Sharp-Fract03', 'Classic Orange Camaro Dark Glow', '3168276f-bde5-419e-b4a1-e03c1ba2a58e', '2011934-2-classic-orange-camaro-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6298-Sharp-Fract04', 'Classic Camaro B&W Sketch', '7612d9be-047d-46ac-9f23-e05422f34d56', '2012027-2-classic-camaro-bandw-sketch');
insert into commerce (id, caption, zazmp) values ('DSCN6374-Sharp', 'Brandon Straps In', 'http://www.zazzle.com/brandon_prepares_mousepad-144113631824800362');
insert into commerce (id, caption, zazmp) values ('DSCN6351-Sharp', 'Eddie Brown Prepares', 'http://www.zazzle.com/eddie_brown_prepares_mousepad-144644057822738986');
insert into commerce (id, caption, zazmp) values ('DSCN6341-Sharp', 'Bright Yellow Dragster', 'http://www.zazzle.com/bright_yellow_dragster_mousepad-144480035553731856');
insert into commerce (id, caption, zazmp) values ('DSCN5288-Sharp-Scrub-B-Fract02', 'Night Classic Chevy', 'http://www.zazzle.com/night_classic_chevy_mousepad-144336411237107154');
insert into commerce (id, caption, zazmp) values ('DSCN6298-Sharp', 'Classic Orange Camaro', 'http://www.zazzle.com/classic_orange_camaro_mousepad-144045740608441327');
insert into commerce (id, caption, zazmp) values ('DSCN6279-Sharp', 'Mustang Burn-Out', 'http://www.zazzle.com/mustang_burn_out_mousepad-144996893999330195');
# added/updated 20081214
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5349-Sharp', 'Trike Racer', '311410876', 'http://www.zazzle.com/trike_racer_mousepad-144764458975636336');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5350-Sharp', 'Trike Racer', '311412074', 'http://www.zazzle.com/trike_racer_mousepad-144112873630880751');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5351-Sharp', 'Trike Racer', '311412860', 'http://www.zazzle.com/trike_racer_mousepad-144637098444295630');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5352-Sharp', 'Trike Racer', '311413764', 'http://www.zazzle.com/trike_racer_mousepad-144239107898434454');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5353-Sharp', 'Trike Racer', '311414915', 'http://www.zazzle.com/trike_racer_mousepad-144577889832121070');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5354-Sharp', 'Trike Racer', '311415608', 'http://www.zazzle.com/trike_racer_mousepad-144655882084924058');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5355-Sharp', 'Trike Racer', '311416360', 'http://www.zazzle.com/trike_racer_mousepad-144747915404279494');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5364-Sharp', 'Junior Dragster', '311417934', 'http://www.zazzle.com/junior_dragster_mousepad-144613476421641392');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5370-Sharp', 'Junior Dragster', '311418826', 'http://www.zazzle.com/junior_dragster_mousepad-144408221044528432');
insert into commerce (id, caption, zazmp) values ('DSCN6599-Sharp', 'Serious Competitor', 'http://www.zazzle.com/junior_dragster_mousepad-144620855509462003');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5375-Sharp', 'Junior Dragster', '311420679', 'http://www.zazzle.com/junior_dragster_mousepad-144205231751786904');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5376-Sharp', 'Junior Dragster', '311422417', 'http://www.zazzle.com/junior_dragster_mousepad-144719078136184066');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5391-S-Sharp', 'Junior Dragster', '311821187', 'http://www.zazzle.com/junior_dragster_mousepad-144891649401835475');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5392-Sharp', 'Junior Dragster', '312163398', 'http://www.zazzle.com/junior_dragster_mousepad-144572335340781297');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5393-Sharp', 'Junior Dragster', '312163905', 'http://www.zazzle.com/junior_dragster_mousepad-144551816696440490');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5415-Sharp', 'Junior Dragster', '312164399', 'http://www.zazzle.com/junior_dragster_mousepad-144312069256913970');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5416-Sharp', 'Junior Dragster', '312164975', 'http://www.zazzle.com/junior_dragster_mousepad-144278087373952013');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5418-Sharp', 'Junior Dragster', '312165459', 'http://www.zazzle.com/junior_dragster_mousepad-144114395147047871');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5421-Sharp', 'Junior Dragster', '312171869', 'http://www.zazzle.com/junior_dragster_mousepad-144153217789236574');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5422-Sharp', 'Junior Dragster', '312173381', 'http://www.zazzle.com/junior_dragster_mousepad-144410826880040957');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5424-Sharp', 'Junior Dragster', '312174372', 'http://www.zazzle.com/junior_dragster_mousepad-144526349990539577');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5426-Sharp', 'Junior Dragster', '312175907', 'http://www.zazzle.com/junior_dragster_mousepad-144478994001651565');
insert into commerce (id, caption, cfmp, zazmp) values ('DSCN5427-Sharp', 'Junior Dragster', '312178337', 'http://www.zazzle.com/junior_dragster_mousepad-144028179057710523');
insert into commerce (id, caption, zazmp) values ('DSCN5615-Sharp', 'Diesel Power', 'http://www.zazzle.com/diesel_power_mousepad-144767491329891306');
insert into commerce (id, zazmp) values ('DSCN6267-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144164377949489973');
insert into commerce (id, zazmp) values ('DSCN6247-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144250606651263632');
insert into commerce (id, zazmp) values ('DSCN6234-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144485322600885877');
insert into commerce (id, zazmp) values ('DSCN6228-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144626593335846537');
insert into commerce (id, zazmp) values ('DSCN6219-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144224561618708168');
insert into commerce (id, caption, zazmp) values ('DSCN6208-Sharp', 'Draguar', 'http://www.zazzle.com/draguar_mousepad-144583527112917708');
insert into commerce (id, zazmp) values ('DSCN6082-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144334004297643052');
insert into commerce (id, caption, zazmp) values ('DSCN6039-Sharp', 'Trike Racer', 'http://www.zazzle.com/trike_racer_mousepad-144993079082634122');
insert into commerce (id, caption, zazmp) values ('DSCN6037-Sharp', 'Trike Racer', 'http://www.zazzle.com/trike_racer_mousepad-144534918621792570');
insert into commerce (id, caption, zazmp) values ('DSCN6034-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144029771622150491');
insert into commerce (id, caption, zazmp) values ('DSCN6033-S-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144927945250792037');
insert into commerce (id, caption, zazmp) values ('DSCN6031-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144664411142882793');
insert into commerce (id, caption, zazmp) values ('DSCN6028-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144273783900786804');
insert into commerce (id, caption, zazmp) values ('DSCN6024-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144628833718508178');
insert into commerce (id, zazmp) values ('DSCN5640-NR-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144156728372990031');
insert into commerce (id, zazmp) values ('DSCN5648-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144974998071356345');
insert into commerce (id, zazmp) values ('DSCN5687-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144685742416017860');
insert into commerce (id, zazmp) values ('DSCN5693-NR-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144649841225723258');
insert into commerce (id, zazmp) values ('DSCN5716-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144892452906927883');
insert into commerce (id, zazmp) values ('DSCN5722-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144220771375541737');
insert into commerce (id, zazmp) values ('DSCN5735-NR-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144607245122335715');
insert into commerce (id, zazmp) values ('DSCN5739-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144962282799801337');
insert into commerce (id, zazmp) values ('DSCN5747-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144246835365634386');
insert into commerce (id, zazmp) values ('DSCN5759-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144989469667392014');
insert into commerce (id, zazmp) values ('DSCN5823-NR-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144213207029960857');
insert into commerce (id, caption, zazmp) values ('DSCN5913-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144563264863085665');
insert into commerce (id, zazmp) values ('DSCN5886-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144350978765889882');
insert into commerce (id, zazmp) values ('DSCN5989-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144540044715912214');
insert into commerce (id, zazmp) values ('DSCN5984-S-Sharp', 'http://www.zazzle.com/drag_racing_mousepad-144715335309910830');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5115-Sharp-Fract01', 'Copper LeMans - Sketch', '7f603505-c5d1-45d5-9ed9-63880a60ab73', '2232320-2-copper-lemans-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN5116-Sharp-Crop01-Fract03', 'Copper LeMans - Contrast Enhanced', '39467dc9-d74b-4f69-9731-a81971dadcc4', '2232343-2-copper-lemans-contrast-enhanced');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6296-Sharp-Fract02', 'Blue Racers - Dark Glow', '0fb4f371-2d07-4550-87d7-e9764810360a', '2232371-2-blue-racers-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6301-Sharp-Fract03', 'Classic Muscle Burn-Out - B&W Sketch', '9c0c52e7-605f-4eb7-bc15-8e46d1083428', '2232463-2-classic-muscle-burn-out-bandw-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6301-Sharp-Fract01', 'Classic Muscle Burn-Out - Sketch', '8fae2be2-2740-49cf-a098-1422f011db0a', '2232488-2-classic-muscle-burn-out-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6343-Sharp-Fract01', 'Multi-Color Striped Drag Racer - Sketch', '9a970a1d-8bab-43ca-9583-bbb3268abeff', '2232539-2-multi-color-striped-drag-racer-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6343-Sharp-Fract03', 'Multi-Stripe Racer - High Contrast', 'a27d03c3-98ce-4b97-bd2c-92b44868e59d', '2232577-2-multi-stripe-racer-high-contrast');
insert into commerce (id, caption, ikid, rbid) values ('TM-DSCN6811_2_3_4_5_6', 'HDR- Christmas Decorated House', '94bd8b99-21bf-4c7d-b5f9-2434b623bee2', '2299062-2-hdr-christmas-decorated-house');
insert into commerce (id, caption, ikid, rbid) values ('TM-DSCN6805_06_07_08_09_10', 'HDR - Large House Decorated', '4e6482f9-5c4b-4098-aaba-936ef167622b', '2299096-2-hdr-large-house-decorated');
insert into commerce (id, caption, ikid, rbid) values ('TM-DSCN6774-5-6-B', 'HDR - Light Reindeer and Santa', '01163d12-d54d-4d1c-9046-4755b0fbaa22', '2299138-2-hdr-light-reindeer-and-santa');
insert into commerce (id, caption, ikid, rbid) values ('TM-DSCN6895_6_7_8', 'Christmas Tree HDR', '559e5e5a-1bf1-49e8-b9cd-88edd20b2c58', '2299165-2-christmas-tree-hdr');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3676-S-Fract01', 'Candy-Cane Entryway - Dark Glow', '0ab91a22-5fdc-4219-8ea6-2646b36266d7', '2299222-2-candy-cane-entryway-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3676-S-Fract03', 'Candy-Cane Entryway - Sketch', '30111da7-93e7-44eb-92ed-9ba01c64150d', '2299232-2-candy-cane-entryway-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3676-S-Fract04', 'Candy-Cane Entryway - B+W Sketch', '996d215e-e81e-4265-bcfd-0fe325b3483b', '2299254-2-candy-cane-entryway-b-w-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3679-Fract01', 'Christmas House and Fountain', '06ef96bf-179e-4e24-b680-aa55d7360634', '2299282-2-christmas-house-and-fountain');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3679-Fract03', 'Christmas House and Fountain', 'a07c5139-4189-4c90-860e-526eae25736b', '2299301-2-christmas-house-and-fountain');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3679-Fract04', 'Christmas House and Fountain', '8f113319-9069-4ac3-9cdb-37de26f6e3bd', '2299317-2-christmas-house-and-fountain');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3685-Fract01', 'Christmas Pillared Entryway', 'd3149ae5-dd8f-4f73-9233-31b469b0de2f', '2299334-2-christmas-pillared-entryway');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3685-Fract04', 'Christmas Pillared Entryway', 'c8197a91-1c77-4c21-802b-3c4063259a30', '2299352-2-christmas-pillared-entryway');
insert into commerce (id, caption, ikid, rbid) values ('DSCN3685-TDetailed', 'Christmas Pillared Entryway', '377d4585-dbb6-4a35-ac65-88d50f2d135e', '2299370-2-christmas-pillared-entryway');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6803-04-Fract05', 'Christmas House Poster', '6cdb6833-b307-48c4-b655-fe7568f832ee', '2348638-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6803-04-Fract04', 'Christmas House Poster', '72c02038-146f-4f35-aec0-b15e572fcf01', '2348825-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6803-04-Fract03', 'Christmas House Poster', 'ea6cec1e-ac16-4572-b537-0dff7a4307df', '2349261-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6803-04-Fract02', 'Christmas House Poster', '12efdb1a-2292-4c52-8613-3a1b763ad1bd', '2349815-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6803-04-Fract01', 'Christmas House Poster', '7848483f-3fae-4a15-a734-96bb74b7eb3b', '2349969-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6795-96-Fract02', 'Christmas House Poster', '6c0b78e9-a3f3-4c46-990c-b4b42809e89a', '2350128-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6795-96-Fract01', 'Christmas House Poster', 'e2d83fa5-6309-4702-a8b3-143ba9198feb', '2351823-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6793-94-Fract02', 'Christmas House Poster', '917108cd-bc14-426b-b3e4-f7cba44eb67c', '2351980-2-christmas-house-poster');
insert into commerce (id, caption, ikid, rbid) values ('Poster-Rod-6793-94-Fract01', 'Christmas House Poster', 'c3a6f446-68aa-4a61-bb3a-caeed9431e31', '2352029-2-christmas-house-poster');
insert into commerce (id, caption, zazmp) values ('DSCN5928-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144344065517717548');
insert into commerce (id, caption, zazmp) values ('DSCN5967-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144822609072620769');
insert into commerce (id, caption, zazmp) values ('DSCN5929-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144206876161093369');
insert into commerce (id, caption, zazmp) values ('DSCN5972-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144760799395168040');
insert into commerce (id, caption, zazmp) values ('DSCN5915-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144958267896943737');
insert into commerce (id, caption, zazmp) values ('DSCN5931-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144364962629676915');
insert into commerce (id, caption, zazmp) values ('DSCN5971-S-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144768622978119921');
insert into commerce (id, caption, zazmp) values ('DSCN5934-Sharp', 'Trike Racer', 'http://www.zazzle.com/junior_dragster_mousepad-144993680832517725');
insert into commerce (id, caption, zazmp) values ('DSCN5966-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144517127823209808');
insert into commerce (id, caption, zazmp) values ('DSCN5973-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144704769394012200');
insert into commerce (id, caption, zazmp) values ('DSCN5924-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144863056679497032');
insert into commerce (id, caption, zazmp) values ('DSCN5920-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144506394063420883');
insert into commerce (id, caption, zazmp) values ('DSCN5926-Sharp', 'Junior Dragster', 'http://www.zazzle.com/junior_dragster_mousepad-144948811243072386');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7189', 'Huge Headlight', 'ca4275f9-b489-495d-a2f1-713e74697519', '2407364-2-huge-headlight');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7133', 'Serpent Corvette Burn-Out', '67bbd497-4eab-421d-be04-748eb6b8cb53', '2407461-2-serpent-corvette-burn-out');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7079', 'Pretty in Primer', '4eb65d5c-da4a-4c16-a98b-969214253af0', '2407559-2-pretty-in-primer');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7188', 'Light and Side', '3c4bc804-5cbd-43c5-ab63-395c3744e655', '2407689-2-light-and-side');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7134', 'Smoky Pick-Up', '2d58777c-51b7-4ea0-8c39-9396e021f24e', '2407815-2-smoky-pick-up');
insert into commerce (id, caption, ikid, rbid) values ('DSCN6171-Sharp', 'Backdraft Burn-Out', 'e700d7f5-c614-462a-9acd-5ab1939e41cb', '2524328-2-backdraft-burn-out');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7621-Sharp', 'Header Highlight', 'b770bf7e-4b23-4dd3-9f8f-d01c0ea37d66', '2733170-2-header-highlight-raw');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7621-Fract01', 'Header Highlight - Dark Sketch', 'e86430d0-012a-49e1-b754-e498d8bf85fb', '2732960-2-header-highlight-dark-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7621-Fract03', 'Header Highlight - High Contrast', '9c2e5d7f-0f77-4515-b493-481cfc56cd05', '2733040-2-header-highlight-high-contrast');
insert into commerce (id, caption, ikid, rbid) values ('DSCN7621-TPsychNR', 'Header Highlight - HDR', '47bb1a2b-de55-432f-acd8-d545f36b1c29', '2733102-2-header-highlight-hdr');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1365-PS-Fract01', 'Hammock in the Sunset - Sketch', '46c42024-9c85-4af9-9578-506888f56453', '2733685-2-hammock-in-the-sunset-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1258-PS-Fract02', 'Woman and Pier - Glow', '30b6f349-d09c-4bf5-8973-e522a1ae18a2', '2733908-2-woman-and-pier-glow');
insert into commerce (id, caption, ikid, rbid) values ('19950223K25-FFCrop-Sharp-Fract02', 'Sunset and Sailboat - Dark Glow', '212bc246-1cf2-49eb-a4d3-dba2494c4f06', '2895497-3-sunset-and-sailboat-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('19950223K25-FFCrop-Sharp-Fract03', 'Sunset and Sailboat - Charcoal Effect', '3434c22f-59f1-4a86-b472-b86179813686', '2895557-3-sunset-and-sailboat-charcoal-effect');
insert into commerce (id, caption, ikid, rbid) values ('R0144N11-None-FFCrop-Fract01', 'Soft White Spikes', 'a079f244-464f-4062-8950-8e111c7ec64b', '2912149-2-soft-white-spikes');
insert into commerce (id, caption, ikid, rbid) values ('R0140N02-FFCrop-Fract01', 'Bearded Iris - Sketch', '1db28ca0-786b-43d3-a4ca-5c27095b1b0d', '2912216-2-bearded-iris-sketch');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1999-PS-Fract01', 'Rose on Blue - Sketch', '9094a17a-d7af-4ef3-a17a-5df667dc0faf', '2912308-2-rose-on-blue-sketch');
insert into commerce (id, caption, ikid, rbid) values ('19950105K25-FFCrop-B-Fract02', 'Glowing Hibiscus', 'b445d67c-67a6-4776-971d-dd8809ffb70b', '2912352-2-glowing-hibiscus');
insert into commerce (id, caption, ikid, rbid) values ('19950176K64-FFCrop-Sharp-Fract01', 'Blue Flow', 'eec1e655-f0c9-4d59-b462-99061b9468a9', '2912442-2-blue-flow');
insert into commerce (id, caption, ikid, rbid) values ('19960094FV-Natural-FFCrop-Sharp-Fract01', 'South Rim Trees - Electric', '9379dcc8-ad01-43dc-8f60-8cacf6930e5d', '2912704-2-south-rim-trees-electric');
insert into commerce (id, caption, ikid, rbid) values ('19960248K64-FFCrop-Sharp-Fract02', 'Path to Palms - Dark Glow', '753b0885-4c89-4e96-987f-2595519387a0', '2912813-2-path-to-palms-dark-glow');
insert into commerce (id, caption, ikid, rbid) values ('BlueFlameOfCreation02', 'Purple Flame of Creation', 'f7d0ea22-598b-4361-8c09-64fcd0e89e35', '2912946-2-purple-flame-of-creation');
insert into commerce (id, caption, ikid, rbid) values ('TM-DSCN6873_4_5_6_7-S', 'Christmas Decorated Path - HDR', '7ff2f50b-c0eb-4e95-bbaf-5c17897f8114', '2913049-2-christmas-decorated-path-hdr');
insert into commerce (id, caption, ikid, rbid) values ('Poster-950-01', '950 - Race Progression', '56c90308-909d-4494-a29c-0dbdafee2d39', '2913155-2-race-progression');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1007-PS-Fract01', 'Las Vegas Hilton - Sketch', 'e3eefd0f-25f8-4d07-bf1f-643891677d5c', '2933735-2-las-vegas-hilton');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1046-PS-S-Fract01', 'Night Overpass - Glow', 'b00ff4c9-243d-4f6c-9d42-1e19a0cb3af6', '2933912-2-night-overpass-glow');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0948-PS-S', 'Corners and Curves', '639c3ead-5caf-425e-9866-2a0405e5cdf0', '2933983-2-corners-and-curves');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1259-PS', 'Restrained', '30c70eb8-bea0-43ae-9cbd-ab5fcf5a064b', '2935803-2-restrained');
insert into commerce (id, caption, ikid, rbid) values ('DSCN0102-PS', 'Power Sunset', 'eade2963-20eb-427a-9726-db013b525422', '2935958-2-power-sunset');
insert into commerce (id, caption, ikid, rbid) values ('R0108N33-FFCrop-Sharp', 'Dark Woods', '42b8b10e-1293-4434-96c6-2d5fe883a531', '3079624-2-dark-woods');
insert into commerce (id, caption, ikid, rbid) values ('19960112FV-FFCrop', 'Grand Canyon Detail', '4e7843fb-70b0-4ed3-bb7e-43741a16347c', '3079713-2-grand-canyon-detail');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1468-PS', 'Rock Striations', '5ab22be8-4b49-4040-94e8-19b0d88c279f', '3079762-2-rock-striations');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1324-PS', 'Shells and Pier', 'dcfd9a8c-610a-405a-b9cd-8fb67cec30e5', '3079801-2-shells-and-pier');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1046-PS', 'Night Overpass', '03615e34-a490-494f-9e03-67d93b865c4d', '3079948-2-night-overpass');
insert into commerce (id, caption, ikid, rbid) values ('DSCN1007-PS', 'Las Vegas Hilton', '56acf567-4c1e-4fd3-9f1e-1b627ef183d7', '3079975-2-las-vegas-hilton');
insert into commerce (id, caption, ikid, rbid) values ('R0322N17-FFCrop-Sharp', 'Calm In the Midst', '836b116b-e7bd-4686-9b2a-a96b5f7bfccf', '3080078-2-calm-in-the-midst');
insert into commerce (id, caption, ikid, rbid) values ('RT5N09-FFCrop', 'Deep Blue Seascape', '34886e93-c57c-45ea-afed-68ec5c191230', '3080145-3-deep-blue-seascape');
insert into commerce (id, caption, ikid, rbid) values ('19960109FV-FFCrop-Sharp', 'Chasms', 'feedd4c3-9345-4c66-892a-8d294448a88a', '3122185-2-chasms');
insert into commerce (id, caption, ikid, rbid) values ('19960095FV-FFCrop-Sharp', 'Canyon Sunrise', '6aadadb7-7009-4dc6-9a86-286b4705c13e', '3122231-2-canyon-sunrise');
insert into commerce (id, caption, ikid, rbid) values ('19960087K25-FFCrop-Sharp', 'Drink Deep from Still Water', 'be6f6fdc-9b28-4bc2-9e15-947b77b4cfe5', '3122274-2-drink-deep-from-still-water');

# caption only

insert into commerce (id, caption) values ('DSCN7598-Sharp', 'All Curves');
insert into commerce (id, caption) values ('DSCN7365-Sharp', 'Stowaway');
insert into commerce (id, caption) values ('DSCN7366-Sharp', 'Stowaway');
insert into commerce (id, caption) values ('DSCN7403-Sharp', 'Rice Smoke');
insert into commerce (id, caption) values ('DSCN7323-Sharp', 'The Flat Black Club');
insert into commerce (id, caption) values ('DSCN7119-Sharp', 'Pretty in Primer');
insert into commerce (id, caption) values ('DSCN7120-Sharp', 'Pretty in Primer');
insert into commerce (id, caption) values ('DSCN7023-Sharp', 'Peek-a-Boo');
insert into commerce (id, caption) values ('DSCN7186-Sharp', 'Long Wait for a Short Trip');
insert into commerce (id, caption) values ('DSCN7189-Sharp', 'Huge Headlight');
insert into commerce (id, caption) values ('DSCN7134-Sharp', 'Smoky Pick-up');
insert into commerce (id, caption) values ('DSCN6948-Sharp', 'Happy Racer');
insert into commerce (id, caption) values ('DSCN7095-Sharp', 'Seeing Double');
insert into commerce (id, caption) values ('DSCN7101-Sharp', 'Keeping You Up?');
insert into commerce (id, caption) values ('DSCN7113-Sharp', 'Symmetry');
insert into commerce (id, caption) values ('DSCN8363-Sharp', 'No choking the driver!!');
insert into commerce (id, caption) values ('DSCN8515-Sharp', 'Schizophrenic');
insert into commerce (id, caption) values ('DSCN8445-Sharp', 'Racer Grrl');
insert into commerce (id, caption) values ('DSCN8446-Sharp', 'Racer Grrlz');
insert into commerce (id, caption) values ('DSCN8239-S-Sharp', 'Purple Flame Paint - Electric');
insert into commerce (id, caption) values ('DSCN8239-S-Fract01', 'Purple Flame Paint - Sketch');
insert into commerce (id, caption) values ('DSCN8239-S-Fract03', 'Purple Flame Paint - Electric');
insert into commerce (id, caption) values ('DSCN8239-S-Fract04', 'Purple Flame Paint - Glow');
insert into commerce (id, caption) values ('DSCN8305-Sharp', 'Red and White Camaro - Sketch');
insert into commerce (id, caption) values ('DSCN8305-Fract01', 'Red and White Camaro - Sketch');
insert into commerce (id, caption) values ('DSCN8305-Fract02', 'Red and White Camaro - Glow');
insert into commerce (id, caption) values ('DSCN8305-Fract03', 'Red and White Camaro - Electric');
insert into commerce (id, caption) values ('DSCN8305-Fract04', 'Red and White Camaro - Charcoal');
insert into commerce (id, caption) values ('DSCN8305-Fract05', 'Red and White Camaro - Abstract');
insert into commerce (id, caption) values ('DSCN7809-Sharp', 'Red and Cream Truck Burnout - Sketch');
insert into commerce (id, caption) values ('DSCN7809-Fract01', 'Red and Cream Truck Burnout - Sketch');
insert into commerce (id, caption) values ('DSCN7809-Fract02', 'Red and Cream Truck Burnout - Glow');
insert into commerce (id, caption) values ('DSCN7809-Fract03', 'Red and Cream Truck Burnout - Abstract');
insert into commerce (id, caption) values ('DSCN7770-Sharp', 'Green Light Wheels Up - Sketch');
insert into commerce (id, caption) values ('DSCN7770-Fract01', 'Green Light Wheels Up - Sketch');
insert into commerce (id, caption) values ('DSCN7770-Fract02', 'Green Light Wheels Up - Glow');
insert into commerce (id, caption) values ('DSCN7770-Fract03', 'Green Light Wheels Up - Electric');
insert into commerce (id, caption) values ('DSCN7770-TPsychNR', 'Green Light Wheels Up - Pseudo-HDR');
insert into commerce (id, caption) values ('DSCN7752-Sharp', 'Powered by Black Cat');
insert into commerce (id, caption) values ('DSCN7752-Fract01', 'Powered by Black Cat - Sketch');
insert into commerce (id, caption) values ('DSCN7752-Fract02', 'Powered by Black Cat - Glow');
insert into commerce (id, caption) values ('DSCN7752-Fract03', 'Powered by Black Cat - Electric');
insert into commerce (id, caption) values ('DSCN7621-Fract02', 'Header Highlight - Glow');
insert into commerce (id, caption) values ('DSCN7621-Fract04', 'Header Highlight - Dark Glow');
insert into commerce (id, caption) values ('DSCN7621-TDramatic', 'Header Highlight - Dramatic');
insert into commerce (id, caption, rbid) values ('DSC6020', 'In a cloud of her own smoke', '5971295-1-in-a-cloud-of-her-own-smoke');
insert into commerce (id, zazcard) values ('L-HDR-9902-9908-ZazCard', 'http://www.zazzle.com/card_love_church_interior-137570902699434620');
insert into commerce (id, zazcard) values ('J-HDR-9902-9908-ZazCard', 'http://www.zazzle.com/card_joy_church_interior-137100697338186469');
insert into commerce (id, zazcard) values ('P-HDR-9902-9908-ZazCard', 'http://www.zazzle.com/card_peace_church_interior-137620559316239041');
insert into commerce (id, zazcard) values ('H-HDR-9902-9908-ZazCard', 'http://www.zazzle.com/card_hope_church_interior-137406882763726747');
insert into commerce (id, zazps) values ('HDR-9902-9908-ZazPostL-ZazPostL', '');
insert into commerce (id, zazmp) values ('SeeLove-19950223K25-CCrop-Sharp-Fract02-Mousepad', 'http://www.zazzle.com/mousepad_see_love-144228506049694803');
insert into commerce (id, zazmp) values ('ForeverWarm-DSCN1365-PS-CCrop-Mousepad', 'http://www.zazzle.com/mousepad_forever_warm-144183561908910765');
insert into commerce (id, zazmp) values ('MyPromise-DSCN4574-DSat-CCrop-Light-Mousepad', 'http://www.zazzle.com/mousepad_my_promise_of_love-144897483853637126');
insert into commerce (id, zazmp) values ('A-DSCN1999-PS-Fract02-Mousepad', 'http://www.zazzle.com/mousepad_i_am_strong-144719958179021511');
insert into commerce (id, zazmp) values ('A-19950105K25-FFCrop-B-Fract01-Mousepad', 'http://www.zazzle.com/mousepad_i_am_cherished-144235078985660345');
insert into commerce (id, zazcard) values ('BeautyGlows02-Dark-DSCN1940-PS-Fract02-CCrop-NoteC', 'http://www.zazzle.com/card_love_beauty_glows-137066229147435643');
insert into commerce (id, zazcard) values ('MyPromise-DSCN4574-DSat-CCrop-Light-NoteCard', 'http://www.zazzle.com/card_love_my_promise-137229510875689103');
insert into commerce (id, zazcard) values ('MyPromise-19940070KL100-CCrop-NoteCard', 'http://www.zazzle.com/card_love_my_promise-137830191883650843');
insert into commerce (id, zazcard) values ('MyPartner-DSCN2031-PS-Fract01-CCrop-DSat-NoteCard', 'http://www.zazzle.com/card_love_my_partner-137680152709812528');
insert into commerce (id, zazcard) values ('A-19950105K25-FFCrop-B-Fract01-NoteCard', 'http://www.zazzle.com/card_love_cherished-137701322259772037');
insert into commerce (id, zazcard) values ('SeeLove-19950223K25-CCrop-Sharp-Fract02-NoteCard', 'http://www.zazzle.com/card_love_see_love-137336345940001097');
insert into commerce (id, zazcard) values ('ForeverWarm-DSCN1365-PS-CCrop-NoteCard', 'http://www.zazzle.com/card_love_forever_warm-137329859651771507');
insert into commerce (id, zazcard) values ('A-DSCN1999-PS-Fract02-NoteCard', 'http://www.zazzle.com/card_love_strength-137997165440519661');
insert into commerce (id, zazmug) values ('DSCN0745-PS-Fract01-ZazMugHalf', 'http://www.zazzle.com/mug_christmas_reindeer-168812667609584913');
insert into commerce (id, zazmug) values ('DSCN3697-Fract01-ZazMugHalf', 'http://www.zazzle.com/mug_christmas_tree_and_presents-168128902434506124');
insert into commerce (id, zazmug) values ('DSCN3697-Fract05-ZazMugHalf', 'http://www.zazzle.com/mug_christmas_tree_and_presents-168318248411217077');
insert into commerce (id, zazmug) values ('DSCN3021-PS-Fract01-ZazMugHalf', 'http://www.zazzle.com/mug_christmas_large_lights-168529800714046466');
insert into commerce (id, zazmug) values ('DSCN3055-PS-Fract01-ZazMugHalf', 'http://www.zazzle.com/mug_christmas_blue_light-168875168313541396');
insert into commerce (id, zazmug) values ('DSCN3017-PS-Fract01-ZazMugFull', 'http://www.zazzle.com/mug_christmas_large_lights-168814978005539084');
insert into commerce (id, zazcard) values ('H-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_hope_presents-137446029296291938');
insert into commerce (id, zazcard) values ('HG-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_holidays_glow_presents-137712365892334044');
insert into commerce (id, zazcard) values ('HH-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_happy_holidays_presents-137894391659719620');
insert into commerce (id, zazcard) values ('HS-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_holidays_shine_presents-137531682017786539');
insert into commerce (id, zazcard) values ('J-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_joy_presents-137330015101979235');
insert into commerce (id, zazcard) values ('L-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_love_presents-137847564864093991 ');
insert into commerce (id, zazcard) values ('MC-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_merry_christmas_presents-137318706879328542');
insert into commerce (id, zazcard) values ('P-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_peace_presents-137878734734225254');
insert into commerce (id, zazcard) values ('SG-DSCN3697-Fract01-ZazCard', 'http://www.zazzle.com/card_christmas_seasons_greetings_presents-137094478808473311');
insert into commerce (id, rbid) values ('H-20040502XFV100-S-FFCrop-Fract01-RBCard', '5959911-1-card-christmas-hope-house');
insert into commerce (id, rbid) values ('H-DSCN3017-PS-Fract02-RBCard', '5959926-1-card-christmas-hope-glowing-lights');
insert into commerce (id, rbid) values ('H-DSCN3025-PS-Fract02-RBCard', '5959945-1-card-christmas-hope-glowing-lights');
insert into commerce (id, rbid) values ('H-DSCN3055-PS-Fract01-RBCard', '5959956-1-card-christmas-hope-glowing-light');
insert into commerce (id, caption) values ('DSCN3647', 'Ruffles Portrait');
insert into commerce (id, caption) values ('DSCN3646', 'Starfire in the Shadows');
insert into commerce (id, caption) values ('DSCN3632', 'Deep in Thought');
insert into commerce (id, caption) values ('DSCN3629', 'Goof');
insert into commerce (id, caption) values ('DSCN3086', 'Rapt Attention');
insert into commerce (id, caption) values ('DSCN3086-Crop01', 'Rapt Attention');
insert into commerce (id, caption) values ('DSCN3061-Crop01', 'Not getting up - you can not make me!!');
insert into commerce (id, caption) values ('DSCN9519', 'She will stand still forever as long as yer scratching those ears');
insert into commerce (id, caption) values ('DSCN9510', 'Proud Skye');
insert into commerce (id, caption) values ('DSCN5046', 'Helium speaking is passed to a new generation');
insert into commerce (id, caption) values ('DSCN5025', 'Snake Charmer');
insert into commerce (id, caption) values ('DSCN0574-PS', 'Desert Power Delivery System<br>Gotta hang the lines where ya can');
insert into commerce (id, caption) values ('DSC2431', 'Born of Smoke');
insert into commerce (id, caption) values ('DSC2668', 'Spotlight on Cookies');
insert into commerce (id, caption) values ('DSC2491', 'Jump Start');
insert into commerce (id, caption) values ('DSC6498', 'There really IS a car in that cloud of smoke :-)');
insert into commerce (id, caption) values ('DSC6744', 'All eyes down-track');
insert into commerce (id, caption) values ('DSC6561', 'The Shadow Knows...');
insert into commerce (id, caption) values ('DSC7828', 'Hey Shelby!!  Your dad is a ham!!');
insert into commerce (id, caption) values ('DSC7974', 'Sometimes they notice me');
insert into commerce (id, caption) values ('DSCN0043', 'Interrogate the Bear!!!');
insert into commerce (id, caption) values ('DSCN0176', 'Connection');

insert into commerce (id, caption) values ('DSC019025', 'Munch, munch, munch');
insert into commerce (id, caption) values ('HDR-DSC019025', 'Munch, munch, munch in HDR');
insert into commerce (id, caption) values ('DSC019031', 'Double munch, munch, munch');
insert into commerce (id, caption) values ('HDR-DSC019031', 'Double munch, munch, munch in HDR');
insert into commerce (id, caption) values ('DSCN0114-PS', 'I know you have a carrot');
insert into commerce (id, caption) values ('DSCN3628', 'Its hard to take a picture of a horse when she comes up behind you to check out the tripod...');
insert into commerce (id, caption) values ('DSCN3633', 'Seths horse - Ruffles Review');
insert into commerce (id, caption) values ('DSCN3635', 'Davids horse Bingo and Ruffles - class clowns');
insert into commerce (id, caption) values ('DSCN3641', 'Wess horse Dusty - troublemaker');
insert into commerce (id, caption) values ('DSCN3644', 'Darleens little one - Starfire');
insert into commerce (id, caption) values ('DSCN3652', 'Comin in for dinner');
insert into commerce (id, caption) values ('DSCN3655', 'Wess Mustang - Drag');
insert into commerce (id, caption) values ('DSCN3662', 'Peek-A-Boo');
insert into commerce (id, caption) values ('DSCN3670', 'A horse train');
insert into commerce (id, caption) values ('DSCN3674', 'Wess mini - Bonanza');
insert into commerce (id, caption) values ('20070054FV-Crop02-8x10-Sharp', 'In Perfect Sync');
insert into commerce (id, caption) values ('DSCN0193-PS', 'Beware of Dogs in Hay');
insert into commerce (id, caption) values ('19960059K64-FFCrop-Sharp', 'Dogfight');
insert into commerce (id, caption) values ('19960061K64-FFCrop-Sharp', 'Fold in Half Sneak Attack!!');
insert into commerce (id, caption) values ('19960126K64-FFCrop-Sharp', 'Impasse');
insert into commerce (id, caption) values ('DSCN3084', 'Prancing');
insert into commerce (id, caption) values ('DSC021712', 'Last Minute Advice');
insert into commerce (id, caption) values ('DSC021858', 'I saw that look and knew what was coming...');
insert into commerce (id, caption) values ('DSC021859', 'That was supposed to be on my nose but I caught it with my mouth...');
insert into commerce (id, caption) values ('DSC021860', 'I started off nice...');
insert into commerce (id, caption) values ('DSC021862', 'But then - it was on...');
insert into commerce (id, caption) values ('DSC021866', 'Yes - we are still 12 at heart :-)');
insert into commerce (id, caption) values ('DSC021870', 'We got cake-faced at our recpetion.  But it was okay - it was a home wedding so we did not have to drive anywhere!!');
insert into commerce (id, caption) values ('DSC021790', 'Doug loves his grandkids');
insert into commerce (id, caption) values ('DSC021770', 'The Grandkids');
insert into commerce (id, caption) values ('DSC021646', 'Cake by Ellen and friend - and it was YUMMY!!');
insert into commerce (id, caption) values ('DSC021651', 'Kimberly and Trina');
insert into commerce (id, caption) values ('DSC021653', 'Greg and Doug wrapping the cooked roasts');
insert into commerce (id, caption) values ('DSC021655', 'Bill (married to Brenda)');
insert into commerce (id, caption) values ('DSC021659', 'Steve Snipes');
insert into commerce (id, caption) values ('DSC021663-S', 'Daisy and Timothy');
insert into commerce (id, caption) values ('DSC021671', 'Brenda - Thanks for marrying us :-)');
insert into commerce (id, caption) values ('DSC021673', 'Brenda, Bill, Gabby, Connor');
insert into commerce (id, caption) values ('DSC021675', 'Connor, Jana, Gabby, Brenda');
insert into commerce (id, caption) values ('DSC021681', 'Connie and Mark (mom and son)');
insert into commerce (id, caption) values ('DSC021685', 'Biological siblings - James, Trina, Bud, Jana, Steve, Brenda');
insert into commerce (id, caption) values ('DSC021689', 'Carol and Flint');
insert into commerce (id, caption) values ('DSC021693', 'Sisters');
insert into commerce (id, caption) values ('DSC021696', 'Joanie, Jesse, and Anthony Rogers, Sophia, Tiffany');
insert into commerce (id, caption) values ('DSC021779-S', '<b>This</b> does not happen often :-)');
insert into commerce (id, caption) values ('Poster-SVHS-01', '1970 Chevy Malibu - Bobby Glover');
insert into commerce (id, caption) values ('Poster-SVHS-02', '1957 Chevy - Willie McCoy');
insert into commerce (id, caption) values ('Poster-SVHS-03', '1957 Chevy - Willie McCoy');
insert into commerce (id, caption) values ('Poster-SVHS-04', '1972 Olds 442 - Frank Revson');
insert into commerce (id, caption) values ('Poster-SVHS-05', '1968 Chevy SS 396 - Barry Taylor');
insert into commerce (id, caption) values ('Poster-SVHS-06', '1924 Ford Roadmaster Coupe Model T - Dan Yoest');
insert into commerce (id, caption) values ('Poster-SVHS-07', '1930 Ford Model A - Charles Marshall');
insert into commerce (id, caption) values ('Poster-SVHS-08', '1940 Ford Deluxe Modified - Ken Wicker');
insert into commerce (id, caption) values ('Poster-SVHS-09', '1929 Ford - John Retz');
insert into commerce (id, caption) values ('Poster-SVHS-10', '1964 Ford Fairlane - Mark Clark');
insert into commerce (id, caption) values ('Poster-SVHS-11', '1986 GMC Caballero - Mike Thomas');
insert into commerce (id, caption) values ('Poster-SCPF-2013-01', 'Dirt Racers at the 2013 SC Poultry Festival');
insert into commerce (id, caption) values ('Poster-SCPF-2013-02', 'Chevy Bel Air at the 2013 SC Poultry Festival');
insert into commerce (id, caption) values ('Poster-SCPF-2013-03', '1934 Ford - Ricky Summer');
insert into commerce (id, caption) values ('D3200DSC004456', 'The chaos starts orderly enough...');
insert into commerce (id, caption) values ('D3200DSC004470', 'There\'s a dog in there somewhere');
insert into commerce (id, caption) values ('D3200DSC004545', 'The calm in the storm');
insert into commerce (id, caption) values ('D3200DSC004573', 'Crystal will not like this one...');
insert into commerce (id, caption) values ('D3200DSC004574', '...But will like this one');
insert into commerce (id, caption) values ('D3200DSC004578', 'Captivated by mom\'s new toy');

insert into commerce (id, caption) values ('DSC0731-S', 'Glow of Faith');
insert into commerce (id, caption) values ('HDR-DSC0538-1', 'The White Church');
insert into commerce (id, caption) values ('HDR-DSC0193', 'The Guardian');
insert into commerce (id, caption) values ('DSC022772', 'Synchronized Cheesecake');
insert into commerce (id, caption) values ('DSC022823', 'What stinks, Lucy?');
insert into commerce (id, caption) values ('DSC022871', 'The peanut gallery is bored');
insert into commerce (id, caption) values ('DSC022898', 'Counting...');
insert into commerce (id, caption) values ('DSC022900', 'ummmm...');
insert into commerce (id, caption) values ('DSC022948', 'Reindeer Games');
insert into commerce (id, caption) values ('HDR-EF-DSC023212-Fract01+11', 'Frankenputer');
insert into commerce (id, caption) values ('HDR-DSC023212-Fract04+11', 'Overclocked');
insert into commerce (id, caption) values ('DSC023212-Fract05', 'Electrified Circuits');

#insert into commerce (id, caption) values ('




#  create views

create view racepics.vChevy as
  select * from vehicle where make = 'Chevy';

create view racepics.vDodge as
  select * from vehicle where make = 'Dodge';

create view racepics.vFord as
  select * from vehicle where make = 'Ford';

create view racepics.vHarley as
  select * from vehicle where make = 'Harley-Davidson';

create view racepics.vOlds as
  select * from vehicle where make = 'Olds';

create view racepics.vPlymouth as
  select * from vehicle where make = 'Plymouth';

create view racepics.vPontiac as
  select * from vehicle where make = 'Pontiac';

create view racepics.vTriumph as
  select * from vehicle where make = 'Triumph';

create view racepics.vAMC as
  select * from vehicle where make = 'AMC';

create view racepics.vImagekind as
  select id, ikid from commerce where ikid != 'NULL';

create view racepics.vRedBubble as
  select id, rbid from commerce where rbid != 'NULL';

create view racepics.vZenFolio as
  select id, zfgal, zfid from commerce where zfid != 'NULL';

create view racepics.vCafePress as
  select id, cfmp, cfcl, cfbs from commerce where 
    cfbs != 'NULL' or
    cfcl != 'NULL' or
    cfmp != 'NULL';

create view racepics.vZazzle as
  select id, zazmp, zazps, zazpost from commerce where
    zazmp   != 'NULL' or
    zazps   != 'NULL' or
    zazpost != 'NULL';

create view racepics.vCaption as
  select id, caption from commerce where caption != 'NULL';

#
#  zazzle posters are history
#

# update commerce set zazpost = 'NULL' where zazpost != 'NULL';

#
#  imagekind is history
#

update commerce set ikid = 'NULL' where ikid != 'NULL';

#
#  cafepress is history
#

update commerce set cfbs = 'NULL' where cfbs != 'NULL';
update commerce set cfcl = 'NULL' where cfcl != 'NULL';
update commerce set cfmp = 'NULL' where cfmp != 'NULL';

#
#  exposure info for the favorites gallery
#

insert into expinfo (id, expose) values ('0368199-R1-077-37', 'All alone for a quarter mile<br>Nikon N65<br>Andy Dawson at SpeedWorld Raceway Park');
insert into expinfo (id, expose) values ('0368199-R4-071-34', 'Nose Up<br>Nikon N65<br>SpeedWorld Raceway Park');
insert into expinfo (id, expose) values ('0368199-R5-063-30', 'Speedy Girl<br>Nikon N65<br>SpeedWorld Raceway Park');
insert into expinfo (id, expose) values ('19940024FV-FFCrop', 'Extreme macro of a backlit turn signal lens<br>Nikon FM2, 28mm on extension tubes<br>Fuji Velvia 50');
insert into expinfo (id, expose) values ('19940070KL100-Crop01', 'Macro of Yellow Begonia - indoor plant<br>Nikon FM2, 50mm on extension tubes<br>Kodak Lumiere 100');
insert into expinfo (id, expose) values ('19940100FV-FFCrop', 'Read/Write Head on Disk Platter<br>Nikon FM2, 50mm on extension tubes<br>Fuji Velvia 50');
insert into expinfo (id, expose) values ('19940144FV-FFCrop', 'Purple-Leaf Sandcherry with Bud<br>Nikon FM2, 50mm on extension tubes<br>Fuji Velvia 50');
insert into expinfo (id, expose) values ('19940461KL100-FFCrop', 'Turntable quartz prism with sync light<br>Nikon FM2, 50mm on extension tubes<br>Kodak Lumiere 100');
insert into expinfo (id, expose) values ('19950102FV-FFCrop', 'Bud and Bloom<br>Nikon FM2, 50mm on extension tubes<br>Fuji Velvia 50');
insert into expinfo (id, expose) values ('19950223K25-FFCrop', 'Sunset over Redondo Beach, California, USA<br>Nikon FM2, 28mm<br>Kodachrome 25');
insert into expinfo (id, expose) values ('19960112FV-FFCrop', 'Grand Canyon, South Rim, Arizona<br>Nikon FM2, 28mm<br>Fuji Velvia 50');
insert into expinfo (id, expose) values ('19960117K64-FFCrop', 'Grand Canyon, South Rim, Arizona<br>Nikon FM2, 200 mm<br>Kodachrome 64');

#
#  base keyword data for speedworld images
#

#insert into keywords (id) select distinct id from image where venue = 'SW';

#update keywords, image set words = 'dragstrip track drag race racing speedworld motor sport car automobile phoenix surprise whittman az arizona' where keywords.id = image.id and venue = 'SW';

insert into
  keywords (id)
    select distinct id from image
;

update 
  keywords 
set 
  words = 'dragstrip track drag race racing speedworld motor sport car automobile phoenix surprise whittman az arizona' 
where 
  keywords.id in 
  ( 
  select 
    id 
  from 
    image 
  where 
    eventid in 
    (
    select pkey from event where venue = 'SW' 
    )
  )
;


EOF
