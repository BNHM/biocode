#!/usr/bin/perl

# myimg_utils.p - G.O  9/6/98
#               - modified for BSCIT 12/2005 JG and GO
#               - modified for Biocode 06/2010 JG

require "biocode_settings";

$mogrify = "/usr/local/bin/mogrify";
$convert = "/usr/local/bin/convert";
$identify = "/usr/local/bin/identify";


# $DEBUG=1;

#$CRASH = 1;
$crash_date = "Wed Nov 22 17:50:59 PST 2006";


#############################################
#            subroutines
#############################################
# sub check_genre ($genre) 
# sub check_photographer ($photographer)
# sub genreLife2genre ($val)
# sub genreLife2life ($val)
# sub get_contact ($photographer)
# sub get_genre_from_lifeform ($lifeform)
# sub get_path ($disknum,$imgnum)
# sub get_path_from_kwid ($kwid)
# sub get_photographer_url
# sub get_thumbnail ($disknum,$imgnum,$orient)
# sub get_width ($orient)
# sub get_height ($orient)
# sub make_copyright ($photographer,$photo_date,$collectn)
# sub make_enlarge ($enlarge)
# sub print_calphotos_header ($heading,$title)
# sub print_calphotos_footer 
# print_enlargement_header ($heading,$title)
# sub print_thumbnail_usage
# sub print_enlarge_usage 

#############################################

sub get_path {
    # given disknum and imgnum, return pathname for jpeg

    local($disknum,$imgnum) = @_;

    local($disk1,$disk2,$disk3) = split(/ /,$disknum);
    $imgname = $imgnum . ".jpeg";
    $path = $disk1 . "_" . $disk2 . "/" . $disk3 . "/" . $imgname;
    return($path);

}

sub get_path_from_kwid {
    # given kwid, return pathname for jpeg

    local($kwid) = @_;

    local($disk1,$disk2,$disk3,$imgnum) = split(/ /,$kwid);
    $imgname = $imgnum . ".jpeg";
    $path = $disk1 . "_" . $disk2 . "/" . $disk3 . "/" . $imgname;
    return($path);

}

sub get_photographer_url {
    local($p) = $photographer;
    $p =~ s/\&/\%26/g;  # Lovell & Libby 
    $p =~ s/ /+/g;
    $photog_url = "http://calphotos.berkeley.edu/cgi/photographer_query?where-name_full=$p&one=T";
    return $photog_url;
}

sub get_thumbnail { ## gets all the image paths
    my ($disknum,$imgnum,$orient) = @_;

    my $imgurl = "";
    my $enl_kwid = "";

    if ($DEBUG) { $debug_msg .= "<h4>In get_thumbnail</h4><dd>disknum=$disknum, imgnum=$imgnum,orient=$orient";}

    my $h = &get_height($orient);
    my $w = &get_width($orient);
    my $path = &get_path($disknum,$imgnum);
    
    my $tnail_url = "http://biocode.berkeley.edu/imgs/128x192/$path";

    if (!$kwid) {
	$kwid = "$disknum $imgnum";
    }
    $enl_kwid = $kwid;
    $enl_kwid =~ s/ /\+/g;


    if($taxon) {   # added 5/2008 - jg
        $alt_tag = $taxon;
        $alt_tag =~ s/"/ /g;
    } else {
        $alt_tag = "click for enlargement";
    }
    if($taxon) {   # added 5/2008 - jg
        $title_tag = $taxon;
        $title_tag =~ s/"/ /g;
    } else {
        $title_tag = "click for enlargement";
    }

    $imgurl = "<a href=/cgi/biocode_img_query?enlarge=$enl_kwid>\n";
    $imgurl .= "<img border=0 ";
    $imgurl .= "src=$tnail_url alt=\"$alt_tag\" title=\"$title_tag\"></a>\n";
    
    return $imgurl;

}


