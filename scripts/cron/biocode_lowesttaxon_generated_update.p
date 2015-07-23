#!/usr/bin/perl

use strict;

push(@INC,"/usr/local/web/biocode/cgi/"); # so that biocode_settings can be found
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 
require "/usr/local/web/biocode/cgi/biocode_settings";


my $select = "";

$select = "select Kingdom, Phylum, Subphylum, Superclass, Class, Subclass, Infraclass, Superorder, Ordr, Suborder, Infraorder, ";
$select .= "Superfamily, Family, Subfamily, Tribe, Subtribe, Genus, Subgenus, SpecificEpithet, SubspecificEpithet, ";
$select .= "LowestTaxon, LowestTaxonLevel, bnhm_id ";
$select .= "from biocode";


my $tmp = &get_multiple_records("$select","biocode");

open(FH,"$tmp");
# open(OH,">/usr/local/web/test/biocode/scripts/cron/out");
# open(OH2,">/usr/local/web/test/biocode/scripts/cron/out2");






while (<FH>) {
    my $line = $_;
    chomp($line);

    my $LowestTaxon_Generated = "";
    my $taxon = "";

    my ($Kingdom, $Phylum, $Subphylum, $Superclass, $Class, $Subclass, $Infraclass, $Superorder, $Ordr, $Suborder, $Infraorder, $Superfamily, $Family, $Subfamily, $Tribe, $Subtribe, $Genus, $Subgenus, $SpecificEpithet, $SubspecificEpithet, $LowestTaxon, $LowestTaxonLevel, $bnhm_id) = split(/\t/,$line);

    $taxon = "$Genus $SpecificEpithet $SubspecificEpithet";
    $taxon = &strip($taxon);


    if($SpecificEpithet || $SubspecificEpithet) {
        $LowestTaxon_Generated = "$taxon";
    } elsif($Genus) {
        $LowestTaxon_Generated = "$taxon";
    } elsif($Subgenus) {
        $LowestTaxon_Generated = "$Subgenus";
    } elsif($Subtribe) {
        $LowestTaxon_Generated = "$Subtribe";
    } elsif($Tribe) {
        $LowestTaxon_Generated = "$Tribe";
    } elsif($Subfamily) {
        $LowestTaxon_Generated = "$Subfamily";
    } elsif($Family) {
        $LowestTaxon_Generated = "$Family";
    } elsif($Superfamily) {
        $LowestTaxon_Generated = "$Superfamily";
    } elsif($Infraorder) {
        $LowestTaxon_Generated = "$Infraorder";
    } elsif($Suborder) {
        $LowestTaxon_Generated = "$Suborder";
    } elsif($Ordr) {
        $LowestTaxon_Generated = "$Ordr";
    } elsif($Superorder) {
        $LowestTaxon_Generated = "$Superorder";
    } elsif($Infraclass) {
        $LowestTaxon_Generated = "$Infraclass";
    } elsif($Subclass) {
        $LowestTaxon_Generated = "$Subclass";
    } elsif($Class) {
        $LowestTaxon_Generated = "$Class";
    } elsif($Superclass) {
        $LowestTaxon_Generated = "$Superclass";
    } elsif($Subphylum) {
        $LowestTaxon_Generated = "$Subphylum";
    } elsif($Phylum) {
        $LowestTaxon_Generated = "$Phylum";
    } elsif($Kingdom) {
        $LowestTaxon_Generated = "$Kingdom";
    } else {
        $LowestTaxon_Generated = "";
    }

    my $LowestTaxon_Generated_2update = $LowestTaxon_Generated;
    $LowestTaxon_Generated_2update =~ s/'/\\'/g;
    $LowestTaxon_Generated_2update = "'$LowestTaxon_Generated_2update'";


    my $update  = "update biocode set ";
    $update    .= "LowestTaxon_Generated = $LowestTaxon_Generated_2update ";
    $update    .= "where bnhm_id = '$bnhm_id'";

    # print "$update\n";

#    if($LowestTaxon) {  
#        if($LowestTaxon ne $LowestTaxon_Generated) {
#            print OH "$update; # $LowestTaxon; $LowestTaxonLevel; $LowestTaxon_Generated\n";
#        }
#    }

#    if($bnhm_id) {  
#        print OH2 "$update;\n";
#    }

    if($bnhm_id) {  
        # print OH "$update;\n";
        &process_query($update,"biocode");
    }



}

# close(FH);
# close(OH);
