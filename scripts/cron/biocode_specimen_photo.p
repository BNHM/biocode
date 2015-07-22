#!/usr/bin/perl

# no longer used -- have to write new one? (if remove photos)
# right now, Dec 5, 2006, pic field is automatically updated to 1 when someone adds a photo (which now goes into CalPhotos)

require "/usr/local/web/biocode/cgi/myschema.p";
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 

$query = "select distinct specimen_no from img where collectn = 'Biocode'";
$tmp = &get_multiple_records($query,"image");

open(FH,"$tmp") || die "Can't open tmp file ";
while(<FH>) {
    $specimen_no = $_;
    chomp($specimen_no);
    push(@unique_bnhm_ids,$specimen_no);
}
close(FH);



### update biocode pic field: 0 = no pic; 1 = pic 
### first set all to 0; then update [pic=1] where there is a pic

$query = "update biocode set pic = '0'";
&process_query($query,"biocode");

open(OH,">/home/joyceg/out");
foreach $id (@unique_bnhm_ids) {
    $query = "update biocode set pic = '1' where bnhm_id = '$id';";
    # print OH "$query\n";
    &process_query($query,"biocode");
}
close(OH);