sub print_thumbnail_usage {

    my($photographer) = @_;

    # print "<font color=red>photographer: $photographer</font><br>";
    # print "<font color=red>contact: $contact</font><br>";

    #  John White white@hotmail.com
    # ($contact_name,$contact_email) = split(/\:/,$contact);
    if ($contact =~ /^(.*)\:* +([^ ]+)$/) {
	$contact_name = $1;
	$contact_email = $2;
    }

    # print "<font color=red>contact_email: $contact_email</font><br>";

    $contact_email = &strip($contact_email);
    # $contact_email =~ s/\@/\[AT\]/g;
    $contact_name =~ s/email//g;
    $contact_name =~ s/\://g;

    if (!$contact_email) {
	$contact_name = "CalPhotos";
	$contact_email = "calphotos[AT]lists.berkeley.edu";
    }

    $photog_url = &get_photographer_url($photographer); 


    if ($copyright eq "public domain") {
	print "This photo is in the public domain and may be freely used for any purpose. ";
	print "Please credit the photographer $photographer. \n";
	print "If you have questions, contact $contact_name ";
	print "<a href=\"mailto:$contact_email\">$contact_email</a>. ";
    } else {
	
	print "The thumbnail photo (128x192 pixels) on this page may be freely used for personal or academic ";
	print "purposes without prior permission under the Fair Use provisions of US copyright law ";

        print "as long as the photo is clearly credited with <b>";
        $print_copy = $copyright;
        $print_copy =~ s/ /\&nbsp\;/g;
        print "&copy;&nbsp;$print_copy</b>.\n ";
	    
	print " For other uses, or if you have questions, contact $contact_name ";
	print "<a href=\"mailto:$contact_email\">$contact_email</a>. ";
        if($contact_email =~ /\[AT\]/) {
            # print "<small>(Replace the [AT] with the @ symbol before sending an email.)</small>";
            print "(Replace the [AT] with the @ symbol before sending an email.)";
        } elsif($contact_email =~ /_NO_SPAM/) {
            # print "<small>(Remove \"_NO_SPAM\" from this email address before sending an email.)</small>";
            print "(Remove \"_NO_SPAM\" from this email address before sending an email.)";
        }
    }
}



sub print_enlarge_usage {

    # $contact_email =~ s/\@/\[AT\]/g;



    local($query) = "select contact_name,contact_email,usage_enlarge from photographer where name_full=\"$photographer\"";
    @row = &get_one_record($query, "image");
    # assume we have a valid name!
    local($contact_name) = $row[0];
    local($contact_email) = $row[1];
    local($usage_enlarge) = $row[2];


    if(!$usage_enlarge) {
        # if no special enlargement usage info, then use contact & copyright from image record,
        # instead of what's in photographer record, since it may be different from one image to another
        if ($contact =~ /^(.*)\:* +([^ ]+)$/) {
            $contact_name = $1;
            $contact_email = $2;
        }
        $contact_email = &strip($contact_email);
        $contact_name =~ s/email//g;
        $contact_name =~ s/\://g;

        $contact = &strip($contact);
        if (!$contact_email) {
            $contact_name = "CalPhotos";
            $contact_email = "calphotos[AT]lists.berkeley.edu";
        }
    }
    
    if ($usage_enlarge) {
	print "$usage_enlarge ";
	print "Contact $contact_name <a href=\"mailto:$contact_email\">$contact_email</a> ";
	print "for more information.";

    } elsif ($copyright eq "public domain") {
	print "This photo is in the public domain and may be freely used for any purpose. ";
        print "Please credit the photographer $photographer. \n";
        print "If you have questions, contact $contact_name ";
        print "<a href=\"mailto:$contact_email\">$contact_email</a>. ";

    } else {  ## default
	print "This photo and associated text may not be used except with ";
	print "express written permission from $contact_name. ";
	print "To obtain permission for personal, academic, commercial, ";
	print "or other uses, or to inquire about high resolution images, ";
	print "prints, fees, or licensing, or if you have other ";
	print "questions, contact $contact_name ";
	print "<a href=\"mailto:$contact_email\">$contact_email</a>. ";
        if($contact_email =~ /\[AT\]/) {
            print "<small>(Replace the [AT] with the @ symbol before sending an email.)</small>";
        } elsif($contact_email =~ /_NO_SPAM/) {
            print "<small>(Remove \"_NO_SPAM\" from this email address before sending an email.)</small>";
        }

    }
}



