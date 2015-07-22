#!/usr/bin/perl

use strict;

require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 
require "/usr/local/web/biocode/cgi/biocode_settings";

my $select = "select specimen_no, seq_num from img where collectn = 'biocode' and specimen_no is not null";
my $tmp = &get_multiple_records("$select","image");

open(FH,"$tmp");
open(OH,">/usr/local/web/biocode/scripts/cron/out");

while (<FH>) {
    my $line = $_;
    chomp($line);
    my ($specimen_no, $seq_num) = split(/\t/,$line);

    if($specimen_no && $seq_num) {

       my $get_taxonomy = "select phylum, class, ordr, family, genus, specificepithet, subspecificepithet, Specimen_Num_Collector from biocode where bnhm_id = '$specimen_no'";

       my ($phylum, $class, $ordr, $family, $genus, $specificepithet, $subspecificepithet, $Specimen_Num_Collector) = &get_one_record($get_taxonomy,"biocode");
       my $taxon = "$genus $specificepithet $subspecificepithet";

       $taxon = &strip($taxon);

       if($phylum) {
           $phylum =~ s/'/\\'/g;
           $phylum = "'$phylum'";
       } else {
           $phylum = "NULL";
       }
       if($class) {
           $class =~ s/'/\\'/g;
           $class = "'$class'";
       } else {
           $class = "NULL";
       }
       if($ordr) {
           $ordr =~ s/'/\\'/g;
           $ordr = "'$ordr'";
       } else {
           $ordr = "NULL";
       }
       if($family) {
           $family =~ s/'/\\'/g;
           $family = "'$family'";
       } else {
           $family = "NULL";
       }
       if($taxon) {
           $taxon =~ s/'/\\'/g;
           $taxon = "'$taxon'";
       } else {
           $taxon = "NULL";
       }
       if($Specimen_Num_Collector) {
           $Specimen_Num_Collector =~ s/'/\\'/g;
           $Specimen_Num_Collector = "'$Specimen_Num_Collector'";
       } else {
           $Specimen_Num_Collector = "NULL";
       }




       my $update  = "update img set ";
       $update    .= "phylum = $phylum, ";
       $update    .= "class = $class, ";
       $update    .= "ordr = $ordr, ";
       $update    .= "family = $family, ";
       $update    .= "taxon = $taxon, ";
       $update    .= "source_id_1 = $Specimen_Num_Collector ";
       $update    .= "where seq_num = $seq_num and specimen_no = '$specimen_no'";

       # print "$update\n";

       # print OH "$update;\n";

       &process_query($update,"image");

    }


}

close(FH);
