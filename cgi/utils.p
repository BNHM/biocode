#!/usr/bin/perl

# utils.p  GO  4/23/03 - generic utilities and variables

require "biocode_settings";

# Needed for pnm utilties:
$ENV{'LD_LIBRARY_PATH'} = "/usr/local/lib/:/lib:/usr/lib:/usr/local/src/jpeg-6b:/usr/local/netpbm/lib:/usr/X11R6/lib";


# bgcolors  background colors (used for forms)
$essig_blue_color = "#669ACC";
$gray_color = "#D1D1D1";
$lt_bluegray_color = "#DFE5FA";  # eme_add_specimens
$lt_sage_color = "#E7E8E0";   # eme_add_specimens
$ucmp_peach = "#FFCC99";
$ucmp_green = "#006666";


# misc
#-------------------
# %mimetypes
# sub check_select_lists_for_name($list,$name)  #  /usr/local/bscit/select_lists/$list

#   dates
#-------------------
# %month_name2number
# %mo_nums
# %nums_mo
# %mo_name
# %num_days
# %month_name2number  # $month_number=$month_name2number{"Apr"};
# %mo_nums   #  $moname=$mo_nums{01};  01 -> Jan
# %mo_nums_1 #  $moname=$mo_nums{1};  1 -> Jan
# %mo_nums_2 #  $moname=$mo_nums{1};  1 -> January
# %nums_mo   #  $monum=$nums_mo{$num};  Jan -> 01
# %mo_name   #  $monum=$mo_names{uc($month)};  uc(jan) -> 01
# %num_days  #  $num_days{'Jan'} -> 31


# caseize & clean up 
#-------------------
# sub caseize_author($author)
# sub caseize_cname($cname)
# sub caseize_higher_taxonomy  # Initial cap - Family, Order, etc.
# (note caseize_taxon is in myimg_utils (why?)
# sub caseize_plant_taxon($taxon)
# sub caseize_placename($placename)
# sub strip($words)
# sub add_commas($val)        ## 1303 -> 1,303
# sub remove_last_comma($line)## 1,2,3, -> 1,2,3
# sub reverse  # reverse a sorted array (9/05 not below?)
# sub urlify   ## "genus species" -> "genus+species"

# computation
#-------------------
# sub get_orientation($pic)
# sub feet2meters($feet)
# sub fathoms2meters($fathoms)


#  geography
#-------------------
# %country_codes
# %country_names
# sub get_country_code_from_array
# sub country_name_is_valid($inc_country) # is it in %country_names
# sub standardize_country_and_state_name($country,$state_prov,$cat_num)
# sub print_country_options_all ($selected_country)  ## see also in myimg_utils.p

# %state_codes
# %state_names
# %state_names_pretty
# sub get_state_name_from_array
# sub get_state_code_from_array
# sub print_state_options_all ($selected_state)      ## see also in myimg_utils.p

# %county_codes
# %county_names
# @Cal_county_names_array
# sub standardize_county_name($county,$state_prov,$cat_num)
# sub get_county_name_from_array
# sub get_county_code_from_array
# sub print_Cal_county_options ($selected_county)

# @HorizontalDatums
# sub degrees2decimal($degrees, $minutes, $seconds, $direction)
# sub add_degree_symbols($lat_or_long)
# sub check_degree_lat_lon($lat_deg,$lat_min,$lat_sec ...)  # ucmp_add_locality
# sub check_decimal_lat_lon($lat,$lon,$cat_num)  # ucmp_add_locality
# sub check_decimal_lat_lon_by_country($lat,$lng,$country) 
# sub check_lat_long_dep_elev  # essig and biocode
# sub is_a_valid_HorizontalDatum
# sub print_HorizontalDatum_options


#  dates
#-------------------
# sub make_date($indate) ## using this one for mysql
# sub make_informix_date ## old version of make_date
# sub get_todays_date  yyyy-mm-dd
# sub print_date_options ($selected_date, $date_prec)
# sub make_pretty_date($date) ## 01/02/1998 -> Jan 02, 1998
# sub make_pretty_date2($date) ## 1998-01-02 -> Jan 02, 1998
# sub make_pretty_date3($mo,$da,$yr) ## (5,21,1965) -> May 21, 1965
# sub get_time
# sub get_all_the_dates      ## sets $today, $this_mon, etc.
# sub check_year($year)      ## makes sure it's reasonable
# sub check_mon_day($mo,$da) ## ditto
# sub checkYMD($yr,$mo,$da)  ## basic checks on m/d/y
# sub check_datetime_format($inc_date) # ensure yyyy-mm-dd hh:mm:ss
# sub get_last_mon_num($this_mon)  ## returns last month's number
# sub get_yesterday($yyyy,$m,$d) ## returns the day before
# sub is_a_leap_year($yyyy)
# sub rm_time_trailing_zeros  ## 08:00:00 -> 08
# sub print_date_options ($selected_date, $date_prec)

# numbers
#-------------------
# sub is_an_integer
# sub is_a_decimalnumber
# sub rm_decimal_trailing_zeros  ## 3.5600 -> 3.56

# taxonomy
#-------------------
# @kingdoms
# @arthropod_classes
# @arthropod_orders
# %arthropod_orders_cnames
# @insect_classes
# @insect_orders
# %insect_orders_cnames
# sub print_kingdom_options ($selected_kingdom)


# headers & footers, etc. "ss" = serverside includes
#---------------------------
# sub make_ss_header($title)
# sub print_ss_header($title)
# sub make_ss_footer  ## returns as a var 8/25/03 
# sub print_ss_footer ## prints it out 8/25/03
# sub print_bad_msg
# sub print_processing_notes


$TODAY = &get_todays_date;

&get_all_the_dates;  # $MSQL_DATETIME 2005-10-26 09:47:12

@HorizontalDatums = ("NAD1927","NAD1983","WGS1984", "unknown");

# $month_number=$month_name2number{"Apr"};
%month_name2number = (Jan,1,Feb,2,Mar,3,Apr,4,May,5,Jun,6,Jul,7,Aug,8,Sep,9,Oct,10,Nov,11,Dec,12);


# $moname=$mo_nums{$month};
%mo_nums = (
            '01', 'Jan',
            '02', 'Feb',
            '03', 'Mar',
            '04', 'Apr',
            '05', 'May',
            '06', 'Jun',
            '07', 'Jul',
            '08', 'Aug',
            '09', 'Sep',
            '10', 'Oct',
            '11', 'Nov',
            '12', 'Dec'
            );


# $moname=$mo_nums_1{$month};
%mo_nums_1 = (
            '1', 'Jan',
            '2', 'Feb',
            '3', 'Mar',
            '4', 'Apr',
            '5', 'May',
            '6', 'Jun',
            '7', 'Jul',
            '8', 'Aug',
            '9', 'Sep',
            '10', 'Oct',
            '11', 'Nov',
            '12', 'Dec'
            );

# $moname=$mo_nums_2{$month};
%mo_nums_2 = (
            '1', 'January',
            '2', 'February',
            '3', 'March',
            '4', 'April',
            '5', 'May',
            '6', 'June',
            '7', 'July',
            '8', 'August',
            '9', 'September',
            '10', 'October',
            '11', 'November',
            '12', 'December'
            );


# $monum=$nums_mo{$num};

%nums_mo = (
            'Jan', '01',
            'Feb', '02',
            'Mar', '03',
            'Apr', '04',
            'May', '05',
            'Jun', '06',
            'Jul', '07',
            'Aug', '08',
            'Sep', '09',
            'Oct', '10',
            'Nov', '11',
            'Dec', '12'
            );


# $monum=$mo_names{uc($month)};

%mo_names = (
             'JAN', '01',
             'JANUARY', '01',
             'FEB','02',
             'FEBRUARY','02',
             'MAR',  '03',
             'MARCH',  '03',
             'APR', '04',
             'APRIL', '04',
             'MAY', '05',
             'JUN', '06',
             'JUNE', '06',
             'JUL', '07',
             'JULY', '07',
             'SUMMER', '07',
             'AUG', '08',
             'AUGUST', '08',
             'SEP', '09',
             'SEPT', '09',
             'SEPTEMBER', '09',
             'OCT', '10',
             'OCTOBER', '10',
             'NOV', '11',
             'NOVEMBER', '11',
             'DEC', '12',
             'DECEMBER', '12'
);


%num_days = (
             'Jan',31,
             'Feb',29,
             'Mar',31,
             'Apr',30,
             'May',31,
             'Jun',30,
             'Jul',31,
             'Aug',31,
             'Sep',30,
             'Oct',31,
             'Nov',30,
             'Dec',31
             );


%mimetypes = (
    'ai' => 'application/postscript',
    'aif' => 'audio/x-aiff',
    'aifc' => 'audio/x-aiff',
    'aiff' => 'audio/x-aiff',
    'asc' => 'text/plain',
    'au' => 'audio/basic',
    'avi' => 'video/x-msvideo',
    'bcpio' => 'application/x-bcpio',
    'bin' => 'application/octet-stream',
    'bmp' => 'image/bmp',
    'cdf' => 'application/x-netcdf',
    'class' => 'application/octet-stream',
    'cpio' => 'application/x-cpio',
    'cpt' => 'application/mac-compactpro',
    'csh' => 'application/x-csh',
    'css' => 'text/css',
    'dcr' => 'application/x-director',
    'dir' => 'application/x-director',
    'djv' => 'image/vnd.djvu',
    'djvu' => 'image/vnd.djvu',
    'dll' => 'application/octet-stream',
    'dms' => 'application/octet-stream',
    'doc' => 'application/msword',
    'dvi' => 'application/x-dvi',
    'dxr' => 'application/x-director',
    'eps' => 'application/postscript',
    'etx' => 'text/x-setext',
    'exe' => 'application/octet-stream',
    'ez' => 'application/andrew-inset',
    'gif' => 'image/gif',
    'gtar' => 'application/x-gtar',
    'hdf' => 'application/x-hdf',
    'hqx' => 'application/mac-binhex40',
    'htm' => 'text/html',
    'html' => 'text/html',
    'ice' => 'x-conference/x-cooltalk',
    'ief' => 'image/ief',
    'iges' => 'model/iges',
    'igs' => 'model/iges',
    'jpe' => 'image/jpeg',
    'jpeg' => 'image/jpeg',
    'jpg' => 'image/jpeg',
    'js' => 'application/x-javascript',
    'kar' => 'audio/midi',
    'latex' => 'application/x-latex',
    'lha' => 'application/octet-stream',
    'lzh' => 'application/octet-stream',
    'm3u' => 'audio/x-mpegurl',
    'man' => 'application/x-troff-man',
    'me' => 'application/x-troff-me',
    'mesh' => 'model/mesh',
    'mid' => 'audio/midi',
    'midi' => 'audio/midi',
    'mif' => 'application/vnd.mif',
    'mov' => 'video/quicktime',
    'movie' => 'video/x-sgi-movie',
    'mp2' => 'audio/mpeg',
    'mp3' => 'audio/mpeg',
    'mpe' => 'video/mpeg',
    'mpeg' => 'video/mpeg',
    'mpg' => 'video/mpeg',
    'mpga' => 'audio/mpeg',
    'ms' => 'application/x-troff-ms',
    'msh' => 'model/mesh',
    'mxu' => 'video/vnd.mpegurl',
    'nc' => 'application/x-netcdf',
    'oda' => 'application/oda',
    'pbm' => 'image/x-portable-bitmap',
    'pdb' => 'chemical/x-pdb',
    'pdf' => 'application/pdf',
    'pgm' => 'image/x-portable-graymap',
    'pgn' => 'application/x-chess-pgn',
    'png' => 'image/png',
    'pnm' => 'image/x-portable-anymap',
    'ppm' => 'image/x-portable-pixmap',
    'ppt' => 'application/powerpoint',
#    'ppt' => 'application/vnd.ms-powerpoint',
    'ps' => 'application/postscript',
    'qt' => 'video/quicktime',
    'ra' => 'audio/x-realaudio',
    'ram' => 'audio/x-pn-realaudio',
    'ras' => 'image/x-cmu-raster',
    'rgb' => 'image/x-rgb',
    'rm' => 'audio/x-pn-realaudio',
    'roff' => 'application/x-troff',
    'rpm' => 'audio/x-pn-realaudio-plugin',
#    'rtf' => 'text/rtf',
    'rtf' => 'application/rtf',
#    'rtf' => 'application/msword',
    'rtx' => 'text/richtext',
    'sgm' => 'text/sgml',
    'sgml' => 'text/sgml',
    'sh' => 'application/x-sh',
    'shar' => 'application/x-shar',
    'silo' => 'model/mesh',
    'sit' => 'application/x-stuffit',
    'skd' => 'application/x-koan',
    'skm' => 'application/x-koan',
    'skp' => 'application/x-koan',
    'skt' => 'application/x-koan',
    'smi' => 'application/smil',
    'smil' => 'application/smil',
    'snd' => 'audio/basic',
    'so' => 'application/octet-stream',
    'spl' => 'application/x-futuresplash',
    'src' => 'application/x-wais-source',
    'sv4cpio' => 'application/x-sv4cpio',
    'sv4crc' => 'application/x-sv4crc',
    'swf' => 'application/x-shockwave-flash',
    't' => 'application/x-troff',
    'tar' => 'application/x-tar',
    'tcl' => 'application/x-tcl',
    'tex' => 'application/x-tex',
    'texi' => 'application/x-texinfo',
    'texinfo' => 'application/x-texinfo',
    'tif' => 'image/tiff',
    'tiff' => 'image/tiff',
    'tr' => 'application/x-troff',
    'tsv' => 'text/tab-separated-values',
    'txt' => 'text/plain',
    'ustar' => 'application/x-ustar',
    'vcd' => 'application/x-cdlink',
    'vrml' => 'model/vrml',
    'wav' => 'audio/x-wav',
    'wbmp' => 'image/vnd.wap.wbmp',
    'wbxml' => 'application/vnd.wap.wbxml',
    'wml' => 'text/vnd.wap.wml',
    'wmlc' => 'application/vnd.wap.wmlc',
    'wmls' => 'text/vnd.wap.wmlscript',
    'wmlsc' => 'application/vnd.wap.wmlscriptc',
    'wrl' => 'model/vrml',
    'xbm' => 'image/x-xbitmap',
    'xht' => 'application/xhtml+xml',
    'xhtml' => 'application/xhtml+xml',
    'xls' => 'application/vnd.ms-excel',
    'xml' => 'text/xml',
    'xpm' => 'image/x-xpixmap',
    'xsl' => 'text/xml',
    'xwd' => 'image/x-xwindowdump',
    'xyz' => 'chemical/x-xyz',
    'zip' => 'application/zip',
);


#sub check_selectlist_for_name {  # biocode_upload
#    local($subdir,$list,$incname) = @_;  # subdir="biocode", list="people.txt"
#
#    $fname = "/usr/local/bscit/select_lists/$subdir/$list";
#    open(SEL, "$fname") || die "Can't open $fname ";
#    while(<SEL>) {
#        $line = $_;
#	$line =~ s/<option>//g;
#	$line = &strip($line);
#	#$bad_msg .= "<li>|$line|";
#	if ($line eq $incname) {
#	    return(1);
#	}
#    }
#    return(0);
#    close(SEL);
#}

sub check_selectlist_for_name {  # biocode_upload
    local($subdir,$list,$incname) = @_;  # subdir="biocode", list="people.txt"

    $fname = $select_list_path . "/$list";
    open(SEL, "$fname") || die "Can't open $fname ";
    while(<SEL>) {
        $line = $_;
        $line =~ s/<option>//g;
        $line = &strip($line);
        #$bad_msg .= "<li>|$line|";
        if ($line eq $incname) {
            return(1);
        }
    }
    return(0);
    close(SEL);
}



sub is_an_integer {
    local($incoming) = @_;

    if ($incoming =~ /^\d+$/) {
	return 1;
    } else {
	return 0;
    }
}

sub is_a_decimalnumber {    # called by biocode_excel_datacheck
    my ($incoming) = @_;

    if ($incoming =~ /^-?\d+\.?\d*$/) { # rejects .2
        return 1;
    } else {
        return 0;
    }
}

sub rm_decimal_trailing_zeros { ## 3.5600 -> 3.56
    local($num) = @_;

    # special case: lat/long = 0.0
    if ($num =~ /^0+\.0+/) { # 
	$num = "0.0";
    } elsif ($num =~ /\./) { # contains a decimal point
        $num =~ s/0+$//g;  # remove trailing zeroes
        $num =~ s/\.$/\.0/g;  # replace trailing decimal point with ".0"
    }
    return $num;

}

sub rm_time_trailing_zeros {  ## 08:00:00 -> 08:00 and 00:00:00 -> just the mdy
    local($timestamp) = @_;
    
    if ($timestamp =~ /(.*) 00\:/) {  # hours are zero
	$timestamp = $1;
    } else {
	$timestamp =~ s/\:00$//g;
    }
    return $timestamp;
}

