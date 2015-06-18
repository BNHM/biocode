
Installation of Biocode FMA:

*********************************************************************
0. First Things
*********************************************************************
Install System
System Preferences -> Sharing -> Computer Name= (biocode)
Pop in your install DVD and you'll see a folder called "Xcode Tools". Click on that, install it, and you will now have make, cc and everything else you need to compile code below

Sections 1-4 deal with the first time installation of the FMA
Sections 5 and up deal with populating data & scripts

*********************************************************************
* 1. SVN:
*********************************************************************
Subversion should be installed by Mac OS
Here is how to checkout SVN from darwin:

mkdir /Users/biocode/Website/
cd /Users/biocode/Website/
svn co svn+ssh://darwin.berkeley.edu/usr/local/svn/biocode

svn co svn+ssh://biocode@darwin.berkeley.edu/usr/local/svn/biocode

# OLD METHOD using Apache/webdav
#svn co http://darwin.berkeley.edu/svn/biocode/

# some useful commands:
svn commit -m "some commit after changes"
svn update (update after changes)
svn delete (delete some file or directory)

*********************************************************************
* 2. HTTP Configuration.
*********************************************************************
Apache should be pre-configured on Mac OS

a. Add to /etc/httpd/httpd.conf (adjust for your environment)

<VirtualHost *:80>
    ScriptAlias /cgi-bin/ /Users/biocode/Website/biocode/cgi/
    ScriptAlias /cgi/ /Users/biocode/Website/biocode/cgi/
    ServerAdmin bscit@berkeley.edu
    DocumentRoot /Users/biocode/Website/biocode/web
    ErrorLog "/private/var/log/httpd/biocode-error_log"
    CustomLog "/private/var/log/httpd/biocode-access_log" common
</VirtualHost>

<Directory "/Users/biocode/Website/biocode/cgi/">
        AllowOverride None
        Options None
        Order allow,deny
        Allow from all
</Directory>

<Directory  "/Users/biocode/Website/biocode/web">
    Options +MultiViews +Indexes +FollowSymLinks +Includes
    Order allow,deny
    Allow from all
</Directory>

b. Add the following to where you see AddType's declared:
 AddType application/vnd.google-earth.kml+xml kml
b. Turn on SSI per instructions at: http://www.macdevcenter.com/lpt/a/3392
 	# To use server-parsed HTML files
 	AddType text/html .shtml
    AddHandler server-parsed .shtml .html .txt

c. Switch on/off web server by (restarting http server is necessary after changes)
System Preferences -> Sharing -> Services -> Personal Web Sharing "On/Off"

*********************************************************************
* 2. Directories
*********************************************************************
# NOTE: may want set this up as cronjob to copy files over periodically
sudo mkdir /data3
sudo mkdir /data3/biocode
sudo mkdir /data3/biocode/web
sudo chown -R biocode /data3/biocode
cd /data3/biocode/web
scp -r biocode@darwin.berkeley.edu:///data3/biocode/web/generated generated
scp -r biocode@darwin.berkeley.edu:///data3/biocode/web/include include 
scp -r biocode@darwin.berkeley.edu:///data3/biocode/web/select_lists select_lists

mkdir /data3/biocode/web/biocode_data/pictures
mkdir /data3/biocode/web/biocode_data/extracts
sudo chmod -R 777 /data3/biocode/web/biocode_data/extracts
sudo chmod -R 777 /data3/biocode/web/select_lists
(copy in any picture libraries you have here --- this is something that needs to be developed)


*********************************************************************
* 3. Perl configuration
*********************************************************************
a. Perl comes installed on Mac by Default

b. Install DBI from CPAN (i install in /usr/local/src and then follow instructions in README)

c. Install DBD::mysql from CPAN (i install in /usr/local/src and then follow instructions in README)
	NOTE BEFORE COMPILING DBD: Before the mysql_config section of the Makefile.PL file insert this line:
	$opt->{'mysql_config'}='/usr/local/mysql/bin/mysql_config';
	There is probably a better way to do this but haven't figured this out

