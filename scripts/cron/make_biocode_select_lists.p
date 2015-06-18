#!/usr/bin/perl


# $DEBUG = 1;

# make all the lists for biocode table

push(@INC,"/usr/local/web/test/biocode/cgi/"); # so that biocode_settings can be found

require "/usr/local/web/biocode/cgi/myquery_utils.p";
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/mybiocode_utils.p";
require "/usr/local/web/test/biocode/cgi/biocode_settings";


$script_name = "biocode_query";
# select_list_path -- from mybiocode_utils.p

if ($DEBUG) {
    print "DEBUG is turned on, so I'm not making everything!!\n";
} else {
    $make_all =1;
}

if ($DEBUG) {
  #  &make_total_biocode;
#    &make_biocode_container_list_options;
#    &make_biocode_tissuetype_list_options;
    &make_biocode_preservative_list_options;

} elsif ($make_all) {

    &make_specimens;
}
elsif ($make_sp) {
    &make_specimens;
} 
else {
    print "Can't figure out what you want me to make!\n";
}

sub make_specimens {

    # print "Making lists for specimens ...\n";
    &make_total_biocode;
    &make_state;     
    &make_country;     
    &make_county;     
    &make_cont_ocean;
    &make_island;
    &make_islandgroup;
    &make_phylum;  
    &make_subphylum;  
    &make_superclass;  
    &make_class;  
    &make_infraclass;  
    &make_subclass;     
    &make_superorder;  
    &make_order;   
    &make_family;
    &make_sex;
    &make_stage;
    &make_plate;
    &make_taxteam;
    &make_taxteam_collecting_event;

    &make_people_select_list;  # in mybiocode_utils.p (people.txt, collectors.txt, submitters.txt)
    &make_prep_types_list;  # in mybiocode_utils.p
    &make_type_status_list;  # in mybiocode_utils.p
    &make_collectioncode_select_list; # in mybiocode_utils.p
    &make_holding_inst;
    # &make_projectname;
    &make_projectcode;

    &make_biocode_species_phylum;
    &make_biocode_species_subphylum;  # new 6/26/2007
    &make_biocode_species_superclass; # new 6/26/2007
    &make_biocode_species_class;
    &make_biocode_species_subclass;   # new 6/26/2007
    &make_biocode_species_infraclass;  # new July 4 2007
    &make_biocode_species_superorder; # new 6/26/2007
    &make_biocode_species_order;
    &make_biocode_species_suborder;   # new 6/26/2007
    &make_biocode_species_infraorder; # new 6/26/2007

    &make_biocode_container_list;
    &make_biocode_container_list_options;
    &make_biocode_tissuetype_list;
    &make_biocode_tissuetype_list_options;
    &make_biocode_preservative_list;
    &make_biocode_preservative_list_options;

    &make_biocode_relaxant_list;

}

sub make_state {
    $out = "$select_list_path/state_prov_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.StateProvince, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by StateProvince order by StateProvince;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
	if ($DEBUG) {print $line;}
	chomp($line);
	($s,$count) = split(/\t/,$line);
	if (!$s) { 
             # just skip it 
	} else {
	    print ( OUT "<option>$s ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}


sub make_country {
    $out = "$select_list_path/country_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.Country, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by Country order by Country;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {$s = "undetermined";}
        print ( OUT "<option>$s ($count)\n");
    }
    close(FH);
    close(OUT);
}

sub make_county {
    $out = "$select_list_path/county_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.County, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by County order by County;\n";

    $tmp = &get_multiple_records($query,"biocode");
    if ($DEBUG) { print "Temp file: $tmp\n";}

    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) { 
            # just skip it
	} else {
	    print ( OUT "<option>$s ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}


sub make_cont_ocean {
    $out = "$select_list_path/cont_ocean_sp.txt";

    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.ContinentOcean, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by ContinentOcean order by ContinentOcean;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {$s = "undetermined";}
        print ( OUT "<option>$s ($count)\n");
    }
    close(FH);
    close(OUT);

}


sub make_island {
    $out = "$select_list_path/island_sp.txt";

    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.Island, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by Island order by Island;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) { 
	    # just skip it 
	} else {
	    print ( OUT "<option>$s ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_islandgroup {
    $out = "$select_list_path/islandgroup_sp.txt";

    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select biocode_collecting_event.IslandGroup, count(*) from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by IslandGroup order by IslandGroup;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {
	    # skip it
	} else {
	    print ( OUT "<option>$s ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_infraclass {
    $out = "$select_list_path/infraclass_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select InfraClass, count(*) from biocode group by Infraclass order by Infraclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_superorder {
    $out = "$select_list_path/superorder_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Superorder, count(*) from biocode group by Superorder order by Superorder;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_class {
    $out = "$select_list_path/class_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Class, count(*) from biocode group by Class order by Class;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_superclass {
    $out = "$select_list_path/superclass_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Superclass, count(*) from biocode group by Superclass order by Superclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_subphylum {
    $out = "$select_list_path/subphylum_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Subphylum, count(*) from biocode group by Subphylum order by Subphylum;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_phylum {
    $out = "$select_list_path/phylum_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Phylum, count(*) from biocode group by Phylum order by Phylum;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_family {
    $out = "$select_list_path/family_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Family, count(*) from biocode group by Family order by Family;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_sex {
    $out = "$select_list_path/sex.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select SexCaste, count(*) from biocode group by SexCaste order by SexCaste;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    print ( OUT "<option>undetermined ($count)\n");
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}


sub make_stage {
    $out = "$select_list_path/stage.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select LifeStage, count(*) from biocode group by LifeStage order by LifeStage;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    print ( OUT "<option>undetermined ($count)\n");
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}

sub make_plate {

    $out = "$select_list_path/format_name96.txt";
    $out2 = "$select_list_path/format_name96_nocount.txt";
    `/bin/rm -f $out`;
    `/bin/rm -f $out2`;
    open(OUT,">>$out") || die "Can't open $out for writing";
    open(OUT2,">>$out2") || die "Can't open $out for writing";

    $query = "select format_name96, count(*) from biocode_tissue group by format_name96 order by format_name96;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
        } else {
            print ( OUT "<option>$c ($count)\n");
            print ( OUT2 "<option>$c\n");
        }
    }
    close(FH);


}

sub make_taxteam {

    $out = "$select_list_path/TaxTeam.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select TaxTeam, count(*) from biocode_collecting_event, biocode ";
    $query .= "where biocode_collecting_event.EventID = biocode.coll_eventid ";
    $query .= "group by biocode_collecting_event.TaxTeam order by biocode_collecting_event.TaxTeam;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
        } else {
            print ( OUT "<option>$c ($count)\n");
        }
    }

}

sub make_taxteam_collecting_event {

    $out = "$select_list_path/TaxTeam_collecting_event.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select TaxTeam, count(*) from biocode_collecting_event ";
    $query .= "group by TaxTeam order by TaxTeam;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
        } else {
            print ( OUT "<option>$c ($count)\n");
        }
    }

}

