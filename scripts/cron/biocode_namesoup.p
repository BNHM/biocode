#!/usr/bin/perl
push(@INC,"/usr/local/web/biocode/cgi/"); # so that biocode_settings can be found
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 

$update = "update biocode set namesoup = concat( coalesce(scientificname,''), ' ', coalesce(colloquialname,''), ' ', coalesce(kingdom,''), ' ', coalesce(phylum,''), ' ', coalesce(subphylum,''), ' ', coalesce(superclass,''), ' ', coalesce(class,''), ' ', coalesce(subclass,''), ' ', coalesce(infraclass,''), ' ', coalesce(superorder,''), ' ', coalesce(ordr,''), ' ', coalesce(suborder,''), ' ', coalesce(infraorder,''), ' ', coalesce(superfamily,''), ' ', coalesce(family,''), ' ', coalesce(subfamily,''), ' ', coalesce(tribe,''), ' ', coalesce(subtribe,''), ' ', coalesce(genus,''), ' ', coalesce(subgenus,''), ' ', coalesce(specificepithet,''))";

&process_query("$update","biocode");