d. Packages needed for photo uploading
    http://search.cpan.org/~gunnar/CGI-UploadEasy-0.11/
    http://search.cpan.org/dist/File-Spec/

# OPTIONAL Perl Packages:
--------------------------------
e. ????http://search.cpan.org/~jmcnamara/OLE-Storage_Lite-0.16/

f. ????http://search.cpan.org/~msergeant/DBD-SQLite-0.31/lib/DBD/SQLite.pm
  perl Makefile.PL
  make
  make install

	run: scripts/fma/create_table.pl
	% chmod 777 pictures/data.dbl

#f. # ??? needed ???http://search.cpan.org/~pmqs/DB_File-1.817/DB_File.pm#Interface_to_Berkeley_DB  

g. http://search.cpan.org/~szabgab/Spreadsheet-ParseExcel-0.32/

*********************************************************************
* 4. ImageMagick
*********************************************************************
a. Install the following libraries into /usr/local/src (a very helpful guide to installing necessary libraries is at: http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=10442&start=0&st=0&sk=t&sd=a&hilit=Mac+OS+Tiger)

    JPEG:
    http://www.ijg.org/files/jpegsrc.v6b.tar.gz
    PNG:
    http://prdownloads.sourceforge.net/libp ... z?download
    TIFF:
    http://dl.maptools.org/dl/libtiff/

    I recommend installing them in the above order (although it may not matter). Then install IM.

    For these libraries and to install IM, the notes on the Install from Source page seems to work (except for the JPEG library). The normal install is:

    cd to each library directory
    ./configure (for an IM Q16 default build)
    make
    sudo make install (rather than make install)


    For the JPEG library, the last step does not work (and this is what took us most of the day to track down). It installs files in /usr/local/bin, but does not install the needed files in /usr/local/include or /usr/local/lib. To get those files properly installed, change the sudo make install to sudo make install-lib. You can find notes about this buried in the Install.doc file that is in the jpeg-6b folder.

b. Download from source and install
    sudo su
    ./configure
    make
    make install
    cd PerlMagick/
    perl Makefile.PL
    make
    make install

*********************************************************************
* 5. Mysql
*********************************************************************
a. Get Mac OS Package Installation for Mysql from http://www.mysql.com/
	get package format for Mac OS X version

b. Install "Mysql Package" AND "Mysql Startup Package"

c. Startup mysql automatically: 
	http://dev.mysql.com/doc/refman/5.0/en/mac-os-x-installation.html

d. Instructions for temporary startup of mysql:
# NOTE: This should not be necessary if you followed instructions above and installed the Mysql Startup Item
	shell> sudo /usr/local/mysql/bin/mysqld_safe &
	(Enter your password, if necessary)
	(Press Control-Z)
	shell> bg
	(Press Control-D or enter "exit" to exit the shell)

e. Setting up mysql
	sudo su
	/usr/local/mysql/bin/mysql

	CREATE DATABASE biocode;
	CREATE USER readonly IDENTIFIED BY 'readonly'; 
	USE biocode
	GRANT SELECT ON *.* TO 'readonly'@'localhost' IDENTIFIED BY 'readonly' WITH GRANT OPTION;

	CREATE DATABASE fma;
	CREATE USER local_tech IDENTIFIED BY 'hogwash'; 
	USE biocode;
	GRANT ALL PRIVILEGES on *.* TO  'local_tech'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;
	GRANT SELECT on *.* TO  'username'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;
	USE fma;
	GRANT ALL PRIVILEGES on *.* TO  'localusername'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;
	GRANT ALL PRIVILEGES on *.* TO  'username'@'localhost' IDENTIFIED BY 'pass' WITH GRANT OPTION;

	Testing, as normal user: 
	mysql -u readonly -preadonly biocode

