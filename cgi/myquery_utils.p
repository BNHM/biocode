#!/usr/bin/perl

# myquery_utils.p - 9/6/98

use DBI;

require "biocode_settings";

$mysql_version = "4.1.10a";  # printed in default_footer  changed 3/28 GO

## uncomment for system crashes
#$CRASH = 1;  ## queries will just exit out of readParse
$crash_date = "Thu Jul 20 12:59:27 PDT 2006";

$ENV{'TERM'} = "vt100";

$tmpdir = "$tmp_file_location";

if ($ENV{'SERVER_PORT'} eq "80") {
    $log = "$production_query_log_dir";  # also append: $table/$yyyy" . "_" . "$mon";
} elsif($ENV{'SERVER_PORT'} eq "8000") {
    $log = "$test_query_log_dir";       # also append: $table/$yyyy" . "_" . "$mon";
}


#####################################
#         subroutines
#####################################
# sub ascii2html ($in)
# sub build_query
# sub check_max 
# sub check_max_no_print 
# sub check_tmpfile ($tmpfile)
# sub clear_all_fields ($table)
# sub download_file ($filename)
# sub download_file_with_fieldnames ($filename)
# sub fill_fields_with_values ($table)
# sub get_multiple_records ($query)
# sub get_num_matches ($query)  ###  use get_count instead!
# sub get_one_record ($query)
# sub is_a_number($fieldname)
# sub make_log_entry ($table,$searchstring,$special) 
# sub make_where_clause ($f)
# sub MethGet
# sub MethPost 
# sub parse_input

# March 2007: (also check *_utils.p for header/footer
# sub print_new_bscit_header ($heading)
# sub print_new_bscit_header_to_file ($fh,$heading)
# sub print_new_bscit_footer
# sub print_new_bscit_footer_to_file ($fh)
# sub print_bscit_footer ($footer_info)
# sub print_default_footer ($footer_info)
# sub print_default_header ($heading)
# sub print_default_header_to_file ($heading)
# sub make_backto_link
# sub print_page_button 
# sub process_query ($query,$database)
# sub readParse (*in)
# sub readParseNoOut (*in)



# some tables that don't use standard names

# for joins, put this in the html form:
#  <input type=hidden name=jointables value="img_all,img_blobs">
#  <input type=hidden name=joincolumns value="(e.loc_num=f.loc_num and e.loc_prefix=f.loc_prefix)">
#  <input type=hidden name=rel-a.photographer value=eq>
#  <select size=5 name=where-a.photographer>
#
# ... and add vars below


$joinalpha{"img_all"} = "a";
$joinalpha{"img_blobs"} = "b";
$joinalpha{"calflora"} = "c";
$joinalpha{"img"} = "d";
$joinalpha{"coda_agent"} = "g";
$joinalpha{"coda_host"} = "h";

$joinname{"a"} = "img_all";
$joinname{"b"} = "img_blobs";
$joinname{"c"} = "calflora";
$joinname{"d"} = "img";
$joinname{"g"} = "coda_agent";
$joinname{"h"} = "coda_host";

## Uppercase functionality for query_utils.p
## 1. Use Informix upper function, do this on html form:
##      <input type=hidden name=upper-genus value=1>
##    this will set $upperarray{'genus'} to 1 and do the right thing
## 2. Query a field that is all caps in the database (not Informix function)
##      add a line below and the right thing will happen
##
$uppercase{"dams"} = 1;
$uppercase{"namesoup"} = 1;
$uppercase{"a.textsoup"} = 1;  ## img_all
$uppercase{"a.locsoup"} = 1;   ## img_all
$uppercase{"u_location"} = 1;
$uppercase{"u_notes"} = 1;  ## img_cas_unscanned
$uppercase{"u_inc_taxon_name"} = 1;
$uppercase{"u_res_taxon_name"} = 1;
$uppercase{"u_taxon"} = 1;
$uppercase{"u_allcnames"} = 1;
$uppercase{"u_description"} = 1;
$uppercase{"u_title"} = 1;
$uppercase{"u_book_title"} = 1;
$uppercase{"u_journalname"} = 1;
$uppercase{"u_authors"} = 1;
$uppercase{"u_author"} = 1;
$uppercase{"u_editors"} = 1;

$uppercase{"u_genus"} = 1;
$uppercase{"u_species"} = 1;

$uppercase{"u_term_name"} = 1;
$uppercase{"u_parent_term_name"} = 1;
$uppercase{"u_Continent_Ocean"} = 1;
$uppercase{"u_Country"} = 1;
$uppercase{"u_State_Prov"} = 1;
$uppercase{"u_County"} = 1;
$uppercase{"u_Island"} = 1;
$uppercase{"u_Island_Group"} = 1;


if (!$script_name) {
    $script_name = "unknown_query";
}

sub download_file {
    local($filename) = @_;

    print "Content-type: text\n\n";

    open(FH, "$tmpdir/$script_name/$filename")
        || die "Can't open $filename' file for reading";
    while(<FH>) {
        print "$_";
    }
}

sub download_file_with_fieldnames {
    local($filename) = @_;
    local($fields);
    print "Content-type: text/text\n\n";

    if ($displaylist && $displaylist ne "*") {
	$fields = $displaylist;
	$fields =~ s/\|/\t/g;
	$fields .= "\n";
    } else {
	$schema = $table . "_schema";
	foreach $f (@$schema) {
	    $fields .= "$f\t";
        }
	$fields =~ s/\t$//g;
    }
    print "($schema) $fields\n";

    open(FH, "$tmpdir/$script_name/$filename")
        || die "Can't open $filename' file for reading";
    while(<FH>) {
        print "$_";
    }
}

sub print_default_header {  ## required for print_default_footer

    local($heading) = @_;  # example: "CalPhotos"

    print "Content-type: text/html\n\n";
    print "<HTML><HEAD>\n<TITLE>";
    print "$heading</TITLE>\n";
    print "$css";
    print "</HEAD>\n";
    print "<BODY BGCOLOR=#FFFFFF>\n";
    print "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>";
    ## silver left square
    print "<tr><td width=5% bgcolor=DFE5FA><br></td>";
    print "<td align=left valign=bottom>\n";
    print "<table border=0 cellpadding=5><tr>";
    print "<td align=left valign=bottom>";
    print "<font face=\"Helvetica,Arial,Verdana\" color=23238E>";
    print "<big><big>$heading</big></big></font>&nbsp;&nbsp;";
    print "</td></table></td></tr>\n";
    ## navy blue bar
    print "<tr><td width=100% colspan=2 bgcolor=23238E><br></td></tr>";
    ## left-side silver vertical strip
    print "<tr><td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>";
    print "<font face=\"Helvetica,Arial,Verdana\">";
    print "<p></font></td>\n";
    ## main body
    print "<td>";
   if ($DEBUG) {print $debug_msg;}

}

sub print_default_header_to_file {  ## required for print_default_footer

    local($heading) = @_;  # example: "CalPhotos"
    local($header) = "";

    # print "Content-type: text/html\n\n";
    $header .= "<HTML><HEAD>\n<TITLE>";
    $header .= "$heading</TITLE>\n";
    $header .= "$css";
    $header .= "</HEAD>\n";
    $header .= "<BODY BGCOLOR=#FFFFFF>\n";
    $header .= "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>";
    ## silver left square
    $header .= "<tr><td width=5% bgcolor=DFE5FA><br></td>";
    $header .= "<td align=left valign=bottom>\n";
    $header .= "<table border=0 cellpadding=5><tr>";
    $header .= "<td align=left valign=bottom>";
    $header .= "<font face=\"Helvetica,Arial,Verdana\" color=23238E>";
    $header .= "<big><big>$heading</big></big></font>&nbsp;&nbsp;";
    $header .= "</td></table></td></tr>\n";
    ## navy blue bar
    $header .= "<tr><td width=100% colspan=2 bgcolor=23238E><br></td></tr>";
    ## left-side silver vertical strip
    $header .= "<tr><td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>";
    $header .= "<font face=\"Helvetica,Arial,Verdana\">";
    $header .= "<p></font></td>\n";
    ## main body
    $header .= "<td>";

    return $header;
    
}



sub print_default_footer {  ## required for print_default_header
    local($footer_info) = @_;  # add'l info in lt. blue bottom bar
    
    if (($num_matches > $max_rows) || ($row_to_start > 0)) {
        &print_page_button;
    }
    
    print "</td></tr>";  ## close out header/body cell
    ## bottom lt. blue section
    print "<tr><td colspan=2 bgcolor=DFE5FA>";
    if ($footer_info) {
	print "$footer_info";
    } else {
	print "<br>";
    }
    print "<center><small>Copyright &copy 1995-2009 UC Regents.  All rights reserved.</small></center><br>";
    print "</td></tr>";
    print " </table>\n";

    print "</td>\n";
    print "</tr>\n";
    print "</table>\n";

    print "</td></tr>";
    print "</table>\n";

    print "<p><center>\n";
    print "<a href=http://calphotos.berkeley.edu>CalPhotos</a> is a project of ";
    print "<a href=http://bscit.berkeley.edu>BSCIT</a>";
    print "&nbsp;&nbsp;&nbsp;&nbsp;University of California, Berkeley";

    print "</table></center><p></small></font>\n";
    print "</body></html>\n";

}


