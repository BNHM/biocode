#!/usr/bin/perl

#require "/usr/local/web/cgi/myschema.p";
require "/usr/local/web/cgi/utils.p";
require "/usr/local/web/cgi/myquery_utils.p"; 
#require "/usr/local/web/cgi/myimg_utils.p"; 
#require "/usr/local/web/test/biocode/cgi/biocode_settings";


$select = "select bnhm_id, ScientificName, ColloquialName, Kingdom, Phylum, Subphylum, Superclass, Class, Subclass, ";
$select .= "Infraclass, Superorder, Ordr, Suborder, Infraorder, Superfamily, Family, Subfamily, Tribe, Subtribe, ";
$select .= "Genus, Subgenus, SpecificEpithet ";
$select .= "from biocode";


$tmp = &get_multiple_records("$select","biocode");
open(FH,"$tmp");

while(<FH>) {
    $row = $_;
    chomp($row);
    ($bnhm_id, $ScientificName, $ColloquialName, $Kingdom, $Phylum, $Subphylum, $Superclass, $Class, $Subclass, $Infraclass, $Superorder, $Ordr, $Suborder, $Infraorder, $Superfamily, $Family, $Subfamily, $Tribe, $Subtribe, $Genus, $Subgenus, $SpecificEpithet) = split(/\t/,$row);

    $namesoup  = "$ScientificName $ColloquialName $Kingdom $Phylum $Subphylum $Superclass $Class $Subclass ";
    $namesoup .= "$Infraclass $Superorder $Ordr $Suborder $Infraorder $Superfamily $Family $Subfamily $Tribe $Subtribe $Genus $Subgenus $SpecificEpithet";
    $namesoup =~ s/'/\\'/g;
    $namesoup = &strip($namesoup);
 
    $update = "update biocode set namesoup = '$namesoup' where bnhm_id = '$bnhm_id'";
    # print "$update\n";
    &process_query("$update","biocode");


}


close(FH);


