#!/usr/bin/perl
# make_biocode_sciname_browselist.p : make browselist of moorea biocode sci names
#    modified 2004-01-06 for mySQL

# creates $testdir/BrowseNames.html and copies it to $proddir

# $DEBUG = 1;
 $UPDATE_PROD = 0;  
 $DO_QUERY = 1;

push(@INC,"/usr/local/web/test/biocode/cgi/"); # so that biocode_settings can be found

require "/usr/local/web/test/biocode/cgi/utils.p";
require "/usr/local/web/test/biocode/cgi/myquery_utils.p";
require "/usr/local/web/test/biocode/cgi/mybiocode_utils.p";
require "/usr/local/web/test/biocode/cgi/biocode_settings";

#$testdir = "/usr/local/web/test/biocode/web/generated";    # in biocode_settings
#$proddir = "/usr/local/web/biocode/web/generated";         # in biocode_settings

## common names for families
$cnamefor{Aphididae} = "aphids";
$cnamefor{Helicopsychidae} = "snail-case caddisflies";
$cnamefor{Hydropsychidae} = "net-spinning caddisflies";
$cnamefor{Leptoceridae} = "long-horn caddisflies";
$cnamefor{Limnephilidae} = "northern caddisflies";
$cnamefor{Philopotamidae} = "finger-net caddisflies";
$cnamefor{Phryganeidae} = "large caddisflies";
$cnamefor{Psychomyiidae} = "trumpet-net caddisflies, tube-making caddisflies";
$cnamefor{Rhyacophilidae} = "primitive caddisflies"; 



$html_page = "$testdir/Browse.html";

`/bin/rm -f $html_page`;
open(HTML,">>$html_page");

#$header = &print_biocode_header_to_file("Browse Moorea Biocode Sprecimen Database");
$header = &print_biocode_header_css_to_file("Browse Moorea Biocode Specimen Database");

print HTML $header;
$backto = &make_biocode_backto_link("Browse by Scientific Name");
print HTML $backto;
&print_list;
$footer = &print_biocode_footer_to_file;
print HTML $footer;

close(HTML);
if ($UPDATE_PROD) {
	`cp $html_page $proddir`;
    }

## this prints classes and orders
sub print_list {


    if ($DO_QUERY) {  # run query that creates BrowseNames.txt

	local($query) = "select Class,Ordr,count(*) from biocode group by Class,Ordr order by Class,Ordr";
	$tmp = &get_multiple_records($query, "biocode");
	# if ($DEBUG) {print "tmp: $tmp \n";    }
    }
    open(F, "$tmp") || die "Can't open tmp file for reading";

    # big giant table for the page
    print HTML "<p><br>\n<table width=100%>\n";
    print HTML "  <tr><td valign=top>\n";

    $working_class = "";
    $working_order = "";
    $num_columns = 0;

    while ($line = <F>) {
	($class,$order,$count) = split(/\t/,$line);

	if ($class eq "Class") {
	    next;
	} elsif (!$class || $class =~ /^ *$/) {
	    $class = "unavailable";
	    $where_c = "null";
	} else {
	    $where_c = $class;
	}
	
	$count = sprintf("%d",$count);


	## print Class
	if (!$working_class) {  # the first time
	    print HTML "<table>\n"; # open new inner table
            print HTML "<tr><td valign=top align=left>";
            print HTML "<font color=999999>class</font>&nbsp;&nbsp;";
            print HTML "<b>$class</b>";
            print HTML "<dl>";
            print HTML "<dd><font color=999999>order</font>";
            $working_class = $class;
            $num_columns++;

	    
	} elsif ($class ne $working_class) {
	    print HTML "         </dl>\n";
	    print HTML "         </td></tr>\n";
	    print HTML "      </table>\n";  # close previous inner table
	    print HTML "   </td>\n";  

            if($num_columns == 5) {
                print HTML "</tr><tr>";
                $num_columns = 0;
            }

	    print HTML "   <td valign=top align=left>\n";  # open new innertable
	    print HTML "        <table>\n"; # open new inner table
	    print HTML "<tr><td align=left>\n";
	    print HTML "<font color=999999>class</font>&nbsp;&nbsp;";
	    print HTML "<b>$class</b>";
	    print HTML "</b>";
	    print HTML "<dl>";
	    print HTML "<dd><font color=999999>order</font>";
	    $working_class = $class;
            $num_columns++;
	}
	
	## print Order
	if (!$order || $order =~ /^ *$/) {
	    $order = "<i>unavailable</i>";
	    $where_o= "null";
	} else {
	    $where_o= $order;
	}
	print HTML "<dd><a href=/cgi/biocode_query?stat=BROWSE&where-Class=$where_c&where-Ordr=$where_o&groupby=Family&special=browse_fam&where-PublicAccess=null>$order</a>";
	print HTML "&nbsp;&nbsp;<small>($count)</small>\n";

    } # end while
    print HTML "</dl>\n";
    print HTML "</td></tr>\n";
    print HTML "</table>\n";
    print HTML "</td>";
    print HTML "</tr></table>\n";  # end big giant table
    print HTML "\n<center>last updated: $todays_date</center>\n";
    close(F);
}