sub print_default_footer_to_file {  ## required for print_default_header
    local($footer_info) = @_;  # add'l info in lt. blue bottom bar
   
    local($footer) = "";

    $footer .= "<!-- end of body --->\n";

   
    $footer .= "</td></tr>";  ## close out header/body cell
    ## bottom lt. blue section
    $footer .= "<tr><td colspan=2 bgcolor=DFE5FA>";
    if ($footer_info) {
        $footer .= "$footer_info";
    } else {
        $footer .= "<br>";
    }
#    $footer .= "<center><small>powered by MySQL v. $mysql_version</small></center>";
    $footer .= "</td></tr>";
    $footer .= " </table>\n";

    $footer .= "<p><center><table cellpadding=5 cellspacing=5>";
    $footer .= "<tr><td align=center>";
#    $footer .= "<a href=/><img src=/graphics/dlplogo2.gif border=0></a>";
    $footer .= "<font face=\"Helvetica,Arial,Verdana\">";
    $footer .= "<small><a href=/>BSCIT</a>";
    $footer .= "&nbsp;&nbsp;&nbsp;&nbsp;University of California, Berkeley<br>\n";
    $footer .= "<p>Copyright &copy 1995-2007 UC Regents.  All Rights Reserved.</p>";
    $footer .= "</small></font></td></tr></table></p></center>\n";
    $footer .= "\n</body></html>";

    return $footer;
}


sub print_bscit_footer {  ## required for print_default_header
    local($footer_info) = @_;  # add'l info in lt. blue bottom bar
    
    if (($num_matches > $max_rows) || ($row_to_start > 0)) {
        &print_page_button;
    }
    
    print "</td></tr>";  ## close out header/body cell
    ## bottom lt. blue section
    print "<tr><td colspan=2 bgcolor=DFE5FA>";
    if ($footer_info) {
	print "$footer_info";
    } else {
	print "<br>";
    }
#    print "<center><small>Copyright &copy 1995-2007 UC Regents.  All rights reserved.</small></center><br>";
    print "</td></tr>";
    print " </table>\n";

    print "</td>\n";
    print "</tr>\n";
    print "</table>\n";

    print "</td></tr>";
    print "</table>\n";

    print "<p><center>\n";
    print "<a href=http://bscit.berkeley.edu>BSCIT</a> ";
    print "&nbsp;&nbsp;&nbsp;&nbsp;University of California, Berkeley";

    print "</table></center><p></small></font>\n";
    print "</body></html>\n";

}


sub print_new_bscit_header {
    # 3/2007 based on /head*.html
    local($head) = @_;

    print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print "<title>\n";
    print "$head\n";
    print "</title>\n";

    print "<style type=\"text/css\">\n";
    print "p, td, th, body {font-family: arial, verdana, helvetica, sans-serif;}\n";
    print "p, td, th, body {font-size: 12px;}\n";
    print "a.nounderline {\n";
    print "    text-decoration: none;\n";
    print "    color:  white;\n";
    print "    outline: none;\n";
    print "}\n";
    print "\"a.subtle_link {\n";
    print "   text-decoration: none;\n";
    print "   font-size: 10px;\n";
    print "   outline: none;\n";
    print "}\n";
    print "</style>\n";

    print "</head>\n";
    print "<body bgcolor=#FFFFFF>\n";

    print "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>\n";
    print "<tr>\n";
    print "<td width=5% bgcolor=99CCCC>\n";

    print "<br>\n";
    print "</td>\n";
    print "<td align=left valign=bottom>\n";
    print "    <table border=0 cellpadding=5>\n";
    print "    <tr>\n";
    print "    <td align=left valign=bottom>\n";
    print "    <font face=\"Helvetica,Arial,Verdana\" color=23238E>\n";
    print "    <big><big>\n";

    print "$head\n";

    print "    </big></big>\n";
    print "    </font>\n";
    print "    &nbsp;&nbsp;\n";
    print "    <font face=\"Helvetica,Arial,Verdana\" color=000000>\n";
    print "    <b>\n";
    print "    <!-- insert a smaller heading comment here -->\n";
    print "    </b>\n";
    print "    </font>\n";
    print "    </td>\n";
    print "    </table>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<!-- horizontal stripe -->\n";
    print "<tr>\n";
    print "<td width=100% colspan=2 bgcolor=336699>\n";
    print "<br>\n";
    print "</td></tr>\n";
    print "<!-- left side lt. blue bar with links -->\n";
    print "<tr>\n";
    print "<td width=10%  bgcolor=99CCCC align=center valign=top>\n";
    print "&nbsp;<p>\n";
    print "<font face=\"Helvetica,Arial,Verdana\">\n";
    print "<p>\n";
    print "<small>\n";


    print "</small>\n";
    print "</font>\n";
    print "</td>\n";
    print "<!-- main menu -->\n";
    print "<td>\n";
    print "    <table cellpadding=5 width=100%>\n";
    print "    <tr>\n";
    print "    <td>\n";
    print "    <font face=\"Helvetica,Arial,Verdana\">\n";

}

sub print_new_bscit_header_to_file {
    local($fh, $head) = @_;

    #print "Content-type: text/html\n\n";
    print $fh "<html>\n";
    print $fh "<head>\n";
    print $fh "<title>\n";
    print $fh "$head\n";
    print $fh "</title>\n";

    print $fh "<style type=\"text/css\">\n";
    print $fh "p, td, body {font-family: arial, verdana, helvetica, sans-serif;}\n";
    print $fh "p, td, body {font-size: 12px;}\n";
    print $fh "a.nounderline {\n";
    print $fh "    text-decoration: none;\n";
    print $fh "    color:  white;\n";
    print $fh "    outline: none;\n";
    print $fh "}\n";
    print $fh "\"a.subtle_link {\n";
    print $fh "   text-decoration: none;\n";
    print $fh "   font-size: 10px;\n";
    print $fh "   outline: none;\n";
    print $fh "}\n";
    print $fh "</style>\n";

    print $fh "</head>\n";
    print $fh "<body bgcolor=#FFFFFF>\n";

    print $fh "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>\n";
    print $fh "<tr>\n";
    print $fh "<td width=5% bgcolor=99CCCC>\n";

    print $fh "<br>\n";
    print $fh "</td>\n";
    print $fh "<td align=left valign=bottom>\n";
    print $fh "    <table border=0 cellpadding=5>\n";
    print $fh "    <tr>\n";
    print $fh "    <td align=left valign=bottom>\n";
    print $fh "    <font face=\"Helvetica,Arial,Verdana\" color=23238E>\n";
    print $fh "    <big><big>\n";

    print $fh "$head\n";

    print $fh "    </big></big>\n";
    print $fh "    </font>\n";
    print $fh "    &nbsp;&nbsp;\n";
    print $fh "    <font face=\"Helvetica,Arial,Verdana\" color=000000>\n";
    print $fh "    <b>\n";
    print $fh "    <!-- insert a smaller heading comment here -->\n";
    print $fh "    </b>\n";
    print $fh "    </font>\n";
    print $fh "    </td>\n";
    print $fh "    </table>\n";
    print $fh "</td>\n";
    print $fh "</tr>\n";

    print $fh "<!-- horizontal stripe -->\n";
    print $fh "<tr>\n";
    print $fh "<td width=100% colspan=2 bgcolor=336699>\n";
    print $fh "<br>\n";
    print $fh "</td></tr>\n";
    print $fh "<!-- left side lt. blue bar with links -->\n";
    print $fh "<tr>\n";
    print $fh "<td width=10%  bgcolor=99CCCC align=center valign=top>\n";
    print $fh "&nbsp;<p>\n";
    print $fh "<font face=\"Helvetica,Arial,Verdana\">\n";
    print $fh "<p>\n";
    print $fh "<small>\n";


    print $fh "</small>\n";
    print $fh "</font>\n";
    print $fh "</td>\n";
    print $fh "<!-- main menu -->\n";
    print $fh "<td>\n";
    print $fh "    <table cellpadding=5 width=100%>\n";
    print $fh "    <tr>\n";
    print $fh "    <td>\n";
    print $fh "    <font face=\"Helvetica,Arial,Verdana\">\n";
}


