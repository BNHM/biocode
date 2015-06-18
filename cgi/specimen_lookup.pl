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
print "<h1>Taxon Lookup</h1>";

print "Provide function to search Biocode Database for existing names and taxon levels.";

print "<p>Select name from a lookup Table and populate current field";

