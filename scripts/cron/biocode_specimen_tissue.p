#!/usr/bin/perl

# set biocode.Tissue to max(biocode_tissue.tissue_num)
# (modified 5/22/08 GO)

push(@INC,"/usr/local/web/test/biocode/cgi/"); # so that biocode_settings can be found

require "/usr/local/web/test/biocode/cgi/myschema.p";
require "/usr/local/web/test/biocode/cgi/utils.p";
require "/usr/local/web/test/biocode/cgi/myquery_utils.p"; 

### first set all tissue fields to null
$query = "update biocode set Tissue=null";
&process_query($query);

### get the list of bnhm_ids from biocode_tissue
$query = "select bnhm_id from biocode_tissue group by bnhm_id";
$tmp = &get_multiple_records($query);

### for each bnhm_id, set Tissue in biocode table
open(FH,"$tmp") || die "Can't open tmp file $tmp ";
while(<FH>) {
    $bnhm_id = $_;
    chomp($bnhm_id);
    $query =  "update biocode set Tissue=(select max(tissue_num) from biocode_tissue";
    $query .= " where bnhm_id='$bnhm_id') where bnhm_id='$bnhm_id'";
    &process_query($query);
    #print "$query\n";
}
close(FH);