sub print_new_bscit_footer {
    # 3/2007 based on /footer.html
    
    print "</td>\n";
    print "</tr>\n";
    print "</table>\n";
    print "<tr>\n";
    print "<td colspan=2 bgcolor=99CCCC>\n";
    print "    <table cellpadding=0>\n";
    print "    <tr>\n";
    print "    <td>\n";
    print "    <font face=\"Helvetica,Arial,Verdana\">\n";
    print "    <small>\n";
    print "    </small>\n";
    print "    <br>\n";
    print "    </font>\n";
    print "    </td>\n";
    print "    </tr>\n";
    print "    </table>\n";
    print "</td>\n";
    print "</tr>\n";
    print "</table>\n";

    print "<p>\n";
    print "<center>\n";
    print "<a href=http://bscit.berkeley.edu>BSCIT</a>&nbsp;&nbsp;\n";
    print "University of California, Berkeley\n";
    print "&nbsp;&nbsp;\n";
    print "<a href=http://bnhm.berkeley.edu>\n";
    print "<img border=0 align=bottom src=http://bscit.berkeley.edu/graphics/bnhm_logo_tiny.gif> Berkeley Natural History Musums</a>\n";
    print "<br>\n";
    print "<small>Copyright &copy 1995-$THISYR UC Regents.  All Rights Reserved.\n";
    print " &nbsp;&nbsp;&nbsp;&nbsp;\n";
    print "<a href=/cgi/dlpmail.pl?step=form&site=bscit&receiver=BSCIT&subject=BSCIT+question>Questions and Comments</a>\n";
    print "<br>\n";

    print "<i>\n";

    print "<br>\n";
    print "</i>\n";
    print "</small>\n";

    print "<p>\n";
    print "</center>\n";
    print "</small>\n";
    print "</font>\n";
    print "</body>\n";
    print "</html>\n";

}

sub print_new_bscit_footer_to_file {
    local($fh) = @_;
    
    print $fh "</td>\n";
    print $fh "</tr>\n";
    print $fh "</table>\n";
    print $fh "<tr>\n";
    print $fh "<td colspan=2 bgcolor=99CCCC>\n";
    print $fh "    <table cellpadding=0>\n";
    print $fh "    <tr>\n";
    print $fh "    <td>\n";
    print $fh "    <font face=\"Helvetica,Arial,Verdana\">\n";
    print $fh "    <small>\n";
    print $fh "    </small>\n";
    print $fh "    <br>\n";
    print $fh "    </font>\n";
    print $fh "    </td>\n";
    print $fh "    </tr>\n";
    print $fh "    </table>\n";
    print $fh "</td>\n";
    print $fh "</tr>\n";
    print $fh "</table>\n";

    print $fh "<p>\n";
    print $fh "<center>\n";
    print $fh "<a href=http://bscit.berkeley.edu>BSCIT</a>&nbsp;&nbsp;\n";
    print $fh "University of California, Berkeley\n";
    print $fh "&nbsp;&nbsp;\n";
    print $fh "<a href=http://bnhm.berkeley.edu>\n";
    print $fh "<img border=0 align=bottom src=http://bscit.berkeley.edu/graphics/bnhm_logo_tiny.gif> Berkeley Natural History Musums</a>\n";
    print $fh "<br>\n";
    print $fh "<small>Copyright &copy 1995-$THISYR UC Regents.  All Rights Reserved.\n";
    print $fh " &nbsp;&nbsp;&nbsp;&nbsp;\n";
    print $fh "<a href=/cgi/dlpmail.pl?step=form&site=bscit&receiver=BSCIT&subject=BSCIT+question>Questions and Comments</a>\n";
    print $fh "<br>\n";

    print $fh "<i>\n";

    print $fh "<br>\n";
    print $fh "</i>\n";
    print $fh "</small>\n";

    print $fh "<p>\n";
    print $fh "</center>\n";
    print $fh "</small>\n";
    print $fh "</font>\n";
    print $fh "</body>\n";
    print $fh "</html>\n";

}


sub make_backto_link {  #  &make_backto_link("/webstats/","Query Statistics","Essig Queries");

    local($current_page,$nameof_page) = @_;  

    $backto = "<center><i><small>";
    $backto .= "Back to: <a href=$base_page_href>$base_page_name</a> > ";
    $backto .= "$current_page";
    $backto .= "</small></i></center><p>";
    return $backto;

}

sub make_backto_link_webstats {  

    local($current_page) = @_;  

    $backto = "<center><i><small>";
    $backto .= "<a href=/webstats/>Database Query Statistics</a> > ";
    $backto .= "$current_page";
    $backto .= "</small></i></center><p>";
    return $backto;

}

sub fill_fields_with_values {  # assigns row[1] to "$taxon"using schema.p
    my ($table, $nostrip) = @_;

    $schema = $table . "_schema";
    $fnum = 0;

    foreach $f (@$schema) {
        if($nostrip) {
	    $val = $row[$fnum];
        } else {
	    $val = &strip($row[$fnum]);
        }
	${$f} = $val;
        ++$fnum;
    }
}

sub clear_all_fields {  #clears out the array
    local($table) = @_;

    $schema = $table . "_schema";
    $fnum = 0;
    foreach $f (@$schema) {
	${$f} = "";
        ++$fnum;
    }
}

sub make_log_entry {
    local($table,$searchstring,$special,$src) = @_;

    $port = $ENV{'SERVER_PORT'};
    $rem_host = $ENV{'REMOTE_HOST'};
    $rem_ip = $ENV{'REMOTE_ADDR'};
    if(!$rem_host) {
        $rem_host = $rem_ip;
    }

    $now = &get_time;
    local($day,$mon,$dd,$time,$PDT,$yyyy)=split(/\s+/,$now);

    if ($DEBUG) {
	print "<h4>In make_log_entry</h4>\n";
	print "table=|$table| searchstring=|$searchstring| special=|$special| src=|$src|<br>";
    }

    if ($searchstring ne "") {
	$log_query = $searchstring;
	if ($DEBUG) {print "Got a log_query: $log_query<br>";}
    } elsif ($input{'enlarge'}) {
	$num_matches = 1;
	$log_query = "enlarge $input{'enlarge'}";
    } elsif ($input{'tmpfile'}) {  # paging through a previous query
	## this should not be logged!
	return;
    } elsif ($input{'batch'}) {  # batch upload check
        ## this should not be logged!
        return;
    } else {
	$log_query = "query unknown";
    } 
    

    $log = "$log/$table/$yyyy" . "_" . "$mon";   # this is instead of the lines above....
    
    if ($special =~ /DETAIL/) {  # this isn't getting passed in
	$num_matches = 1;
    }

    if ($DEBUG) {print "log: $log<br>";}

    ## write a line to the log file
    open(LOG,">>$log") || die "Cannot open $log: $!";
    print (LOG "$yyyy $mon $dd $time|$rem_host|$table|$num_matches|$log_query|$special|$src\n");
    close(LOG);

}

sub parse_input {

    if ($DEBUG) {$debug_msg .= "<h4>In parse_input</h4><p>\n";}

    foreach $field (%input) {

	## ignore fields with no inputs
	if ($input{$field} eq "" || 
	    $input{$field} eq "any" || 
	    $input{$field} eq "choose one" ||
	    $input{$field} eq "select one" ||
	    $input{$field} eq "N/A" ||
	    $input{$field} eq "none" ) {
	    next;

	} elsif ($input{$field} eq "undetermined" && $script_name ne "eme_species_query") {
	    next;

	} elsif ($field =~ /^display\d$/) {
	    ${$field} = $input{$field};

	} elsif ($field eq "allrecords") {  # get all records - no 'where' clause
	    $allrecords = $input{'allrecords'};

	} elsif ($field eq "row-to-start") {  # prev-next buttons
	    $row_to_start = $input{'row-to-start'};

	} elsif ($field eq "num-matches") {  # 
            $num_matches = $input{"num-matches"}; 

	} elsif ($field eq "tmpfile") {  # 
            $tmp = $input{"tmpfile"}; 

	} elsif ($field eq "bmtmpfile") {  # 
            $bmtmpfile = $input{"bmtmpfile"}; 

	} elsif ($field eq "download_tmp") {  # 
            $download_tmp= $input{"download_tmp"}; 

	} elsif ($field eq "bm") {  #  for berkeley mapper -- info on whether or not there are georeferenced records
            $bm = $input{"bm"}; 

	} elsif ($field eq "max") {
            # it isn't used for text files
            $max_rows = $input{$field};

	} elsif ($field eq "table") {
	    # it isn't used for text files
	    $table = $input{$field}; 

	} elsif ($field eq "displaylist") { # calflora advanced query
            $displaylist = $input{$field};

	} elsif ($field eq "selectlist") {
	    $selectlist = $input{$field};

	} elsif ($field eq "special") {  # ceres headers
	    if ($input{$field} eq "all") {
		$allrecords = 1;
	    } else {
		$special = $input{$field};
	    }

	} elsif ($field eq "orderby") { 
	    # $debug_msg .= "<h4>Got field orderby: $input{$field}</h4>";
	    $orderby = $input{$field};

	} elsif ($field eq "orderby1") {
            $orderby = $input{$field};

	} elsif ($field eq "orderby2") {
            $orderby .= "|$input{$field}";

	} elsif ($field eq "groupby") { # yes or no
	    $groupby = $input{$field};
	    
        ## stuff for calflora buttons

	} elsif ($field eq "button_flag") { # yes or no
            $button_flag = $input{$field};

	} elsif ($field eq "searchstring") { # yes or no
            $searchstring = $input{$field};

	} elsif ($field eq "prevselect") { # yes or no
            $prevselect = $input{$field};

	} elsif ($field eq "output") {
	    $output = $input{$field};

	} elsif ($field eq "jointables") {  # img_all,img_blobs
            @jointables = split(/\,/,$input{$field});
	    $JOIN = 1;

	} elsif ($field eq "joincolumns") { # c.calrecnum=d.calrecnum
	    $joincolumns = $input{$field};
	
	} else {  
	    $debug_msg .= "$field: $input{$field}<br>";
	    
	    # special hacks:

	    
	    # strip out count in parens, as in <option>Airport (3)
	    $input{$field} =~ s/\(\d+\)$//g;  # <option>Airport (3)
	    $input{$field} =~ s/\(\d+\)\|/\|/g;  # Armenia (2)|Angola (2)


	    # ignore ...
	    $input{$field} =~ s/\.\.\.//g;

	    # where-County-l
	    # rel-County-l
	    # upper-genus

	    ($action,$fieldname,$tablecode) = split(/\-/,$field); 

	    if ($action eq "where") {
		# $debug_msg .= "In parse_input:<dd>where=$fieldname:$input{$field}<br>";
		$anywheres = 1; ## got a where clause
		if ($fieldname =~ /.*\w[1,2]$/ && 
		    $fieldname !~ /specno/ && $fieldname !~ /^Collector/ &&
		    $fieldname !~ /^source_id/) { # rank1,rank2
		    $save_where .= "$fieldname ";
		    # $debug_msg .= "(table: $table) savewhere: $save_where<br>";
		} 
		$where{$fieldname} .= " $input{$field}"; 
		$tcodes{$fieldname} .= " $tablecode";    
		# $debug_msg .= "where{fieldname} $fieldname = $where{$fieldname}<br>";

	    } elsif ($action eq "rel") {
		if ($fieldname =~ /.*\w[1,2]$/ && 
		    $table !~ /ucmp/ && 
		    $fieldname != /^source_id/) { # rank1,rank2
                    $save_rel .= "$fieldname ";
                }
		$rel{$fieldname} = $input{$field};
	    
	    } elsif ($action eq "upper") { # field should use Informix upper function
		$upperarray{$fieldname} = 1;
		

	    } else {   # lets assign the value to variable instead of throwing it away, ok?
		${$field} = $input{$field};
		$garbage .= " $input{$field}";
	    }
	}
    }
}