sub add_commas {  # 1303 -> 1,303
    local($num) = @_;

    local($count) = 1;
    local($numlen) = length($num);
    local($result) = "";

    @rev = split(//,reverse($num));
    
    foreach $r (@rev) {
	$result .= $r;
	if ($count % 3 eq 0 && $count ne $numlen) {
	    $result .= ",";
	}
	++$count;
    }

    return reverse($result);
}


sub caseize_author {  # BRODERIP & SOWERBY -> Broderip & Sowerby
    local($author) = @_;
    local($new_author) = "";

    local(@names) = split(/ /,$author);
    foreach $n (@names) {
	$n = lc($n);
	$n = "\u$n";
	$new_author .= "$n ";
    }
    $new_author = &strip($new_author);
    return $new_author;
}


sub caseize_cname {  # Big WHITE flower, whiteflower -> Big White Flower, Whiteflower
    local($cname) = @_;

    $cname =~ s/ Or /\,/g;
    $cname =~ s/ or /\,/g;
    $cname =~ s/ OR /\,/g;
    $cname =~ s/\;/\,/g;
    
    local(@entire_cname) = split(/\,/,$cname); ## (Big WHITE flower) (whiteflower)
    $new_cname = "";
    foreach $sep_name (@entire_cname) {
	$sep_name = &strip($sep_name);

	if ($sep_name =~ /^\((.*)\)$/) {  # get rid of parens aorund it
	    $sep_name = $1;
        }
	if ($sep_name =~ /^\'(.*)\'$/) {  # get rid of single quotes aorund it
	    $sep_name = $1;
	}
	local(@one_name) = split(/ /,$sep_name);  ## (Big) (WHITE) (flower)
	$one_new_cname = "";
	foreach $w (@one_name) {
	    $w = lc($w);
	    if ($w eq "del" || $w eq "de" || $w eq "los" || $w eq "of") {
		# keep lower case
	    } else {
		$w = "\u$w";
	    }
	    $one_new_cname .= " $w";
	}
	$new_cname .= "$one_new_cname, ";
    }
    $cname = &strip($new_cname);
    $cname = &remove_last_comma($cname);
    return $cname;
}

sub caseize_higher_taxonomy {  # assumes one word
    local($inc_name) = @_;

    $inc_name = &strip(lc($inc_name));
    if ($inc_name =~ /^\?(.*$)/) {  # i.e., ?genus -> ?Genus
	$actual_name = &strip($1);  # set rid of extra spaces
	$inc_name = "?" . "\u$actual_name";
    } else {
	$inc_name = "\u$inc_name";
    }
    return $inc_name;
}


sub caseize_placename {  # BAJA CALIFORNIA - > Baja California 
    local($placename) = @_;
    local($new_placename) = "";

    local(@names) = split(/ /,$placename);
    foreach $n (@names) {
	if ($n =~ /(.*)\/(.*)/) { # Yolo/Yuba County
	    $n1 = lc($1);
	    $n1 = "\u$n1";
	    $n2 = lc($2);
	    $n2 = "\u$n2";
	    $n = "$n1/$n2";
	} else {
	    $n = lc($n);
	    $n = "\u$n";
	}
	$new_placename .= "$n ";
    }
    $new_placename = &strip($new_placename);
    return $new_placename;
}


sub caseize_plant_taxon {  # Genus species subspecies ...
    ## this works for plants, is the same as ./img_utils.p
    local($taxon) = @_;

    local($first,@rest) = split(/ /,$taxon);
    $first = lc($first);
    $first = "\u$first";
    $taxon = $first;
    foreach $w (@rest) {
	local($next) = "";
	if ($w =~ /^X(.*)/) {  ## hybrid
	    $next = "X" . lc($1);
	} else {
	    $next = lc($w);
	}
	$next =~ s/^spec\.$/sp\./g;
	$next =~ s/^var$/var\./g;
	$next =~ s/^ssp$/ssp\./g;
	$taxon .= " $next";
    }
    $taxon = &strip($taxon);
    return $taxon;
}


sub feet2meters {
    local($feet) = @_;

    if ($feet eq "") {
	return;  # so we don't set null to zero
    }
    $m = .3048 * $feet;
    $m = sprintf("%.4f",$m);   # 4 decimal places
    return $m;
}


sub fathoms2meters {
    local($fathoms) = @_;

    if ($fathoms eq "") {
	return;   # so we don't set null to zero
    }

    $m = 1.8288 * $fathoms;
    $m = sprintf("%.4f",$m);   # 4 decimal places
    return $m;
}


sub degrees2decimal {  # convert lat/long degrees, minutes, seconds to decimal
    local($degrees, $minutes, $seconds, $direction) = @_;

    # http://www.fcc.gov/mb/audio/bickel/DDDMMSS-decimal.html
    # test      dd mm ss
    # test: lat 42 30 0  N  -> 42.5 
    # test: lon 124 0 0  W  -> -124.0
    ## updated 1/11/2006 to allow zero values in lat_deg or long_deg


    if ($degrees eq "" && $minutes eq "" && $seconds eq "") {
	return "";
    }

    local($decimal) = $degrees + ($minutes/60) + ($seconds/3600);
    if (uc($direction) eq "S" || uc($direction) eq "W") {
	$decimal = -1 * $decimal;
    }
    #$decimal = sprintf("%.4f",$decimal);   # 4 decimal places
    # 4/26/2006: increase to 6 decimal places for better accuracy
    $decimal = sprintf("%.6f",$decimal);   # 6 decimal places
    return $decimal;
}


sub add_degree_symbols {  # 34 24 7.00 N  -> 34&deg; 24' 7.00" N

    local($lat_or_lon) = @_;  # 34 24 7.00 N
    
    if ($lat_or_lon =~ /^(.*)(N|S|E|W)$/) {
	local($deg,$min,$sec) = split(/\s+/,$1);
	local($dir) = $2;

	$print_ll = "$deg&deg;";   # deg
	if ($min ne "") {$print_ll .= " $min\'";} # min
	if ($sec ne "") {$print_ll .= " $sec\"";} # sec
	$print_ll .= " $dir";
	return $print_ll;
    } else {
	return $lat_or_lon;
    }
}

# this is for separate args deg,min,sec,dir
sub add_degree_symbols_2 {  # 34,24,7.00,N  -> 34&deg; 24' 7.00" N

    local($deg,$min,$sec,$dir) = @_;  # (34,24,7.00,N)
    
    if ($deg ne "" && $min ne "" && $sec ne "" && $dir ne "") {
	$print_ll = "$deg&deg; $min\' $sec\" $dir";
    } elsif ($deg ne "" && $min ne "" && $dir ne "") {
	$print_ll = "$deg&deg; $min\' $dir";
    } elsif ($deg ne "" && $dir ne "") {
        $print_ll = "$deg&deg; $dir";
    } elsif ($deg eq "0") {
        $print_ll = "$deg&deg; $dir";
    } elsif ($deg ne "") {  # no dir
        $print_ll = "$deg&deg;";

    } else {
	$print_ll = "$deg $min $sec $dir";
    }
    return $print_ll;
}

sub check_degree_lat_lon {  # add_ucmp_loc

    local($lat_deg,$lat_min,$lat_sec,$lat_dir,$long_deg,$long_min,$long_sec,$long_dir) =  @_;

    ## updated 1/11/2006 to allow zero values in lat_deg or long_deg
    ## default directions per http://biology.usgs.gov/fgdc.metadata/version2/3_D.htm
    ## Lat  37 48 12 S   Long    73 01 29 W

    $valid_deg_latlon = 1;

    if ($lat_deg ne "" || $long_deg ne "") {
	## make sure we got both
	if ($lat_deg eq "") {
	    $bad_msg .= "<li>Got longitute degrees without latitude degrees\n";
	    $valid_deg_latlon = 0;
	    return;
	} elsif ($long_deg eq "") {
	    $bad_msg .= "<li>Got latitude degrees without longitute degrees\n";
	    $valid_deg_latlon = 0;
	    return;
	}
	if (!$lat_dir) {
	    if ($lat_deg == 0) {  # point on the Equator
		$lat_dir = "N";
	    } else {
		$valid_deg_latlon = 0;
		$bad_msg .= "<li>Direction required for latitude degrees";
	    }
	} else {
	    if ($lat_dir !~ /[N,S]/) {
		$valid_deg_latlon = 0;
		$bad_msg .= "<li>Latitude direction must be N or S\n";
	    }
	}
	if (!$long_dir) {
	    if ($long_deg == 0) {  # point on the Prime Meridian
		$long_dir = "E";  
	    } else {
		$valid_deg_latlon = 0;
		$bad_msg .= "<li>Direction required for longitude degrees";
	    }
        } else {
	    if ($long_dir !~ /[E,W]/) {
		$valid_deg_latlon = 0;
                $bad_msg .= "<li>Longitude direction must be E or W\n";
            }
	}
	if ($lat_deg < 0 || $lat_deg > 90) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Latitude degrees must be between 0 and 90\n";
	}
	if ($lat_min < 0 || $lat_min > 60) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Latitude minutes must be between 0 and 60\n";
	}
	if ($lat_sec < 0 || $lat_sec > 60) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Latitude secords must be between 0 and 60\n";
	}
	if ($long_deg < 0 || $long_deg > 180) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Longitude degrees must be between 0 and 180\n";
	}
	if ($long_min < 0 || $long_min > 60) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Longitude minutes must be between 0 and 60\n";
	}
	if ($long_sec < 0 || $long_sec > 60) {
	    $valid_deg_latlon = 0;
	    $bad_msg .= "<li>Longitude secords must be between 0 and 60\n";
	}



    } else { # didn't get degrees
	$valid_deg_latlon = 0;
	return;
    }
}


sub check_decimal_lat_lon {  # ucmp_add_locality
    local($lat,$long,$cat_num) = @_;

    if ($lat eq "" && $long eq "") {
	return;
    } elsif ($long eq "") {
	$bad_msg .= "<li>Got a decimal latitude without a longitude\n";
    } elsif ($lat eq "") {
	$bad_msg .= "<li>Got a decimal longitude without a latitude\n";

    } elsif ($lat !~ /^\-?\d{1,2}\.?\d{0,8}$/) {
	$bad_msg .= "<li>Decimal latitude \"$lat\" is not a valid format\n";
    } elsif ($long !~ /^\-?\d{1,3}\.?\d{0,8}$/) {
	$bad_msg .= "<li>Decimal longitude \"$long\" is not a valid format\n";
    }
    return($lat,$long);
}

sub check_decimal_lat_lon_by_country {
    ## used by CalPhotos upload and update, EME upload and update

    local($lat,$lng,$country) = @_;   # (34.1460,117.7090,US)

    
    # lat/long - if there's one, there must be the other
    if ($lat ne "" || $lng ne "") {
	    
        if ($lng eq "") {
            $bad_msg .= "<li><b>lat/long</b> you entered a lat but not a long\n";
        } elsif ($lat eq "") {
            $bad_msg .= "<li><b>lat/long</b> you entered a long but not a lat\n";
        } elsif ($lat !~ /^\-?\d+\.\d\d\d\d\d*$/) {
            $bad_msg .= "<li><b>latitude</b> \"$lat\" is not a 4 to 8 place decimal number\n";
        } elsif ($lng !~ /^\-?\d+\.\d\d\d\d\d*$/) {
            $bad_msg .= "<li><b>longitude</b> \"$lng\" is not a 4 to 8 place decimal number\n";
        } 
        if ($lat ne "" && $lng ne "" && !$country) {
	    $bad_msg .= "<li><b>country needed</b> so we can check the lat/long\n";
	}
	else {
	    # comment this out till problems resolved w/ Hawaii & Guam
	    $USlatlongcheck = 0;
	    if ($country eq "US" && $USlatlongcheck == 1) {
	   	if ($lng >= 0) {
		    $bad_msg .= "<li><b>longitude</b> \"$lng\" ";
		    $bad_msg .= "must be negative for US locations\n";
		} elsif ($lat < 0) {
		    $bad_msg .= "<li><b>latitude</b> \"$lat\" ";
		    $bad_msg .= "cannot be negative for US locations\n";
		}
	    }
	}
     }


}

