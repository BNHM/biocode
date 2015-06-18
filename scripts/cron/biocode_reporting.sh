# drop and create biocode_reporting 
mysqladmin -u bnhm -pfrogchorus -f drop biocode_reporting
mysqladmin -u bnhm -pfrogchorus create biocode_reporting

# send biocode database over
mysqldump -u bnhm -pfrogchorus --no-create-db biocode | mysql -u bnhm -pfrogchorus biocode_reporting 

# operations on the tissue_view table
mysql -u bnhm -pfrogchorus biocode_reporting -e "create table biocode_tissue_join as select * from biocode_tissue_view;"
mysql -u bnhm -pfrogchorus biocode_reporting -e "create index btjx on biocode_tissue_join (tissue_id);"

# send the LIMS database over
mysqldump -u bnhm -pfrogchorus --no-create-db labbench assembly cycle cyclesequencing cyclesequencing_cocktail cyclesequencing_thermocycle databaseversion extraction folder gelimages pcr pcr_cocktail pcr_thermocycle plate state thermocycle workflow  | mysql -u bnhm -pfrogchorus biocode_reporting 

# send the image.img table over
mysqldump -u bnhm -pfrogchorus --no-create-db image img| mysql -u bnhm -pfrogchorus biocode_reporting 

# build accumulations tables
./biocode_report_accumulations.p
