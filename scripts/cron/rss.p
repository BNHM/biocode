#!/usr/bin/perl

use CGI qw/ :standard /;
use Digest::MD5 qw(md5_hex);
use Data::Dumper ;
use URI::Escape;

use CGI;
use XML::Simple;

push(@INC,"/usr/local/web/test/biocode/cgi/");
require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "mybiocode_utils.p";
require "biocode_settings";

our $gBiocodeDbString="dbi:mysql:biocode:$g_db_location";
our $gMetaDbString="dbi:mysql:biocode:$g_db_location";

my $rssDirectory = '/usr/local/web/biocode/web/rss/';
#my $rssDirectory='/Users/biocode/Website/biocode/web/rss/';
my $rssFile= 'stats.rss';
my $rssFilePath=$rssDirectory.$rssFile;

xmlPrint();

sub xmlPrint {
    print header('text/xml');

($ceNum)=&get_one_record('select count(*) from biocode_collecting_event where projectcode ="MBIO"');
($specimensNum)= &get_one_record('select count(*) from biocode where bnhm_id like "MBIO%"');
$phylaNum=&get_num_matches('select count(*) from biocode where phylum is not NULL and phylum != "NA" and phylum != "Unidentified" and bnhm_id like "MBIO%" group by phylum');
$pubDate=`date`;
    my $xml = <<EOF;
<?xml version="1.0" encoding="iso-8859-1"?><!DOCTYPE rss PUBLIC "-//Netscape Communications//DTD RSS 0.91//EN" "http://my.netscape.com/publish/formats/rss-0.91.dtd"><rss version="0.91">
<channel>
<copyright>Copyright 1994 to 2003 by the Regents of the University of California, all rights reserved. </copyright>
<language>en-us</language>
<title>Moorea Biocode Project</title>
<link>http://www.mooreabiocode.org/</link>
<description>Moorea Biocode Project Database Statistics</description>
<pubDate>$pubDate</pubDate>
<webMaster>jdeck@berkeley.edu</webMaster>
<lastBuildDate>$pubDate</lastBuildDate>

<item>
<title>$ceNum Collecting Events</title>
<link>http://www.mooreabiocode.org/</link>
<description>
Number of Collecting Events
</description>
</item>

<item>
<title>$specimensNum Specimens Collected</title>
<link>http://www.mooreabiocode.org/</link>
<description>
Total number of specimens collected
</description>
</item>

<item>
<title>$phylaNum Phyla Collected</title>
<link>http://www.mooreabiocode.org/</link>
<description>
Total number of phyla collected
</description>
</item>

</channel>
</rss>
EOF

	open(NEWFILE, ">$rssFilePath"); # or emailMe that it failed! 
	print NEWFILE $xml;
	close(NEWFILE);

    exit;
}
