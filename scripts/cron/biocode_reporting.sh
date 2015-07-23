#!/bin/bash
user=$(grep g_db_fulluser /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')
pass=$(grep g_db_fullpass /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')
location=$(grep g_db_location /usr/local/web/biocode/cgi/biocode_settings | awk -F\" '{print $(NF-1)}')

# drop and create biocode_reporting 
mysqladmin -u $user -p$pass -h $location -f drop biocode_reporting
mysqladmin -u $user -p$pass -h $location create biocode_reporting

# send biocode database over
mysqldump -u $user -p$pass -h $location --no-create-db biocode | mysql -u $user -p$pass -h $location biocode_reporting 
echo "stop2";

# operations on the tissue_view table
mysql -u $user -p$pass -h $location biocode_reporting -e "create table biocode_tissue_join as select * from biocode_tissue_view;"
mysql -u $user -p$pass -h $location biocode_reporting -e "create index btjx on biocode_tissue_join (tissue_id);"

# send the LIMS database over
mysqldump -u $user  -p$pass -h $location --no-create-db labbench assembly cycle cyclesequencing cyclesequencing_cocktail cyclesequencing_thermocycle databaseversion extraction folder gelimages pcr pcr_cocktail pcr_thermocycle plate state thermocycle workflow  | mysql -u $user -p$pass -h $location biocode_reporting 

# send the image.img table over
mysqldump -u $user -p$pass -h $location --no-create-db image img | mysql -u $user -p$pass -h $location biocode_reporting 

# build accumulations tables
./biocode_report_accumulations.p