sub make_where_clause {  # called by build_query
    local($f) = @_;  # the fieldname

    ## see "subroutines for make_where_clause" below 
    ## make_where_clause assumes these values are available:
    ## $f  - -> $fieldname  such as "country"
    ## $rel{$f}  --> $relation  the relation, such as "equals" or "like"
    ## $where{$f} --> $val   the value, such as "null" or "Canada"

    if ($DEBUG) {
	$debug_msg .= "<h4>In make_where_clause</h4>";
	$debug_msg .= "f = $f: **$where{$f}**)<p>\n";
	$debug_msg .= "rel{f} = $rel{$f}\n";
    }
	
    $val = &strip($where{$f});
    
    ## to get an "is null" match, type null into the value on the form
    ## (i.e., don't try using "is null" as the relation)
    ## set relation and check for "is null"
    if ($val eq "null" || $val eq "NULL") { 
	$relation = "is null";
    } elsif ($val =~ /undetermined/ && $script_name ne "eme_species_query") { 
	$relation = "is null";
    } elsif ($val eq "notnull") {
        $relation = "is not null";
    } elsif ($rel{$f}) {
	$relation = $rel{$f};
    } else {
	# &check_for_relation_null;
	$relation = "eq";
    }
    $tcode = $tcodes{$f};

    $fieldname = &strip($f);

    ## special cases
    &check_for_fieldname_ends_ina_number;
    &check_for_relation_greater_than;
    &check_for_relation_less_than;
    &check_for_relation_equals;
    &check_for_fieldname_county;
    &check_for_fieldname_country;
    &check_for_fieldname_state;
    &check_for_fieldname_lifeform;
    &check_for_fieldname_datetime;
    &check_for_uppercase_informix_fields;  # old - dams, namesoup


    &add_wildcards_to_val;

    &make_subclause;  # also splits out "or" clauses
    &make_whereclause;

    if ($DEBUG) {
        $debug_msg .= "\n<h4>Leaving make_where_clause</h4>";
        $debug_msg .= "\t<dd>subclause: $subclause\n\twhereclause: $whereclause\n\n";
    }
}


sub build_query {

    if ($DEBUG) {$debug_msg .= "<h4>In build_query</h4>  selectlist: $selectlist<p>\n";}

    $firstwhere = 1;
    $firstselect = 1;

    # First, see which fields came in from the form with values.
    # If there's a value, call make_where_clause to add that in.

    if ($JOIN) {
	if ($DEBUG) {$debug_msg .= "\n<br>JOIN: jointables: @jointables";}
	foreach $s (@jointables) {
	    $schema1 = $s . "_schema";
	    if ($DEBUG) {$debug_msg .= "<br>\nlooking at $schema1\n";}
	    foreach $f (@$schema1) {
		# $debug_msg .= "<li>f: $f = ";
                $newf = $s . "." . $f;
		# $debug_msg .= "$where{$newf}";
		if ($where{$newf}) {
		    $gotwhere{$s} = 1;  
		    $debug_msg .= "<br>\ngot a join/where for |$s| (jointables=@jointables)\n";
		    &make_where_clause($newf);
		}
	    }
	}
	if ($DEBUG) {
	    $debug_msg .= "<br>\n***done with foreach s in jointables\n";
	    $debug_msg .= " ... whereclause: $whereclause\n";
	}
        # now check saved lists for repeated fields
        if ($save_where) {
            foreach $clear (@schema2) { $clear = ""; }    # clear out array
            @schema2 = split(/ /,$save_where);
	    ## ?? modify this?
            foreach $f (@schema2) {
                &make_where_clause($f);
            }
        }

    } else {  ## not a join
	if ($DEBUG) {$debug_msg .= "<br>build_query: not a join<p>";}
	$schema1 = $table . "_schema";  #  @occ from schema.p
	if ($DEBUG) {$debug_msg .= "<br>build_query: schema1: $schema1 : @$schema1<p>";}

	foreach $f (@$schema1) { 
	    # if ($DEBUG) {$debug_msg .= "<br>build_query:<dd>$f->|$where{$f}|";}
	    if ($where{$f}) {
		&make_where_clause($f);
	    }
	}
	# now check saved lists for repeated fields
	if ($save_where) {
	    if ($DEBUG) {$debug_msg .= "<br><font color=red>build_query: there's a save_where: $save_where</font>";}
	    foreach $clear (@schema2) { $clear = ""; }    # clear out array
	    @schema2 = split(/ /,$save_where);
	    foreach $f (@schema2) {
		&make_where_clause($f);
	    }
	}

    } # if JOIN

    # select table

    if ($JOIN) {  # tableA,tableB,tableC
	foreach $j (@jointables) {
	    $j = &strip($j);
	    ## doesn't matter if we got a where - still include table in select
	    ## if ($gotwhere{$j}) {
		$debug_msg .= "<br>JOIN [j=$j]: adding $j (jointables=|@jointables|)\n";
		$s .= "$j $joinalpha{$j},";
	    ##}
	}
	$selecttable = &remove_last_comma($s);
	if ($joincolumns) { # specifies columns to join tables by e.g. calflora.taxon=img.taxon
	    $whereclause .= " and " . $joincolumns;
	    $debug_msg .= "<br>\nJOIN COLUMNS: $joincolumns\n ";
	  $debug_msg .= "WHERE: $whereclause\n SELECTTABLE: $selecttable\n";
	}
	

    } else {
	$selecttable = $table;
    }

    ### selectlist

    $selectlist =~ s/\|/\,/g;
	
    if ($groupby) {  ## groupby is 'T' or blank

	if ($displaylist eq "default" || $displaylist eq "all 58 fields"
	    || $display_option eq "default" || $display_option eq "all") { # Essig 6/07

	    # ignore groupby 
	} else {
	    $groupclause = "GROUP BY $selectlist";
	    $selectlist = "count(*),$selectlist";
	    # $selectlist = "$selectlist,count(*)";  # why in this order?  6/10/05
	}
	if ($DEBUG) {
	    $debug_msg .= "<h4>build_query In if groupby</h4><dd>Groupby=$groupby  ";
	    $debug_msg .= "<dd>Displaylist=$displaylist ";
	    $debug_msg .= "<dd>Selectlist=$selectlist<p>\n";
	}
    }
    ## make sure anything in orderby is also in select
    if ($orderby) {
	if ($DEBUG) {
	    $debug_msg .= "<h4>build_query In orderby</h4><dd>Orderby=$orderby  ";
	    $debug_msg .= "<dd>Selectlist:$selectlist<p>\n";}
	if ($selectlist eq "*") { 
	    ## then anything in orderby is OK
	# } elsif (uc($orderby) =~ / ASC$/ || uc($orderby) =~ / DESC$/) {
	#    ## don't include it in select list  (added & then cmtd out 11/2005 GO)
	} else {  ## need to add it in
            foreach $clear (@orderarray) { $clear = ""; }    # clear out array
	    @orderarray = split(/\|/,$orderby);
	    foreach $f (@orderarray) {
		if ($f =~ /specno as unsigned integer/||
		    $table eq "ucmp_loc2") {  # also uses cast
		    # ignore it - ucmp2 default orderby
		} elsif ($selectlist !~ /$f/) {
		    $selectlist .= ",$f";
		    if ($groupby) {  # then add it to groupby too
			$groupclause .= ",$f";
		    }
		}
	    }

	}
	#$orderby =~ s/\|/,/;
	$orderby =~ s/\|/,/g;
	$orderclause = "ORDER BY $orderby";
	if ($DEBUG) {$debug_msg .= "### selectlist=$selectlist<br>*** orderclause=$orderclause\n";}

    }
    if (!$whereclause && !$allrecords && !$skipwherecheck) { # nothing selected
	$error = "<h4>Please enter a value to match</h4>\n";
    }
    
    $query = "SELECT $selectlist FROM $selecttable $whereclause $groupclause $orderclause";

    $debug_msg .= "<p><b>Build_query</b> Query: $query\n<p>";


}