sub make_informix_date {  # copied from sql_utils_inf.p:make_date
    ## returns

    local($indate) = @_;

    if ($DEBUG) {print "In make_informix_date: indate=|$indate|\n";}

    ## mm-dd-yy (assume 19__)
    if ($indate =~ /^(\d{1,2})-(\d{1,2})-(\d\d)$/) {
        $mo = $1;
        $da = $2;
        $yr = "19$3";

    ## mm-dd-yyyy
    } elsif ($indate =~ /^(\d{1,2})-(\d{1,2})-(\d\d\d\d)$/) {
        $mo = $1;
        $da = $2;
        $yr = $3;

    ## mm/dd/yy (assume 19__)
    } elsif ($indate =~ /^(\d{1,2})\/(\d{1,2})\/(\d\d)$/) {
	$mo = $1;
	$da = $2;
	$yr = "19$3";

    ## yyyymmdd
    } elsif ($indate =~ /^(\d\d\d\d)(\d\d)(\d\d)$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## 03/31/1995
    } elsif ($indate =~ /^(\d{1,2})\/(\d{1,2})\/(\d\d\d\d).*$/) {
        $mo = $1;
        $da = $2;
        $yr = $3;

    ## 1995/03/31
    } elsif ($indate =~ /^(\d\d\d\d)\/(\d{1,2})\/(\d{1,2})$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## 1992/3/  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\/(\d{1,2})\/* *$/) {
        $yr = $1;
        $mo = $2;
        $da = "00";

    ## 1992/  /  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\/* +\/ *$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## 1992/  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\/+$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## 1995\03\31
    } elsif ($indate =~ /^(\d\d\d\d)\\(\d{1,2})\\(\d{1,2})$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;


    ## 1992\3\  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\\(\d{1,2})\\ *$/) {
        $yr = $1;
        $mo = $2;
        $da = "00";

    ## 1992\  \  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\\* +\\ *$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## 1992\  (micro)
    } elsif ($indate =~ /^(\d\d\d\d)\\$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## 03/1995
    } elsif ($indate =~ /^(\d{1,2})\/(\d\d\d\d).*$/) {
        $mo = $1;
        $da = "00";
        $yr = $2;

    ## 03/95  (assume 19__)
    } elsif ($indate =~ /^(\d{1,2})\/(\d\d).*$/) {
        $mo = $1;
        $da = "00";
        $yr = "19$2";


    ## 1995-03-31
    } elsif ($indate =~ /^(\d\d\d\d)-(\d{1,2})\-(\d{1,2}).*$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## 1992
    } elsif ($indate =~ /^(\d\d\d\d)$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## Oct 95 or Oct. 95 or OCT 95 (assume 19__)
    } elsif ($indate =~ /^(\D\D\D)\.* (\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "19$2";

   ## Oct 1995 or Oct. 1995 or OCT 1995
    } elsif ($indate =~ /^(\D\D\D)\.* (\d\d\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "$2";


    ## October 1995
    } elsif ($indate =~ /^(\D\D\D+) (\d\d\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "$2";

    ## October 95 (assume 19__)
    } elsif ($indate =~ /^(\D\D\D+) (\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "19$2";

    ## October 15, 1995 or Oct 5 1995
    } elsif ($indate =~ /^(\D\D\D+) (\d{1,2})\,* *(\d\d\d\d) *$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "$2";
        $yr = "$3";

    } else {  # no date
         # print "-- Error: INVALID DATE INDATE=|$indate| $disknum $imgnum\n";
	return 0;
    }

    $yr = sprintf("%04d",$yr);
    $mo = sprintf("%02d",$mo);
    $da = sprintf("%02d",$da);

    if ($DEBUG) {
	print "yr=|$yr|  mo=|$mo|  da=|$da|\n";
    }

    if ((int($da) > 31 || int($da) < 0) && $indate ne "NULL"){
        $bad_msg .= "[$specno_1|$loc_num] Day |$da| is outside range ...\n";
	return;
    }
    if ((int($mo) > 12 || int($mo) < 0) && $indate ne "NULL") {
	$bad_msg .= "[$specno_1|$loc_num] Monthy |$mo| is outside range ...\n";
        return;
    }
    if ((int($yr) < 1700 || int($yr) > $THISYR) && $indate ne "NULL") {
	$bad_msg .= "[$specno_1|$loc_num] Year |$yr| is outside range ...\n";
	$bad_msg .= "THISYR: $THISYR\n";
        return;
    }
    # check for right number of days
    if ($mo eq "02" && int($da) > 29) {
	$bad_msg .= "[$specno_1|$loc_num] too many days for February\n";
        return;
    }
    if (($mo eq "04" || $mo eq "06" || $mo eq "09" || $mo eq "11") && int($da) > 30) {
	$bad_msg .= "[$specno_1|$loc_num] too many days for month $mo\n";
        return;
    }
    $outdate = "$yr-$mo-$da";
    if ($DEBUG) {
	print "outdate: $outdate\n";
    }
    return $outdate;
}


sub get_todays_date {
    $TODAY = `date +%Y-%m-%d`;  ## yyyy-mm-dd
    chomp $TODAY;

    return ($TODAY);
}


sub strip {  ## strip leading & trailing spaces, reduce internal spaces to one
    my ($foo) = @_;

    $foo =~ s/\s+/ /g;
    $foo =~ s/\s+$//g;
    $foo =~ s/^\s+//g;
    return $foo;
}

sub really_strip {  ## strip leading & trailing spaces, reduce internal spaces to one
    my ($foo) = @_;

    $foo =~ s/\s+/ /g;
    $foo =~ s/\s+$//g;
    $foo =~ s/^\s+//g;
    $foo =~ s/\n//g;
    $foo =~ s/\r//g;
    return $foo;
}




sub print_date_options {

    my ($selected_date, $date_prec) = @_;

    @months = ('Month','unknown','January','February','March','April','May',
              'June','July','August','September','October','November','December');

    @days = ('Day','unknown','01','02','03','04','05','06','07','08','09','10',
            '11','12','13','14','15','16','17','18','19','20','21','22','23',
            '24','25','26','27','28','29','30','31');

    if($selected_date eq "newphoto" || $date_prec eq "nodate") {

        $selected_year = "YYYY";
        $selected_month = "Month";
        $selected_day = "Day";

    } else {

        @selected = split(/\-/,$selected_date);
        $selected_year = $selected[0];  # "1999"
        $selected_month = $selected[1]; # "02"
        $selected_day = $selected[2];   # "28"
        if (!$selected_year || $date_prec eq "nodate") {
            return;  # date is unknown
        }



        if ($date_prec eq "exactmonth") {
            $selected_day = "Day" if ($selected_day eq "01");
            $selected_month = $months[$selected_month + 1];

        } elsif ($date_prec eq "exactyear") {
            $selected_day = "Day" if ($selected_day eq "01");
            $selected_month = "Month" if ($selected_month eq "01");

        } else {
            # exactday - get English name
            $selected_month = $months[$selected_month + 1];  #

        }

    }

    print "<select name=date_month>\n";

    foreach $m (@months) {
        if ($m eq $selected_month) {
            print "<option selected>$m\n";
        } else {
            print "<option>$m\n";
        }
    }
    print "</select>\n";
    print "<select name=date_day>\n";
    foreach $d (@days) {
        if ($d eq $selected_day) {
            print "<option selected>$d\n";
        } else {
            print "<option>$d\n";
        }
    }
    print "</select>\n";
    print "<input name=date_year size=4 maxlength=4 value=$selected_year>\n";
}

sub make_pretty_date {  # takes informix date mm/dd/yyyy, returns Jan 02, 1998
    my ($indate,$precision) = @_;

    if ($DEBUG) {
        print "<h4>In make_pretty_date. $indate,$precision</h4>\n";
    }

    my ($mo,$da,$yr)=split(/\//,$indate);
    my ($month) = $mo_nums{$mo};
    my ($day) = sprintf("%d",$da);
    if ($precision eq "exactyear") {
        $pretty_date = $yr;  # mon,day unknown
    } elsif ($precision =~ /\d+/) {
        $yr2 = $yr + $precision;
        $pretty_date = "$yr-$yr2";
    } elsif ($precision eq "year+1") {
        $yr2 = $yr + 1;
        $pretty_date = "$yr-$yr2";
    } elsif ($precision eq "year+2") {
        $yr2 = $yr + 2;
        $pretty_date = "$yr-$yr2";

    } elsif ($precision eq "year+3") {
        $yr2 = $yr + 3;
        $pretty_date = "$yr-$yr2";
    } elsif ($precision eq "year+5") {
        $yr2 = $yr + 5;
        $pretty_date = "$yr-$yr2";

    } elsif ($precision eq "year+6") {
        $yr2 = $yr + 6;
        $pretty_date = "$yr-$yr2";

    } elsif ($precision eq "year+9") {
        $yr2 = $yr + 9;
        $pretty_date = "$yr-$yr2";

    } elsif ($precision eq "year+10") {
        $yr2 = $yr + 10;
        $pretty_date = "$yr-$yr2";

    } elsif ($precision eq "year+50") {
        $yr2 = $yr + 50;
        $pretty_date = "$yr-$yr2";


    } elsif ($precision eq "exactmonth") {
        $pretty_date = "$month $yr";  # day unknown
    } else {
        $pretty_date = "$month $day, $yr";
    }
    if ($DEBUG) {
        print "<h4>Leaving make_pretty_date. pretty_date=|$pretty_date|</h4>";
    }
    return $pretty_date;
}


sub make_pretty_date2 {  # takes informix date yyyy-mm-dd, returns Jan 02, 1998
    my ($indate,$precision) = @_;

    my ($yr,$mo,$da)=split(/\-/,$indate);
    my ($month) = $mo_nums{$mo};
    my ($day) = sprintf("%d",$da);
    if ($yr eq "0000") {
        $pretty_date = "";
    } elsif ($precision eq "exactyear") {
        $pretty_date = $yr;  # mon,day unknown
    } elsif ($precision eq "exactmonth") {
        $pretty_date = "$month $yr";  # day unknown
    } elsif ($precision =~ /\d+/) {
        $yr2 = $yr + $precision;
        #$pretty_date = "$yr-$yr2";
	$pretty_date = "between $yr and $yr2";
    } else {
        $pretty_date = "$month $day, $yr";
    }
    return $pretty_date;
}


sub make_pretty_date3 {  # integers (5,21,1965) -> May 21, 1965
    my ($mo,$da,$yr) = @_;
    $mo = sprintf("%02d",$mo);

    my ($month) = $mo_nums{$mo};
    my ($day) = sprintf("%d",$da);

    if (!$da && !$mo && !$yr) {
	return "";
    }

    if ($yr && $mo && $da) {
	$pretty_date = "$month $day, $yr";
    } elsif ($yr && !$da && !$mo) {
        $pretty_date = $yr;  # mon,day unknown
    } elsif ($yr && $mo && !$da) {
        $pretty_date = "$month $yr";  # day unknown
    } elsif (!$yr && $mo && !$da) {  
	$pretty_date = "$month";  # this seems unlikely
    } else {
        $pretty_date = "";  # day only?
    }
    return $pretty_date;
}


#sub make_pretty_date4 {  # takes informix date yyyy-mm-dd, returns Jan 02, 1998
#
#    my ($indate,$precision) = @_;
#
#    my ($yr,$mo,$da)=split(/\-/,$indate);
#    my ($month) = $mo_nums{$mo};
#    my ($day) = sprintf("%d",$da);
#    if ($precision eq "exactyear") {
#        $pretty_date = $yr;  # mon,day unknown
#    } elsif ($precision eq "exactmonth") {
#        $pretty_date = "$month $yr";  # day unknown
#    } elsif ($precision =~ /\d+/) {
#        $yr2 = $yr + $precision;
#        #$pretty_date = "$yr-$yr2";
#	$pretty_date = "between $yr and $yr2";
#    } else {
#        $pretty_date = "$month $day, $yr";
#    }
#    return $pretty_date;
#}


    ## modified 1/2004 for Mysql

sub make_date {   # takes weird forms, returns yyyy-mm-dd

    local($indate) = @_;
    local($outdate) = 0;

    if ($DEBUG) {print "In make_date: indate=|$indate|\n";}

    ## mm-dd-yy (assume 19__)
    if ($indate =~ /^(\d{1,2})-(\d{1,2})-(\d\d)$/) {
        $mo = $1;
        $da = $2;
        $yr = "19$3";

    ## mm-dd-yyyy
    } elsif ($indate =~ /^(\d{1,2})-(\d{1,2})-(\d\d\d\d)$/) {
        $mo = $1;
        $da = $2;
        $yr = $3;

    ## mm/dd/yy (assume 19__)
    } elsif ($indate =~ /^(\d{1,2})\/(\d{1,2})\/(\d\d)$/) {
         $mo = $1;
         $da = $2;
         $yr = "19$3";

    ## yyyymmdd
    } elsif ($indate =~ /^(\d\d\d\d)(\d\d)(\d\d)$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## yyyy.mm.dd
    } elsif ($indate =~ /^(\d\d\d\d)\.(\d{1,2})\.(\d{1,2})$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

	

    ## 03/31/1995
    } elsif ($indate =~ /^(\d{1,2})\/(\d{1,2})\/(\d\d\d\d).*$/) {
        $mo = $1;
        $da = $2;
        $yr = $3;

    ## 03/1995
    } elsif ($indate =~ /^(\d{1,2})\/(\d\d\d\d).*$/) {
        $mo = $1;
        $da = "00";
        $yr = $2;
    ## 03/95  (assume 19__)
    } elsif ($indate =~ /^(\d{1,2})\/(\d\d).*$/) {
        $mo = $1;
        $da = "00";
        $yr = "19$2";


    ## 1995/03/31  or 1995/3/31
    } elsif ($indate =~ /^(\d\d\d\d)\/(\d{1,2})\/(\d{1,2}).*$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## 1995/03/  or 1995/3/
    } elsif ($indate =~ /^(\d\d\d\d)\/(\d{1,2})\/$/) {
        $yr = $1;
        $mo = $2;
        $da = "00";

    ## 1995\03\31  or 1995\3\31
    } elsif ($indate =~ /^(\d\d\d\d)\\(\d{1,2})\\(\d{1,2}).*$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;



    ## 1995-03-31
    } elsif ($indate =~ /^(\d\d\d\d)-(\d{1,2})\-(\d{1,2}).*$/) {
        $yr = $1;
        $mo = $2;
        $da = $3;

    ## 1992
    } elsif ($indate =~ /^(\d\d\d\d)$/) {
        $yr = $1;
        $mo = "00";
        $da = "00";

    ## Oct 95 or Oct. 95 or OCT 95 (assume 19__)
    } elsif ($indate =~ /^(\D\D\D)\.* (\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "19$2";

   ## Oct 1995 or Oct. 1995 or OCT 1995
    } elsif ($indate =~ /^(\D\D\D)\.* (\d\d\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "$2";


    ## October 1995

    } elsif ($indate =~ /^(\D\D\D+) (\d\d\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "$2";

    ## October 95 (assume 19__)
    } elsif ($indate =~ /^(\D\D\D+) (\d\d)$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "00";
        $yr = "19$2";

    ## October 15, 1995 or Oct 5 1995
    } elsif ($indate =~ /^(\D\D\D+) (\d{1,2})\,* *(\d\d\d\d) *$/) {
        $month = uc($1);
        $mo=$mo_names{$month};
        $da = "$2";
        $yr = "$3";

    } else {  # no date
         $bad_date_msg .= "invalid date \"$indate\" ";
         return 0;
     }


    if (($da > 31 || $da < 0) && $indate ne "NULL"){
        $bad_date_msg .=  " Day \"$da\" is outside range ...";
        return;
    }
    if (($mo > 12 || $mo < 0) && $indate ne "NULL") {
        $bad_date_msg .=  " Month \"$mo\" is outside range ...";
        return;
    }
    if (($yr < 1700 || $yr > $THISYR) && $indate ne "NULL") {
        $bad_date_msg .=  " Year \"$yr\" is outside range ...\n";
        return;
    }
    # check for right number of days
    if ($mo == 2 && $da > 29) {
        $bad_date_msg .=  " too many days for February\n";
        return;
    }
    if (($mo == 4 || $mo == 6 || $mo == 9 || $mo == 11) && $da > 30) {
        $bad_date_msg .=  "... too many days for month $mo\n";
        return;
    }

    # change 00 in mo or da to 01
 #   if ($mo eq "00" || $mo eq "0") {$mo = "01";}  # should always be 00/00/yyyy
 #    if ($da eq "00" || $da eq "0") {$da = "01";}

    ## update Jan 2004 for mysql
    if (!$mo) {$mo = "00";}
    if (!$da) {$da = "00";}

    $outdate = sprintf "%04d-%02d-%02d",$yr,$mo,$da;
    
    return $outdate;
}

## check_year and check_mon_day return "" if any problems are found (so check for that)
##   they also initialize $bad_date_msg 
## $bad_date_msg can be printed as one line after $bad_msg .= [num]
## otherwise, they return the date

sub check_year {
    local($yr) = @_;
    $bad_date_msg = "";  # start over on bad_date_msg

    if (!$yr) {
	return "";
    }
    if ($yr eq "-") {
	return "";
    }

    if ($yr !~ /^\d\d\d\d$/) {
	$bad_date_msg .= "year \"$yr\" is not 4 digits ...";
	$yr = "";
    }
    elsif ($yr < 1700 || $yr > $THISYR) {
	$bad_date_msg .= "year \"$yr\" is outside allowable range ...";
	$yr = "";
    }
    return $yr;
}

sub check_mon_day {
    local ($mo,$da) = @_;
    $bad_date_msg = "";  # start over on bad_date_msg

    if ($DEBUG) {
	#print "In check_mon_day ($mo,$da)\n";
    }

    if ($mo) {
	if ($mo !~ /^\d{1,2}$/) {
	    $bad_date_msg .= "month \"$mo\" is not one or two digits ...";
	    $mo = "";
	}
	if ($mo > 12 || $mo < 0) {
	    $bad_date_msg .=  " Month \"$mo\" is outside range ...";
	    $mo = "";
	}
    } else {
	$mo = 0;
    }
    if ($da) {
	if ($da !~ /^\d{1,2}$/) {
	    $bad_date_msg .= "day \"$da\" is not one or two digits ...";
	    $da = "";
	}
	if ($da > 31 || $da < 0) {
	    $bad_date_msg .=  " Day \"$da\" is outside range ...";
	    $da = "";
	}
	# check for right number of days
	if ($mo == 2 && $da > 29) {
	    $bad_date_msg .=  " Day \"$da\": wrong for February ...\n";
	    $da = "";
	}
	if (($mo == 4 || $mo == 6 || $mo == 9 || $mo == 11) && $da > 30) {
	    $bad_date_msg .=  " Day \"$da\": too many days for month $mo\n";
	    $da = "";
	}
    } else {
	$da = 0;
    }
    $mo = sprintf("%02d",$mo);
    $da = sprintf("%02d",$da);
    return ($mo,$da);
}

sub checkYMD {    ## assumes at least a year was input

# Used by mybiocode_utils and myeme_utils
# call: ($OK,$msg) = &checkYMD($input{YearCollected},$input{MonthCollected},$input{DayCollected},);
# if (!$OK) {$bad_msg .= "<dd><li><b>Y/M/D Collected</b> $msg";}


    local($yr,$mo,$da) = @_;
    local($msg) = "";

    if (!$yr) {
	return (1,"");
    }
    elsif ($yr !~ /\d\d\d\d/) {
	$msg = "Year \"$yr\" is not four digits";
	return (0,$msg);
    }
    elsif ($yr < 1800) {
	$msg = "Year \"$yr\" is before 1800";
        return (0,$msg);
    }
    elsif ($yr > $THISYR) {
        $msg = "Year \"$yr\" is in the future";
        return (0,$msg);
    }

    # year is OK - now check month
    if (!$mo) {
	if ($da) {
	    $msg = "Day was input but not Month";
	    return(0,$msg);
	} else {
	    return (1,"");
	}
    }
    elsif ($mo !~ /\d{1,2}/) {
        $msg = "Month \"$mo\" is not one or two digits";
        return (0,$msg);
    }
    elsif ($mo > 12 || $mo < 1) {
	$msg = "Month ($mo) is not between 1 and 12";
	return (0,$msg);
    }

    # month is OK - now check day
    if (!$da) {
	return (1,"");
    }
    elsif ($da > 31 || $da < 1) {
	$msg = "Day ($da) is not between 1 and 31";
	return (0,$msg);
    }
    elsif ($mo == 2 && $da > 29) {
	$msg = "Month is February but day > 28";
	return (0,$msg);
    }
    elsif (($mo == 4 || $mo == 6 || $mo == 9 || $mo == 11) && $da > 30) {
	$msg = "Day is greater than 30 but month is $mo";
	return (0,$msg);
    }

    else {
	return (1,"");
    }

}

sub check_datetime_format {  # verify it's yyyy-mm-dd hh:mm:ss (or yyyy-mm-dd)
                             #  and validate m/d/y
    local ($inc_date) = @_;

    if (!$inc_date) {
	return;
    }
    if ($inc_date =~ /^(\d\d\d\d)-(\d\d)-(\d\d) (\d\d:\d\d:\d\d)$/ ||
	$inc_date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
	$yr = $1;
	$mo = $2;
	$da = $3;
	
	&check_year($yr);
	if ($bad_date_msg) {
	    $bad_msg .= "<li>Date ($inc_date): $bad_date_msg";
	}
	&check_mon_day($mo,$da);
	if ($bad_date_msg) {
            $bad_msg .= "<li>Date ($inc_date): $bad_date_msg";
        }

    } else {
	$bad_msg .= "<li>Date \"$inc_date\" is not yyyy-mm-dd hh:mm:ss";
    }
}

sub get_time {  # Mon Nov 29 20:21:29 PST 1999

    $new_time = `date`;
    chomp $new_time;
    return $new_time;
}



sub get_all_the_dates {
    #   $todays_date="Feb 05 1999" $update_time="Tue Feb 9, 1999 10:00:13"
    #   $kwid_date="199902"
    # month:
    #   $this_mon="Feb"  $this_mon_num1="2"  $this_mon_num2="02"
    #   $first_log_moname = "Jan"  $first_log_monum = 1
    # day :
    #   $this_day="05"  $this_day_1="5"  $first_day ="1";
    #
    # year:
    #   $this_yr="1999"  $first_log_year = "1999"
    # yearmonth (for database entries)
    #   $yearmonth="1999_Feb"

    # $monum=$monums{"Apr"};
    %monums = (Jan,1,Feb,2,Mar,3,Apr,4,May,5,Jun,6,Jul,7,Aug,8,Sep,9,Oct,10,Nov,11,Dec,12);

    $update_time = &strip(`date '+%a %h %e, %Y %T'`);    # Tue Feb 9, 2007 10:00:13
    $todays_date = &strip(`date '+%h %d %Y'`);           # Feb 05 2007
    $year_last2digits = &strip(`date '+%y'`);            # 07
    $MSQL_DATETIME = &strip(`date '+%Y-%m-%d %T'`);      ## 2005-10-26 09:47:12
    ($this_mon,
     $this_day,
     $this_yr) =
         split(/ /,$todays_date); # (Feb,5,1999)

    ## these also can be set via get_todays_date()
    $THISYR = $this_yr;
    $THISMO = $this_mon;
    $THISDA = $this_day;

    $yearmonth = $this_yr . "_" . $this_mon;  # "1999_Feb"
    $this_mon_num1 = $monums{$this_mon};  ## 2
    $this_mon_num2 = sprintf("%02d",$this_mon_num1);  ## 02
    $this_day_1 = sprintf("%d",$this_day);  ## 5
    $this_day_2 = sprintf("%02d",$this_day);  ## 05
    $kwid_date = $this_yr . $this_mon_num2; ## 200412
    $mysql_fmt_today = $this_yr . "-" . $this_mon_num2 . "-" . $this_day_2; # 2005-05-24

    $yesterday = &get_yesterday($this_yr,$this_mon_num1,$this_day_1);  # 2005-05-24

    $first_log_moname = "Jan";
    $first_log_monum = 1;
    $first_log_year = "1999";


    if ($DEBUG) {$debug_msg .= "In get_all_the_dates\n";}

}

sub get_last_mon_num {      ## given this month, return last month May = 5
    local($this_mon) = @_;   # 5

    if ($this_mon == 1) {
	return 12;
    } else {
	return $this_mon -1;
    }
}

sub get_yesterday { ## given today, return yesterday as yyyy-mm-dd
    local($this_year,$this_mon,$today) = @_;   # (2005,5,9)

    ## starting values, subject to change below
    local($y_year) = $this_year;
    local($y_mon) = $this_mon;
    local($y_day) = $today -1;

    if ($today == 1) {
	$y_mon = &get_last_mon_num($this_mon);
	if ($y_mon == 12) {  ## today is Jan 1
	    $y_year = $this_year - 1;
	    $y_day = 31;
	} elsif ($y_mon == 2) {  ## last month was February - leap year?
	    $y_mon = "02";
	    if (&is_a_leap_year($this_year)) {
		$y_day = "29";
	    } else {
		$y_day =  "28";
	    }
	} else {
	    $y_day = $num_days{$mo_nums_1{$y_mon}};
	}

    } 
    $y_mon = sprintf("%02d",$y_mon);
    $y_day = sprintf("%02d",$y_day);
    return $y_year . "-" . $y_mon  . "-" . $y_day;
}

sub is_a_leap_year {
    local($year)  = @_; 

    if ($year % 4 == 0) {  # if it's divisible by 4
	if ($year % 100 != 0) { # and it's not a century year
	    return 1;
	} elsif ($year % 400 == 0) {  # or it's a century year div. by zero
	    return 1;
	} else {
	    return 0;
	}
    } else {  # not divisible by 4
	return 0;
    }
}

sub make_ss_header  { ## returns as a var 8/25/03 

    local($title) = @_;

    local($header) = "";
    $header .= "<!--#include virtual=\"/title.html\" -->\n";
    $header .= "$title\n";
    $header .= "<!--#include virtual=\"/head1.html\" -->\n";
    $header .= "$title\n";
    $header .= "<!--#include virtual=\"/head2.html\" -->\n";
    $header .= "<!--#include virtual=\"/head3.html\" -->\n"; 

    return $header;

}
sub print_ss_header { ## prints it out 8/25/03

    my $title = @_;

    print "Content-type: text/html\n\n";
    print "<!--#include virtual=\"/title.html\" -->\n";
    print "$title\n";
    print "<!--#include virtual=\"/head1.html\" -->\n";
    print "$title\n";
    print "<!--#include virtual=\"/head2.html\" -->\n";
    print "<!--#include virtual=\"/head3.html\" -->\n"; 

}



sub make_ss_footer  { ## returns as a var 8/25/03 

    my $footer = "\n<!--#include virtual=\"/footer.html\" -->\n";
    return $footer;

}
sub print_ss_footer { ## prints it out 8/25/03

    print "<!--#include virtual=\"/footer.html\" -->\n";
}


sub print_bad_msg {

    $bad_msg=~ s/<li><b>/\n/g;
    $bad_msg=~ s/<b>//g;
    $bad_msg=~ s/<\/b>//g;

    print BAD "$bad_msg\n";

    $bad_msg = "";
    close(BAD);
}


sub print_processing_notes {

    $proc_notes = "processing_notes.txt";
    `/bin/rm $proc_notes`;

    $tmp_file = "tmp.txt";
    `/bin/rm $tmp_file`;
    open(TMP,">$tmp_file") || die "Cannot open $tmp_file: $!";
    foreach $p (@process_notes) {
	print TMP "$p ($process_notes{$p})\n";
    }
    close(TMP);
    open(PRO,">$proc_notes") || die "Cannot open $proc_notes: $!";
    print PRO "Processing notes\n";
    print PRO "==================\n";
    close(PRO);
    `sort $tmp_file >> $proc_notes`;
}


sub remove_last_comma {
    local($foo) = @_;

    $foo =~ s/\, *$//g;
    return $foo;
}


sub urlify {
    local($foo) = @_;
    $foo =~ s/ /\+/g;
    return $foo;
}

sub get_orientation {
    local($pic) = @_;  # $jpeg/128x192/corel/$cdnum/$i.jpeg";

    unless ( -e $pic) {
        print "get_orientation: Can't find $pic - bye, bye\n\n";
        exit;
    }
    # format of $out: stdin:  PPM raw, 192 by 128  maxval 255

    $or = `/usr/local/bin/djpeg -pnm $pic | /usr/local/bin/pnmfile`;

    if ($or =~ /^.+\s(\d+) by (\d+)\s.+$/) {
        $width = $1;
        $height = $2;
    }
    if ($width < $height){
        $orient = "V";
    } else  {
        $orient = "H";
    }
    close(O);
    return $orient;
}

## adapted from ./ucmp_utils.p
## returns ($country, $state_prov)
## 
## add to calling script: %seen = ();  # array for processing_notes.txt

sub standardize_country_and_state_name {
    local($country,$state_prov,$cat_num) = @_;

    if ($DEBUG) {
	print "In standardize_country_and_state_name: country=|$country| state_prov=|$state_prov|\n";
    }

    $country = &strip($country);
    $state_prov = &strip($state_prov);
    
    if (!$country && !$state_prov) {
	return;
    }
    if ($country =~ /^\?+$/) {
	$bad_msg .= "[$cat_num] Country name \"$country\" replaced with blank\n";
	$country = "";
    }
    if ($state_prov =~ /^\?+$/) {
        $bad_msg .= "[$cat_num] State_Prov name \"$state_prov\" replaced with blank\n";
        $state_prov = "";
    }
    if (uc($country) eq "US" || 
	uc($country) =~ /U\.*S\.*A\.*/ || 
	uc($country) eq "UNITED STATES") {
	if ($country ne "United States") {
	    local($newp) = "Country:  changed $country to United States";
	    push(@process_notes,$newp) unless $seen{$newp}++;
	    $process_notes{$newp}++;
	}
	$country = "United States";
	
	
    } elsif (uc($country) =~ /^ANTARCTIC PENINSULA$/) {
	local($newp) = "Country:  changed $country to Antarctica";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Antarctica";

    } elsif (uc($country) =~ /^ANTIGUA$/) {
	local($newp) = "Country:  changed $country to Antigua and Barbuda";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Antigua and Barbuda";

    } elsif (uc($country) =~ /^BARBUDA$/) {
	local($newp) = "Country:  changed $country to Antigua and Barbuda";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Antigua and Barbuda";
	
    } elsif (uc($country) =~ /^BELAU$/) {
        local($newp) = "Country:  changed $country to Palau";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Palau";
	

    } elsif (uc($country) =~ /BELGIAN CONGO/) {
	local($newp) = "Country:  changed $country to Congo, the Democratic Republic of the";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Congo, the Democratic Republic of the";

    } elsif (uc($country) =~ /BELGIIUM/) {
        local($newp) = "Country:  changed $country to Belgium";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Belgium";
	
    } elsif (uc($country) =~ /BORNEO/) {
	local($newp) = "Country:  changed $country to Brunei Darussalam";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Brunei Darussalam";
	

    } elsif (uc($country) =~ /BRITISH ANTARCTIC/) {
	if (uc($state_prov) =~ /SHETLAND ISLANDS/) {
	    local($newp) = "Country:  changed $country to United Kingdom since state is $state_prov";
	    push(@process_notes,$newp) unless $seen{$newp}++;
	    $process_notes{$newp}++;
	} else {
	    $bad_msg .= "[$cat_num] unable to determine country (country: $orig_country , state_prov: $state_prov\n";
	}
	$country = "United Kingdom";
	

    } elsif (uc($country) =~ /BURMA/) {
	local($newp) = "Country:  changed $country to Myanmar";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Myanmar";

    } elsif (uc($country) =~ /COLUMBIA/) {
        local($newp) = "Country:  changed $country to Colombia";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Colombia";
	
    } elsif (uc($country) =~ /COMMONWEALTH OF THE NORTHERN MARIANAS/) {
        local($newp) = "Country:  changed $country to Northern Mariana Islands";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Northern Mariana Islands";

    } elsif (uc($country) =~ /CONGO, DEMOCRATIC REPUBLIC OF THE/) {
	local($newp) = "Country:  changed $country to Congo, the Democratic Republic of the";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
	$country = "Congo, the Democratic Republic of the";
	
    } elsif (uc($country) =~ /CONGO, REPUBLIC OF THE/) {
        local($newp) = "Country:  changed $country to Congo, the Democratic Republic of the";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Congo, the Democratic Republic of the";


    } elsif (uc($country) =~ /COTE D\'IVORIE/) {
	
        local($newp) = "Country:  changed $country to Cote d'Ivoire";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Cote d'Ivoire";

    } elsif (uc($country) eq "CM" && $cont_ocean eq "South America") {
        local($newp) = "Country:  changed $country to Colombia since cont. is $cont_ocean";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Colombia";

    } elsif (uc($country) eq "CZECHOSLOVAKIA") {
	$country = "Czech Republic";
	local($newp) = "Country:  changed Czechoslovakia to Czech Republic";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;


    } elsif (uc($country) =~ /EAST PRUSSIA/) {
        local($newp) = "Country:  changed $country to Poland";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Poland";

    } elsif (uc($country) eq "ENGLAND" || uc($country) eq "ENLAND" || uc($country) eq "BRITISH ISLES") {
	if (!$state_prov) {
	    $state_prov = "England";
	    local($newp) = "Country:  changed $country to United Kingdom and state to England";
	    push(@process_notes,$newp) unless $seen{$newp}++;
	    $process_notes{$newp}++;

	} else {
	    local($newp) = "Country:  changed $country to United Kingdom; keeping state_prov \"$state_prov\"";
	}
	$country = "United Kingdom";

    } elsif (uc($country) =~ /EQUADOR/) {
	local($newp) = "Country:  changed $country to Ecuador";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
	$country = "Ecuador";

    } elsif (uc($country) =~ /FEDERATED STATES OF MICRONESIA/) {
        local($newp) = "Country:  changed $country to Micronesia, Federated States of";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Micronesia, Federated States of";


    } elsif (uc($country) =~ /FRENCH .*CONGO/) {
        local($newp) = "Country:  changed $country to Congo";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Congo";

    } elsif (uc($country) =~ /IRAN/) {
	local($newp) = "Country:  changed $country to Iran, Islamic Republic of";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Iran, Islamic Republic of";
	
    } elsif (uc($country) =~ /JAVA/) {
	local($newp) = "Country:  changed $country to Indonesia";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Indonesia";

    } elsif (uc($country) =~ /KIRGIZIYA/) {
	local($newp) = "Country:  changed $country to Kyrgyzstan";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Kyrgyzstan";

    } elsif (uc($country) =~ /LAOS/) {
	local($newp) = "Country:  changed $country to Lao People's Democratic Republic";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Lao People's Democratic Republic";

    } elsif (uc($country) =~ /MALAGASY/) {
        local($newp) = "Country:  changed $country to Madagascar";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Madagascar";

    } elsif (uc($country) =~ /^MICRONESIA$/) {
        local($newp) = "Country:  changed $country to Micronesia, Federated States of";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Micronesia, Federated States of";


    } elsif (uc($country) =~ /NEW HEBRIDES/) {
        local($newp) = "Country:  changed $country to Vanuatu";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Vanuatu";

    } elsif (uc($country) =~ /PALESTINE/) {
        local($newp) = "Country:  changed $country to Israel (could be Jordan...)"; 
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Israel";

    } elsif (uc($country) =~ /PANAMA CANAL ZONE/) {
	local($newp) = "Country:  changed $country to Panama";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Panama";

    } elsif (uc($country) =~ /PERU-BRAZIL/) {
	local($newp) = "Country:  changed $country to Peru";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Peru";

    } elsif (uc($country) =~ /PHILIPPINE/) {
	if ($country ne "Philippines") {
	    local($newp) = "Country:  changed $country to Philippines";
	    push(@process_notes,$newp) unless $seen{$newp}++;
	    $process_notes{$newp}++;
	}
	$country = "Philippines";

    } elsif (uc($country) eq "REPUBLIC OF CHINA") {
        local($newp) = "Country:  changed $country to China";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "China";


    } elsif (uc($country) =~ /RHODESIA/) {
        local($newp) = "Country:  changed $country to Zimbabwe";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Zimbabwe";


    } elsif (uc($country) =~ /ROSS DEPENDENCY/) {
	if (!$state_prov) {
	    $state_prov = $country;
	}
	local($newp) = "Country:  changed $country to Antarctica; state is $state_prov";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Antarctica";

    } elsif (uc($country) =~ /RUMANIA/) {
        local($newp) = "Country:  changed $country to Romania";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Romania";

    } elsif (uc($country) eq "RUSSIA") {
	local($newp) = "Country:  changed $country to Russian Federation";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Russian Federation";

    } elsif (uc($country) =~ /SCOTLAND/) {
	if (!$state_prov) {
            $state_prov = "Scotland";
        } else {
            $bad_msg .= "[$cat_num] changed country from Scotland to UK; check state_prov \"$state_prov\"\n";
        }
	local($newp) = "Country:  changed $country to United Kingdom; state is $state_prov";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "United Kingdom";

    } elsif (uc($country) =~ /SOUTH KOREA/) {
	local($newp) = "Country:  changed $country to Korea, Republic of";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Korea, Republic of";

    } elsif (uc($country) eq "SYRIA") {
        local($newp) = "Country:  changed $country to Syrian Arab Republic";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Syrian Arab Republic";

    } elsif (uc($country) =~ /TAIWAN/) {
	local($newp) = "Country:  changed $country to Taiwan, Province of China";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Taiwan, Province of China";

    } elsif (uc($country) =~ /TANZANIA/) {
	local($newp) = "Country:  changed $country to Tanzania, United Republic of";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Tanzania, United Republic of";

    } elsif (uc($country) eq "TRINIDAD") {
	local($newp) = "Country:  changed $country to Trinidad and Tobago";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Trinidad and Tobago";

    } elsif (uc($country) eq "TRINIDAD & TOBAGO") {
	local($newp) = "Country:  changed $country to Trinidad and Tobago";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Trinidad and Tobago";

    } elsif (uc($country) =~ /U\.*S\.*S\.*R\.*/) {

	if (uc($state_prov) =~ /ESTONIA/ || 
            uc($state_prov) =~ /KAZAKHSTAN/  || 
            uc($state_prov) =~ /LATVIA/  || 
            uc($state_prov) =~ /UKRAINE/ ) {

	    local($newp) = "Country:  changed $country to $state_prov and deleted state_prov $state_prov";
	    push(@process_notes,$newp) unless $seen{$newp}++;
	    $process_notes{$newp}++;
	    $country = $state_prov;
	    $state_prov = "";

	} elsif (uc($state_prov) =~ /SIBERIA/ || 
                 uc($state_prov) =~ /ORLOV/ ||
                 uc($state_prov) =~ /RUSSIAN SOVIET FSR/ ||
                 uc($state_prov) =~ /SEVERNAYA ZEMLYA/) {

	    local($newp) = "Country:  changed $country to Russian Federation; state is $state_prov";
	    push(@process_notes,$newp) unless $seen{$newp}++;
            $process_notes{$newp}++;
            $country = "Russian Federation";
	    
	} else {
	    local($newp) = "Country:  changed $country to Russian Federation; state is $state_prov";
	    push(@process_notes,$newp) unless $seen{$newp}++;
            $process_notes{$newp}++;
	    $country = "Russian Federation";
	    $bad_msg .= "[$cat_num] unable to determine country for USSR (state: $state_prov)\n";
	}

    } elsif (uc($country) =~ /VENZUELA/) {
	local($newp) = "Country:  changed $country to Venezuela";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Venezuela";

    } elsif (uc($country) =~ /WALES/) {
	if (!$state_prov) {
            $state_prov = "Wales";
        } else {
            $bad_msg .= "[$cat_num] changed country from Wales to UK; check state_prov\n";
        }
	local($newp) = "Country:  changed $country to United Kingdom; state is $state_prov";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "United Kingdom";

    } elsif (uc($country) =~ /WEST GERMANY/) {
	local($newp) = "Country:  changed $country to Germany";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Germany";
 
    } elsif (uc($country) =~ /WESTERN SAMOA/) {
	local($newp) = "Country:  changed $country to Samoa";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
	$country = "Samoa";
    }
    
    ## check ISO 3166 database
    
    if ($country) {
	$ckd_country = &get_country_code($country);
	if (!$ckd_country) {
	    $bad_msg .= "[$cat_num] country \"$country\" not found\n";
	}
    }

    ### now do state_prov #####

    $state_exception{"Midway Islands"} = 1;

    if ($state_prov =~ /^(.*)\?$/) {  # questionable state
	$state_prov = $1;
	$notes  .= "state is uncertain .. ";
    }
    
    if ($state_prov =~ /^(.*) Dept$/) {
        $state_prov = "$1 Department";
        local($newp) = " State_prov: expanded Dept to Department";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }


    if ($state_prov =~ /^(.*) Dist$/) {
        $state_prov = "$1 District";
        local($newp) = " State_prov: expanded Dist to District";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }


    if ($state_prov =~ /^(.*) Div$/) {
        $state_prov = "$1 Division";
        local($newp) = " State_prov: expanded Div to Division";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }

    if ($state_prov =~ /^(.*) Pref$/) {
        $state_prov = "$1 Prefect";
        local($newp) = " State_prov: expanded Pref to Prefect";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }

    if ($state_prov =~ /^(.*) Prov$/) {
        $state_prov = "$1 Province";
	local($newp) = " State_prov: expanded Prov to Province";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }

    if ($state_prov =~ /^(.*) Reg$/) {
	$state_prov = "$1 Region";
	local($newp) = " State_prov: expanded Reg to Region";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }

    if ($state_prov =~ /^(.*) Terr$/) {
        $state_prov = "$1 Territory";
        local($newp) = " State_prov: expanded Terr to Territory";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }
    if ($state_prov =~ /^(.*) Territ$/) {
        $state_prov = "$1 Territory";
        local($newp) = " State_prov: expanded Territ to Territory";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
    }

    if (uc($state_prov) =~ /^CALFORNIA/ ||
	uc($state_prov) =~ /^CALIFFORNIA/ ||
	uc($state_prov) =~ /^CALIFOIRNIA/ ||
	uc($state_prov) =~ /^CALFIORNIA/) {
	local($newp) = " State: corrected $state_prov to California";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$state_prov = "California";
    }

    elsif ($state_prov eq "Misssouri") {
	local($newp) = " State: corrected $state_prov to Missouri";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $state_prov = "Missouri";

    }
    elsif ($state_prov eq "Montana or Wyoming") {
	$state_prov = "Montana";
	$bad_msg .= "[$cat_num] changed state \"Montana or Wyoming\" to Montana";

    }
    elsif (uc($state_prov) =~ /NORTHERN MARIANAS/ and $country eq "United States") {
	local($newp) = " State: $state_prov changed to country Northern Mariana Islands";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
        $country = "Northern Mariana Islands";
        $state_prov = "";

    }
    elsif (uc($state_prov) =~ /OREGIN/) {
	local($newp) = " State: $state_prov changed to Oregon";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$state_prov = "Oregon";
    }
    elsif (uc($state_prov) =~ /PUERTO RICO/) {
	local($newp) = " State: Puerto Rico changed to country Puerto Rico";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
	$country = "Puerto Rico";
	$state_prov = "";
    }

    elsif (uc($state_prov) =~ /ST. CROIX/ && $country eq "United States") {
        local($newp) = " State: $State_prov country changed to Virgin Islands";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $country = "Virgin Islands, U.S.";
    } 

    elsif (uc($state_prov) =~ /WAKE/) {
	local($newp) = " State: $state_prov changed to blank";
	push(@process_notes,$newp) unless $seen{$newp}++;
	$process_notes{$newp}++;
	$state_prov = "";
    }
    elsif (uc($state_prov) =~ /WASHINNGTON/) {
        local($newp) = " State: $state_prov changed to Washington";
        push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
        $state_prov = "Washington";
    }
    elsif (uc($state_prov) =~ /VIRGIN ISLANDS/) {
	local($newp) = " State: Virgin Islands changed to country Virgin Islands, U.S.";
	push(@process_notes,$newp) unless $seen{$newp}++;
        $process_notes{$newp}++;
	$country = "Virgin Islands, U.S.";
	$state_prov = "";
    }

    
    if ($state_prov && $country eq "United States") {
	if (length($state_prov) == 2) {
	    $s = &get_state_name(uc($state_prov));
	} else {
	    $s = $state_prov;
	}
	$ckd_state = &get_state_code($s);
	if (!$ckd_state && !$exception{$state_prov}) {
	    $bad_msg .= "[$cat_num] country is USA but state \"$state_prov\" not found\n";
	} else {
	    $state_prov = $s;
	}

    }
    return ($country,$state_prov);
}

# various checks on the county; returns county
# country needed so can add "County" or "Province" or etc.

sub standardize_county_names {
    local($c,$state_prov,$country,$cat_num) = @_;

    if ($cat_num) {
	local($ref) = "[$cat_num] ";
    }

    if (!$c) {return "";}

    $c = &strip($c);
    # taking out caseize - it fails on McNair (and others)
    # $c = &caseize_placename($c);

    ## misc. typos
    if ($state_prov eq "California") {
	$c = &caseize_placename($c);
	$c =~ s/Contra Cota/Contra Costa/g;
	$c =~ s/Obiispo/Obispo/g;
	$c =~ s/Humbolt/Humboldt/g;
	$c =~ s/Humblodt/Humboldt/g;
	$c =~ s/San Bernadino/San Bernardino/g;
	$c =~ s/Tuolomne/Tuolumne/g;
    }

    if (uc($c) =~ /(.*) OR (.*)/) {
	local($rename) = &caseize_placename($1);
	$bad_msg .= "$ref County: is $c, changed it to $rename";
	$c = $rename;
    }

    if ($c =~ /(.*) Prov\.*$/) {
        $c = "$1 Province";
    }
    $c =~ s/Dist\.*$/District/g;
    $c =~ s/Div\.*$/Division/g;
    $c =~ s/Dept\.*$/Department/g;


    ## ? at the end
    # if ($c =~ /^(.*\w) *\?$/) {
    #    $c = $1;
    #    $notes .= "county is uncertain .. ";
    #}

    ## ? at the beginning
    # if ($c =~ /^\?(.*)$/) {
    #    $rename = &caseize_placename($1);
    #    $bad_msg .= "$ref County: is $c , changed it to $rename";
    #	$c = $rename;
    #}

    ## strip off "Co" or "Co."
    if ($c =~ /(.*) Co\.*\?*$/) {
	$c = "$1 County";
    }

    if ($c =~ /(.*) co\.*\?*$/) {
	$c = "$1 County";
    }

    ## lookup California counties
    if ($c && ($state_prov eq "California" || $state_prov eq "CA")) {
	if ($c =~ /\//) {  
              #more than one county - just leave it
	} else {
	    local($ckd_county) = &get_county_code($c);
	    if (!$ckd_county) {
		$bad_msg .= "<li>$ref state is California but county \"$c\" not found\n";
	    }
	}
    }

    ## add County on to the end ..

    if ($c !~ /County$/) {
	if ($country eq "United States" || $country eq "US") {
	    if ($state_prov eq "Louisiana") {
		if ($c !~ /Parish$/) {
		    $c .= " Parish";
		}
	    } elsif ($state_prov eq "Alaska") {
		# Alaska has Boroughs and other things
	    } elsif ($state_prov eq "Virginia") {
                # Virginia has Counties and Cities

	    } else {
		$c .= " County";
	    }
	}
    }
    return $c;
}

sub country_name_is_valid {
    local($inc_country)= @_;

    $check = uc($inc_country);

    if ($country_codes{$check}) {
	return 1;
    } else {
	return 0;
    }
}

sub get_country_code_from_array {  #given a name, get a two-letter ISO 3166 code
    local($country)= @_;

    $country = &strip($country);
    $country_code = $country_codes{uc($country)};;
    
    if ($country_code) {
	return $country_code;
    } else {
        return 0;
    }


}


sub get_state_name_from_array {  #given a two-letter abbrev. return a full name
    local($statecode)= @_;

    $state = &strip($state);
    $statename=$state_names{uc($statecode)};

      if ($state_name) {
        return $state_name;
    } else {
        return 0;
    }


}


sub get_state_code_from_array {  #given a name, get a two-letter abbrev.
    local($state)= @_;

    $state = &strip($state);

    $statecode=$state_codes{uc($state)};

    if ($statecode){ 
        return $statecode;
    } else {
        return 0;
    }

} 
sub get_county_name_from_array {  #given a two-letter abbrev. return a full name
    local($countycode)= @_;

    $county = &strip($county);
    $countyname=$county_codes{uc($countycode)};

      if ($county_name) {
        return $county_name;
    } else {
        return 0;
    }


}

sub is_a_number {
    local($fieldname) = @_;

    foreach $n (@nontextfields) {
        if ($n eq $fieldname) {return 1;}
    }
    return 0;
}


sub is_a_valid_HorizontalDatum {       # called by biocode_excel_datacheck
    my ($incoming) = @_;

    $incoming = &strip($incoming);

    if (!$incoming) {
	return;
    }
    foreach my $c (@HorizontalDatums) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}

sub print_HorizontalDatum_options {
    local($selected_HorizontalDatum) = @_;


    if (!$selected_HorizontalDatum) {
        $selected_HorizontalDatum = "unselected";
    }
    push(@HorizontalDatums,"unselected");
    foreach $s (@HorizontalDatums) {
        if ($s eq $selected_HorizontalDatum) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}


sub get_county_code_from_array {  #given a name, get a two-letter abbrev.
    local($county)= @_;

    $county = &strip($county);

    $countycode=$county_names{$county};

    if ($countycode){ 
        return $countycode;
    } else {
        return 0;
    }

} 


sub print_Cal_county_options {
    local($selected_county) = @_;  # should be the full name of the county

    foreach $c (@Cal_county_names_array) {
	if ($c eq $selected_county) {
	    print "<option selected>$c\n";
	} else {
	    print "<option>$c\n";
	}
    }
}

sub print_kingdom_options {
    local($selected_kingdom)  = @_; 

    foreach $k (@kingdoms) {
	if ($k eq $selected_kingdom) {
	    print "<option selected>$k\n";
        } else {
            print "<option>$k\n";
        }
    }
}


sub print_country_options_all {  
    local($selected_country) = @_;  # should be the full name of the county

    if (!$selected_country) {
	$selected_country = "unselected";
        print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }
    # 2/2008 note: this list is currently hand-edited
    $country_list = "/usr/local/bscit/select_lists/geo_data/country_all.txt";
    open(G,$country_list) || die "Can't open $country_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_country) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}


sub print_state_options_all {  
    local($selected_state) = @_;  # should be the full name of the state
 
    if (!$selected_state) {
	$selected_state = "none";
    } elsif ($selected_state eq "new") {
        print "<option selected>unselected\n";
    }
 
    $state_list = "/usr/local/bscit/select_lists/geo_data/state_all.txt";
    open(G,$state_list) || die "Can't open $state_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_state) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}


sub check_lat_long_dep_elev {  # used for eme, biocode

#print "<p>HERE HERE<p>";
#print "<p>long: $input{VerbatimLongitude}<p>";
#print "<p>lat: $input{VerbatimLatitude}<p>";

    ## Elevation and Depth: check min, max (GO 2/29/08)
    $elev_min = &strip($input{MinElevationMeters});
    $elev_max = &strip($input{MaxElevationMeters});
    $dep_min = &strip($input{MinDepthMeters});
    $dep_max = &strip($input{MaxDepthMeters});

    if ($elev_max) {
	if (!$elev_min) {
	    $bad_msg .= "<li><b>Elevation: 2nd elevation was input without a 1st elevation (if elevation is not a range, use 1st field only)";
	} elsif ($elev_min > $elev_max) {
	    $bad_msg .= "<li><b>Elevation: 1st elevation is greater than 2nd elevation";
	}
    }

    if ($dep_max) {
	if (!$dep_min) {
	    $bad_msg .= "<li><b>Depth: 2nd depth was input without a 1st depth (if depth is not a range, use 1st field only)";
	} elsif ($dep_min > $dep_max) {
	    $bad_msg .= "<li><b>Depth: 1st depth is greater than 2nd depth";
	}
    }
    

    ## Examples
    ## 
    ## VerbatimLatitude VerbatimLongitude DecimalLatitude DecimalLongitude
    ##    37 48 12 S       73 01 29 W         -37.8033       -73.0247 
    ##  30o 44' 00 N      115o 57' 00 W        30.7333      -115.9500 

    $input{VerbatimLatitude} = &strip($input{VerbatimLatitude});
    $input{VerbatimLongitude} = &strip($input{VerbatimLongitude});
    $input{VerbatimLatitude2} = &strip($input{VerbatimLatitude2});
    $input{VerbatimLongitude2} = &strip($input{VerbatimLongitude2});


    if ($input{VerbatimLongitude} || $input{VerbatimLatitude}) {
	if (!$input{VerbatimLatitude}) {
	    $bad_msg .= "<li><b>VerbatimLongitude entered but not VerbatimLatitude";
	} elsif (!$input{VerbatimLongitude}) {
	    $bad_msg .= "<li><b>VerbatimLatitude entered but not VerbatimLongitude";

	## match "16o 27' 00 S" or "04 43 00 N" or "116 44 13.4 W"
	} elsif ( ($input{VerbatimLatitude} =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) &&
		  ($input{VerbatimLongitude} =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) ) {
	    ($long_deg,$long_min,$long_sec,$long_dir) = split(/ /,$input{VerbatimLongitude});
	    ($lat_deg,$lat_min,$lat_sec,$lat_dir) = split(/ /,$input{VerbatimLatitude});
	    $input{DecimalLongitude} = &degrees2decimal($long_deg,$long_min,$long_sec,$long_dir);
	    $input{DecimalLatitude} = &degrees2decimal($lat_deg,$lat_min,$lat_sec,$lat_dir);

        ## match degrees decimal minutes: "36° 54.947' S" or "071° 27.417' W"
        ##                             or "36 54.947 S" or "071 27.417 W"
        } elsif ($input{VerbatimLatitude} =~ /^(\d{1,3})\W* (\d{1,2})(\.\d{1,5})\W* ([EWNS])$/) {
	    $lat_deg = $1;
            $lat_min = $2;
            $lat_sec = $3;
            $lat_sec = $lat_sec * 60;
            $lat_dir = $4;
            if($input{VerbatimLongitude} =~ /^(\d{1,3})\W* (\d{1,2})(\.\d{1,5})\W* ([EWNS])$/) {
	        $long_deg = $1;
                $long_min = $2;
                $long_sec = $3;
                $long_sec = $long_sec * 60;
                $long_dir = $4;
	        $input{DecimalLongitude} = &degrees2decimal($long_deg,$long_min,$long_sec,$long_dir);
                $input{DecimalLatitude} = &degrees2decimal($lat_deg,$lat_min,$lat_sec,$lat_dir);
            }

        # match this format: S17.54990 W149.79460 (S = -; W = -; N = nothing; E = nothing)
        } elsif ($input{VerbatimLatitude} =~ /^[SWNE]\s*(\d+\.\d+)$/ && $input{VerbatimLongitude} =~ /^[SWNE]\s*(\d+\.\d+)$/) {
            if ($input{VerbatimLatitude} =~ /^S\s*(\d+\.\d+)$/) {
                $input{DecimalLatitude} = "-$1";
            } elsif ($input{VerbatimLatitude} =~ /^N\s*(\d+\.\d+)$/) {
                $input{DecimalLatitude} = "$1";
            }
   
            if ($input{VerbatimLongitude} =~ /^W\s*(\d+\.\d+)$/) {
                $input{DecimalLongitude} = "-$1";
            } elsif ($input{VerbatimLongitude} =~ /^E\s*(\d+\.\d+)$/) {
                $input{DecimalLongitude} = "$1";
            }

	} else {
	    $bad_msg .= "<li><b>Verbatim Lat/Long:</b> unrecognized format ";
	    $bad_msg .= " <small>($help_win_link=VerbatimLatLon')\">click here for help</a>)</small>";
	    if ($input{DecimalLongitude} || $input{DecimalLatitude}) {
		$cmts .= "<li><b>Decimal Lat/Long:</b> please check, since Verbatim Lat/Long are invalid";
	    }
	}
    }
    if ($input{VerbatimLongitude2} || $input{VerbatimLatitude2}) {
	if (!$input{VerbatimLatitude2}) {
	    $bad_msg .= "<li><b>VerbatimLongitude2 entered but not VerbatimLatitude2";
	} elsif (!$input{VerbatimLongitude2}) {
	    $bad_msg .= "<li><b>VerbatimLatitude2 entered but not VerbatimLongitude2";

	## match "16o 27' 00 S" or "04 43 00 N" or "116 44 13.4 W"
	} elsif ( ($input{VerbatimLatitude2} =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) &&
		  ($input{VerbatimLongitude2} =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) ) {
	    ($long_deg,$long_min,$long_sec,$long_dir) = split(/ /,$input{VerbatimLongitude2});
	    ($lat_deg,$lat_min,$lat_sec,$lat_dir) = split(/ /,$input{VerbatimLatitude2});
	    $input{DecimalLongitude2} = &degrees2decimal($long_deg,$long_min,$long_sec,$long_dir);
	    $input{DecimalLatitude2} = &degrees2decimal($lat_deg,$lat_min,$lat_sec,$lat_dir);

	} else {
	    $bad_msg .= "<li><b>Verbatim Lat/Long 2:</b> unrecognized format ";
	    $bad_msg .= " <small>($help_win_link=VerbatimLatLon')\">click here for help</a>)</small>";
	    if ($input{DecimalLongitude2} || $input{DecimalLatitude2}) {
		$cmts .= "<li><b>Decimal Lat/Long 2:</b> please check, since Verbatim Lat/Long 2 are invalid";
	    }
	}
    }
    # make sure we got decimal numbers for all
    foreach $item qw(DecimalLongitude DecimalLatitude DecimalLongitude2 DecimalLatitude2 
        MinElevationMeters MaxElevationMeters MinDepthMeters MaxDepthMeters) {

        $input{$item} =~ s/\s//g;
	if ($input{$item}) {
	    if (!&is_a_decimalnumber($input{$item})) {
		$bad_msg .= "<li><b>$item</b> \"$input{$item}\" is not a decimal number";
	    }
	    else {
		$input{$item} = sprintf("%1.5f",$input{$item});
	    }
	}
    }
    ## double check US lat/longs
    
    if ($input{DecimalLongitude}) {
	$country_code = $country_codes{uc($input{Country})};
	&check_decimal_lat_lon_by_country($input{DecimalLatitude},$input{DecimalLongitude},$country_code);
    }
    if ($input{DecimalLongitude2}) {
	$country_code = $country_codes{uc($input{Country})};
	&check_decimal_lat_lon_by_country($input{DecimalLatitude2},$input{DecimalLongitude2},$country_code);
    }
}


sub checkSpecimenNumCollector {
    my ($file)=@_;
    # Remove the .* (extension)
    my ($name, $path, $suffix) = fileparse($file, '\.[^\.]*');
    # remove any _[a-z]  OR _[1-9] characters
    #($name, $path, $suffix) = fileparse($name, '_[a-z]|_[1-9][0-9]|_[1-9]$');
	# parse out just filename
    ($name, $path, $suffix) = fileparse($name);
	
	# take everything before the plus symbol and just parse that
	($name,$suffix) = split(/\+/,$name);

    $val = "";
    $query =  "SELECT biocode.specimen_num_collector";
    #$query .= " FROM biocode, biocode_collecting_event ";
    $query .= " FROM biocode";
    $query .= " WHERE upper(biocode.Specimen_Num_Collector) = upper('$name')";
    #$query .= " AND biocode_collecting_event.EventID = biocode.Coll_EventID";

    ($bnhm_id) = &get_one_record($query,"biocode");
    if($bnhm_id eq "") {
        return -9999;
    } else {
        return $bnhm_id;
    }
}

sub convert_verbatim_lat_long {  

    my($VerbatimLatitude, $VerbatimLongitude) = @_;
    my $DecimalLongitude = "";
    my $DecimalLatitude = "";


    ## Examples
    ## 
    ## VerbatimLatitude VerbatimLongitude DecimalLatitude DecimalLongitude
    ##    37 48 12 S       73 01 29 W         -37.8033       -73.0247 
    ##  30o 44' 00 N      115o 57' 00 W        30.7333      -115.9500 

    $VerbatimLatitude = &strip($VerbatimLatitude);
    $VerbatimLongitude = &strip($VerbatimLongitude);


    if ($VerbatimLongitude || $VerbatimLatitude) {
	if (!$VerbatimLatitude) {
	    $bad_msg .= "<li><b>VerbatimLongitude entered but not VerbatimLatitude";
	} elsif (!$VerbatimLongitude) {
	    $bad_msg .= "<li><b>VerbatimLatitude entered but not VerbatimLongitude";

	## match "16o 27' 00 S" or "04 43 00 N" or "116 44 13.4 W"
	} elsif ( ($VerbatimLatitude =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) &&
		  ($VerbatimLongitude =~ /^\d{1,3}\W* \d{1,2}\W* \d{1,2}(\.\d+)*\W* [EWNS]$/) ) {
	    ($long_deg,$long_min,$long_sec,$long_dir) = split(/ /,$VerbatimLongitude);
	    ($lat_deg,$lat_min,$lat_sec,$lat_dir) = split(/ /,$VerbatimLatitude);
	    $DecimalLongitude = &degrees2decimal($long_deg,$long_min,$long_sec,$long_dir);
	    $DecimalLatitude = &degrees2decimal($lat_deg,$lat_min,$lat_sec,$lat_dir);

        ## match degrees decimal minutes: "36° 54.947' S" or "071° 27.417' W"
        ##                             or "36 54.947 S" or "071 27.417 W"
        } elsif ($VerbatimLatitude =~ /^(\d{1,3})\W* (\d{1,2})(\.\d{1,5})\W* ([EWNS])$/) {
	    $lat_deg = $1;
            $lat_min = $2;
            $lat_sec = $3;
            $lat_sec = $lat_sec * 60;
            $lat_dir = $4;
            if($VerbatimLongitude =~ /^(\d{1,3})\W* (\d{1,2})(\.\d{1,5})\W* ([EWNS])$/) {
	        $long_deg = $1;
                $long_min = $2;
                $long_sec = $3;
                $long_sec = $long_sec * 60;
                $long_dir = $4;
	        $DecimalLongitude = &degrees2decimal($long_deg,$long_min,$long_sec,$long_dir);
                $DecimalLatitude = &degrees2decimal($lat_deg,$lat_min,$lat_sec,$lat_dir);
            }

        # match this format: S17.54990 W149.79460 (S = -; W = -; N = nothing; E = nothing)
        } elsif ($VerbatimLatitude =~ /^[SWNE]\s*(\d+\.\d+)$/ && $VerbatimLongitude =~ /^[SWNE]\s*(\d+\.\d+)$/) {
            if ($VerbatimLatitude =~ /^S\s*(\d+\.\d+)$/) {
                $DecimalLatitude = "-$1";
            } elsif ($VerbatimLatitude =~ /^N\s*(\d+\.\d+)$/) {
                $DecimalLatitude = "$1";
            }

            if ($VerbatimLongitude =~ /^W\s*(\d+\.\d+)$/) {
                $DecimalLongitude = "-$1";
            } elsif ($VerbatimLongitude =~ /^E\s*(\d+\.\d+)$/) {
                $DecimalLongitude = "$1";
            }

	} else {
	    $bad_msg .= "<li><b>Verbatim Lat/Long:</b> unrecognized format ";
	    $bad_msg .= " <small>($help_win_link=VerbatimLatLon')\">click here for help</a>)</small>";
	    if ($DecimalLongitude || $DecimalLatitude) {
		$cmts .= "<li><b>Decimal Lat/Long:</b> please check, since Verbatim Lat/Long are invalid";
	    }
	}
    }

    # make sure we got decimal numbers for all
    foreach $item qw(DecimalLongitude DecimalLatitude) {

        $input{$item} =~ s/\s//g;
	if ($input{$item}) {
	    if (!&is_a_decimalnumber($input{$item})) {
		$bad_msg .= "<li><b>$item</b> \"$input{$item}\" is not a decimal number";
	    }
	    else {
		$input{$item} = sprintf("%1.5f",$input{$item});
	    }
	}
    }
    return($DecimalLatitude,$DecimalLongitude);
    
}





## $county = @county_codes{$county};  return name
%county_codes = (
                 'ACC', 'Alameda/Contra Costa',
                 'ALA', 'Alameda',
                 'ALP', 'Alpine',
                 'AMA', 'Amador',
                 'BUT', 'Butte',
                 'CAL', 'Calaveras',
                 'CCA', 'Contra Costa',
                 'COL', 'Colusa',
                 'DNT', 'Del Norte',
                 'ELD', 'El Dorado',
                 'FRE', 'Fresno',
                 'FTU', 'Fresno/Tulare',
                 'GLE', 'Glenn',
                 'HUM', 'Humboldt',
                 'IMP', 'Imperial',
                 'IMN', 'Inyo/Mono',
                 'INY', 'Inyo',
                 'ISB', 'Inyo/San Bernardino',
                 'ISD', 'Imperial/San Diego',
                 'KNG', 'Kings',
                 'KRN', 'Kern',
                 'KRV', 'Kern/Ventura',
                 'LAK', 'Lake',
                 'LAS', 'Lassen',
                 'LAX', 'Los Angeles',
                 'LSH', 'Lassen/Shasta',
                 'MAD', 'Madera',
                 'MEN', 'Mendocino',
                 'MER', 'Merced',
                 'MNO', 'Mono',
                 'MNT', 'Monterey',
                 'MOD', 'Modoc',
                 'MPA', 'Mariposa',
                 'MPT', 'Mariposa/Tuolumne',
                 'MRN', 'Marin',
                 'NAP', 'Napa',
                 'NEV', 'Nevada',
                 'ORA', 'Orange',
                 'PLA', 'Placer',
                 'PLU', 'Plumas',
                 'RIV', 'Riverside',
                 'SAC', 'Sacramento',
                 'SBA', 'Santa Barbara',
                 'SBD', 'San Bernardino',
                 'SBT', 'San Benito',
                 'SCL', 'Santa Clara',
                 'SCR', 'Santa Cruz',
                 'SCS', 'Santa Clara/Stanislaus',
                 'SDG', 'San Diego',
                 'SFO', 'San Francisco',
                 'SMT', 'San Mateo',
                 'SHA', 'Shasta',
                 'SIE', 'Sierra',
                 'SIS', 'Siskiyou',
                 'SIT', 'Siskiyou/Trinity',
                 'SJQ', 'San Joaquin',
                 'SLO', 'San Luis Obispo',
                 'SOL', 'Solano',
                 'SON', 'Sonoma',
                 'SSC', 'Santa Clara/Santa Cruz',
                 'STA', 'Stanislaus',
                 'SUT', 'Sutter',
                 'TEH', 'Tehama',
                 'TTR', 'Tehama/Trinity',
                 'TRI', 'Trinity',
                 'TUL', 'Tulare',
                 'TUO', 'Tuolumne',
                 'VEN', 'Ventura',
                 'YOL', 'Yolo',
                 'YUB', 'Yuba'
                 );

## $county_code = @county_names{$fullname};
%county_names = (
                 'Alameda', 'ALA',
                 'Alameda/Contra Costa','ACC',
                 'Alpine', 'ALP',
                 'Amador', 'AMA',
                 'Butte', 'BUT',
                 'Calaveras', 'CAL',
                 'Colusa', 'COL',
                 'Contra Costa', 'CCA',
                 'Del Norte', 'DNT',
                 'El Dorado', 'ELD',
                 'Fresno', 'FRE',
                 'Fresno/Tulare','FTU',
                 'Glenn', 'GLE',
                 'Humboldt', 'HUM',
                 'Imperial', 'IMP',
                 'Imperial/San Diego','ISD',
                 'Inyo', 'INY',
                 'Inyo/Mono','IMN',
                 'Inyo/San Bernardino','ISB',
                 'Kern', 'KRN',
                 'Kern/Ventura','KRV',
                 'Kings', 'KNG',
                 'Lake', 'LAK',
                 'Lassen', 'LAS',
                 'Lassen/Shasta','LSH',
                 'Los Angeles', 'LAX',
                 'Madera', 'MAD',
                 'Marin', 'MRN',
                 'Mariposa', 'MPA',
                 'Mariposa/Tuolumne','MPT',
                 'Mendocino', 'MEN',
                 'Merced', 'MER',
                 'Modoc', 'MOD',
                 'Mono', 'MNO',
                 'Monterey', 'MNT',
                 'Napa', 'NAP',
                 'Nevada', 'NEV',
                 'Orange', 'ORA',
                 'Placer', 'PLA',
                 'Plumas', 'PLU',
                 'Riverside', 'RIV',
                 'Sacramento', 'SAC',
                 'San Benito', 'SBT',
                 'San Bernardino', 'SBD',
                 'San Diego', 'SDG',
                 'San Francisco', 'SFO',
                 'San Joaquin', 'SJQ',
                 'San Luis Obispo', 'SLO',
                 'San Mateo', 'SMT',
                 'Santa Barbara', 'SBA',
                 'Santa Clara', 'SCL',
                 'Santa Clara/Santa Cruz','SSC',
                 'Santa Clara/Stanislaus','SCS',
                 'Santa Cruz', 'SCR',
                 'Shasta', 'SHA',
                 'Sierra', 'SIE',
                 'Siskiyou', 'SIS',
                 'Siskiyou/Trinity','SIT',
                 'Solano', 'SOL',
                 'Sonoma', 'SON',
                 'Stanislaus', 'STA',
                 'Sutter', 'SUT',
                 'Tehama', 'TEH',
                 'Tehama/Trinity','TTR',
                 'Trinity', 'TRI',
                 'Tulare', 'TUL',
                 'Tuolumne', 'TUO',
                 'Ventura', 'VEN',
                 'Yolo', 'YOL',
                 'Yuba', 'YUB'
                 );

@Cal_county_names_array = (
                 'Alameda County', 
                 'Alpine County', 
                 'Amador County', 
                 'Butte County', 
                 'Calaveras County',
                 'Colusa County', 
                 'Contra Costa County',
                 'Del Norte County', 
                 'El Dorado County', 
                 'Fresno County', 
                 'Glenn County', 
                 'Humboldt County',
                 'Imperial County',
                 'Inyo County',
                 'Kern County',
                 'Kings County',
                 'Lake County', 
                 'Lassen County',
                 'Los Angeles County',
                 'Madera County', 
                 'Marin County', 
                 'Mariposa County',
                 'Mendocino County',
                 'Merced County', 
                 'Modoc County', 
                 'Mono County', 
                 'Monterey County',
                 'Napa County', 
                 'Nevada County',
                 'Orange County',
                 'Placer County',
                 'Plumas County',
                 'Riverside County',
                 'Sacramento County',
                 'San Benito County',
                 'San Bernardino County',
                 'San Diego County', 
                 'San Francisco County',
                 'San Joaquin County',
                 'San Luis Obispo County',
                 'San Mateo County',
                 'Santa Barbara County',
                 'Santa Clara County',
                 'Santa Cruz County', 
                 'Shasta County',
                 'Sierra County', 
                 'Siskiyou County',
                 'Solano County',
                 'Sonoma County',
                 'Stanislaus County',
                 'Sutter County',
                 'Tehama County',
                 'Trinity County',
                 'Tulare County', 
                 'Tuolumne County',
                 'Ventura County', 
                 'Yolo County',
                 'Yuba County',
                 );


# $cname=$country_names{$code};

%country_names = (
	'AF',	'Afghanistan',
	'AL',	'Albania',
	'DZ',	'Algeria',
	'AS',	'American Samoa',
	'AD',	'Andorra',
	'AO',	'Angola',
	'AI',	'Anguilla',
	'AQ',	'Antarctica',
	'AG',	'Antigua and Barbuda',
	'AR',	'Argentina',
	'AM',	'Armenia',
	'AW',	'Aruba',
	'AU',	'Australia',
	'AT',	'Austria',
	'AZ',	'Azerbaijan',
	'BS',	'Bahamas',
	'BH',	'Bahrain',
	'BD',	'Bangladesh',
	'BB',	'Barbados',
	'BY',	'Belarus',
	'BE',	'Belgium',
	'BZ',	'Belize',
	'BJ',	'Benin',
	'BM',	'Bermuda',
	'BT',	'Bhutan',
	'BO',	'Bolivia',
	'BA',	'Bosnia and Herzegovina',
	'BW',	'Botswana',
	'BV',	'Bouvet Island',
	'BR',	'Brazil',
	'IO',	'British Indian Ocean Territory',
	'BN',	'Brunei Darussalam',
	'BG',	'Bulgaria',
	'BF',	'Burkina Faso',
	'BI',	'Burundi',
	'KH',	'Cambodia',
	'CM',	'Cameroon',
	'CA',	'Canada',
	'CV',	'Cape Verde',
	'KY',	'Cayman Islands',
	'CF',	'Central African Republic',
	'TD',	'Chad',
	'CL',	'Chile',
	'CN',	'China',
	'CX',	'Christmas Island',
	'CC',	'Cocos (Keeling) Islands',
	'CO',	'Colombia',
	'KM',	'Comoros',
	'CG',	'Congo',
	'CD',	'Congo, the Democratic Republic of the',
	'CK',	'Cook Islands',
	'CR',	'Costa Rica',
	'CI',	'Cote d\'Ivoire',
	'HR',	'Croatia',
	'CU',	'Cuba',
	'CY',	'Cyprus',
	'CZ',	'Czech Republic',
	'DK',	'Denmark',
	'DJ',	'Djibouti',
	'DM',	'Dominica',
	'DO',	'Dominican Republic',
	'TP',	'East Timor',
	'EC',	'Ecuador',
	'EG',	'Egypt',
	'SV',	'El Salvador',
	'GQ',	'Equatorial Guinea',
	'ER',	'Eritrea',
	'EE',	'Estonia',
	'ET',	'Ethiopia',
	'FK',	'Falkland Islands (Malvinas)',
	'FO',	'Faroe Islands',
	'FJ',	'Fiji',
	'FI',	'Finland',
	'FR',	'France',
	'GF',	'French Guiana',
	'PF',	'French Polynesia',
	'TF',	'French Southern Territories',
	'GA',	'Gabon',
	'GM',	'Gambia',
	'GE',	'Georgia',
	'DE',	'Germany',
	'GH',	'Ghana',
	'GI',	'Gibraltar',
	'GR',	'Greece',
	'GL',	'Greenland',
	'GD',	'Grenada',
	'GP',	'Guadeloupe',
	'GU',	'Guam',
	'GT',	'Guatemala',
	'GN',	'Guinea',
	'GW',	'Guinea-Bissau',
	'GY',	'Guyana',
	'HT',	'Haiti',
	'HM',	'Heard Island and McDonald Islands',
	'VA',	'Holy See (Vatican City State)',
	'HN',	'Honduras',
	'HK',	'Hong Kong',
	'HU',	'Hungary',
	'IS',	'Iceland',
	'IN',	'India',
	'ID',	'Indonesia',
	'IR',	'Iran, Islamic Republic of',
	'IQ',	'Iraq',
	'IE',	'Ireland',
	'IL',	'Israel',
	'IT',	'Italy',
	'JM',	'Jamaica',
	'JP',	'Japan',
	'JO',	'Jordan',
	'KZ',	'Kazakhstan',
	'KE',	'Kenya',
	'KI',	'Kiribati',
	'KP',	'Korea, Democratic People\'s Republic of',
	'KR',	'Korea, Republic of',
	'KW',	'Kuwait',
	'KG',	'Kyrgyzstan',
	'LA',	'Lao People\'s Democratic Republic',
	'LV',	'Latvia',
	'LB',	'Lebanon',
	'LS',	'Lesotho',
	'LR',	'Liberia',
	'LY',	'Libyan Arab Jamahiriya',
	'LI',	'Liechtenstein',
	'LT',	'Lithuania',
	'LU',	'Luxembourg',
	'MO',	'Macau',
	'MK',	'Macedonia, the Former Yugoslav Republic of',
	'MG',	'Madagascar',
	'MW',	'Malawi',
	'MY',	'Malaysia',
	'MV',	'Maldives',
	'ML',	'Mali',
	'MT',	'Malta',
	'MH',	'Marshall Islands',
	'MQ',	'Martinique',
	'MR',	'Mauritania',
	'MU',	'Mauritius',
	'YT',	'Mayotte',
	'MX',	'Mexico',
	'FM',	'Micronesia, Federated States of',
	'MD',	'Moldova, Republic of',
	'MC',	'Monaco',
	'MN',	'Mongolia',
	'MS',	'Montserrat',
	'MA',	'Morocco',
	'MZ',	'Mozambique',
	'MM',	'Myanmar',
	'NA',	'Namibia',
	'NR',	'Nauru',
	'NP',	'Nepal',
	'NL',	'Netherlands',
	'AN',	'Netherlands Antilles',
	'NC',	'New Caledonia',
	'NZ',	'New Zealand',
	'NI',	'Nicaragua',
	'NE',	'Niger',
	'NG',	'Nigeria',
	'NU',	'Niue',
	'NF',	'Norfolk Island',
	'MP',	'Northern Mariana Islands',
	'NO',	'Norway',
	'OM',	'Oman',
	'PK',	'Pakistan',
	'PW',	'Palau',
	'PA',	'Panama',
	'PG',	'Papua New Guinea',
	'PY',	'Paraguay',
	'PE',	'Peru',
	'PH',	'Philippines',
	'PN',	'Pitcairn',
	'PL',	'Poland',
	'PT',	'Portugal',
	'PR',	'Puerto Rico',
	'QA',	'Qatar',
	'RE',	'RÉunion',
	'RO',	'Romania',
	'RU',	'Russian Federation',
	'RW',	'Rwanda',
	'SH',	'Saint Helena',
	'KN',	'Saint Kitts and Nevis',
	'LC',	'Saint Lucia',
	'PM',	'Saint Pierre and Miquelon',
	'VC',	'Saint Vincent and the Grenadines',
	'WS',	'Samoa',
	'SM',	'San Marino',
	'ST',	'Sao Tome and Principe',
	'SA',	'Saudi Arabia',
	'SN',	'Senegal',
	'SC',	'Seychelles',
	'SL',	'Sierra Leone',
	'SG',	'Singapore',
	'SK',	'Slovakia',
	'SI',	'Slovenia',
	'SB',	'Solomon Islands',
	'SO',	'Somalia',
	'ZA',	'South Africa',
	'GS',	'South Georgia and the South Sandwich Islands',
	'ES',	'Spain',
	'LK',	'Sri Lanka',
	'SD',	'Sudan',
	'SR',	'Suriname',
	'SJ',	'Svalbard and Jan Mayen',
	'SZ',	'Swaziland',
	'SE',	'Sweden',
	'CH',	'Switzerland',
	'SY',	'Syrian Arab Republic',
	'TW',	'Taiwan, Province of China',
	'TJ',	'Tajikistan',
	'TZ',	'Tanzania, United Republic of',
	'TH',	'Thailand',
	'TG',	'Togo',
	'TK',	'Tokelau',
	'TO',	'Tonga',
	'TT',	'Trinidad and Tobago',
	'TN',	'Tunisia',
	'TR',	'Turkey',
	'TM',	'Turkmenistan',
	'TC',	'Turks and Caicos Islands',
	'TV',	'Tuvalu',
	'UG',	'Uganda',
	'UA',	'Ukraine',
	'AE',	'United Arab Emirates',
	'GB',	'United Kingdom',
	'US',	'United States',
	'UM',	'United States Minor Outlying Islands',
	'UY',	'Uruguay',
	'UZ',	'Uzbekistan',
	'VU',	'Vanuatu',
	'VE',	'Venezuela',
	'VN',	'Vietnam',
	'VG',	'Virgin Islands, British',
	'VI',	'Virgin Islands, U.S.',
	'WF',	'Wallis and Futuna',
	'EH',	'Western Sahara',
	'YE',	'Yemen',
	'YU',	'Yugoslavia',
	'ZM',	'Zambia',
	'ZW',	'Zimbabwe',
);
		  

# $ccode=$country_codes{uc($country)};

%country_codes = (
		'AFGHANISTAN', 'AF',
		'ALBANIA', 'AL',
		'ALGERIA', 'DZ',
		'AMERICAN SAMOA', 'AS',
		'ANDORRA', 'AD',
		'ANGOLA', 'AO',
		'ANGUILLA', 'AI',
		'ANTARCTICA', 'AQ',
		'ANTIGUA AND BARBUDA', 'AG',
		'ARGENTINA', 'AR',
		'ARMENIA', 'AM',
		'ARUBA', 'AW',
		'AUSTRALIA', 'AU',
		'AUSTRIA', 'AT',
		'AZERBAIJAN', 'AZ',
		'BAHAMAS', 'BS',
		'BAHRAIN', 'BH',
		'BANGLADESH', 'BD',
		'BARBADOS', 'BB',
		'BELARUS', 'BY',
		'BELGIUM', 'BE',
		'BELIZE', 'BZ',
		'BENIN', 'BJ',
		'BERMUDA', 'BM',
		'BHUTAN', 'BT',
		'BOLIVIA', 'BO',
		'BOSNIA AND HERZEGOVINA', 'BA',
		'BOTSWANA', 'BW',
		'BOUVET ISLAND', 'BV',
		'BRAZIL', 'BR',
		'BRITISH INDIAN OCEAN TERRITORY', 'IO',
		'BRUNEI DARUSSALAM', 'BN',
		'BULGARIA', 'BG',
		'BURKINA FASO', 'BF',
		'BURUNDI', 'BI',
		'CAMBODIA', 'KH',
		'CAMEROON', 'CM',
		'CANADA', 'CA',
		'CAPE VERDE', 'CV',
		'CAYMAN ISLANDS', 'KY',
		'CENTRAL AFRICAN REPUBLIC', 'CF',
		'CHAD', 'TD',
		'CHILE', 'CL',
		'CHINA', 'CN',
		'CHRISTMAS ISLAND', 'CX',
		'COCOS (KEELING) ISLANDS', 'CC',
		'COLOMBIA', 'CO',
		'COMOROS', 'KM',
		'CONGO', 'CG',
		'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'CD',
		'COOK ISLANDS', 'CK',
		'COSTA RICA', 'CR',
		'COTE D\'IVOIRE', 'CI',
		'CROATIA', 'HR',
		'CUBA', 'CU',
		'CYPRUS', 'CY',
		'CZECH REPUBLIC', 'CZ',
		'DENMARK', 'DK',
		'DJIBOUTI', 'DJ',
		'DOMINICA', 'DM',
		'DOMINICAN REPUBLIC', 'DO',
		'EAST TIMOR', 'TP',
		'ECUADOR', 'EC',
		'EGYPT', 'EG',
		'EL SALVADOR', 'SV',
		'EQUATORIAL GUINEA', 'GQ',
		'ERITREA', 'ER',
		'ESTONIA', 'EE',
		'ETHIOPIA', 'ET',
		'FALKLAND ISLANDS (MALVINAS)', 'FK',
		'FAROE ISLANDS', 'FO',
		'FIJI', 'FJ',
		'FINLAND', 'FI',
		'FRANCE', 'FR',
		'FRENCH GUIANA', 'GF',
		'FRENCH POLYNESIA', 'PF',
		'FRENCH SOUTHERN TERRITORIES', 'TF',
		'GABON', 'GA',
		'GAMBIA', 'GM',
		'GEORGIA', 'GE',
		'GERMANY', 'DE',
		'GHANA', 'GH',
		'GIBRALTAR', 'GI',
		'GREECE', 'GR',
		'GREENLAND', 'GL',
		'GRENADA', 'GD',
		'GUADELOUPE', 'GP',
		'GUAM', 'GU',
		'GUATEMALA', 'GT',
		'GUINEA', 'GN',
		'GUINEA-BISSAU', 'GW',
		'GUYANA', 'GY',
		'HAITI', 'HT',
		'HEARD ISLAND AND MCDONALD ISLANDS', 'HM',
		'HOLY SEE (VATICAN CITY STATE)', 'VA',
		'HONDURAS', 'HN',
		'HONG KONG', 'HK',
		'HUNGARY', 'HU',
		'ICELAND', 'IS',
		'INDIA', 'IN',
		'INDONESIA', 'ID',
		'IRAN, ISLAMIC REPUBLIC OF', 'IR',
		'IRAQ', 'IQ',
		'IRELAND', 'IE',
		'ISRAEL', 'IL',
		'ITALY', 'IT',
		'JAMAICA', 'JM',
		'JAPAN', 'JP',
		'JORDAN', 'JO',
		'KAZAKHSTAN', 'KZ',
		'KENYA', 'KE',
		'KIRIBATI', 'KI',
		'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF', 'KP',
		'KOREA, REPUBLIC OF', 'KR',
		'KUWAIT', 'KW',
		'KYRGYZSTAN', 'KG',
		'LAO PEOPLE\'S DEMOCRATIC REPUBLIC', 'LA',
		'LATVIA', 'LV',
		'LEBANON', 'LB',
		'LESOTHO', 'LS',
		'LIBERIA', 'LR',
		'LIBYAN ARAB JAMAHIRIYA', 'LY',
		'LIECHTENSTEIN', 'LI',
		'LITHUANIA', 'LT',
		'LUXEMBOURG', 'LU',
		'MACAO', 'MO',
		'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', 'MK',
		'MADAGASCAR', 'MG',
		'MALAWI', 'MW',
		'MALAYSIA', 'MY',
		'MALDIVES', 'MV',
		'MALI', 'ML',
		'MALTA', 'MT',
		'MARSHALL ISLANDS', 'MH',
		'MARTINIQUE', 'MQ',
		'MAURITANIA', 'MR',
		'MAURITIUS', 'MU',
		'MAYOTTE', 'YT',
		'MEXICO', 'MX',
		'MICRONESIA, FEDERATED STATES OF', 'FM',
		'MOLDOVA, REPUBLIC OF', 'MD',
		'MONACO', 'MC',
		'MONGOLIA', 'MN',
		'MONTSERRAT', 'MS',
		'MOROCCO', 'MA',
		'MOZAMBIQUE', 'MZ',
		'MYANMAR', 'MM',
		'NAMIBIA', 'NA',
		'NAURU', 'NR',
		'NEPAL', 'NP',
		'NETHERLANDS', 'NL',
		'NETHERLANDS ANTILLES', 'AN',
		'NEW CALEDONIA', 'NC',
		'NEW ZEALAND', 'NZ',
		'NICARAGUA', 'NI',
		'NIGER', 'NE',
		'NIGERIA', 'NG',
		'NIUE', 'NU',
		'NORFOLK ISLAND', 'NF',
		'NORTHERN MARIANA ISLANDS', 'MP',
		'NORWAY', 'NO',
		'OMAN', 'OM',
		'PAKISTAN', 'PK',
		'PALAU', 'PW',
		'PANAMA', 'PA',
		'PAPUA NEW GUINEA', 'PG',
		'PARAGUAY', 'PY',
		'PERU', 'PE',
		'PHILIPPINES', 'PH',
		'PITCAIRN', 'PN',
		'POLAND', 'PL',
		'PORTUGAL', 'PT',
		'PUERTO RICO', 'PR',
		'QATAR', 'QA',
		'REUNION', 'RE',
		'ROMANIA', 'RO',
		'RUSSIAN FEDERATION', 'RU',
		'RWANDA', 'RW',
		'SAINT HELENA', 'SH',
		'SAINT KITTS AND NEVIS', 'KN',
		'SAINT LUCIA', 'LC',
		'SAINT PIERRE AND MIQUELON', 'PM',
		'SAINT VINCENT AND THE GRENADINES', 'VC',
		'SAMOA', 'WS',
		'SAN MARINO', 'SM',
		'SAO TOME AND PRINCIPE', 'ST',
		'SAUDI ARABIA', 'SA',
		'SENEGAL', 'SN',
		'SEYCHELLES', 'SC',
		'SIERRA LEONE', 'SL',
		'SINGAPORE', 'SG',
		'SLOVAKIA', 'SK',
		'SLOVENIA', 'SI',
		'SOLOMON ISLANDS', 'SB',
		'SOMALIA', 'SO',
		'SOUTH AFRICA', 'ZA',
		'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'GS',
		'SPAIN', 'ES',
		'SRI LANKA', 'LK',
		'SUDAN', 'SD',
		'SURINAME', 'SR',
		'SVALBARD AND JAN MAYEN', 'SJ',
		'SWAZILAND', 'SZ',
		'SWEDEN', 'SE',
		'SWITZERLAND', 'CH',
		'SYRIAN ARAB REPUBLIC', 'SY',
		'TAIWAN, PROVINCE OF CHINA', 'TW',
		'TAJIKISTAN', 'TJ',
		'TANZANIA, UNITED REPUBLIC OF', 'TZ',
		'THAILAND', 'TH',
		'TOGO', 'TG',
		'TOKELAU', 'TK',
		'TONGA', 'TO',
		'TRINIDAD AND TOBAGO', 'TT',
		'TUNISIA', 'TN',
		'TURKEY', 'TR',
		'TURKMENISTAN', 'TM',
		'TURKS AND CAICOS ISLANDS', 'TC',
		'TUVALU', 'TV',
		'UGANDA', 'UG',
		'UKRAINE', 'UA',
		'UNITED ARAB EMIRATES', 'AE',
		'UNITED KINGDOM', 'GB',
		'UNITED STATES', 'US',
		'UNITED STATES MINOR OUTLYING ISLANDS', 'UM',
		'URUGUAY', 'UY',
		'UZBEKISTAN', 'UZ',
		'VANUATU', 'VU',
		'VENEZUELA', 'VE',
		'VIET NAM', 'VN',
		'VIRGIN ISLANDS, BRITISH', 'VG',
		'VIRGIN ISLANDS, U.S.', 'VI',
		'WALLIS AND FUTUNA', 'WF',
		'WESTERN SAHARA', 'EH',
		'YEMEN', 'YE',
		'YUGOSLAVIA', 'YU',
		'ZAMBIA', 'ZM',
		'ZIMBABWE', 'ZW',
		'PALESTINIAN TERRITORY, OCCUPIED', 'PS'
		);

#$statecode=$state_codes{uc($state_prov)};

%state_codes = (
		'ALABAMA', 'AL',
		'ALASKA', 'AK',
		# 'AMERICAN SAMOA', 'AS',
		'ARIZONA', 'AZ',
		'ARKANSAS', 'AR',
		'CALIFORNIA', 'CA',
		'COLORADO', 'CO',
		'CONNECTICUT', 'CT',
		'DELAWARE', 'DE',
		'DISTRICT OF COLUMBIA', 'DC',
		# 'FEDERATED STATES OF MICRONESIA', 'FM',
		'FLORIDA', 'FL',
		'GEORGIA', 'GA',
		# 'GUAM', 'GU',  # use country = Guam
		'HAWAII', 'HI',
		'IDAHO', 'ID',
		'ILLINOIS', 'IL',
		'INDIANA', 'IN',
		'IOWA', 'IA',
		'KANSAS', 'KS',
		'KENTUCKY', 'KY',
		'LOUISIANA', 'LA',
		'MAINE', 'ME',
		# 'MARSHALL ISLANDS', 'MH',
		'MARYLAND', 'MD',
		'MASSACHUSETTS', 'MA',
		'MICHIGAN', 'MI',
		'MINNESOTA', 'MN',
		'MISSISSIPPI', 'MS',
		'MISSOURI', 'MO',
		'MONTANA', 'MT',
		'NEBRASKA', 'NE',
		'NEVADA', 'NV',
		'NEW HAMPSHIRE', 'NH',
		'NEW JERSEY', 'NJ',
		'NEW MEXICO', 'NM',
		'NEW YORK', 'NY',
		'NORTH CAROLINA', 'NC',
		'NORTH DAKOTA', 'ND',
		#'NORTHERN MARIANA ISLANDS', 'MP',
		'OHIO', 'OH',
		'OKLAHOMA', 'OK',
		'OREGON', 'OR',
		#'PALAU', 'PW',
		'PENNSYLVANIA', 'PA',
		#'PUERTO RICO', 'PR',
		'RHODE ISLAND', 'RI',
		'SOUTH CAROLINA', 'SC',
		'SOUTH DAKOTA', 'SD',
		'TENNESSEE', 'TN',
		'TEXAS', 'TX',
		'UTAH', 'UT',
		'VERMONT', 'VT',
		'# VIRGIN ISLANDS OF THE U.S.', 'VI',
		'VIRGINIA', 'VA',
		'WASHINGTON', 'WA',
		'WEST VIRGINIA', 'WV',
		'WISCONSIN', 'WI',
		'WYOMING', 'WY',
		# 'U.S. MINOR OUTLYING ISLANDS', 'UM'
		);

#$statename=$state_names{uc($state_prov)};

%state_names = (
		'AL', 'ALABAMA',
		'AK', 'ALASKA',
		#'AS', 'AMERICAN SAMOA',
		'AZ', 'ARIZONA',
		'AR', 'ARKANSAS',
		'CA', 'CALIFORNIA',
		'CO', 'COLORADO',
		'CT', 'CONNECTICUT',
		'DE', 'DELAWARE',
		'DC', 'DISTRICT OF COLUMBIA',
		#'FM', 'FEDERATED STATES OF MICRONESIA',
		'FL', 'FLORIDA',
		'GA', 'GEORGIA',
		# 'GU', 'GUAM',  # use country= Guam
		'HI', 'HAWAII',
		'ID', 'IDAHO',
		'IL', 'ILLINOIS',
		'IN', 'INDIANA',
		'IA', 'IOWA',
		'KS', 'KANSAS',
		'KY', 'KENTUCKY',
		'LA', 'LOUISIANA',
		'ME', 'MAINE',
		#'MH', 'MARSHALL ISLANDS',
		'MD', 'MARYLAND',
		'MA', 'MASSACHUSETTS',
		'MI', 'MICHIGAN',
		'MN', 'MINNESOTA',
		'MS', 'MISSISSIPPI',
		'MO', 'MISSOURI',
		'MT', 'MONTANA',
		'NE', 'NEBRASKA',
		'NV', 'NEVADA',
		'NH', 'NEW HAMPSHIRE',
		'NJ', 'NEW JERSEY',
		'NM', 'NEW MEXICO',
		'NY', 'NEW YORK',
		'NC', 'NORTH CAROLINA',
		'ND', 'NORTH DAKOTA',
		#'MP', 'NORTHERN MARIANA ISLANDS',
		'OH', 'OHIO',
		'OK', 'OKLAHOMA',
		'OR', 'OREGON',
		#'PW', 'PALAU',
		'PA', 'PENNSYLVANIA',
		#'PR', 'PUERTO RICO',
		'RI', 'RHODE ISLAND',
		'SC', 'SOUTH CAROLINA',
		'SD', 'SOUTH DAKOTA',
		'TN', 'TENNESSEE',
		'TX', 'TEXAS',
		'UT', 'UTAH',
		'VT', 'VERMONT',
		#'VI', 'VIRGIN ISLANDS OF THE U.S.',
		'VA', 'VIRGINIA',
		'WA', 'WASHINGTON',
		'WV', 'WEST VIRGINIA',
		'WI', 'WISCONSIN',
		'WY', 'WYOMING',
		#'UM', 'U.S. MINOR OUTLYING ISLANDS'
		);
#$statename=$state_names_pretty{$state_code};

%state_names_pretty = (
		'AL', 'Alabama',
		'AK', 'Alaska',
		#'AS', 'American Samoa',
		'AZ', 'Arizona',
		'AR', 'Arkansas',
		'CA', 'California',
		'CO', 'Colorado',
		'CT', 'Connecticut',
		'DE', 'Delaware',
		'DC', 'District of Columbia',
		#'FM', 'Federated States of Micronesia',
		'FL', 'Florida',
		'GA', 'Georgia',
		# 'GU', 'Guam',  # use country = Guam
		'HI', 'Hawaii',
		'ID', 'Idaho',
		'IL', 'Illinois',
		'IN', 'Indiana',
		'IA', 'Iowa',
		'KS', 'Kansas',
		'KY', 'Kentucky',
		'LA', 'Louisiana',
		'ME', 'Maine',
		#'MH', 'Marshall Islands',
		'MD', 'Maryland',
		'MA', 'Massachusetts',
		'MI', 'Michigan',
		'MN', 'Minnesota',
		'MS', 'Mississippi',
		'MO', 'Missouri',
		'MT', 'Montana',
		'NE', 'Nebraska',
		'NV', 'Nevada',
		'NH', 'New Hampshire',
		'NJ', 'New Jersey',
		'NM', 'New Mexico',
		'NY', 'New York',
		'NC', 'North Carolina',
		'ND', 'North Dakota',
		#'MP', 'Northern Mariana Islands',
		'OH', 'Ohio',
		'OK', 'Oklahoma',
		'OR', 'Oregon',
		'PW', 'Palau',
		'PA', 'Pennsylvania',
		#'PR', 'Puerto Rico',
		'RI', 'Rhode Island',
		'SC', 'South Carolina',
		'SD', 'South Dakota',
		'TN', 'Tennessee',
		'TX', 'Texas',
		'UT', 'Utah',
		'VT', 'Vermont',
		#'VI', 'Virgin Islands of the U.S.',
		'VA', 'Virginia',
		'WA', 'Washington',
		'WV', 'West Virginia',
		'WI', 'Wisconsin',
		'WY', 'Wyoming',
		#'UM', 'U.S. Minor Outlying Islands'
		);

%region_names_pretty = (
		'PM', 'Peninsular Malaysia',
		'SAB', 'Sabah',
		'SAR', 'Sarawak'
		);

@kingdoms = qw(Animal Plant Fungal Monera);

@arthropod_classes = qw(Arachnida Archipolypoda Arthropleurida Branchiura Chilopoda Cirripedia
		     Diplopoda Entognatha Euthycarcinoidea Insecta Malacostraca 
		     Maxillopoda Merostomata Myriapoda Mystacocarida Onychophora Ostracoda
		     Pauropoda Pentastomida Pycnogonida Remipedia Symphyla Tantulocarida 
		     Tardigrada Trilobita);

@arthropod_orders = qw(Acari Amblypygi Amphipoda Araneae Blattodea 
		       Chordeumatida Coleoptera Collembola 
		    Dermaptera Diplura Diptera Embiidina
		    Ephemeroptera Grylloblattaria Hemiptera Hymenoptera Isopoda Isoptera
		    Lepidoptera Mantodea Mecoptera 
		    Megaloptera Microcoryphia Neuroptera Odonata Opiliones 
		    Orthoptera Palpigradi Phasmatodea Phthiraptera Plecoptera 
		       Polydesmida Protura 
		    Pseudoscorpiones Psocoptera Raphidioptera Ricinulei
		    Schizomida Scolopendrida Scorpionida Siphonaptera Solifugae Strepsiptera 
		    Thelyphonida Thysanoptera Trichoptera Uropygida Zoraptera Zygentoma);

@insect_orders = qw(Blattodea Coleoptera Collembola Dermaptera Diplura Diptera Embiidina
		    Ephemeroptera Grylloblattaria Hemiptera Hymenoptera Isoptera
		    Lepidoptera Mantodea Mecoptera Megaloptera Microcoryphia Neuroptera Odonata
		    Orthoptera Phasmatodea Phthiraptera Plecoptera Protura 
		    Psocoptera Raphidioptera Siphonaptera Strepsiptera Thysanoptera 
		    Trichoptera Zoraptera Zygentoma);


%insect_orders_cnames = (
		'Blattodea', 'Cockroaches',
		'Coleoptera', 'Beetles',
		'Collembola', 'Springtails',
		'Dermaptera', 'Earwigs',
		'Diplura', 'Diplurans',
		'Diptera', 'Flies',
		'Embiidina', 'Web-Spinners',
		'Ephemeroptera', 'Mayflies',
		'Grylloblattaria', 'Rock Crawlers',
		'Hemiptera', 'Bugs',
		'Hymenoptera', 'Sawflies, Parasitic Wasps, Ants, Wasps, & Bees',
		'Isoptera', 'Termites',
		'Lepidoptera', 'Butterflies & Moths',
		'Mantodea', 'Mantids',
		'Mecoptera', 'Scorpionflies & Hangingflies',
		'Megaloptera', 'Alderflies, Dobsonflies, Fishflies',
		'Microcoryphia', 'Jumping Bristletails',
		'Neuroptera', 'Snakeflies, Lacewings, Antlions, & Owlflies',
		'Odonata', 'Dragonflies & Damselflies',
		'Orthoptera', 'Grasshoppers, Crickets, & Katydids',
		'Phasmatodea', 'Walkingsticks & Leaf Insects',
		'Phthiraptera', 'Lice',
		'Plecoptera', 'Stoneflies',
		'Protura', 'Proturans',
		'Psocoptera', 'Psocids',
		'Siphonaptera', 'Fleas',
		'Strepsiptera', 'Twisted-Wing Parasites',
		'Thysanoptera', 'Thrips',
		# 'Thysanura', 'Silverfish',
		'Trichoptera', 'Caddisflies',
		'Zoraptera', 'Zorapterans',
		'Zygentoma', 'Silverfish'
		);



%arthropod_orders_cnames = (
		'Acari', 'Mites & Ticks',
                'Araneae', 'Spiders',
		'Blattodea', 'Cockroaches',
		'Coleoptera', 'Beetles',
		'Collembola', 'Springtails',
		'Dermaptera', 'Earwigs',
		'Diplura', 'Diplurans',
		'Diptera', 'Flies',
		'Embiidina', 'Web-Spinners',
		'Ephemeroptera', 'Mayflies',
		'Grylloblattaria', 'Rock Crawlers',
		'Hemiptera', 'Bugs',
		'Hymenoptera', 'Sawflies, Parasitic Wasps, Ants, Wasps, & Bees',
		'Isoptera', 'Termites',
		'Lepidoptera', 'Butterflies & Moths',
		'Mantodea', 'Mantids',
		'Mecoptera', 'Scorpionflies & Hangingflies',
		'Megaloptera', 'Alderflies, Dobsonflies, & Fishflies',
		'Microcoryphia', 'Jumping Bristletails',
		'Neuroptera', 'Snakeflies, Lacewings, Antlions, & Owlflies',
		'Odonata', 'Dragonflies & Damselflies',
                'Opiliones', 'Harvestmen or Daddy Longlegs',
		'Orthoptera', 'Grasshoppers, Crickets, & Katydids',
                'Palpigradi', 'Micro Whipscorpions',
		'Phasmatodea', 'Walkingsticks & Leaf Insects',
		'Plecoptera', 'Stoneflies',
		'Protura', 'Proturans',
                'Pseudoscorpiones', 'Pseudoscorpions',
		'Psocoptera', 'Psocids',
		'Phthiraptera', 'Lice',
		'Ricinulei', 'Hooded Tickspiders',
		'Scorpionida', 'Scorpions',
		'Siphonaptera', 'Fleas',
                'Solifugae', 'Windscorpions',
		'Strepsiptera', 'Twisted-Wing Parasites',
                'Schizomida', 'Shorttailed Whipscorpions',
		'Thysanoptera', 'Thrips',
		# 'Thysanura', 'Silverfish',
		'Trichoptera', 'Caddisflies',
                'Uropygida', 'Whipscorpions',
		'Zoraptera', 'Zorapterans',
		'Zygentoma', 'Silverfish'
		);


@specimen_label_names = qw("Univ. of California");


%roman_months = (
                'Jan','I',
                'Feb','II',
                'Mar','III',
                'Apr','IV',
                'May','V',
                'Jun','VI',
                'Jul','VII',
                'Aug','VIII',
                'Sep','IX',
                'Oct','X',
                'Nov','XI',
                'Dec','XII',
                );


%roman_month_nums = (
                '1','I',
                '2','II',
                '3','III',
                '4','IV',
                '5','V',
                '6','VI',
                '7','VII',
                '8','VIII',
                '9','IX',
                '10','X',
                '11','XI',
                '12','XII'
                );


%roman_months_lower = (
                'Jan','i',
                'Feb','ii',
                'Mar','iii',
                'Apr','iv',
                'May','v',
                'Jun','vi',
                'Jul','vii',
                'Aug','viii',
                'Sep','ix',
                'Oct','x',
                'Nov','xi',
                'Dec','xii',
                );


%roman_month_nums_lower = (
                '1','i',
                '2','ii',
                '3','iii',
                '4','iv',
                '5','v',
                '6','vi',
                '7','vii',
                '8','viii',
                '9','ix',
                '10','x',
                '11','xi',
                '12','xii'
                );

@biocode_kingdoms = qw( Fungi Metazoa Monera Protista Viridiplantae );


# used in biocode_add_specimens

@biocode_phylums = qw (Acanthocephala Acoelomorpha Annelida Arthropoda Brachiopoda Bryozoa Bryophyta
                       Chaetognatha Chlorophyta Chordata Ciliophora Cnidaria Coniferophyta 
                       Ctenophora Cyanobacteria Cycadophyta Cycliophora Cyrtotreta Dikaryomycota 
                       Echinodermata Echiura Enteropneusta Entoprocta Gastrotricha 
                       Gnathostomulida Granuloreticulosa Hemichordata Kinorhyncha Loricifera Magnoliophyta Metazoa 
                       Mollusca Myxozoa Nematoda Nematomorpha Nemertea Onychophora 
                       Phaeophyta Phoronida Pinophyta Placozoa Platyhelminthes Porifera Priapulida 
                       Protista Pteridophyta Pterobranchia Rhizaria Rhodophyta Rotifera Sarcomastigophora 
                       Sipuncula Streptophyta Tardigrada Tracheophyta PlaceHolder);




@biocode_orders = qw(Acari Amblypygi Araneae Blattodea Coleoptera Collembola 
		    Dermaptera Diplura Diptera Embiidina
		    Ephemeroptera Grylloblattaria Hemiptera Hymenoptera Isoptera
		    Lepidoptera Mantodea Mecoptera Megaloptera Microcoryphia Neuroptera Odonata Opiliones 
		    Orthoptera Palpigradi Phasmatodea Phthiraptera Plecoptera Protura 
		    Pseudoscorpiones Psocoptera Ricinulei
		    Schizomida Scorpionida Siphonaptera Solifugae Strepsiptera 
		    Thelyphonida Thysanoptera Trichoptera Uropygida Zoraptera Zygentoma);
