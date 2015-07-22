#!/usr/bin/perl
#


require "/usr/local/web/cgi/myschema.p";   # we need the up-to-date img schema from here -- not ideal
require "utils.p";
require "myquery_utils.p";      # parse input, make_where_clause, build_query, DBI

#### global variables ####

$loadfile_dir = "/data/mysql_out/jg";

# May 2013 -- gap between 438581 and 555557


$new_img_num = "3084";
$seq_num = 441666;  # FIGURE THIS OUT ... 

# gap in img seq_num:
# 98682|Animal|4444 4444 1210|0140|4444 4444 1210 0140

$dl_notes = "Bulk loaded -- JG. 2013-05-20";
$biocode_photo_dir = "/data/biocode/photos/ID_folders";

# ALSO see/edit select statement below

$DEBUG = 0;


### DATE -- still have to code for this based on begin_date and end_date !!!!!!!!!!!!!!!!!!

$photo_date = "2009-01-01";
$date_prec = "exactyear";

#$photo_date = "2009-01-01";
#$date_prec = "2";  # add 2 years to 2009: between 2009 and 2011

#$photo_date = "2011-07-03";
#$date_prec = "exactday";

#$photo_date = "2011-01-01";
#$photo_date = "2010-08-01";
#$date_prec = "exactmonth";
#$date_prec = "exactyear";


#mysql> select distinct begin_date, end_date, directory from bulkphoto where DateFirstEntered > '2013-04-01';
#+------------+------------+--------------------------------+
#| begin_date | end_date   | directory                      |
#+------------+------------+--------------------------------+
#| 2009-10-01 | 2009-11-30 | Gustav Paulay-MINV2009_new     |
#| 2009-10-01 | 2009-11-30 | Gustav Paulay-MINV2009         |
#| 2012-07-01 | 2012-07-10 | Amanda Windsor-ACEH_2012       |
#| 2012-06-20 | 2012-06-20 | IBRC 2012 class-Jun20_IBRC_D90 |
#+------------+------------+--------------------------------+

###########################

my $tmp = &get_all_records_ready_for_calphotos;
&load_photos_into_calphotos($tmp);

###########################


sub get_all_records_ready_for_calphotos {

    my $select = "";

    $select  = "select b.photographer, p.specimenNumCollector, b.begin_date, b.end_date, ";
    $select .= "b.directory, b.picturename, b.cameratype, b.phototype, p.internalid ";

    $select .= "from photomatch as p, bulkphoto as b where b.directory like 'Gustav Paulay-MINV2009%' ";
    # $select .= "from photomatch as p, bulkphoto as b where b.directory = 'Gustav Paulay-MINV2012' ";
    # $select .= "from photomatch as p, bulkphoto as b where b.directory like 'Amanda Windsor%' ";
    # $select .= "from photomatch as p, bulkphoto as b where b.directory = 'Amanda Windsor-ACEH_2012' ";

    #$select .= "from photomatch as p, bulkphoto as b where ";
    #$select .= "(b.directory = 'Antoine N\\'Yeurt-Algae_photos' ";
    #$select .= "or b.directory = 'Claude Payri-Algae_underwater') ";


    # $select .= "from photomatch as p, bulkphoto as b where ";
    # $select .= "(b.directory like 'Chris Meyer-MINV_1000px_xmoo%' ";
    # $select .= "or b.directory like 'Chris Meyer-MINV_XMOO%') ";

    $select .= "and p.specimennumcollector is not null ";
    $select .= "and p.bulkphoto_id = b.bulkphoto_id and p.calphotos_location is null";


    if($DEBUG) { print "\n$select\n"; }
    # print "\n$select\n";

    $tmp = &get_multiple_records($select,"biocode");

}