sub print_data_usage {

    print "Please request permission from $contact_name <a href=\"mailto:$contact_email\">$contact_email</a> ";
    print "before using or storing text from multiple ";
    print "photos, such as scientific and common names, locations, dates, and notes.";

}





#################################################################
###  converting stuff on query form
#################################################################

sub genreLife2life {  #Plant--fern -> fern
    local($val) = @_;

    $val =~ s/\S+\-\-(\S+)/$1/g;  # strip out genre
    return $val;
}

sub genreLife2genre { # Plant--fern -> Plant
    local($val) = @_;

    $val =~ s/(\S+)\-\-\S+/$1/g;  # strip out lifefrom
    return $val;
}

#################################################################
###  utilities for img table
#################################################################


sub get_contact {
    local($photographer) = @_;

    local($query) = "select contact from photographer where name_full = '$photographer'";
    @row = &get_one_record($query, "image");
    local($contact) = &strip($row[0]);
#    $cmts .= "<dd><li><b>contact:</b> $contact (from photographer database)";
    return $contact;
}

sub get_genre_from_lifeform {
    local($lifeform) = @_;

    if (!$lifeform) {
	return "";
    }
    local($query) = "select genre from img_lifeform where lifeform = '$lifeform'";
    @row = &get_one_record($query,  "image");
    local($genre) = &strip($row[0]);
    return $genre;
}



sub check_genre { # make sure it's a valid one
    local($genre) = @_;

    local($query) = "select count(*) from img_lifeform where genre='$genre'";
    @row = &get_one_record($query, "image");
    $matches = $row[0];
    if ($matches > 0) {
	return $genre;
    } else {
	$bad_msg .= "<dd><li><b>Did not recognize genre \"$genre\"\n";
	return 0;
    }
}


sub check_photographer { # make sure it's a valid one
    local($photographer) = @_;

    # check for last name, first name
    if ($photographer =~ /,/) {
	## Tom Smith, Jr. (not addressing "Smith, Jr., Tom"

	if ($photographer =~ /Jr\.*$/) {  # ignore if "Jr."

	} else {
	    ($last,$first) = split(/,/,$photographer);
	    $photographer = &strip("$first $last");
	}
    }
    if ($debugging) {
	$cmts .= "<dd><li><b>check_photographer: using \"$photographer\" (debug info)\n";
    }
    local($query) = "select count(*) from photographer where name_full='$photographer'";

    @row = &get_one_record($query, "image");
    $matches = $row[0];
 #   $debug_msg .= "check_photographer: matches for $photographer = $matches\n";
    if ($matches eq 1) {
	return $photographer;
    } else {
	$bad_msg .= "<dd><li><b>Did not recognize photographer \"$photographer\"\n";
	return 0;
    }
}







sub make_copyright {  # "John Game,1999-02-28"
    local($photographer,$photo_date,$collectn) = @_;

    $date_year = $photo_date;
    $date_year =~ s/^(\d\d\d\d)\-\d\d\-\d\d/$1/g;

    if ($photographer eq "Unknown" ) {
	
	if ($collectn && $collectn ne "Private") {
	    $copyright = "$date_year $collectn";
	} else {
	    $copyright = "";
	}
	return $copyright;
    }
    local($query) = "select copyright from photographer where name_full = '$photographer'";
    @row = &get_one_record($query, "image");

    local($photog_copyright) = @row;

    if ($photog_copyright) {
	$copyright = "$date_year $photog_copyright";

    } elsif ($photographer ne "Unknown" && ($collectn eq "Private" || $collectn eq "AmphibiaWeb" || $collectn eq "CalState")) {
        $copyright = "$date_year $photographer";

    } else {
	$bad_msg .= "<dd><li><b>Copyright:</b> don't know how to make copyright for collection \"$collectn\" and photographer \"$photographer\" ";
    }
    return $copyright;
}