*********************************************************************
* 10. Populating data into mysql database
*********************************************************************
	# Dumping the Biocode Server data for the read-only biocode database
	[DARWIN]
	mysqldump -u bnhm -pfrogchorus --add-drop-table biocode biocode biocode_collecting_event biocode_collecting_event_deleted biocode_container biocode_deleted biocode_people biocode_preservative biocode_relaxant biocode_species biocode_tissue biocode_tissue_deleted biocode_tissuetype country county state > biocode_out.sql
	[LOCAL] 
	mysql -u local_tech -phogwash biocode < biocode_out.sql

	# Creating the table templates for the FMA database.
	mysql -u local_tech -phogwash fma < createfma.sql
              # this causes a syntax error with mysql on the G4
	
	# How to setup tables for an individual expedition (make sure to use LIKE, instead of AS below to preserve indexes)
	# Examples ONLY!!
	CREATE TABLE fma.minv_biocode LIKE fma.biocode;
	CREATE TABLE fma.minv_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.minv_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.minv_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.minv_batch LIKE fma.batch;

	CREATE TABLE fma.tinv_biocode LIKE fma.biocode;
	CREATE TABLE fma.tinv_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.tinv_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.tinv_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.tinv_batch LIKE fma.batch;

	CREATE TABLE fma.vert_biocode LIKE fma.biocode;
	CREATE TABLE fma.vert_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.vert_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.vert_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.vert_batch LIKE fma.batch;
	
	CREATE TABLE fma.equip1_biocode LIKE fma.biocode;
	CREATE TABLE fma.equip1_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.equip1_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.equip1_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.equip1_batch LIKE fma.batch;
	
	CREATE TABLE fma.plants_biocode LIKE fma.biocode;
	CREATE TABLE fma.plants_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.plants_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.plants_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.plants_batch LIKE fma.batch;

	CREATE TABLE fma.test_biocode LIKE fma.biocode;
	CREATE TABLE fma.test_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.test_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.test_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.test_batch LIKE fma.batch;

	CREATE TABLE fma.algal_biocode LIKE fma.biocode;
	CREATE TABLE fma.algal_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.algal_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.algal_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.algal_batch LIKE fma.batch;

	CREATE TABLE fma.izminv_biocode LIKE fma.biocode;
	CREATE TABLE fma.izminv_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.izminv_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.izminv_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.izminv_batch LIKE fma.batch;

	CREATE TABLE fma.fungi_biocode LIKE fma.biocode;
	CREATE TABLE fma.fungi_biocode_tissue LIKE fma.biocode_tissue;
	CREATE TABLE fma.fungi_biocode_collecting_event LIKE fma.biocode_collecting_event;
	CREATE TABLE fma.fungi_photomatch LIKE fma.photomatch;
	CREATE TABLE fma.fungi_batch LIKE fma.batch;
*********************************************************************
* 6. Create Temporary Directory for writing:
*********************************************************************
[DARWIN]
	cd /data1/tmp
	ls -1  (NOTE: use the listing from these files to create the temporary directories needed below)

[LOCAL]
	mkdir /data1/tmp
	sudo mkdir /data1
	sudo mkdir /data1/tmp
	cd /data1/tmp
	[write a shell script to create all the needed tmp directories]
	sudo chmod -R 777 /data1/tmp 

	TODO: create cronjob to clean out this directory



*********************************************************************
* Other useful commands
*********************************************************************
# Command to transfer big files to remote server that allows to proceed in batches (in case of failure, you
# can restart and pickup where you left off)
nohup rsync --partial --progress --rsh=ssh 080911_Nitta.tar.gz darwin.berkeley.edu:/home/biocode/nitta2.tar.gz &

*********************************************************************
* Protocols for Data Manaagement
*********************************************************************
Safety net: first put them into the deleted table.

insert into biocode_tissue_deleted select * from biocode_tissue where batch_id = "2008-06-05_13:39:40";
delete from biocode_tissue where batch_id = "2008-06-05_13:39:40";


BUGS:
-User adds photo on "localhost" cannot revisit declaration on some other
host... they must all be localhost.  For now, am runnign this on darwin but
must revisit this when i make local versions.