$count = 0;
sub load_photos_into_calphotos {
    my ($tmp) = @_;
    open(FH, "$tmp") || die "can't open $tmp file";
    open(OH, ">$loadfile_dir/out") || die "can't open file";

    while(<FH>) {
        $row = $_;
        chomp($row);
        ($photographer, $specimenNumCollector, $begin_date, $end_date, $directory, $picturename, $cameratype, $phototype, $internalid) = split(/\t/,$row);


        # print "$specimenNumCollector\n";
        if($specimenNumCollector eq "-9999") {   # some kind of photomatcher bug that's putting -9999 into the specimenNumCollector field?
            next;
        }

        if($DEBUG) {
            print "photographer: $photographer; spec num: $specimenNumCollector; begin date: $begin_date; end date: $end_date\n";
            print "directory: $directory; picturename: $picturename; cameratype: $cameratype\n\n";
        }

        if($picturename !~ /^[\sa-zA-Z\&\+\(\),\.0-9_\-]+$/) {  # eliminates diacritical characters
            print "bad filename: $picturename\n";
        } else {


            my $kwid = &make_load_file($photographer, $specimenNumCollector, $begin_date, $end_date, $directory, $picturename, $cameratype, $phototype);

#            &copy_images($directory,$picturename,$new_img_num);   # uncomment to copy images to final CalPhotos location

            &update_photomatch_table($kwid,$internalid);          # uncomment to update photomatch table so will not load images again

            $count++;

        }

    }


    close(FH);
    close(OH);

}


sub update_photomatch_table {
    my ($photomatch_kwid,$internalid) = @_;

    # example calphotos location:
    # http://calphotos.berkeley.edu/cgi/img_query?where-kwid=8120+3181+4569+0097&one=T

    $photomatch_kwid =~ s/ /+/g;
    # my $calphotos_location = "http://calphotos.berkeley.edu/cgi/img_query?where-kwid=$photomatch_kwid&one=T";
    my $calphotos_location = "http://biocode.berkeley.edu/cgi/biocode_img_query?where-kwid=$photomatch_kwid&one=T";

    my $update = "update photomatch set calphotos_location = '$calphotos_location' where internalid = '$internalid'";
    if($DEBUG) { print "update photomatch: $update"; }
    &process_query($update,"biocode");
}




sub make_load_file {

     my ($photographer, $specimenNumCollector, $begin_date, $end_date, $directory, $picturename, $cameratype, $phototype) = @_;;

     my $specimen_query = "";
     my $photographer_query = "";
     my $not_in_DB = 0;

     $photo_info = $cameratype;
     $orig_filename = $picturename;
     ($genre, $lifeform) = split(/--/,$phototype);
    
     # try to guess/fix lifeform for spiders
     if($ordr eq "Arachnidae" || $family eq "Arachnidae") {   # some of Jerome's consistent fuck-ups
         $lifeform = "Invertebrate-Spider";
     }
     if($family eq "Araneae") {   # unlikely Jerome will ever get this right, but other people might
         $lifeform = "Invertebrate-Spider";
     }

     $specimen_query  = "select biocode.bnhm_id, biocode.genus, biocode.specificepithet, biocode.subspecificepithet, biocode.family, ";
     $specimen_query .= "biocode.ordr, biocode.class, biocode.phylum, ";
     $specimen_query .= "biocode_collecting_event.Locality, biocode_collecting_event.Island, biocode_collecting_event.IslandGroup, biocode_collecting_event.Country, ";
     $specimen_query .= "biocode_collecting_event.ContinentOcean, biocode_collecting_event.DecimalLatitude, biocode_collecting_event.DecimalLongitude ";
     $specimen_query .= "from biocode, biocode_collecting_event where biocode.Specimen_Num_Collector = '$specimenNumCollector'";
     $specimen_query .= "and biocode_collecting_event.EventID = biocode.Coll_EventID";

     if($DEBUG) {
         print "get specimen fields: $specimen_query\n\n";
     }

     ($bnhm_id, $genus, $species, $subspecies, $family, $ordr, $class, $phylum, $Locality, $Island, $IslandGroup, $Country, $ContinentOcean, $lat, $lng) = &get_one_record($specimen_query,"biocode"); 

     $taxon = "$genus $species $subspecies";
     $taxon = &strip($taxon);
     $ph_taxon = $taxon;

     if(!$bnhm_id) {
          print "$specimenNumCollector not in DB ....\n\n";
          $not_in_DB = 1;
     }

     if($not_in_DB) {
         next;
     }

     $specimen_no = $bnhm_id;

     $location = $Locality;
     $island = $Island;
     $islandgroup = $Island;
     $country = $country_codes{uc($Country)};
     $continent = $ContinentOcean;

     $namesoup = "$taxon $family $ordr $class";
     $namesoup = &strip($namesoup);

     $cap_loc = "Moorea"; # ???

     $captivity = 1;

     $copyright = "2013 Moorea Biocode";
     $license = "CC BY-NC-SA 3.0";

     $index_date = $TODAY;

     $collectn = "Biocode";
     $enlarge = "3";

     $museum = "Moorea Biocode";

     $source_id_1 = $specimenNumCollector;

     ($kwid, $disknum, $imgnum, $new_img_num) = &get_kwid($new_img_num);

     $safe_photographer = $photographer;
     $safe_photographer =~ s/'/\\'/g;
     $photographer_query = "select email from photographer where name_full = '$safe_photographer'";

     ($email) = &get_one_record($photographer_query,"image");
     $contact = "$photographer $email";

     $ready = 1;


    # make_insert_statement

    $insert_stmt = "";
    $seq_num++;
    foreach $s (@img_schema) {
        if(!${$s} && $s ne "seq_num") {
            ${$s} = "\\N";
        }
        $insert_stmt .= "${$s}|";
    }


    if($DEBUG) {
        print "$insert_stmt\n\n";
    }

    print OH "$insert_stmt\n";


    return $kwid;
}