sub check_max {

    # check for blank max
    if ($max_rows eq "") {        # default max
	$max_rows = 50;
    }

    if ($max_rows > $num_matches) { 
	$max_rows = $num_matches;
    }

    if (!$row_to_start) {
	$row_to_start = 0;
    } 

    print "<b>Number of matches</b>: $num_matches<br>\n";

    if (($num_matches > $max_rows) || ($row_to_start > 0)) {
        &print_page_button;
    }
}

sub check_max_no_print {

    # check for blank max
    if ($max_rows eq "") {        # default max
	$max_rows = 50;
    }

    if ($max_rows > $num_matches) { 
	$max_rows = $num_matches;
    }

    if (!$row_to_start) {
	$row_to_start = 0;
    } 

}

sub check_max_no_print_num_matches {

    # check for blank max
    if ($max_rows eq "") {        # default max
	$max_rows = 50;
    }

    if ($max_rows > $num_matches) { 
	$max_rows = $num_matches;
    }

    if (!$row_to_start) {
	$row_to_start = 0;
    } 

    if (($num_matches > $max_rows) || ($row_to_start > 0)) {
        &print_page_button;
    }
}

sub MethGet {
    return ($ENV{'REQUEST_METHOD'} eq "GET");
}

sub MethPost {
    return ($ENV{'REQUEST_METHOD'} eq "POST");
}


sub readParse {
    local (*in) = @_ if @_;
    local ($i, $key, $val);

    if ($DEBUG) {$debug_msg .= "<h4>In readParse</h4><p>\n";}

    ## check for a crash
    
    if ($CRASH) {  ## CRASH gets set in query_utils.p
	
	&print_default_header($heading);
	# print "<h3>Sorry, the database is temporarily offline for about a week ";
	print "<h3>Sorry, the database is offline for about a week ";
	print "while we do some major upgrades to the schema and the codebase.</h3>";
	# print "Please try again in a few minutes.";
	print "<p>This message was last updated <b>$crash_date</b><p>";
	&print_default_footer;
	exit;
    }

    # Read in text
    if (&MethGet) {
       $in = $ENV{'QUERY_STRING'};
    } elsif (&MethPost) {
        read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
    }
    
    $debug_msg .= "\n\n <b>IN</b> = $in\n\n<p>";

    $query_string = $in;
    foreach $clear (@in) { $clear = ""; }  # clear out array

    # changed 7/19/99 G.O.
    #@in = split(/[&;]/,$in);
    @in = split(/&/,$in);
    foreach $i (0 .. $#in) {
    # Convert plus's to spaces
     #   $debug_msg .= "$in[$i]<br>";
        $in[$i] =~ s/\+/ /g;

        # Split into key and value.
        ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.
	if ($val eq "any" || $val eq "none") {next;}

        # added May 2011
        # print "Content-type: text/html\n\n";
        my $unsafe = &check_safety_of_values($val);
        if($unsafe) {
            next;
        }
    # Convert %XX from hex numbers to alphanumeric
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
    # Associate key and value
        $in{$key} .= "|" if (defined($in{$key})); # multiple separator
        $in{$key} .= $val;
##	$debug_msg .= "<P>[$key] = $val<br>";
  }
   return scalar(@in);
}

# Adapted from readParse, but customized to work inside a service utility, esp. with custom debug messages
# Also with a special feature of ignoring any Plus symbols
sub readParseNoOutNoPlus {
    local (*in) = @_ if @_;
    local ($i, $key, $val);

    # Read in text
    #if (&MethGet) {
       $in = $ENV{'QUERY_STRING'};
    #} elsif (&MethPost) {
    #    read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
    #}
#
    foreach $clear (@in) { $clear = ""; }  # clear out array

    @in = split(/&/,$in);
    foreach $i (0 .. $#in) {

        # Split into key and value.
        ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.
        if ($val eq "any" || $val eq "none") {
            next;
        }
        # Convert %XX from hex numbers to alphanumeric
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
        # Associate key and value
        $in{$key} .= "|" if (defined($in{$key})); # multiple separator
        $in{$key} .= $val;
    }
    return scalar(@in);
}

# Adapted from readParse, but customized to work inside a service utility, esp. with custom debug messages
sub readParseNoOut {
    local (*in) = @_ if @_;
    local ($i, $key, $val);

    $in = $ENV{'QUERY_STRING'};

    foreach $clear (@in) { $clear = ""; }  # clear out array

    @in = split(/&/,$in);
    foreach $i (0 .. $#in) {
        $in[$i] =~ s/\+/ /g;

        # Split into key and value.
        ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.
    	if ($val eq "any" || $val eq "none") {
			next;
		}
    	# Convert %XX from hex numbers to alphanumeric
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
    	# Associate key and value
        $in{$key} .= "|" if (defined($in{$key})); # multiple separator
        $in{$key} .= $val;
  	}
   	return scalar(@in);
}

sub print_page_button {

    $debug_msg .= "<h4>In print_page_button</h4> script_name=$script_name<p>\n";
    $debug_msg .= "<font color=green>bmtmpfile = $bmtmpfile<p></font>\n";

#    if ($max_rows eq "") {
#	$max_rows = $input{'null-max-max'};
#    }
    if ($ONE_RECORD) {return;}

    $this_page = $row_to_start + $max_rows;


    print "<table cellpadding=0 cellspacing=0 noborder>\n";

    #### Previous Button

    if ($row_to_start > 0) {
	print "\n<!-- prev button -->\n";
        print "<tr><td valign=top>";
        if($script_name eq "pl_query" && $mvzpl) {
            print "<form action=\"../cgi-bin/pl_mvz_query\" method=post>\n";
        } elsif($script_name eq "eme_species_query") {
            print "<form action=\"../cgi-bin/$script_name\" method=get>\n";  
        } elsif($script_name eq "biocode_species_query") {
            print "<form action=\"../cgi-bin/$script_name\" method=get>\n";  
        } else {
            print "<form action=\"../cgi-bin/$script_name\" method=post>\n";  
        }

	&print_button_hidden_fields;

        print "<input type=submit name=prev value=\"prev $max_rows\">\n";
        $start = $row_to_start - $max_rows;
        print "<input type=hidden name=row-to-start value=\"$start\">\n";
    }
    print "</form></td>\n";   

    #### Next Button

    if ($this_page < $num_matches) {
	print "\n<!-- next button -->\n";
        print "<td valign=top>";
        if($script_name eq "pl_query" && $mvzpl) {
            print "<form action=\"../cgi-bin/pl_mvz_query\" method=post>\n"; 
        } elsif($script_name eq "eme_species_query") {
            print "<form action=\"../cgi-bin/$script_name\" method=get>\n";  
        } elsif($script_name eq "biocode_species_query") {
            print "<form action=\"../cgi-bin/$script_name\" method=get>\n";  
        } else {
            print "<form action=\"../cgi-bin/$script_name\" method=post>\n"; 
        }
	&print_button_hidden_fields;

        if (($this_page + $max_rows) > $num_matches) {
            $num_next = $num_matches - $this_page;
        } else {
            $num_next = $max_rows;
        }
        print "<input type=submit name=next value=\"next $num_next\">\n";
        $start = $row_to_start + $max_rows;
        print "<input type=hidden name=row-to-start value=\"$start\">\n";
    }
    print "</form></td>\n";
    print "</tr></table>\n";
}