sub make_cname {
    $out = "$select_list_path/cname_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select ColloquialName, count(*) from biocode group by ColloquialName order by ColloquialName;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    print ( OUT "<option>undetermined ($count)\n");
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}




sub make_subclass {
    $out = "$select_list_path/subclass_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select subclass, count(*) from biocode group by subclass order by subclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        # if ($DEBUG) {print $line;}
        chomp($line);
        ($c,$count) = split(/\t/,$line);
        if (!$c) {
	    # print ( OUT "<option>undetermined ($count)\n");
	    next;
	} else {
	    print ( OUT "<option>$c ($count)\n");
	}
    }
    close(FH);
    close(OUT);
}


sub make_order {
    $out = "$select_list_path/order_sp.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select Ordr, count(*) from biocode group by Ordr order by Ordr;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {
            # $s = "undetermined";
            next;
        }
        print ( OUT "<option>$s ($count)\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_species_order {
    $out = "$select_list_path/order_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select ordr from biocode_species group by ordr order by ordr;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_phylum {
    $out = "$select_list_path/phylum_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select phylum from biocode_species group by phylum order by phylum;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_subphylum {
    $out = "$select_list_path/subphylum_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select subphylum from biocode_species group by subphylum order by subphylum;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_superclass {
    $out = "$select_list_path/superclass_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select superclass from biocode_species group by superclass order by superclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_species_class {
    $out = "$select_list_path/class_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select class from biocode_species group by class order by class;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_infraclass {
    $out = "$select_list_path/infraclass_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select infraclass from biocode_species group by infraclass order by infraclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_species_subclass {
    $out = "$select_list_path/subclass_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select subclass from biocode_species group by subclass order by subclass;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_species_superorder {
    $out = "$select_list_path/superorder_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select superorder from biocode_species group by superorder order by superorder;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
	if (!$line) {next;}
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_suborder {
    $out = "$select_list_path/suborder_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select suborder from biocode_species group by suborder order by suborder;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
	if (!$line) {next;}
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_species_infraorder {
    $out = "$select_list_path/infraorder_biocode_species.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select infraorder from biocode_species group by infraorder order by infraorder;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        chomp($line);
	if (!$line) {next;}
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_holding_inst {
    $out = "$select_list_path/holding_inst.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select HoldingInstitution,count(*) from biocode group by HoldingInstitution order by HoldingInstitution;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {$s = "undetermined";}
        print ( OUT "<option>$s ($count)\n");
    }
    close(FH);
    close(OUT);
}



sub make_projectcode {
    $out = "$select_list_path/projectcode.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select ProjectCode,count(*) from biocode group by ProjectCode order by ProjectCode;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        ($s,$count) = split(/\t/,$line);
        if (!$s) {$s = "undetermined";}
        print ( OUT "<option>$s ($count)\n");
    }
    close(FH);
    close(OUT);

}


sub make_fiji_islands {
    $out = "$select_list_path/fiji_islands.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select name from biocode_fiji_islands order by name;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_total_biocode {

    $biocode_total_file = "$select_list_path/total_biocode.txt";
    $biocode_total = &get_count("biocode","");
    $biocode_total = &add_commas($biocode_total);
    `echo $biocode_total > $biocode_total_file`;
    
}

sub make_biocode_container_list {
    $out = "$select_list_path/container.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select container from biocode_container order by container;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_container_list_options {
    $out = "$select_list_path/container_opt.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select container from biocode_container order by container;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_tissuetype_list {
    $out = "$select_list_path/tissuetype.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select tissuetype from biocode_tissuetype order by tissuetype;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_tissuetype_list_options {
    $out = "$select_list_path/tissuetype_opt.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select tissuetype from biocode_tissuetype order by tissuetype;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}

sub make_biocode_preservative_list {
    $out = "$select_list_path/preservative.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select preservative from biocode_preservative order by preservative;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "$line\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_preservative_list_options {
    $out = "$select_list_path/preservative_opt.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select preservative from biocode_preservative order by preservative;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "<option>$line\n");
    }
    close(FH);
    close(OUT);
}


sub make_biocode_relaxant_list {
    $out = "$select_list_path/relaxant.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    $query = "select relaxant from biocode_relaxant order by relaxant;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    while($line = <FH>) {
        if ($DEBUG) {print $line;}
        chomp($line);
        print ( OUT "$line\n");
    }
    close(FH);
    close(OUT);
}