sub copy_images {

    my ($directory,$picturename,$new_img_num) = @_;
    my $command = "";
    my $mmyy = &get_mmyy;

    $directory =~ s/'/\\'/g;

    my $orig_filename = $biocode_photo_dir . "/" . $directory;
    my $thumb = $orig_filename . "/calthumbs/" . $picturename;
    my $enlargement = $orig_filename . "/midres/" . $picturename;

    $thumb =~ s/ /\\ /g;
    $thumb =~ s/\(/\\\(/g;
    $thumb =~ s/\)/\\\)/g;
    $thumb =~ s/\&/\\\&/g;
    $enlargement =~ s/ /\\ /g;
    $enlargement =~ s/\(/\\\(/g;
    $enlargement =~ s/\)/\\\)/g;
    $enlargement =~ s/\&/\\\&/g;

    $command = "/bin/cp $thumb /data2/images/128x192/4444_4444/$mmyy/$new_img_num.jpeg";
    # if($DEBUG) { print "copy thumbnail: $command\n\n"; }
    system($command);

    $command = "/bin/cp $enlargement /data2/images/512x768/4444_4444/$mmyy/$new_img_num.jpeg";
    # if($DEBUG) { print "\ncopy enlargement: $command\n\n"; }
    system($command);

}


sub get_kwid {

    my ($new_img_num) = @_;

    my $old_img_num = $new_img_num;

    my $first4 = "4444";
    my $second4 = "4444";
    my $mmyy = &get_mmyy;
    $new_img_num = &get_new_img_num($old_img_num);

    my $disknum = "$first4 $second4 $mmyy";
    my $imgnum = "$new_img_num";
    my $kwid = "$first4 $second4 $mmyy $new_img_num";

    return ($kwid, $disknum, $imgnum, $new_img_num);
}


sub get_new_img_num {

    my ($old_img_num) = @_;

    my $new_img_num = $old_img_num + 1;

    if(length($new_img_num) == 1) {
        $new_img_num = "000".$new_img_num;
    } elsif(length($new_img_num) == 2) {
        $new_img_num = "00".$new_img_num;
    } elsif(length($new_img_num) == 3) {
        $new_img_num = "0".$new_img_num;
    }

    return $new_img_num;

}

sub get_mmyy {

    my $mmyy = "";
    my $todays_date = &get_todays_date;

    my @date_parts = split(/\-/,$todays_date);

    my $yy = substr($date_parts[0], 2, 2);
    my $mm = $date_parts[1];

    $mmyy = $mm.$yy;

    return $mmyy;
}