sub print_button_hidden_fields {

    print "<input type=hidden name=query_src value=\"$query_src\">\n";
    print "<input type=hidden name=tmpfile value=\"$tmp\">\n";
    print "<input type=hidden name=num-matches value=\"$num_matches\">\n";
    print "<input type=hidden name=max value=\"$max_rows\">\n";
    print "<input type=hidden name=prevwhere value=\"$searchstring\">\n";  # causing a problem for mvz/ie
    print "<input type=hidden name=button_flag value=\"$button_flag\">\n";
    print "<input type=hidden name=prevselect value=\"$selectlist\">\n";
    print "<input type=hidden name=table value=\"$table\">\n";
    print "<input type=hidden name=special value=$special>\n";

    # for img table - no pics
    if ($input{'text_only'}) {
	print "<input type=hidden name=text_only value=\"1\">\n";
    }

    # for EME species query
    if ($input{'lfile'}) {
	print "<input type=hidden name=lfile value=$input{lfile}>\n";
    }
    if($script_name ne "eme_species_query" 
        && $script_name ne "eme_species_query_form"
        && $script_name ne "biocode_species_query" 
        && $script_name ne "biocode_species_query_form") {
        print "<input type=hidden name=OK2SHOWPRIVATE value=$OK2SHOWPRIVATE>\n";
    }
    if($script_name eq "biocode_collect_event_query") {
       print "<input type=hidden name=bmtmpfile value=\"$bmtmpfile\">\n";
       print "<input type=hidden name=bm value=\"$bm\">\n";
    }
    if($script_name eq "biocode_query") {
        print "<input type=hidden name=downloadfile value=$download_on>\n";
        print "<input type=hidden name=download_tmp value=$download_tmp>\n";
        print "<input type=hidden name=only value=$input{only}>\n";
    }
    ## CalPhotos

    ## display options for photo custom query
    if($script_name eq "img_query") {
	print "<input type=hidden name=display2 value=\"$input{display2}\">\n";
	print "<input type=hidden name=display3 value=\"$input{display3}\">\n";
	print "<input type=hidden name=display4 value=\"$input{display4}\">\n";
	print "<input type=hidden name=display5 value=\"$input{display5}\">\n";
	print "<input type=hidden name=display6 value=\"$input{display6}\">\n";
	print "<input type=hidden name=display7 value=\"$input{display7}\">\n";
	print "<input type=hidden name=display8 value=\"$input{display8}\">\n";
	print "<input type=hidden name=display9 value=\"$input{display9}\">\n";
	print "<input type=hidden name=display10 value=\"$input{display10}\">\n";
	print "<input type=hidden name=display11 value=\"$input{display11}\">\n";
	print "<input type=hidden name=display12 value=\"$input{display12}\">\n";
	print "<input type=hidden name=display13 value=\"$input{display13}\">\n";
	print "<input type=hidden name=title_tag value=\"$input{title_tag}\">\n";

    }

    # pldoc
    if($script_name eq "pl_query") {
	print "<input type=hidden name=specialmvz value=\"$specialmvz\">\n";
    }
    
    # for MVZ dump
    if($script_name eq "mvz_query") {
	print "<input type=hidden name=dump value=\"$dump_args\">\n"; 

	# for MVZ back link
	print "<input type=hidden name=backlink value=\"$backlink\">\n"; 
    }
    if($input{view}) {
	print "<input type=hidden name=view value=\"$input{view}\">\n";
    }
    if($input{display}) {
	print "<input type=hidden name=display value=\"$input{display}\">\n"; 
    }

    # for MVZ notebooks
    if ($input{'record_type'}) {
	print "<input type=hidden name=record_type value=$returntype>\n";
    }
    if($ENV{'REQUEST_URI'} =~ /mvz_volume_query/) {
	print "<input type=hidden name=orig_query value=$tmp_uri>\n";
    }

    # for displaying ID reviewed/not reviewed
    if ($input{'where-anno'}) {
	print "<input type=hidden name=where-anno value=1>\n";
    }

    # for supressing CalFlora thumbnail photo
    if ($where{no_thumbnail}) {
	print "<input type=hidden name=where-no_thumbnail value=\"1\">\n";
    }
}

sub get_one_record {
    my ($query, $database) = @_;
    my (@row);

    if(!$database) { 
        $database = "biocode";
    }  # else, database might equal "image" for example

    foreach $clear (@row) { $clear = ""; }  # clear out array

    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");
    if ( !defined $dbh ) {
        die "Cannot connect to mysql server: $DBI::errstr\n";
    }
    $sth = $dbh->prepare( $query )
        or die "Can't prepare statement: $DBI::errstr\n";
    $sth->execute;
    @row = $sth->fetchrow;
    $sth->finish;
    $dbh->disconnect;
    return @row;
}


sub get_multiple_records {

    # results are saved to $tmpdir/unknown_query by default
    #   or, set "$script_name

    if ($DEBUG) {$debug_msg .= "<h4>In get_multiple_records</h4>";}
    my ($query, $database) = @_;
    my ($count, $field, @row, $tmp);

    if(!$database) { 
        $database = "biocode";
    }  # else, database might equal "image" for example

    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");

    if ( !defined $dbh ) {
        die "Cannot connect to mysql server: $DBI::errstr\n";
    }

    $sth = $dbh->prepare( $query )
        or die "Can't prepare statement: $DBI::errstr\n";

    $sth->execute;

    #### Save query results to a temporary file

    chdir("$tmpdir/$script_name")
        || die "Can't change to $tmpdir/$script_name directory";
    $tmp = rand(1000000);
    $tmp = sprintf("%d",$tmp);

    while(-e $tmp) {
        $tmp = rand(1000000);
        $tmp = sprintf("%d",$tmp);
    }
    
    open(FH, ">>$tmp")
        || die "Can't open tmp file in $tmpdir/$script_name";

    foreach $clear (@row) { $clear = ""; }    # clear out array
    $row_count = 0;
    while ( @row = $sth->fetchrow ) {
        $count = 0;

        foreach $field (@row) {
	    
	    # really don;t want to strip, but AW breaks GO 12/12/2007 
	    if ($script_name =~ /^eme/) {
		# don't strip the field; instead replace mid-field line breaks
		$field =~ s/\n/\<br\>/g;
	    } else {
		#$field = strip($field);  
		$field =~ s/\n/\<br\>/g;
	    }
            if($count > 0) {
                print FH "\t";
            }
            print FH "$field";
            $count++;
        }
        print FH "\n";
	$row_count++;
    }
    close(FH);

    # $num_matches = $sth->rows;
    $num_matches = $row_count;
    $sth->finish;

    $dbh->disconnect;

    return $tmp;

}
sub get_num_matches {  # does a query and returns the number of matches
    ## see instead: &get_count

    if ($DEBUG) {$debug_msg .= "<h4>In get_num_matches</h4>";}
    my($query, $database) = @_;
    my($num_matches);

    if(!$database) {
        $database = "biocode";
    }  # else, database might equal "image" for example

#    $dbh = DBI->connect("dbi:mysql:$database");
    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");

    if ( !defined $dbh ) {
        die "Cannot connect to mysql server: $DBI::errstr\n";
    }
    if ($DEBUG) {$debug_msg .= "query: $query\n<br>";}
    $sth = $dbh->prepare( $query )
        or die "Can't prepare statement: $DBI::errstr\n";
    $sth->execute;
    chdir("/dev");
    my($tmp) = "/dev/null";
    open(FH, ">>$tmp")
        || die "Can't open tmp file in /dev";
    while ( @row = $sth->fetchrow ) {
	# busywork
    }
    close(FH);
    $num_matches = $sth->rows;
    $sth->finish;
    $dbh->disconnect;
    if ($DEBUG) {$debug_msg .= "num_matches: $num_matches\n<br>";}
    return $num_matches;

}

## do a query other than select (do insert or update)

sub process_queryMsg { 
    $pqmsg="";
    my ($query, $database) = @_;

    if(!$database) { 
        $database = "biocode";
    }  # else, database might equal "image" for example

    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");

    if ( !defined $dbh ) {
        $pqmsg .= "Cannot connect to mysql server: $DBI::errstr\n";
    }
    $sth = $dbh->prepare( $query )
         or $pqmsg  .= "Can't prepare statement: $DBI::errstr [$query]\n";
    $sth->execute 
        or $pqmsg .= "$DBI::errstr";
    $sth->finish;
    $dbh->disconnect;
    return $pqmsg;

}
sub process_query { 
    my ($query, $database) = @_;

    if(!$database) {   # JG added 11/20/03 for mysql
        $database = "biocode";
    }  # else, database might equal "image" for example

#    $dbh = DBI->connect("dbi:mysql:$database");
    $dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");

    if ( !defined $dbh ) {
        die "Cannot connect to mysql server: $DBI::errstr\n";
    }
    $sth = $dbh->prepare( $query )
         or die "Can't prepare statement: $DBI::errstr [$query]\n";
    $sth->execute; 
    ##print "\n\nExecution failed: $DBI::errstr\n\n";
    $sth->finish;
    $dbh->disconnect;

}




sub is_a_number {
    local($fieldname) = @_;

    foreach $n (@nontextfields) {  # in myschema.p
        if ($n eq $fieldname) {return 1;}
    }
    return 0;
}





sub ascii2html{
    $in = $_;
    $in =~ s/\r//g;       ## kill any carriage returns
    $in =~ s/\&/&amp;/g;  ## substitute ampersands
    $in =~ s/\"/&quot;/g; ## substitute any quotes
    $in =~ s/</&lt;/g;    ## substitute greater than signs
    $in =~ s/>/&gt;/g;    ## substitute lesser than signs
    $in =~ s/\n/<br>\n/g; ## subsutute line breaks with <br>
    chomp($in);
    return($in);
}


