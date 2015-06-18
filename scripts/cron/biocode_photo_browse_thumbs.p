#!/usr/bin/perl


require "/usr/local/web/biocode/cgi/myschema.p";
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/myquery_utils.p"; 
require "/usr/local/web/biocode/cgi/myimg_utils.p"; 
require "/usr/local/web/biocode/cgi/biocode_settings";

my $path_to_headers_footers = "/usr/local/web/test/biocode/web/headers_footers/";

my @names = ();

(@names) = &make_page("phylum","class");
&make_more_detailed_page("phylum","class","order");

(@names) = &make_page("class","order");
&make_more_detailed_page("class","ordr","family");

(@names) = &make_page("ordr","family");
&make_more_detailed_page("ordr","family","taxon");

(@names) = &make_page("family","taxon");
&make_more_detailed_page("family","taxon");



sub make_more_detailed_page {
    my ($level1,$level2,$level3) = @_;


    foreach my $name (@names) {
        my $name_quote_safe = $name;
        $name_quote_safe =~ s/'/\\'/g;

        my $thumb_count = 0;
        my $query = "select $level2, count(*) from img where collectn = 'Biocode' and specimen_no like 'mbio%' and $level1 = '$name_quote_safe' group by $level2 order by $level2";
        my $tmp = &get_multiple_records("$query","image");

        my $outfile = "$testdir/photos_".$name.".html";
        open(OH, ">$outfile") || die "can't open file in $outdir directory ";
        &print_biocode_header;
    
        &display_links;
        print OH "<center>";
        print OH "<table border>";
        print OH "<tr>\n";

        open(FH,"$tmp") || die "Can't open tmp file $tmp ";

        while(<FH>) {
            my $row = $_;
            chomp($row);
            my ($name2, $count) = split(/\t/,$row);
            if($name2 eq "NULL" || $name2 eq "") {
                next;
            }
            
            my $next_level_count = 0;
            $thumb_count++;

            my $url_name = $name;  # in case there are spaces in the name (crappy data)
            $url_name =~ s/\s/+/g;  # in case there are spaces in the name (crappy data or scientific name)

            my $url_name2 = $name2;  # in case there are spaces in the name (crappy data)
            $url_name2 =~ s/\s/+/g;  # in case there are spaces in the name (crappy data or scientific name)

            my $kwid = &get_one_biocode_pic($name2,$level2,$name,$level1);
            my ($p1,$p2,$p3,$p4) = split(/\s/,$kwid);


            print OH "<td>\n";
            print OH "<center>";
            print OH "<a href=http://biocode.berkeley.edu/cgi/biocode_img_query?where-$level2=$url_name2&where-$level1=$url_name&where-collectn=biocode&where-specimen_no=mbio&rel-specimen_no=begins+with>";
            print OH "<img src=http://calphotos.berkeley.edu/imgs/128x192/$p1"."_"."$p2/$p3/$p4.jpeg></a>\n";
            print OH "<br>\n";
            print OH "<a href=http://biocode.berkeley.edu/cgi/biocode_img_query?where-$level2=$url_name2&where-$level1=$url_name&where-collectn=biocode&where-specimen_no=mbio&rel-specimen_no=begins+with>$name2</a> ";
            if($count == 1) {
                print OH "<small>[see $count photo]</small>\n";
            } else {
                print OH "<small>[see all $count photos]</small>\n";
            }

            # decide whether to display link to another thumb browse page 
            if($level3) {
                $next_level_count = &get_next_level_count($name2,$level2,$level3);
            }

            if($level2 ne "taxon" && $next_level_count) {
                print OH "<br>\n";
                print OH "<a href=/generated/photos_".$name2.".html>$name2</a> <small>[browse by $level3]</small>\n";
            }

            print OH "</center>";
            print OH "</td>\n";

            if($thumb_count == 4) {
                print OH "</tr>\n";
                print OH "<tr>\n";
                $thumb_count = 0;
            }
        }

        print OH "</tr>\n";

        print OH "</table>";
        print OH "</center>";
        &print_biocode_footer;

        close(OH);
        close(FH);
    }

}



