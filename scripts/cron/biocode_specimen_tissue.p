#!/usr/bin/perl

# set biocode.Tissue to max(biocode_tissue.tissue_num)
# (modified 5/22/08 GO)

print "beginning of script .. ";

push(@INC,"/usr/local/web/biocode/cgi/"); # so that biocode_settings can be found

require "/usr/local/web/biocode/cgi/myschema.p";
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 
require "/usr/local/web/biocode/cgi/biocode_settings";

print "beginning process .. ";

### first set all tissue fields to null
$query = "update biocode set Tissue=null";
&process_query($query);
print "processed tissues, setting all to null";

### get the list of bnhm_ids from biocode_tissue
$query = "select bnhm_id from biocode_tissue group by bnhm_id";
$tmp = &get_multiple_records($query);
print "got all tissues by bnhm_id";

### for each bnhm_id, set Tissue in biocode table
open(FH,"$tmp") || die "Can't open tmp file $tmp ";
while(<FH>) {
    $bnhm_id = $_;
    chomp($bnhm_id);
    $query =  "update biocode set Tissue=(select max(tissue_num) from biocode_tissue";
    $query .= " where bnhm_id='$bnhm_id') where bnhm_id='$bnhm_id'";
    #print "$query\n";
    &process_query($query);
}
close(FH);
print "updated tissues";