sub check_tmpfile {

    my ($tmpfile) = @_;
    $tmpfile = "$tmpdir/".$tmpfile;
 
    if(! -e $tmpfile) {
        print "Content-type: text/html\n\n";
        print "<body bgcolor=FFFFFF>\n";
        print "<h3>";
        print "Sorry, your session has expired. ";
        print "Please go back to the query page and re-submit your query.";
        print "</h3>";
        exit;
    }

}


sub get_country_name {  #given a two-letter code, get a name
    my ($country)= @_;

    my ($query) = "select name from country where code = '$country'";
    @row = &get_one_record($query);
    if (@row) {
        local($countryname) = $row[0];
        return $countryname;
    } else {
        return 0;
    }

}

sub get_state_name {  #given a two-letter abbrev. return a full name
    local($statecode)= @_;

    $state = &strip($state);
    local($query) = "select name from state where code = '$statecode'";
    @row = &get_one_record($query);
    if (@row) {
        $state_name = $row[0];
        return $state_name;
    } else {
        return 0;
    }

}

sub get_country_code {  #given a name, get a two-letter ISO 3166 code
    local($country)= @_;

    $country = &strip($country);
    $c_name = uc($country);
    local($query) = "select code from country where name = \"$c_name\" ";
    @row = &get_one_record($query);
    if (@row) {
        $country_code = $row[0];
        return $country_code;
    } else {
        return 0;
    }

}

sub get_region_code {  #given a name, get a region code (2-4 letters)
    local($region)= @_;

    $region = &strip($region);
    $r_name = uc($region);
    local($query) = "select name_code from region where name = \"$r_name\" ";
    @row = &get_one_record($query);
    if (@row) {
        $region_code = $row[0];
        return $region_code;
    } else {
        return 0;
    }

}
sub get_state_code {  #given a name, get a two-letter abbrev.
    local($state)= @_;

    $state = &strip($state);
    $c_name = uc($state);
    local($query) = "select code from state where name = '$c_name'";
    @row = &get_one_record($query);
    if (@row) {
        $state_code = $row[0];
        return $state_code;
    } else {
        return 0;
    }

}

sub get_county_name {  #given a three-letter code, get a name
    local($county)= @_;

    local($query) = "select name from county where code = '$county'";
    @row = &get_one_record($query);
    if (@row) {
        local($countyname) = $row[0];
        return $countyname;
    } else {
        return 0;
    }

}