sub get_width{
    local($orient) = @_;

    if ($orient eq "V") {
        $w = "128";
    } else {
        $w = "192";
    }
    return $w;
}



sub get_height{
    local($orient) = @_;

    if ($orient eq "V") {
        $h = "192";
    } else {
        $h = "128";
    }
    return $h;
}



sub make_enlarge {
    local($enlarge) = @_;
    
    if ($enlarge  =~ /4X/) {  # 512x768
        $enlarge = 3;
    } elsif ($enlarge =~ /2X/) { # 256x384
        $enlarge = 2;
    } else {
        $enlarge = 1;  # thumbnail only
    }
    return $enlarge;
}








####### Browse List utilities




sub print_calphotos_header {
    local($heading,$title) = @_;  # 

    print "Content-type: text/html\n\n";

    print "<html><head>\n";
    print "<title>";

    print "Moorea Biocode Photos: $title\n";
    print "</title>\n";

    # stylesheet from /head1.html
    print "<style type=\"text/css\">\n";
    print "p, td, th, body {font-family: arial, verdana, helvetica, sans-serif;}\n";
    print "p, td, th, body {font-size: 12px;}\n";
    print "a.nounderline {text-decoration: none; color:  white; outline: none;}\n";
    print "\"a.subtle_link {text-decoration: none; font-size: 10px; outline: none;}\n";
    print "</style>\n";
    print "</head>\n";
    print "<BODY BGCOLOR=#FFFFFF>\n";
    print "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>";

    ## silver left square
    print "<tr><td width=5% bgcolor=DFE5FA><br></td>";
    print "<td align=left valign=bottom>\n";
    print "<table border=0 cellpadding=5><tr>";
    print "<td align=left valign=bottom>";
    print "<font face=\"Helvetica,Arial,Verdana\" color=23238E>";
    #print "<big><big><big>$heading</big></big></big></font>&nbsp;&nbsp;&nbsp;&nbsp;";
    print "<big><big><big><a href=/query_photos.html>Moorea Biocode Photos</a></big></big></big></font>&nbsp;&nbsp;&nbsp;\n";
    if ($heading) {
	print "<big><big>$heading</big></big>\n";
    } else {
	print "Photo Database";
    }
    print "</td></table>\n</td></tr>\n";
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

sub print_enlargement_header {
    local($heading,$title) = @_;  # caption
    
    print "Content-type: text/html\n\n";
    print "<html><head>\n<title>";
    print "Moorea Biocode Photos\n";
    print "</title>\n";
    # stylesheet from /head1.html
    print "<style type=\"text/css\">\n";
    print "p, td, th, body {font-family: arial, verdana, helvetica, sans-serif;}\n";
    print "p, td, th, body {font-size: 12px;}\n";
    print "a.nounderline {text-decoration: none; color:  white; outline: none;}\n";
    print "\"a.subtle_link {text-decoration: none; font-size: 10px; outline: none;}\n";
    print "</style>\n";
    print "</head>\n";

    print "<BODY BGCOLOR=#FFFFFF>\n";
    print "<table align=center border=0 width=90% cellspacing=0 cellpadding=0>";
    
    ## silver left square
    print "<tr><td width=5% bgcolor=DFE5FA><br></td>";
    print "<td align=left valign=bottom>\n";
    print "<table border=0 cellpadding=5><tr>";
    print "<td align=left valign=bottom>";
    print "<font face=\"Helvetica,Arial,Verdana\" color=23238E>";
    

    print "<big><big><big><a href=/query_photos.html>Moorea Biocode Photos</a></big></big></big></font>&nbsp;&nbsp;&nbsp;&nbsp;";
    print "Photo Database";

    print "<font face=\"Helvetica,Arial,Verdana\" color=23238E>";
    print "<p><big>$heading</big></font> &nbsp;&nbsp;";

    if($source_id_1) {
        print "&nbsp;&nbsp;$source_id_1&nbsp;&nbsp;&nbsp;";
    }
    

    print "(<a href=/cgi/biocode_img_query?seq_num=$seq_num&one=T>";
    print "view details</a>)";
    
    print "</td></table>\n</td></tr>\n";
    
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


sub print_calphotos_footer {
    # from ./myquery_utils.p/print_default_footer

    local($footer_info) = @_;  # add'l info in lt. blue bottom bar

    if (($max_rows || $row_to_start) &&
	 ($num_matches > $max_rows) || ($row_to_start > 0)) {
        &print_page_button;
	# print "<h4>NUM_MATCHES=|$num_matches| MAX_ROWS=|$max_rows|  ROW_TO_START=|$row_to_start|</h4>\n";
     }
    print "</td></tr>";  ## close out header/body cell
    ## bottom lt. blue section
    print "<tr><td colspan=2 bgcolor=DFE5FA>";
    if ($footer_info) {
        print "$footer_info";
    } else {
        print "<br>";
    }

    print "<center><small>Copyright &copy 1995-2010 UC Regents. ";
    print "All rights reserved.</small></center><br>";
    print "</td></tr>";
    print " </table>\n";

    print "<p><center>\n";
    print "Images served by <a href=http://calphotos.berkeley.edu>CalPhotos</a>, which is a project of ";
    print "<a href=http://bscit.berkeley.edu>BSCIT</a>";
    print "&nbsp;&nbsp;&nbsp;&nbsp;University of California, Berkeley";
    
    print "</table></center><p></small></font>\n";
    if ($DEBUG) {print $debug_msg;}
    print "\n</body></html>";
}


sub get_display_email {
    my ($c_email,$display_email) = @_;

    # uncomment to debug:
    # print "<br>in get_display_email:<br>display_email: $display_email<br>c_email: $c_email<br>";

    if($display_email eq "bracketat") {
        $c_email =~ s/\@/\[AT\]/g;
    } elsif($display_email eq "nospam") {
        $c_email =~ s/\@/_NO_SPAM\@/g;
    } elsif($display_email eq "spaceat") {
        $c_email =~ s/\@/ AT /g;
    } elsif($display_email eq "nochange") {
        # no change
    }

    return $c_email;

}


sub make_one_thumbnail {

    my ($source, $thumbnail) = @_;
    my $junk1, $junk2, $junk3, $junk4, $dimensions;
    my $width, $height, $orient;
    my $command;
    my $identify_output;

    $identify_output = `$identify "$source"`;
    if($DEBUG) { print "identify command: $identify \"$source\"<p>\n"; }
    if($DEBUG) { print "identify: $identify_output<p>\n"; }
    ($junk1, $junk2, $dimensions, $junk3, $junk4, $junk5) = split(/\s+/,$identify_output);
    ($width,$height) = split(/x/,$dimensions);
    if($width >= $height) {
        $orient = "H";
    } else {
        $orient = "V";
    }

    if($DEBUG) { print "original size: orient=$orient w:$width h:$height<p>\n";}


    if($orient eq "H") {
        $command = "$convert \"$source\" -density 72x72 -units PixelsPerInch -quality 100 -geometry 192x128 $thumbnail";
    } else {   # orientation eq "V"
        $command = "$convert \"$source\" -density 72x72 -units PixelsPerInch -quality 100 -geometry 128x192 $thumbnail";
    }
    if($DEBUG) { print "mogrify command: $command<p>\n"; }
    system("$command");

}



1; #return true