sub make_page {
    my ($level1,$level2) = @_;

    @names = ();
    my $thumb_count = 0;

    my $query = "select $level1, count(*) from img where collectn = 'Biocode' and specimen_no like 'mbio%' group by $level1 order by $level1";
    my $tmp = &get_multiple_records("$query","image");

    my $outfile = "$testdir/photos_".$level1.".html";
    open(OH, ">$outfile") || die "can't open file in $outdir directory ";
    &print_biocode_header;

    &display_links;
    print OH "<center>";
    print OH "<table border>";

    open(FH,"$tmp") || die "Can't open tmp file $tmp ";
    while(<FH>) {
        my $row = $_;
        chomp($row);
        my ($name, $count) = split(/\t/,$row);
        if($name eq "NULL" || $name eq "") {
            next;
        }
        push(@names,$name);

        $next_level_count = "";
        $thumb_count++;
        my $url_name = $name;  # in case there are spaces in the name (crappy data)
        $url_name =~ s/\s/+/g;  # in case there are spaces in the name (crappy data or scientific name)
        my $kwid = &get_one_biocode_pic($name,$level1);
        my ($p1,$p2,$p3,$p4) = split(/\s/,$kwid);

        if($thumb_count == 1) {
            print OH "<tr>\n";
        }

        print OH "<td>\n";
        print OH "<center>";
        print OH "<a href=http://biocode.berkeley.edu/cgi/biocode_img_query?where-$level1=$url_name&where-collectn=biocode&where-specimen_no=mbio&rel-specimen_no=begins+with>";
        print OH "<img src=http://calphotos.berkeley.edu/imgs/128x192/$p1"."_"."$p2/$p3/$p4.jpeg></a>\n";
        print OH "<br>\n";
        print OH "<a href=http://biocode.berkeley.edu/cgi/biocode_img_query?where-$level1=$url_name&where-collectn=biocode&where-specimen_no=mbio&rel-specimen_no=begins+with>$name</a> ";
        if($count == 1) {
            print OH "<small>[see $count photo]</small>\n";
        } else {
            print OH "<small>[see all $count photos]</small>\n";
        }

        # decide whether to display link to another thumb browse page 
        if($level2) {
            $next_level_count = &get_next_level_count($name,$level1,$level2);
        }


        if($level1 ne "taxon" && $next_level_count) {
            print OH "<br>\n";
            print OH "<a href=/generated/photos_".$name.".html>$name</a> <small>[browse by $level2]</small>\n";
#            print OH "<a href=/generated/photos_".$name.".html>$name</a> <small>[browse by $level2]</small>\n";
        }

        print OH "</center>";
        print OH "</td>\n";

        if($thumb_count == 4) {
            print OH "</tr>\n";
            $thumb_count = 0;
        }
    }

    print OH "</table>";
    print OH "</center>";
    &print_biocode_footer;

    close(OH);

    return @names;
}


sub get_next_level_count {
    my ($name, $level1, $level2) = @_;
    my $next_level_count = 0;

    my $name_quote_safe = $name;
    $name_quote_safe =~ s/'/\\'/g;

    if($level1 eq "order") {
        $level1 = "ordr";
    }
    if($level2 eq "order") {
        $level2 = "ordr";
    }

    #example: select count(*) from img where phylum = 'Granuloreticulosa' and class is not null and class != '' and collectn = 'biocode';
    my $select = "select count(*) from img where $level1 = '$name_quote_safe' and $level2 is not null and $level2 != '' and collectn = 'biocode' and specimen_no like 'mbio%' ";

    my ($next_level_count) = &get_one_record("$select","image");

    return $next_level_count;
}


sub get_one_biocode_pic {
    my ($value,$field,$value2,$field2) = @_;
    my $second_field = "";

    $value =~ s/'/\\'/g;
    $value2 =~ s/'/\\'/g;

    if($value2 && $field2) {
        $second_field = " and $field2 = '$value2' ";
    }
    my $query = "select kwid from img where collectn = 'biocode' and specimen_no like 'mbio%' and $field = '$value' $second_field limit 1";

    my ($kwid) = &get_one_record("$query","image");

    return $kwid;
}


sub display_links {
    print OH "<br>\n";
    print OH "<center>\n";
    print OH "<small>\n";
    print OH "<i>Browse Biocode Photos by: \n";
    print OH "&nbsp;&nbsp;\n";
    print OH "&nbsp;&nbsp;\n";
    print OH "<a href=/generated/photos_phylum.html>Phylum</a>\n";
    print OH "&nbsp;&nbsp;\n";
    print OH "<a href=/generated/photos_class.html>Class</a>\n";
    print OH "&nbsp;&nbsp;\n";
    print OH "<a href=/generated/photos_ordr.html>Order</a>\n";
    print OH "&nbsp;&nbsp;\n";
    print OH "<a href=/generated/photos_family.html>Family</a>\n";
    print OH "</small>\n";
    print OH "<center>\n";
    print OH "<br>\n";
}


sub print_biocode_header {  # unfortunately this duplicated from mybiocode_utils because can't run mybiocode_utils functions from any dir other than cgi
    open(FH,"$path_to_headers_footers/title.html");
    while(<FH>) {
        print OH $_;
    }
    close(FH);

    print OH "Moorea Biocode Specimens Photos Browse List\n";

    open(FH,"$path_to_headers_footers/head1.html");
    while(<FH>) {
        print OH $_;
    }
    close(FH);

    print OH "<table>\n";
    print OH "<tr>\n";
    print OH "<td>\n";
    print OH "<a href=http://moorea.berkeley.edu/><img src=/images/biocode_new.jpg height=70 border=0></a>\n";
    print OH "</td>\n";
    print OH "<td>\n";
    print OH "<big><big>\n";
    print OH "Moorea Biocode Databases\n";
    print OH "</td>\n";
    print OH "<td>\n";
    print OH "&nbsp;&nbsp;\n";
    print OH "<a href=http://criobe.wordpress.com/><img src=/images/criobe_new.png height=70 border=0></a>\n";
    print OH "</td>\n";
    print OH "</tr>\n";
    print OH "</table>\n";
    open(FH,"$path_to_headers_footers/head2.html");
    while(<FH>) {
        print OH $_;
    }
    close(FH);

    print OH "<!-- insert side bar links here -->\n";
    open(FH,"$path_to_headers_footers/head3.html");
    while(<FH>) {
        print OH $_;
    }
    close(FH);

    print OH "<blockquote>\n";
}



sub print_biocode_footer {
    print OH "</blockquote>";
    open(FH,"$path_to_headers_footers/footer.html");
    while(<FH>) {
        print OH $_;
    }
    close(FH);
}