sub get_county_code {  #given a name, get a three-letter code
    local($county)= @_;

    $county =~ s/.*\. (.*) *(COUNTY).*/$1/g;
    $county =~ s/^(.*) COUNTY.*/$1/g;
    $county =~ s/.*\. (.*) *(County).*/$1/g;
    $county =~ s/^(.*) County.*/$1/g;
    $county = &strip($county);
    if ($county =~ /\,/ || $county =~ /\//) {  # more than one county
        if ($county =~ /\,/) {
            @counties = split(/\,/,$county);
        }
        if ($county =~ /\//) {
            @counties = split(/\//,$county);
        }
        foreach $c (@counties) {
            $c = &strip($c);
        }
        @counties = sort @counties;
        $county = "";
        foreach $c (@counties) {
            $county .= "$c/";
        }
        $county =~ s/\/$//g;

    }
    $c_name = uc($county);
    local($query) = "select code from county where name = '$c_name'";
    @row = &get_one_record($query);
    if (@row) {
        $county_code = $row[0];
        return $county_code;
    } else {
        return 0;
    }

}


sub get_max_seq_num {

    local($table) = @_;
    local($seq) = "";

    $query  = "select max(seq_num) from $table";
    @row = &get_one_record($query);
    $seq = $row[0] +1;
    return $seq;
}

# adapting for elib vs image database GO 10/7/04
sub get_max_seq_num2 {

    local($table,$db) = @_;
    local($seq) = "";

    $query  = "select max(seq_num) from $table";
    @row = &get_one_record($query,$db);
    $seq = $row[0] +1;
    return $seq;
}


sub get_continent {  # given a 2-ltr country code, return continent
    ## Jan 2005: adding a check for Hawaii + add'l arg
    local($country,$state)= @_;

    if ($state eq "Hawaii" or $state eq "HI") {
	return "Pacific Ocean";
    } else {
	local($query) = "select continent from country where code = '$country'";
	@row = &get_one_record($query);
	if (@row) {
	    local($continent) = $row[0];
	    return &strip($continent);
	} else {
	    return 0;
	}
    }
}


sub get_count {  # just gets a count on a table
    # &get_count("img_flora","taxon='$taxon'");
    # see also: get_num_matches in /cgi/query_utils.p (which doesn't seem to work)

    local($table,$where) = @_;
    local($count,$query);

    if ($where) {
        $query = "select count(*) from $table where $where";
    } else {
        $query = "select count(*) from $table";
    }
    if ($DEBUG) {
        $debug_msg .= "<h4>In get_count: query=$query</h4>\n";
    }
    if($table eq "img" || $table eq "photographer") {
        @row = &get_one_record($query,"image");

    } else {
        @row = &get_one_record($query);
    }

    if ($row[0] >= 1) {
        $count = $row[0];
    } else {
        $count = 0;
    }
    if ($DEBUG) {
        $debug_msg .= "<h4>In get_count: count=$count</h4>\n";
    }
    return $count;
}


sub get_state_list_aw {
    my ($state_code) = @_;  
    my @state_long_list;

    @state_list = split(/\,/,$state_code);

    foreach $i (@state_list) {

        my $query = "select name from state where code = '$i'";
        my @row = &get_one_record($query);
        push(@state_long_list, $row[0]);

    }

    return @state_long_list;

}




#####################################
### subroutines for make_where_clause
#####################################

sub check_for_fieldname_ends_ina_number {
    # field names that end in '1' or '2' are dummies for html form - strip
    if ($fieldname =~ /.*[1,2]$/ && $table !~ /ucmp/ && 
	$fieldname !~ /^source_id/ && $table !~ /^eme/ && $table !~ /^biocode/) {
        if ($DEBUG) {$debug_msg .= "Dummy field $fieldname ${$fieldname}<br>";}
        $fieldname =~ s/(.*\w)[1,2]$/$1/g;
    }
}

sub check_for_relation_null {  ### no longer used - see line 850 "set relation"

    if ($DEBUG) {$debug_msg .= "<h4>entering check_for_relation_null val = $val</h4>";}

    if ($val eq "null" || $val eq "NULL" || $val =~ /undetermined/) {  # where-county=null
	$relation = "is null";
    } elsif ($val eq "notnull") {
        $relation = "is not null";
    } else {
	$relation = "eq";  # default: this lets you skip "rel-fieldname" on URL
    }


}

sub check_for_relation_greater_than {
    if ($relation eq "g.t." || $relation eq "gt" || 
	$relation eq "greater than" ||
	$relation eq "more than" ||
	$relation eq "after" || 
	$relation eq "is later than" ||
	$relation eq "north of" ||
	$relation eq "larger than" ||
	$relation eq "east of" ||
        $relation eq "above" ) {
	$relation = ">";
    } 
    if ($relation eq "g.t.e." || $relation eq "gte" ||  # added 8/8/00 Morosco
	$relation eq "greater than or equal" ||
	$relation eq "more than or equal" ||
	$relation eq "larger than or equal" ||
	$relation eq "after or equal" ||
        $relation eq "north of or equal" ||
        $relation eq "east of or equal" ||
        $relation eq "above or equal" ||
	$relation eq ">=" ) {
	$relation = ">=";
    }
}

sub check_for_relation_less_than {
    if ($relation eq "l.t." || $relation eq "lt" ||
	$relation eq "less than" ||
	$relation eq "is earlier than" ||
	$relation eq "before" || 
	$relation eq "south of" ||
	$relation eq "smaller than" ||
	$relation eq "west of" ||
	$relation eq "below") {
	$relation = "<";
    } 

     if ($relation eq "l.t.e." || $relation eq "lte" ||  # added 8/8/00 Morosco
        $relation eq "less than or equal" ||
        $relation eq "smaller than or equal" ||
	 $relation eq "before or equal" ||
        $relation eq "south of or equal" ||
        $relation eq "west of or equal" ||
        $relation eq "below or equal" ||
	 $relation eq "<=" ) {
	 $relation = "<=";
     }
}

sub check_for_relation_equals {
    if ($relation eq "eq." || $relation eq "eq" || $relation =~ /^equals/ || 
	$relation eq "is") {
	$relation = "=";
    } 
    if ($relation eq "ne." || $relation eq "ne" || $relation eq "does not equal" || 
	$relation eq "is not" || $relation eq "<>") {
	$relation = "!=";
    }
}

sub check_for_fieldname_county {
    ## 9/30/04 this is getting to be a mess - need to change it!
    ##
    if ($fieldname =~ /county/ && length($val) > 3 && $fieldname !~ /other_county/) { 	# example "Alpine" -> "ALP"
	if ($table ne "dams" && $table ne "img_cas_unscanned" 
	    && $table !~ /ucmp/ && $table !~ /eme/ && $table !~ /biocode/
	    && $table !~ /notebook/ && $table !~ /calmoth/) { 
	    if($val =~ /\|/) {                            # if have to get mutiple countries..
		@list = split(/\|/,$val);
		$val = "";
		foreach $l (@list) {
		    if ($DEBUG) {$debug_msg .= "<dd><li>l: |$l|\n";}
		    $l = &strip($l);
		    $val .= $county_names{$l};
		    $val = $val."|";
		}
		chop($val);                               # get rid of last |
	    } else {
		$val = $county_names{$val}; 
	    }
	} else {
	    ## leave it as it is
	}
    }
}

sub check_for_fieldname_country {
    if ($fieldname =~ /country/ && length($val) > 2 
	&& !$USE_STD_FIELDNAMES
	&& $table !~ /^efc/
	) {
	if($val =~ /\|/) {                            # if have to get mutiple countries..
            @list = split(/\|/,$val);
            $val = "";
            foreach $l (@list) {
                $val .= &get_country_code($l);
                $val = $val."|";
            }
            chop($val);                               # get rid of last |
        } else {
	    $val = &get_country_code($val);
	}
    }
}



sub check_for_fieldname_state {
    if ($fieldname eq "state" && length($val) > 2) {
	if ($table ne "img_cas_unscanned" && $table !~ /^efc/) {
	    if($val =~ /\|/) {        # if have to get mutiple states..
		@list = split(/\|/,$val);
		$val = "";
		foreach $l (@list) {
		    $val .= &get_state_code($l);
		    $val = $val."|";
		}
		chop($val);                               # get rid of last |
	    } else {
		$val = &get_state_code($val);
	    }
	}
    }
}

sub check_for_fieldname_lifeform {

    if ($fieldname eq "lifeform" && $table =~ /img/) {

	if ($val =~ /\|/) {     	## Animal--Invertebrate |Animal--Mammal 
	    if ($DEBUG) {
		$debug_msg .= "<h4>Got a genre--lifeform OR</h4>\n";
	    }
	    @list = split(/\|/,$val);  ## 
	    foreach $l (@list) {
		$l = &strip($l);
		if ($DEBUG) {
		    $debug_msg .= "<dd>$l";
		}
		if ($l =~ /(\S+)\-\-(\S+)/) {
		    $or_genre = &strip($1);
		    $or_life = &strip($2);
		    $lifeform_subclause .= " OR (lifeform = '$or_life' AND genre = '$or_genre')";
		}
	    }
	    $lifeform_subclause =~ s/^ OR //g;  # strip off the first OR
	} else {
	    if ($val =~ /(\S+)\-\-(\S+)/) {
		$val = $2;
		$extrawhere = " and genre = '$1' ";
	    }
	}
    }
}

sub check_for_uppercase_informix_fields {

    if ($uppercase{$table}) {  ## i.e., dams
	$val = uc($val);
    }
    if ($uppercase{$fieldname}) {  ## i.e., namesoup
        $val = uc($val);
    }

}

sub check_for_fieldname_datetime {  # added 5/4/2006  GO

    # for type datetime, query date only :
    #       where date(last_modified_date)="2006-05-03"

    if ($fieldname eq "last_modified_date") {
	$fieldname = "date(last_modified_date)";
    } elsif ($fieldname eq "creation_date") {
	$fieldname = "date(creation_date)";
    }
}


sub add_wildcards_to_val {
    if (!&is_a_number($fieldname)) {
	if ($relation eq "like" || $relation eq "contains") {
	    $val = "\"%" . $val . "%\"";
	 #   $val = "'%" . $val . "%'";
	    $relation = "like";
	    $t_fieldname = "$t_fieldname";
	} elsif ($relation eq "notlike") {  ## Added 2-9-99 TM
	    $val = "\"%" . $val . "%\"";
	    $relation = "not like";
	    $t_fieldname = "$t_fieldname";
	} elsif ($relation eq "begins with") {
	    $val = "\"" . $val . "%\"";
	  #  $val = "'" . $val . "%'";
	    $relation = "like";
	    $t_fieldname = "$t_fieldname";
	} elsif ($relation eq "ends with") {
            $val = "\"%" . $val . "\"";
            $relation = "like";
            $t_fieldname = "$t_fieldname";
	} elsif ($relation eq "match") {
	    $val = "$val";
	} elsif ($relation eq "matchboolean") {
	    $val = "$val";
	} elsif ($relation eq "matchphrase") {
	    $val = "$val";

	} else {
	    $val = "\"$val\"";
	  #   $val = "'$val'";
	}
    }
}

sub make_subclause {
    ## OR clause
    ##
    if ($DEBUG) {
        $debug_msg .= "\n<h4>Entering make_subclause</h4>";
        $debug_msg .= "\t<dd>subclause: $subclause\n\twhereclause: $whereclause\n\n";
    }

    if ($val =~ /\|/) { # Or clause needed:  
	if ($DEBUG) {$debug_msg .= "<h4>In make_subclause: OR clause needed: val=$val</h4>\n";}
	$subclause = "";
        foreach $clear (@orvals) { $clear = ""; }   # clear out array
	@orvals = split(/\|/,$val);

	if ($lifeform_subclause) {
	    $subclause .= " OR $lifeform_subclause";
	    $lifeform_subclause = "";

	} elsif ($val =~ /\%/) {  
	    foreach $o (@orvals) {
		$o =~ s/\%//g;
		$subclause .= " OR $fieldname $relation '%$o%'";
	    }
	} else {
	    foreach $o (@orvals) {
		$subclause .= " OR $fieldname $relation '$o'";
	    }
	}
	##
	$subclause =~ s/^ OR //g; 
	$subclause =~ s/\"//g; 
	$subclause =~ s/'/\"/g;
	$subclause = "($subclause)"; 

    } elsif ($upperarray{$fieldname}) {
        $val = uc($val);
        $subclause = "upper($fieldname) $relation $val";

    } elsif ($relation eq "is null" || $relation eq "is not null") { # added 11/13/00 G.O.
        $subclause = "$fieldname $relation";

    } elsif ($relation eq "match") { # added for mysql 6/4/03 J.G.
        $val =~ s/\'/\\'/g;
        $subclause = "match($fieldname) against('$val')";

    } elsif ($relation eq "matchboolean") { # added for mysql 7/7/03 J.G.  # modified 1/21/04
        $val =~ s/\'/\\'/g;
        $subclause = "match($fieldname) against('$val' IN BOOLEAN MODE)";

    } elsif ($relation eq "matchphrase") { # added for mysql 7/7/03 J.G.  # modified 1/21/04
        $val =~ s/\'/\\'/g;
#        $subclause = "match($fieldname) against('\"$val*\"' IN BOOLEAN MODE)";
        $subclause = "match($fieldname) against('\"$val\"' IN BOOLEAN MODE)";

    } else {
	$subclause = "$fieldname $relation $val";
    }
    if ($DEBUG) {
	$debug_msg .= "\n<h4>Leaving make_subclause</h4>";
        $debug_msg .= "\t<dd>subclause: $subclause\n\twhereclause: $whereclause \n\n";
    }
}

sub make_whereclause {

    if ($DEBUG) {
        $debug_msg .= "<h4>Entering make_whereclause</h4>\n";
    }

    if ($firstwhere) {  # gets set in sub build_query
	$whereclause = "WHERE $subclause";
	$firstwhere = 0;
    } else {
        if ($special eq "OR") {
 	    $whereclause .= " or $subclause";
            
        } else { # default
            $whereclause .= " and $subclause";
        }
    }
    if ($extrawhere) {
         $whereclause .= $extrawhere;
    }
    if ($DEBUG) {
	$debug_msg .= "<h4>Leaving make_whereclause</h4>\n";
	$debug_msg .= "whereclause = $whereclause<p>\n";
    }
}

sub check_safety_of_values {
    my ($val) = @_;
    my $unsafe = 0;
    # print "<font color=red>val: $val</font><br>";

    if($val =~ /information_schema/i) {
        $unsafe = 1;

    # union all
    } elsif($val =~ /union[(%2B)|\s]+all/i) {
        $unsafe = 1;

    # union select
    } elsif($val =~ /union[(%2B)|\s]+select/i) {
        $unsafe = 1;

    # and select
    } elsif($val =~ /and[(%2B)|\s]+select/i) {
        $unsafe = 1;

    # and ascii
    } elsif($val =~ /and[(%2B)|\s]+ascii/i) {
        $unsafe = 1;

    # and length
    } elsif($val =~ /and[(%2B)|\s]+length/i) {
        $unsafe = 1;

    # and exists
    } elsif($val =~ /and[(%2B)|\s]+exists/i) {
        $unsafe = 1;

    } elsif($val =~ /schema_name/i) {
        $unsafe = 1;

    # and 1, and 0, etc.
    } elsif($val =~ /and[(%2B)|\s]+[0-9]/i) {
        $unsafe = 1;
    }
    return $unsafe;
}



1; #return true
