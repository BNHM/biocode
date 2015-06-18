#!/usr/bin/perl -w
#recursive directory listing
use CGI;
use DBI;
use File::Find;
# Print Header
my $query = new CGI;
print $query->header;

 $strReturn.="<head>\n";
    $strReturn.="<style>\n";
    $strReturn.="th { font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="td { font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="body { font-family: lucida grande, verdana; font-size: 10px; }\n";
    $strReturn.="h1{ font-family: lucida grande, verdana; font-size: 18px; }\n";
    $strReturn.="option{ font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="input{ font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="textbox{ font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="select{ font-family: lucida grande, verdana; font-size: 9px; }\n";
    $strReturn.="</style>\n";
    $strReturn.="<script>\n";
    $strReturn.="function test() {alert('add a row');}";
    $strReturn.="</script>\n";
    $strReturn.="</head>\n";

print $strReturn;
print "<h1>Select fields to display</h1>";

    $strRow.="<table>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>EnteredBy</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>Coll_EventID_collector</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>Specimen_Num_Collector</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>Year</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>Month</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>Day</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox checked></td><td><b>MorphoSpecies</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>LowestTaxon</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>LowestTaxonLevel</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>Well</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>Destruct?</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>format_name96</b></td></tr>";
    $strRow.="<tr><td><input type=checkbox></td><td><b>Notes</b></td></tr>";
    $strRow.="</table>";

print $strRow;

