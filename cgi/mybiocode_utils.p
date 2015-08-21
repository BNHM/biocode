#!/usr/bin/perl

# mybiocode_utils.p  GO april 2003
# Jan 2004  (using mysql)

require "biocode_settings";

$TODAY = &get_todays_date;

# assign catalog numbers ignoring specimen numbers 1003607 & 1003610
# $IGNORE_CATNUMS = 1003607;  # getting rid of this

@taxon_levels = qw(Kingdom Phylum Subphylum Superclass Class Subclass Infraclass Superorder Ordr Suborder Infraorder Superfamily Family Subfamily Tribe Subtribe Genus Genus_and_Species);

#
# Fields that are allowed on Excel
#
@excel_spec_allowable = qw(rowcount EnteredBy Coll_EventID_collector Specimen_Num_Collector ColloquialName MorphoSpecies_Description MorphoSpecies_Match LowestTaxon LowestTaxonLevel IdentifiedBy IdentifiedInstitution BasisOfID YearIdentified MonthIdentified DayIdentified PreviousID SexCaste LifeStage Parts Weight WeightUnits Length LengthUnits PreparationType preservative relaxant IndividualCount Cultivated Notes pic HoldingInstitution Taxon_Certainty fixative VoucherCatalogNumber specimen_Habitat specimen_MicroHabitat Associated_Taxon specimen_MinDepthMeters specimen_MaxDepthMeters specimen_ElevationMeters Kingdom Phylum Subphylum Superclass Class Subclass Infraclass Superorder Ordr Suborder Infraorder Superfamily Family Subfamily Tribe Subtribe Genus Subgenus SpecificEpithet SubspecificEpithet tissue_barcode tissue_container tissue_preservative tissue_type_preserved tissue2_barcode tissue2_container tissue2_preservative tissue2_type_preserved tissue2_HoldingInstitution tissue3_barcode tissue3_container tissue3_preservative tissue3_type_preserved tissue3_HoldingInstitution tissue4_barcode tissue4_container tissue4_preservative tissue4_type_preserved tissue4_HoldingInstitution tissue5_barcode tissue5_container tissue5_preservative tissue5_type_preserved tissue5_HoldingInstitution format_name96 well_number96 tissue_type_well Association_Type Color RelatedCatalogItem tissue_HoldingInstitution ScientificNameAuthor DNASequenceNo SubProject SubSubProject);

# A list of system generated fields that are allowable
@system_spec_allowable = qw(ScientificName);

# Tissue allowable fields for combined specimen/tissue data entry
@excel_tissue_allowable_brief = qw(well_number96 format_name96 tissue_type_well tissue_barcode tissue_type_preserved tissue_preservative tissue_container tissue_HoldingInstitution tissue2_barcode tissue2_container tissue2_preservative tissue2_type_preserved tissue2_HoldingInstitution tissue3_barcode tissue3_container tissue3_preservative tissue3_type_preserved tissue3_HoldingInstitution tissue4_barcode tissue4_container tissue4_preservative tissue4_type_preserved tissue4_HoldingInstitution tissue5_barcode tissue5_container tissue5_preservative tissue5_type_preserved tissue5_HoldingInstitution

tissue2_barcode tissue2_container tissue2_preservative tissue2_type_preserved tissue2_HoldingInstitution tissue3_barcode tissue3_container tissue3_preservative tissue3_type_preserved tissue3_HoldingInstitution tissue4_barcode tissue4_container tissue4_preservative tissue4_type_preserved tissue4_HoldingInstitution
tissue5_barcode tissue5_container tissue5_preservative tissue5_type_preserved tissue5_HoldingInstitution
);

#These are tissue allowable fields only for specific tissue sheeet
#@excel_tissue_allowable = qw(Coll_EventID_collector Specimen_Num_Collector HoldingInstitution OtherCatalogNum entry_date year month day person_subsampling container preservative tissuetype format_name96 well_number96 molecular_id notes from_tissue tissue_barcode tissue_remaining);

@excel_collevent_allowable = qw(rowcount EnteredBy Collector_List Collector Collector2 Collector3 Collector4 Collector5 Collector6 Collector7 Collector8  YearCollected MonthCollected DayCollected TimeofDay YearCollected2 MonthCollected2 DayCollected2 TimeofDay2 ContinentOcean IslandGroup Island Country StateProvince County Locality DecimalLongitude DecimalLatitude DecimalLongitude2 DecimalLatitude2 HorizontalDatum MaxErrorInMeters MinElevationMeters MaxElevationMeters MinDepthMeters MaxDepthMeters DepthOfBottomMeters DepthErrorMeters IndividualCount Habitat MicroHabitat Collection_Method Landowner Permit_Info Remarks TaxonNotes Coll_EventID_collector pic VerbatimLongitude VerbatimLatitude VerbatimLongitude2 VerbatimLatitude2 TaxTeam);


@required_collevent_fields = qw(Coll_EventID_collector EnteredBy Country TaxTeam);

@required_specimen_fields = qw(Coll_EventID_collector EnteredBy Specimen_Num_Collector HoldingInstitution Phylum);

@ProjectCodes = qw(CMPI INDO IRLA MBIO SLAB);

@institutions = ("Australian National Insect Collection","Australian Museum","Bishop Museum", "Brigham Young University","California Academy of Sciences","California State Collection of Arthropods","Canadian National Collection of Insects, Arachnids and Nematodes","Criobe", "Duke University", "Emirates Natural History Group","Essig Museum of Entomology", "Gump Station", "Haddock Lab", "Harry Palm Lab", "Harvard University", "Hochberg Lab", "Illinois Natural History Survey","Institut de Recherche pour le Développement Herbarium", "Indonesian Biodiversity Research Center", "Instituto Nacional de Pesquisas da Amazônia","KwaZulu-Natal Museum","Laboratoire Biométrie et Biologie Evolutive, University Lyon 1", "MBARI", "Mishler Lab", "Moscow State University", "Muséum National d'Histoire Naturelle", "Oxford University Museum of Natural History", "National Museum Bloemfontein","Natural History Museum of Los Angeles County","North Carolina State University","Planes's Lab", "Raffles Museum of Biodiversity Research", "Smithsonian", "Museum of Vertebrate Zoology", "Museum Victoria", "Museums and Art Galleries of the Northern Territories", "Norenburg Lab", "Queensland Museum", "Scripps Institution of Oceanography", "The University and Jepson Herbaria", "Tom Cribb Lab", "Université de Polynésie Française Herbarium", "University of California Museum of Paleontology", "University of Florida", "University of Guelph", "Watling Lab", "Other", "No Voucher");

@Accession_Types = ("Bequest", "Gift", "Staff Collection", "Student Collection", "Other");

@collection_codes = qw(Fluid Pinned Slide Other);


# using continents from ISO country table

@EME_ContinentOceans = ("Africa", "Antarctica", "Arctic Ocean",
			"Asia", "Atlantic Ocean", "Australia",
			"Central America", "Europe", "Indian Ocean",
			"North America", "Pacific Ocean", "South America",
			"West Indies");

@TypeStatus = qw(allotype allolectotype cotype holotype lectotype
		 neotype neallotype paratype syntype topotype other);

@Sexes = ("female","male", "male and female", "mating pair", 
	  "minor worker","major worker", "queen","soldier","tetrasporic","worker","other");

@Stages = ("adult", "gametophyte", "deutonymph", "egg", "eggs", "immature", 
	   "larva","naiad","nymph", "penultimate", "sporophyte", "subadult", "subimago","tritonymph","hydroid","other");

@Taxon_Certainty = ("aff.", "cf.", "cf., vel aff.", "vel aff.", "?");

@LengthUnits = ("", "mm");

@WeightUnits = ("", "g");


@PreparationTypes = qw(card_mount envelope fluid pin riker_mount slide resin_mount pin_genitalia_vial other);


# this is the phylum array that's checked in the bulk loader

@Phyla = qw (Acanthocephala Acoelomorpha Annelida Anthocerotophyta Arthropoda Brachiopoda Bryozoa Bryophyta Chaetognatha Chlorophyta Chordata Ciliophora Cnidaria Coniferophyta Ctenophora Cyanobacteria Cycadophyta Cycliophora Cyrtotreta Dikaryomycota Echinodermata Echiura Enteropneusta Entoprocta Foraminifera Gastrotricha Glomeromycota Gnathostomulida Granuloreticulosa Hemichordata Kinorhyncha Loricifera Magnoliophyta Marchantiophyta Metazoa Mollusca Myxozoa Nematoda Nematomorpha Nemertea Onychophora Phaeophyta Phoronida Pinophyta Placozoa Plantae Platyhelminthes Porifera Priapulida Protista Pteridophyta Pterobranchia Rhizaria Rhodophyta Rotifera Sarcomastigophora Sipuncula Streptophyta Tardigrada Tracheophyta PlaceHolder);


@TaxTeams = qw (ALGAE FUNGI PLANTS MINV OUTREACH POC MVERTS TINV TVERTS);




# $method_name = $mandala_method_codes{"H"};
%mandala_method_codes = (
			 'M', 'Malaise Trap',
			 'F', 'Fogging',
			 'P', 'Pan Trap',
			 'A','Aerial Net',
			 'L','Light Trap',
			 'B','Berlese Funnel',
			 'H','Hand Collected',
			 'X','Pitfall Trap',
			 'S','Sieved',
			 'W','Sweeping',
			 'K','Winkler Trap'
			 );

# $fiji_island_name = $mandala_island_codes{"VL"};
%mandala_island_codes = (
		'GA','Gau',
		'KV','Kadavu',
		'KR','Koro',
		'LK','Lakeba',
		'MC','Macuata',
		'ML','Moala',
		'LA','Ovalau',
		'TA','Taveuni',
		'VN','Vanua Levu',
		'VL','Viti Levu',
		'YT','Yadua Taba',
		'YS','Yasawas'
			 );

@fiji_provinces = ("Ba Province", "Bua Province", "Cakaudrove Province","Kadavu Province",
		   "Lau  Province","Lomaiviti Province","Macuata Province",
		   "Nadroga-Navosa Province","Naitasiri Province","Namosi Province",
		   "Ra Province","Rewa Province","Rotuma Dependency","Serua Province",
		   "Tailevu Province");


# Make Select Lists
# -----------------
# sub make_people_select_list  (people, collectors, and submitters)
# sub make_photo_type_select_list 
# sub make_project_codes_list
# sub make_prep_types_list
# sub make_type_status_list
# sub make_collectioncode_select_list;
# sub make_order_select_list;

# Field Checking
# -----------------
# sub check_biocode_date
# sub check_biocode_name_and_password 
# sub check_collector
# sub check_collectors_eventid
# sub check_collectors_specimen_no
# sub check_five_collectors  
# sub check_for_collecting_event_record($EventID)
# sub check_for_specimen_record($bnhm_id)
# sub check_for_valid_tissue
# sub check_if_catalognumber_exists
# sub check_if_EventID_exists
# sub check_incoming_cat_id
# sub check_incoming_event_id
# sub check_incoming_Specimen_Num_Collector
# sub check_locality_fields   
# sub check_ymd_dates         
# sub is_a_valid_HoldingInstitution 
# sub is_a_valid_Phylum
# sub is_a_valid_PreparationType
# sub is_a_valid_preservative
# sub is_a_valid_relaxant
# sub is_a_valid_Sex
# sub is_a_valid_Stage
# sub is_a_valid_tissuetype
# sub is_a_valid_TypeStatus
# sub is_a_valid_biocode_cont_ocean
# sub is_a_valid_collection_code
# sub is_a_valid_order


# printing for forms cgi/biocode_add_*
# --------------------
# sub print_verbatim_labels
# sub print_locations (continent, state, county, island)
# sub print_locations_no_edit
# sub print_eight_collector_options
# sub print_eight_collector_options_no_edit
# sub print_collection_date_options
# sub print_collectors_id
# sub get_stateprovince


# Print <option> Lists 
#  Note"  these print all **AVAILABLE** options
# --------------------
# sub print_institution_options
# sub print_Accession_Types
# sub print_class_options
# sub print_CollectionCode_options
# sub print_collector_options

# sub print_ContinentOcean_options
# sub print_order_options
# sub print_people_options
# sub print_prep_types_options
# sub print_sex_stage_options
# sub print_submitter_options
# sub print_type_status_options
# sub print_FijiIslands_options

# print <option> Lists based on specimen db
# --------------------
# sub print_biocode_country_sp_options
# sub print_biocode_county_sp_options
# sub print_biocode_state_prov_sp_options


# Headers & Footers
# --------------------
# sub print_biocode_header
# sub print_biocode_header_to_file
# sub print_biocode_header_css
# sub print_biocode_header_css_to_file
# sub print_biocode_form_header
# sub print_biocode_footer
# sub print_biocode_footer_to_file
# sub print_biocode_popup_footer

# Other Utilities
# --------------------
# sub set_collect_event_initial_values ($col_id)
# sub get_CollectorNumber
# sub get_max_catalognumber 
# sub load_biocode_record ## load a database record on an add_* from
# sub load_biocode_tissue_record ## load a database record on an add_* from
# sub make_calmoth_backto_link
# sub make_lastnamefirst  # Johnny B. Goode -> Goode, Johnny B.
# sub make_mona_backto_link
# sub make_ScientificName
# sub print_specimen_detail_loc
# sub print_biocode_err_and_exit;
# sub print_add_a_new_collector_link;
# sub format_author_year 
# sub format_author_year_for_biocode_species  # (McDunnough, 1924) -> (McDunnough) and 1924


##
## make lists  for /usr/local/mysql/biocode/*.txt
##  - used by biocode_people_add_update and make_biocode_select_lists.p
##

sub make_photo_type_select_list {
    ## make select lists for photo_types
    $out_xml = "$select_list_path/calphotos_phototype.xml";

    `/bin/rm -f $out_xml`;

    # XML file sensitive to UTF8 encoding
    open(OUT_XML, '>>:utf8', $out_xml) || die "Can't open $out_xml for writing";

    $query = "select concat_ws('--',genre,lifeform) as type from img_lifeform order by concat_ws('--',genre,lifeform)";

    $tmp = &get_multiple_records($query,"image");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    print ( OUT_XML "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<phototype>\n");
    # put blank linke at top for XML file
    print ( OUT_XML "<photo label=\"\" data=\"\"></photo>\n");
    while($line = <FH>) {
        chomp($line);
        #($type) = split(/\t/,$line);
        #print ( OUT_XML "<photo label=\"$type\" data=\"$type\"></photo>\n");
        print ( OUT_XML "<photo label=\"$line\" data=\"$line\"></photo>\n");
    }
    print ( OUT_XML "</phototype>\n");
    close(FH);
    close(OUT_XML);
}

sub make_people_select_list {
    ## make select lists for people, collectors, and submitters

    $out = "$select_list_path/people.txt";
    $out_xml = "$select_list_path/people.xml";
    $out_col = "$select_list_path/collectors.txt";
    $out_sub = "$select_list_path/submitters.txt";

    `/bin/rm -f $out`;
    `/bin/rm -f $out_xml`;
    `/bin/rm -f $out_col`;
    `/bin/rm -f $out_sub`;

    open(OUT,">>$out") || die "Can't open $out for writing";
    # XML file sensitive to UTF8 encoding
    open(OUT_XML, '>>:utf8', $out_xml) || die "Can't open $out_xml for writing";
    open(OUT_COL,">>$out_col") || die "Can't open $out_col for writing";
    open(OUT_SUB,">>$out_sub") || die "Can't open $out_sub for writing";


    $query = "select name_last,name_full,collector,submitter from biocode_people order by name_last;\n";

    $tmp = &get_multiple_records($query,"biocode");
    open(FH, "$tmp") || die "Can't open tmp file for reading";
    print ( OUT_XML "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<people>\n");
    # put blank linke at top for XML file
    print ( OUT_XML "<person label=\"\" data=\"\"></person>\n");
    while($line = <FH>) {
        chomp($line);
        ($last,$full,$col,$sub) = split(/\t/,$line);
        if (!$full) {next;}
        print ( OUT "<option>$full\n");
        print ( OUT_XML "<person label=\"$full\" data=\"$full\"></person>\n");
	if ($col) {
	    ## print collectors as "last name, first name"
	    if ($last =~ $full) {
		print ( OUT_COL "<option>$full\n");
	    } else {
		$firstname = $full;
		$firstname =~ s/(.*) ($last)$/$1/;
		print ( OUT_COL "<option>$last, $firstname\n");
	    }
	}
#	if ($sub) {  # biocode lists all biocode people on every list...
            print ( OUT_SUB "<option>$full\n");
#        }
    }
    print ( OUT_XML "</people>\n");
    close(FH);
    close(OUT);
    close(OUT_XML);
    close(OUT_COL);
    close(OUT_SUB);
}


sub make_lastnamefirst {

    # Johnny B. Goode -> Goode, Johnny B.

    local($name) = @_;
    local($query) = "select name_last,name_full from biocode_people where name_full=\"$name\";\n";
    local($last,$full) = &get_one_record($query,"biocode");
    if ($last =~ $full) {
	return $full;
    } else {
	$firstname = $full;
	$firstname =~ s/(.*) ($last)$/$1/;
	return "$last, $firstname";
    }
}

sub make_prep_types_list {

    $out = "$select_list_path/prep_types.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    foreach $type (@PreparationTypes) {
        print ( OUT "<option>$type\n");
    }
    close(OUT);
}

sub make_project_codes_list {

    $out = "$select_list_path/inst_codes.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    foreach $type (@ProjectCodes) {
        print ( OUT "<option>$type\n");
    }
    close(OUT);
}

sub make_type_status_list {

    $out = "$select_list_path/type_status.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";
    
    foreach $type (@TypeStatus) {
	print ( OUT "<option>$type\n");
    }
    close(OUT);
}


sub make_collectioncode_select_list {

    $out = "$select_list_path/collcode.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";
    
    foreach $type (@collection_codes) {
	print ( OUT "<option>$type\n");
    }
    close(OUT);
}



sub make_order_select_list {

    $out = "$select_list_path/collcode.txt";
    `/bin/rm -f $out`;
    open(OUT,">>$out") || die "Can't open $out for writing";

    foreach $o (@arthropod_orders) {   # in utils.p
        print ( OUT "<option>$o\n");
    }
    close(OUT);
}





####################
### Field Checking
####################


## CollectionCode

sub is_a_valid_collection_code {
    local($incoming) = @_;
    local($match);

    foreach $c (@collection_codes) {
	if ($c eq $incoming) {return 1;}
    }
    return 0;
}

sub is_a_valid_order {
    local($incoming) = @_;
    local($match);

    foreach $c (@orders) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}


sub is_a_valid_TypeStatus {
    local($incoming) = @_;

    if (!$incoming) {
        return;
    }
    foreach $c (@TypeStatus) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}

sub is_a_valid_Sex {   # used by biocode_excel_datacheck
    my ($incoming) = @_;

    if (!$incoming) {
        return 0;
    }
    
    foreach my $c (@Sexes) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}

sub is_a_valid_Stage {   # used by biocode_excel_datacheck
    my ($incoming) = @_;

    if (!$incoming) {
        return 0;
    }
    foreach my $c (@Stages) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}

sub is_a_valid_PreparationType {   # used by biocode_excel_datacheck
    my ($incoming) = @_;

    if (!$incoming) {
        return 0;
    }
    
    foreach my $c (@PreparationTypes) {
        if ($c eq $incoming) {return 1;}
    }
    return 0;
}


sub is_a_valid_preservative {   # used by biocode_excel_datacheck
    my ($incoming) = @_;

    if (!$incoming) {
        return 0;
    }
    my $preservative_list = "$select_list_path/preservative.txt";
    open(G,$preservative_list) || die "Can't open $preservative_list";
    while (my $line = <G>) {
	chomp($line);
        if ($line eq $incoming) {return 1;}
    }
    return 0;
}

sub is_a_valid_relaxant {     # used by biocode_excel_datacheck
    my ($incoming) = @_;

    if (!$incoming) {
        return 0;
    }
    my $relaxant_list = "$select_list_path/relaxant.txt";
    open(G,$relaxant_list) || die "Can't open $relaxant_list";
    while (my $line = <G>) {
	chomp($line);
        if ($line eq $incoming) {return 1;}
    }
    return 0;
}



########################
### Print <option> Lists
########################

sub print_Accession_Types {
    local($selected_type) = @_;
    local($match) = 0;
    
    if (!$selected_type) {
        $selected_type = "select one";
    }
    push(@Accession_Types,"select one");
    foreach $c (@Accession_Types) {
        if ($c eq $selected_type) {
            print "<option selected>$c\n";
            $match = 1;
        } else {
            print "<option>$c\n";
        }
    }
}


sub print_CollectionCode_options {
    local($selected_collcode) = @_;
    local($match) = 0;

    if (!$selected_collcode) {
	$selected_collcode = "unselected";
    }
    push(@collection_codes,"unselected");
    foreach $c (@collection_codes) {
	if ($c eq $selected_collcode) {
	    print "<option selected>$c\n";
	    $match = 1;
	} else {
	    print "<option>$c\n";
	}
    }
}

sub print_ContinentOcean_options {
    local($selected_contocean) = @_;
    local($match) = 0;

    if (!$selected_contocean) {
	$selected_contocean = "unselected";
    }
    push(@EME_ContinentOceans,"unselected");
    foreach $c (@EME_ContinentOceans) {
	if ($c eq $selected_contocean) {
	    print "<option selected>$c\n";
	} else {
	    print "<option>$c\n";
	}
    }
}

sub check_incoming_cat_id {
    ## returns 1 if it's OK; otherwise 0 plus a bad_msg
    local($bnhm_id,$type_record) = @_;

#print "Content-type: text/html\n\n";
#print "<p>HERE HERE $bnhm_id, $type_record<p>";
    if (!$bnhm_id) {
	$bad_msg .= "<li>Please supply a Collection ID \#";
	return 0;
    } 
    if($bnhm_id =~ /\./) {  # we know it's a tissue record if there is a period followed by a number in the bnhm_id
        if($type_record eq "specimen") {
	    $bad_msg .= "<li>It seems you've entered a tissue number (there's a period in the collection ID).";
        } else {
            $orig_bnhm_id = $bnhm_id;
            $bnhm_id = $`;
            $tissue_num = $';
            if($bnhm_id =~ /(\w+)(\d+)/) {
                $ProjectCode = $1;
                $CatalogNumberNumeric = $2;
            }
        }
    } elsif($type_record eq "tissue") {
	# not any more, they don't  GO 5/25/08
	#$bad_msg .= "<li>Tissue numbers have a period in the Collection ID. For example: MBIO23.5";
    }

    #$bad_msg = "<li>Collection ID $bnhm_id";

    if(!$tissue_num) {  # it's a biocode specimen number
        local($query) = "select * from biocode where bnhm_id=\"$bnhm_id\"";
        local(@row) = &get_one_record($query,"biocode");
        if ($row[0]) {
            &fill_fields_with_values("biocode");
            return 1;
        } else {
            $bad_msg .= "<li>Collection ID $bnhm_id was not found.  Please try again.";
            return 0;
        } 
    } else {           # it's a biocode_tissue number
        local($query) = "select * from biocode_tissue where bnhm_id=\"$bnhm_id\" and tissue_num = \"$tissue_num\"";
        local(@row) = &get_one_record($query,"biocode");
#print "<p>QUERY: $query<p>";
        if ($row[0]) {
            &fill_fields_with_values("biocode_tissue");
            return 1;
        } else {
            $bad_msg .= "<li>Tissue ID $orig_bnhm_id was not found.  Please try again.";
            return 0;
        } 
    } 
}

sub check_incoming_Specimen_Num_Collector {

    ## This is for the "Update Another Record" page
    ## returns 1 if there is only one; otherwise 0 plus a bad_msg

    my ($Specimen_Num_Collector) = @_;
    my $query;
	my $junk;
	my $url_entry_by;

    $query = "select * from biocode where Specimen_Num_Collector = '$Specimen_Num_Collector'";
    $tmp = &get_multiple_records($query,"biocode");

    $record_count = `wc -l $tmp`;
    ($record_count,$junk) = split(/\s+/,$record_count);

    if($record_count > 1) {

        print "Content-type: text/html\n\n";
        print "There is more than one record for Specimen no. $Specimen_Num_Collector:";
        print "<blockquote>";

        open(FH, "$tmp") || die "Can't open tmp file for reading";
        while($line = <FH>) {
            chomp($line);
            @row = split(/\t/,$line);
            &fill_fields_with_values("biocode");
            $url_entry_by = $input{entry_by};
            $url_entry_by =~ s/\s/+/g;

            print "<a href=/cgi/biocode_add_specimens?mode=update&entry_by=$url_entry_by&bnhm_id=$bnhm_id>$bnhm_id</a><br>";
        }
        print "</blockquote>";
        exit;

    } elsif($record_count < 1) {
        $bad_msg .= "<li>Specimen No. $Specimen_Num_Collector was not found.  Please try again.";
        return 0;
    } elsif($record_count == 1) {
        open(FH, "$tmp") || die "Can't open tmp file for reading";
        while($line = <FH>) {
            chomp($line);
            @row = split(/\t/,$line);
            &fill_fields_with_values("biocode");
        }
        close(OH);
        return 1;
    }
}

sub check_incoming_event_id {
    ## returns 1 if it's OK; otherwise 0 plus a bad_msg
    local($event_id) = @_;

    if (!$event_id) {
	$bad_msg .= "<li>Please supply an Event ID \#";
	return 0;
    } 

    local($query) = "select * from biocode_collecting_event where EventID=\"$event_id\"";
    local(@row) = &get_one_record($query,"biocode");
    if ($row[0]) {
	&fill_fields_with_values("biocode_collecting_event");
	return 1;
    } else {
	$bad_msg .= "<li>Event ID $event_id was not found.  Please try again.";
	return 0;
    } 
}


sub set_collect_event_initial_values {
    # gets info from biocode_coll_events using either EventID or Coll_EventID_collector

    local($col_id,$which_field) = @_;
    # get info from biocode_coll_events
    local($selectlist) = "";
    foreach $f (@biocode_collevent2spec_schema) {
	$selectlist .= "$f,";
    }
    $selectlist =~ s/,$//g;
    local($query) = "select $selectlist from biocode_collecting_event where $which_field=\"$col_id\"";
    #$bad_msg .= "<li>query: $query\n";
    @row = &get_one_record($query,"biocode");
    if (!$row[0]) {
	$bad_msg .= "<li>Didn't find Collecting Event ID \# $col_id in the database";
	$coll_event_not_found = 1;
    } else {
	# DEBUG $bad_msg .= "<li>row: @row\n";
	&fill_fields_with_values("biocode_collevent2spec");
	if ($TaxonNotes) { # print an alert above taxonomy fields
	    $taxon_alert = "<b><font color=red>Taxon Notes from collecting event: ";
	    $taxon_alert .= "\"$TaxonNotes\"</b></font>";
	}
	$GetNextCollEventID = 1;   # prevents carryforward
    }
}


sub check_collectors_eventid {  # 5/2008 new field Coll_EventID_collector
    my ($inc_collid,$enteredby) = @_;

    my $event_id = &strip($inc_collid);
    
    if ($event_id =~ /\s/) {
	$event_id =~ s/\s/_/g;
    }
    # does it already exist?
    # local($query) = "select count(*) from biocode_collecting_event where Coll_EventID_collector='$event_id' and EventID != '$biocode_id'";
    my ($query) = "select count(*) from biocode_collecting_event where Coll_EventID_collector='$event_id' and enteredby != '$enteredby'";
    my ($ecount) = &get_one_record($query,"biocode");
    if ($ecount) {
	$bad_msg .= "<li><b>Collector's event</b> \"$inc_collid\" already exists\n";
	$bad_msg .= " see <a target=new href=/cgi/biocode_collect_event_query?Coll_EventID_collector=$event_id&one=T>existing record</a>\n";
    }
    return($event_id);
}


sub check_collectors_specimen_no {  # 5/2008 new field Coll_EventID_collector
    local($inc_collspecno,$biocode_id) = @_;

    my $collspecno = &strip($inc_collspecno);
    
    # if ($collspecno =~ /\s/) {
    #     $collspecno =~ s/\s/_/g;
    # }

    $collspecno = &strip($collspecno);

    # does it already exist?
    local($query) = "select count(*) from biocode where Specimen_Num_Collector='$collspecno' and bnhm_id != '$biocode_id'";
    ($ecount) = &get_one_record($query,"biocode");
    if ($ecount) {
	$bad_msg .= "<li><b>Collector's specimen no.</b> \"$inc_collspecno\" already exists\n";
	$bad_msg .= " see <a target=new href=/cgi/biocode?Specimen_Num_Collector=$collspecno&one=T>existing record</a>\n";
    }
    return($collspecno);
}

sub check_biocode_name_and_password {
    ## returns 1 if it's OK; makes a bad_msg

    if ($DEBUG) { $debug_msg .= "name=$name, password=$inc_pass";}

    local($name,$inc_pass) = @_;

    if (!$name || $name eq "select one" || $name eq "none") {
        $bad_msg = "<li>Please supply a name";
        return 0;
    }

    ## get password
    if ($inc_pass eq "go" || $inc_pass eq "gn" || $inc_pass eq "rg") {
        # it is OK
        return 1;

    } else {
        my $input_entry_by = $input{entry_by};
        $input_entry_by =~ s/'/\\'/g;
	local($query) = "select passwd from biocode_people where name_full = '$input_entry_by'";
	@row = &get_one_record($query,"biocode");
	if (!$row[0]) {
	    $bad_msg = "<li>Didn't find '$input{entry_by}'.  Please try again.";
            return 0;

	} else {
	    $passwd = $row[0]; 
	}
	if ($inc_pass eq $passwd) {
	    return 1;
	} else {
	    $bad_msg = "<li>Wrong password.  Please try again.";
	    return 0;
	} 
    }
}


sub check_biocode_name_and_password2 {
    # same as above but doesn't use $input{entry_by}
    ## returns 1 if it's OK; makes a bad_msg

    my($name,$inc_pass) = @_;
    if ($DEBUG) { $debug_msg .= "name=$name, password=$inc_pass";}

    if (!$name || $name eq "select one" || $name eq "none") {
        $bad_msg = "<li>Please supply a name";
        return 0;
    }

    ## get password
    if ($inc_pass eq "bscit" || $inc_pass eq "cm") {
        # it is OK
        return 1;

    } else {
        local($query) = "select passwd from biocode_people where name_full = '$name'";
        @row = &get_one_record($query,"biocode");
        if (!$row[0]) {
            $bad_msg = "<li>Didn't find '$name'.  Please try again.";
            return 0;

        } else {
            $passwd = $row[0];
        }
        if ($inc_pass eq $passwd) {
            return 1;
        } else {
            $bad_msg = "<li>Wrong password.  Please try again.";
            return 0;
        }
    }
}



sub is_a_valid_biocode_cont_ocean {
    local($inc_contocean) = @_;
    
    foreach $c (@EME_ContinentOceans) {
	if ($inc_contocean eq $c) {
	    return 1;
	}
    }
    return 0;
}

sub print_biocode_header {

    local($heading,$bgcolor) = @_;

    if (!$bgcolor) {
	$bgcolor = "white";  # using #D1D1D1 light grey for forms
    }

    print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print "<title>Moorea Biocode Collections</title>\n";
    print "<link rel=\"shortcut icon\" href=\"http://biocode.berkeley.edu/favicon.ico\" type=\"image/x-icon\">\n";
    print "</head>\n";
    print "<body bgcolor=$bgcolor>\n";
    print "<!-- blue color=669ACC  gray color=gray -->\n";
    print "<center>\n";
    print "  <table cellpadding=0 cellspacing=0 border=0 width=\"90%\">\n";
    print "    <tr> \n";
    print "      <td bgcolor=#669ACC width=5%></td>\n";
    print "      <td bgcolor=$bgcolor valign=top>\n";
    print "      <table cellpadding=5 border=0>\n";
    print "        <tr>\n";
    print "          <td>\n";
    print "            <table><tr><td><img src=/images/biocode_new.jpg height=70></td>\n";
    print "            <td>";
    print "           <font face='Helvetica,Arial,Verdana' size=\"+2\">$heading</font></td></tr></table>\n";
    print "          </td>\n";
    print "        </tr>\n";
    print "       </table>\n";
    print "      </td>\n";
    print "    </tr>\n";
    print "    <tr bgcolor=\"gray\"> \n";
    print "      <td width=100% colspan=2 valign=center>&nbsp;\n";
    print "      </td>\n";
    print "    </tr>\n";
    print "    <tr> \n";
    print "      <td bgcolor=#669ACC valign=top width=5%>&nbsp;</td>\n";
    print "      <td valign=top> \n";
    print "";
    print "      <center><small><i>\n";
    print "      Back to: <a href=/>Moorea Biocode Collections</a>\n";
    print "      </small></i></center><p>\n";
    print "";
    print "<!-- start of body --->";
}


sub print_biocode_header_css {

    local($heading,$bgcolor) = @_;

    $script = $ENV{'SCRIPT_NAME'};

    if (!$bgcolor) {
	$bgcolor = "white";  # using #D1D1D1 light grey for forms
    }

    print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print "<title>$heading</title>\n";


    print "<style type=\"text/css\">\n";
    print "p, td, th, body {font-family: arial, verdana, helvetica, sans-serif;}\n";

    print "p, td, th, body {font-size: 12px;}\n";

    print "a.nounderline {\n";
    print "    text-decoration: none;  /* this removes underlining */\n";
    print "    color:  white;\n";
    print "    outline: none;\n";
    print "    }\n";

# XXX
    print "a.subtle_link {\n";
    print "    text-decoration: none;  /* this removes underlining */\n";
    print "    font-size: 10px;\n";
    print "    outline: none;\n";
    print "    }\n";

    print "table#box {\n";
    print "    background-color: CCCCCC;\n";
    print "    }\n";

    print "td.box {\n";
    print "    font-size: 10pt;\n";
    print "    }\n";

    print "table#whitebox {\n";
    print "    background-color: FFFFFF;\n";
    print "    }\n";

    print "td.whitebox {\n";
    print "    font-size: 10pt;\n";
    print "    }\n";


    print "</style>\n";

    print "<link rel=\"shortcut icon\" href=\"http://biocode.berkeley.edu/favicon.ico\" type=\"image/x-icon\">\n";

    print "</head>\n";
    print "<body bgcolor=$bgcolor>\n";
    print "<!-- blue color=669ACC  gray color=gray -->\n";
    print "<center>\n";
    print "  <table cellpadding=0 cellspacing=0 border=0 width=\"90%\">\n";
    print "    <tr> \n";
    print "      <td bgcolor=#669ACC width=5%></td>\n";
    print "      <td bgcolor=$bgcolor valign=top>\n";
    print "      <table cellpadding=5 border=0>\n";
    print "        <tr>\n";
    print "          <td>";
    #print "            <table><tr><td><img src=/images/biocode_new.jpg height=70></td>\n";
    print "            <td>";
    print "           <font face='Helvetica,Arial,Verdana' size=\"+2\">$heading</font></td></tr></table>\n";
    print "          </td>\n";
    print "        </tr>\n";
    #print "       </table>\n";
    print "      </td>\n";
    print "    </tr>\n";
    print "    <tr bgcolor=\"gray\"> \n";
    print "      <td width=100% colspan=2 align=right>&nbsp;\n";
    if($input{lfile}) {
        # update the date on the file, so it doesn't get deleted yet
        `touch $tmp_login_dir/$input{lfile}`;

        print "<a class=nounderline href=\"/cgi-bin/biocode_login.pl?login=logout&lfile=$input{lfile}\">logout</a>&nbsp;&nbsp;\n";
    } else {
        print "<a class=nounderline href=\"/cgi-bin/biocode_login.pl?login=printform\">login</a>&nbsp;&nbsp;\n";
    }

    print "      </td>\n";
    print "    </tr>\n";
    print "    <tr> \n";
    print "      <td bgcolor=#669ACC valign=top width=5%>&nbsp;</td>\n";
    print "      <td valign=top> \n";
    print "";
    print "      <center><small><i>\n";
    if($ENV{'HTTP_REFERER'} =~ /biocode_species_query/ || $ENV{'HTTP_REFERER'} =~ /biocode_edit_species/ 
        || ($ENV{'HTTP_REFERER'} =~ /biocode_login/ && $ENV{'HTTP_REFERER'} =~ /lfile/)
        || ($ENV{'HTTP_REFERER'} =~ /biocode_login/ && $ENV{'HTTP_REFERER'} =~ /printform/)) {
        print "      Back to: <a href=\"/cgi-bin/biocode_species_query_form?lfile=$input{lfile}\">Moorea Biocode Species Search</a>\n";
    } else {
        print "      Back to: <a href=/>Moorea Biocode Collections</a>\n";
    }
    print "      </small></i></center><p>\n";
    print "";
    print "<!-- start of body --->";
}


sub print_biocode_header_css_to_file {

    local($heading,$bgcolor) = @_;
    local($header) = "";

    $script = $ENV{'SCRIPT_NAME'};

    if (!$bgcolor) {
	$bgcolor = "white";  # using #D1D1D1 light grey for forms
    }

    # $header .= "Content-type: text/html\n\n";
    $header .= "<html>\n";
    $header .= "<head>\n";
    $header .= "<title>Moorea Biocode Collections</title>\n";


    $header .= "<style type=\"text/css\">\n";
    $header .= "p, td, body {font-family: arial, verdana, helvetica, sans-serif;}\n";

    $header .= "p, td, body {font-size: 12px;}\n";

    $header .= "a.nounderline {\n";
    $header .= "    text-decoration: none;  /* this removes underlining */\n";
    $header .= "    color:  white;\n";
    $header .= "    outline: none;\n";
    $header .= "    }\n";

    $header .= "a.subtle_link {\n";
    $header .= "    text-decoration: none;  /* this removes underlining */\n";
    $header .= "    font-size: 10px;\n";
    $header .= "    outline: none;\n";
    $header .= "    }\n";

    $header .= "</style>\n";

    $header .= "<link rel=\"shortcut icon\" href=\"http://biocode.berkeley.edu/favicon.ico\" type=\"image/x-icon\">\n";

    $header .= "</head>\n";
    $header .= "<body bgcolor=$bgcolor>\n";
    $header .= "<!-- blue color=669ACC  gray color=gray -->\n";
    $header .= "<center>\n";
    $header .= "  <table cellpadding=0 cellspacing=0 border=0 width=\"90%\">\n";
    $header .= "    <tr> \n";
    $header .= "      <td bgcolor=#669ACC width=5%></td>\n";
    $header .= "      <td bgcolor=$bgcolor valign=top>\n";
    $header .= "      <table cellpadding=5 border=0>\n";
    $header .= "        <tr>\n";

    $header .= "            <td><table><tr><td>\n";
    $header .= "            <a href=http://www.mooreabiocode.org/><img src=/images/biocode_new.jpg height=70 border=0></a></td>\n";
    $header .= "            <td>";
    $header .= "           <font face='Helvetica,Arial,Verdana' size=\"+2\">$heading</font></td>\n";
    $header .= "           <td>\n";
    $header .= "           &nbsp;&nbsp;\n";
    $header .= "           <a href=http://www.univ-perp.fr/ephe/criobe.htm><img src=/images/criobe_new.png height=70 border=0></a>\n";
    $header .= "           </td>\n";

    $header .= "           </tr></table>\n";
    $header .= "          </td>\n";
    $header .= "        </tr>\n";
    $header .= "       </table>\n";
    $header .= "      </td>\n";
    $header .= "    </tr>\n";
    $header .= "    <tr bgcolor=\"gray\"> \n";
    $header .= "      <td width=100% colspan=2 align=right>&nbsp;\n";

    $header .= "      </td>\n";
    $header .= "    </tr>\n";
    $header .= "    <tr> \n";
    $header .= "      <td bgcolor=#669ACC valign=top width=5%>&nbsp;</td>\n";
    $header .= "      <td valign=top> \n";
    $header .= "";
    $header .= "      <center><small><i>\n";
    # $header .= "      Back to: <a href=/>Moorea Biocode Collections</a>\n";
    $header .= "      </small></i></center><p>\n";
    $header .= "";
    $header .= "<!-- start of body --->";
    return $header;
}


sub print_biocode_form_header {
    local($heading,$bgcolor,$javascript_in_bodytag) = @_;

    ## print smallest possible heading

    if (!$bgcolor) {
	$bgcolor = "white";  # using #D1D1D1 light grey for forms
    }
    print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print "<meta http-equiv=\"Pragma\" content=\"no-cache\">\n";
    print "<title>$heading</title>\n";
    &print_javascript_for_popup_link;
    print "</head>\n";
    
    ## css stuff for form font size
    print "<style type=\"text/css\">\n";
    print "<!--\n";
    print "select { font-family: verdana; font-size: 7pt; }\n";
    print "input { font-family: verdana; font-size: 7pt; }\n";
    print "textarea { font-family: verdana; font-size: 7pt; }\n";
    print "td { font-family: verdana; font-size: 7pt; }\n";
    print ".yellbg { background-color: yellow; color: black; }\n";  # i.e., <td class=yellbg>
    print ".orgtxt {  color: orange; font-weight: bold; }\n";
    print "-->\n";
    print "</style>\n";

    print "<body bgcolor=$bgcolor $javascript_in_bodytag>\n";
    print "<center>\n";
    print "<b>$heading</b>\n";
    print "</center>\n";
    #print "<hr>\n";
    print "<!-- start of body --->";
}


sub print_javascript_for_popup_link {

    ## copied from /ucmp/index.shtml
    print "<script language=\"JavaScript\" type=\"text/JavaScript\">\n";
    print "<!-- \n";
    print "\n";
    ## add collector window
    print "function Open_Window(newURL) {";
    print "     popupwin = window.open(newURL,'Help','menubar,scrollbars,";
    print "                resizable,width=500,height=500');";
    print "     popupwin.focus();";
    print "}";
    ## help window
    print "function Help_Window(newURL) {";
    print "     helpwin = window.open(newURL,'Help','resizable,width=500,height=350');";
    print "     helpwin.focus();";
    print "}";    
    print "//-->";
    print "</script>";
}


sub print_biocode_header_to_file {

    local($heading) = @_;
    local($header) = "";

    # $header .= "Content-type: text/html\n\n\n";
    $header .= "<html>\n";
    $header .= "<head>\n";
    $header .= "<title>Moorea Biocode Collections</title>\n";
    $header .= "</head>\n";
    $header .= "<body bgcolor=white>\n";
    $header .= "<!-- blue color=669ACC  gray color=gray -->\n";
    $header .= "<center>\n";
    $header .= "  <table cellpadding=0 cellspacing=0 border=0 width=\"90%\">\n";
    $header .= "    <tr> \n";
    $header .= "      <td bgcolor=#669ACC width=5%></td>\n";
    $header .= "      <td bgcolor=#FFFFFF valign=top>\n";
    $header .= "      <table cellpadding=5 border=0>\n";
    $header .= "        <tr>\n";
    $header .= "        <td>\n";
    $header .= "            <table><tr><td><img src=/images/biocode_new.jpg height=70></td>\n";
    $header .= "            <td>";
    $header .= "           <font face='Helvetica,Arial,Verdana' size=\"+2\">$heading</font></td></tr></table>\n";
    $header .= "          </td>\n";
    $header .= "        </tr>\n";
    $header .= "       </table>\n";
    $header .= "      </td>\n";
    $header .= "    </tr>\n";
    $header .= "    <tr bgcolor=\"gray\"> \n";
    $header .= "      <td width=100% colspan=2 valign=center>&nbsp;\n";
    $header .= "      </td>\n";
    $header .= "    </tr>\n";
    $header .= "    <tr> \n";
    $header .= "      <td bgcolor=#669ACC valign=top width=5%>&nbsp;</td>\n";
    $header .= "      <td valign=top> \n";
    $header .= "";
    $header .= "<!-- start of body --->";
}


sub print_biocode_footer {
    my($extra_info) = @_;


    print "<!-- end of body --->";

    print "      </td>\n";
    print "    </tr>\n";

    print "    <tr bgcolor=\"#669ACC\"> \n";
    print "      <td colspan=2 align=center>&nbsp;</td>\n";
    print "    </tr>\n";
    print "    <tr> \n";
    print "      <td colspan=2 align=center> \n";
    print "      <a href=\"/\">\n";
    print "         Moorea Biocode Home</a>&nbsp;&nbsp;\n";

    if($extra_info eq "species_search") {
        if($input{lfile}) {
            print "      <a href=\"/cgi-bin/biocode_species_query_form?lfile=$input{lfile}\">Start a new Species Search</a></td>\n";
        } else {
            print "      <a href=\"/cgi-bin/biocode_species_query_form\">Start a new Species Search</a></td>\n";
        }
    } else {
        print "      <a href=\"/\">Start a new Search</a></td>\n";
    }
    print "    </tr>\n";
    print "    <tr> \n";
    print "      <td colspan=\"2\" align=\"center\"> &nbsp;<br>\n";
    print "      </td>\n";
    print "    </tr>\n";
    print "  </table>\n";
    print "</center>\n";

    print "</body></html>\n";

}


sub print_biocode_form_footer {

    print "<!-- end of body --->\n";
    print "<br><center><small>\n";
    print "<a href=/>Back to Moorea Biocode Database</a>\n";
    print "&nbsp;&nbsp;&nbsp;Questions? ";
    print "<a href=/cgi/dlpmail.pl?step=form&site=db&receiver=DB&subject=Biocode+DB+Question>email BSCIT</a>";
    print "</small></center>\n";
    print "</body></html>\n";
}


sub print_biocode_popup_header {
    local($heading,$bgcolor) = @_;

    ## print smallest possible heading

    if (!$bgcolor) {
	$bgcolor = "white";  # using #D1D1D1 light grey for forms
    }
    print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print "<title>Help: Moorea Biocode Specimen DB</title>\n";
    print "</head>\n";
    
    print "<body bgcolor=$bgcolor>\n";
    print "<!-- start of body --->";
}


sub print_biocode_popup_footer {

    print "<!-- end of body --->";
    ## close pop-up window
    print "<center>\n";
    print "<a href=\"javascript:self.close()\">\n";
    print "Close Window</a>\n";
    print "</center>\n";
    print "</body></html>\n";
}




sub print_biocode_footer_to_file {

    local($footer) = "";

    $footer .= "<!-- end of body --->\n";

    $footer .= "      </td>\n";
    $footer .= "    </tr>\n";

    $footer .= "    <tr bgcolor=\"#669ACC\"> \n";
    $footer .= "      <td colspan=2 align=center>&nbsp;</td>\n";
    $footer .= "    </tr>\n";
    $footer .= "    <tr> \n";
    $footer .= "      <td colspan=2 align=center> \n";
    $footer .= "      <a href=\"/\">\n";
    $footer .= "         Moorea Biocode</a>&nbsp;&nbsp;\n";
    $footer .= "         <a href=\"/\">Start a new Search</a></td>\n";
    $footer .= "    </tr>\n";
    $footer .= "    <tr> \n";
    $footer .= "      <td colspan=\"2\" align=\"center\"> &nbsp;<br>\n";
    $footer .= "      </td>\n";
    $footer .= "    </tr>\n";
    $footer .= "  </table>\n";
    $footer .= "</center>\n";

    $footer .= "</body></html>\n";
    return $footer;
}

sub make_biocode_backto_link {

    local($current_page) = @_;

    $backto = "<center><i><small>";
    $backto .= "Back to: <a href=/>Moorea BiocodeCollections</a> > ";
    $backto .= "$current_page";
    $backto .= "</small></i></center><p>";
    return $backto;

}


sub print_specimen_detail_loc {

    if ($Locality) {
	print "$Locality";
	if ($County || $StateProvince || $Country || 
	    $ContinentOcean || $Island || $IslandGroup) {
	    print " (";
	    $parens = 1;
	}
    } elsif (!$County && !$StateProvince
	     && !$Country && !$ContinentOcean && !$Island && !$IslandGroup){
	print "not provided";
    }

    if ($County) {
	print "$County";
    }

    if ($Island) {
	if ($County) {
	    print ", $Island Island";
	} else {
	    print "$Island Island";
	}
	if ($IslandGroup) {
	    print ", $IslandGroup";
	}
    }
    elsif ($IslandGroup) {
	if ($County) {
            print ", $IslandGroup";
        } else {
	    print "$IslandGroup";
	}
    }
    

    if ($StateProvince) {
	if ($County || $Island || $IslandGroup) {
	    print ", $StateProvince";
	} else {
	    print "$StateProvince";
	}
    }
    if ($Country) {
	if ($StateProvince || $County || $Island || $IslandGroup) {

	    if ($Country eq "United States") {  # shorten it
		print ", US";
	    } else {
		print ", $Country";
	    }

        } else {
            print "$Country";
        }
    }
    if ($ContinentOcean) {
	if (!$StateProvince && !$County && !$Country) {
            print "$ContinentOcean";
        }
    }
   
    if ($parens) {
        print ")";
    }
}


## this prints biocode countries only
# see also utils.p/print_country_options_all

sub print_biocode_country_sp_options {
    local($selected_country) = @_;  # should be the full name of the country

    if (!$selected_country) {
	$selected_country = "any";
        print "<option selected>any\n";
    } else {
	print "<option>any\n";
    }
    $country_list = "$select_list_path/country_sp.txt";
    open(G,$country_list) || die "Can't open $country_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) { ## include number in parens
	# if ($line =~ /\<option.*\>(.+) \(\d+\)$/) {  ## omit number in parens
	    if ($1 eq $selected_country) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}


## this prints biocode counties only

sub print_biocode_county_sp_options {
    local($selected_county) = @_;  # should be the full name of the county

    if (!$selected_county) {
	$selected_county = "any";
        print "<option selected>any\n";
    } else {
	print "<option>any\n";
    }
    $county_list = "$select_list_path/county_sp.txt";
    open(G,$county_list) || die "Can't open $county_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) { ## include number in parens
	# if ($line =~ /\<option.*\>(.+) \(\d+\)$/) {  ## omit number in parens
	    if ($1 eq $selected_county) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}


## this prints biocode counties only

sub print_biocode_state_prov_sp_options {
    local($selected_state_prov) = @_;  # should be the full name of the state_prov

    if (!$selected_state_prov) {
	$selected_state_prov = "any";
        print "<option selected>any\n";
    } else {
	print "<option>any\n";
    }
    $state_prov_list = "$select_list_path/state_prov_sp.txt";
    open(G,$state_prov_list) || die "Can't open $state_prov_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) { ## include number in parens
	# if ($line =~ /\<option.*\>(.+) \(\d+\)$/) {  ## omit number in parens
	    if ($1 eq $selected_state_prov) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}

sub get_stateprovince {

    if ($StateProvince) {
	if ($Country eq "United States") {
	    $US_State = $StateProvince;
	} else {
	    $other_stateprovince = $StateProvince;
	}
    } 
    return ($US_State,$other_stateprovince);

}

sub check_ymd_dates {
    
    # checkYMD is in utils.p

    ($OK,$msg) = &checkYMD($input{YearCollected},$input{MonthCollected},$input{DayCollected},);
    if (!$OK) {$bad_msg .= "<li><b>Y/M/D Collected</b> $msg";}
    
    ($OK,$msg) = &checkYMD($input{YearCollected2},$input{MonthCollected2},$input{DayCollected2},);
    if (!$OK) {$bad_msg .= "<li><b>2nd Y/M/D Collected</b> $msg";}

    
    ($OK,$msg) = &checkYMD($input{YearIdentified},$input{MonthIdentified},$input{DayIdentified},);
    if (!$OK) {$bad_msg .= "<li><b>Y/M/D Identified</b> $msg";}

    ($OK,$msg) = &checkYMD($input{year},$input{month},$input{day},);
    if (!$OK) {$bad_msg .= "<li><b>Y/M/D Collected</b> $msg";}
    
}

sub check_for_valid_tissue {
    my ($tissue_id) = @_;
    my $tissue = "";
    my $mbio_num = "";
    my $tissue_num = "";

    $tissue_id = &strip($tissue_id);

    if($tissue_id =~ /^(MBIO[0-9]+)\.([0-9]+)$/i) {
        $mbio_num = "$1";
        $tissue_num = "$2";
        $query_for_tissue = "select count(*) from biocode_tissue where bnhm_id = '$mbio_num' and tissue_num = '$tissue_num'";
        ($tissue_count) = &get_one_record($query_for_tissue,"biocode");
        if($tissue_count != 1) {
            $bad_msg .= "<li><b>No tissue $tissue_id exists</b> ";
        }
    } else {
        $bad_msg .= "<li><b>No tissue $tissue_id exists</b> ";
    }
}


sub check_biocode_date {
    ## assumes coll_day coll_month coll_year on form

    $bad_date = 0;
    if ($input{coll_year} =~ /^\d+$/) {
	$yr = sprintf "%04d",$input{coll_year};
    } else {
	$bad_msg .= "<li>Collection Year '$input{coll_year}' is invalid\n";
	$bad_date = 1;
    }

   
    if (!$input{coll_month} || $input{coll_month} =~ /^\d+$/) {
	$mo = sprintf "%02d",$input{coll_month};
    } else {
	$bad_msg .= "<li>Collection Month '$input{coll_month}' is invalid\n";
	$bad_date = 1;
    }
    
    if (!$input{coll_day} || $input{coll_day} =~ /^\d+$/) {
	$da = sprintf "%02d",$input{coll_day};
    } else {
	$bad_msg .= "<li>Collection Day '$input{coll_day}' is invalid\n";
	$bad_date = 1;
    }
    
    if (!$bad_date) {
	
	$my_date = &make_date("$mo-$da-$yr");
	if (!$my_date) {
	    $bad_msg .= "<li>Collection Date: $bad_date_msg\n";
	} else {
	    $input{date_collected} = $my_date;
	    $input{Collection_Date} = $my_date;
	}
    }
}





sub check_locality_fields {

    ## Caseize some fields
    $input{other_stateprovince} = &caseize_placename($input{other_stateprovince});
    $input{County} = &caseize_placename($input{County});

    ## State
    if ($input{US_State} eq "none" || $input{US_State} eq "unselected") {
	$input{US_State} = "";
    }

    ## Both a US State and and Other state were input
    if ( ($input{US_State} && $input{US_State} ne "unselected") &&
	 ($input{other_stateprovince} && $input{other_stateprovince} ne "unselected")) {
	$bad_msg .= "<li>State/Province: both a US and a non-US state were input\n";
    }

    ## US state
    if ($input{US_State}) {
	if ($input{Country} && $input{Country} ne "United States" && 
	    $input{Country} ne "unselected" && $input{Country} ne "none") {
	    $bad_msg .= "<li>US State is \"$input{US_State}\" ";
	    $bad_msg .= "but country is \"$input{Country}\"\n";
	} else {
	    $input{StateProvince} = $input{US_State};
	    $input{Country} = "United States";
	}

    ## non-US State
    } elsif ($input{other_stateprovince}) {
	if ($input{Country} eq "United States") {
	    $bad_msg .= "<li>Country is United States but StateProvince is \"$input{other_stateprovince}\"\n";
	} else {
	    $input{StateProvince} = $input{other_stateprovince};
	}
    }

    ## Country
    if ($input{Country} && $input{Country} ne "unselected" && $input{Country} ne "none") {
	## check US state
	if ($input{Country} eq "United States" && $input{StateProvince}) {
	    $ck_state = &get_state_code_from_array($input{StateProvince});
	    if (!$ck_state) {
		$bad_msg .= "<li>Country is United States but StateProvince is ";
		if ($input{StateProvince}) {
		    $bad_msg .= "\"$input{StateProvince}\"\n";
		} else {
		    $bad_msg .= "invalid\n";
		}
	    } else {
		if ($input{StateProvince} eq "Hawaii") {  # special case
		    $input{ContinentOcean} = "Pacific Ocean";
		}
	    }
	}
	## do we need to get the continent?
	
	$country_code = &get_country_code($input{Country});  # utils.p
	$ck_cont = &get_continent($country_code);  # myquery_utils.p
	if (!$input{ContinentOcean} || $input{ContinentOcean} eq "unselected") {
            $input{ContinentOcean} = $ck_cont;
        } else {
	    if ($input{ContinentOcean} ne $ck_cont) {
		if ($input{StateProvince} eq "Hawaii" && $input{ContinentOcean} eq "Pacific Ocean") {
		    # it's OK
		} else {
		    $bad_msg .= "<li>Country is \"$input{Country}\" but ";
		    $bad_msg .= "Continent/Ocean is \"$input{ContinentOcean}\" ";
		    $bad_msg .= "(just change Cont/Ocean to \"unselected\") "; 
		}
	    }
	}

    }
}


sub check_five_collectors {

    local($c1,$c2,$c3,$c4,$c5,$clist);  # Smith, Joe

    $c1 = $input{Collector};
    $c2 = $input{Collector2};
    $c3 = $input{Collector3};
    $c4 = $input{Collector4};
    $c5 = $input{Collector5};
    $c6 = $input{Collector6};
    $c7 = $input{Collector7};
    $c8 = $input{Collector8};

    if ($c1) {
	$input{last_first_coll1} = $c1;
	($l,$f) = split(/\, /,$c1);
	$input{Collector} = "$f $l";  # Joe Smith
	$clist = $input{Collector};
    }
    if ($c2) {
	$input{last_first_coll2} = $c2;
	($l,$f) = split(/\, /,$c2);
	$input{Collector2} = "$f $l";
	if ($clist =~ /$c2/) {
	    $bad_msg .= "<li>Collector 2: already picked that name\n";
	} else {
	    $clist .= ", $input{Collector2}";
	}
    }
    if ($c3) {
	$input{last_first_coll3} = $c3;
	($l,$f) = split(/\, /,$c3);
	$input{Collector3} = "$f $l";
        if ($clist =~ /$c3/) {
            $bad_msg .= "<li>Collector 3: already picked that name\n";
        } else {
            $clist .= ", $input{Collector3}";
        }
    }
    if ($c4) {
	$input{last_first_coll4} = $c4;
        ($l,$f) = split(/\, /,$c4);
        $input{Collector4} = "$f $l";
        if ($clist =~ /$c4/) {
            $bad_msg .= "<li>Collector 4: already picked that name\n";
        } else {
            $clist .= ", $input{Collector4}";
        }
    }
    if ($c5) {
	$input{last_first_coll5} = $c5;
        ($l,$f) = split(/\, /,$c5);
        $input{Collector5} = "$f $l";
        if ($clist =~ /$c5/) {
            $bad_msg .= "<li>Collector 5: already picked that name\n";
        } else {
            $clist .= ", $input{Collector5}";
        }
    }
    if ($c6) {
	$input{last_first_coll6} = $c6;
        ($l,$f) = split(/\, /,$c6);
        $input{Collector6} = "$f $l";
        if ($clist =~ /$c6/) {
            $bad_msg .= "<li>Collector 6: already picked that name\n";
        } else {
            $clist .= ", $input{Collector6}";
        }
    }
    if ($c7) {
	$input{last_first_coll7} = $c7;
        ($l,$f) = split(/\, /,$c7);
        $input{Collector7} = "$f $l";
        if ($clist =~ /$c7/) {
            $bad_msg .= "<li>Collector 7: already picked that name\n";
        } else {
            $clist .= ", $input{Collector7}";
        }
    }
    if ($c8) {
	$input{last_first_coll8} = $c8;
        ($l,$f) = split(/\, /,$c8);
        $input{Collector8} = "$f $l";
        if ($clist =~ /$c8/) {
            $bad_msg .= "<li>Collector 8: already picked that name\n";
        } else {
            $clist .= ", $input{Collector8}";
        }
    }
    $input{Collector_List} = $clist;



}



sub check_collector {    # returns collector name if match
    local($Collector) = @_;
    
    local($lastname,$fullname,$shortname) = &make_collector_names($Collector);
    local($query) = "select * from biocode_people where name_full=\"$fullname\"";
    # $bad_msg .= "Query: $query\n";
    @row = &get_one_record($query,"biocode");
    local($seq_num) = $row[0];
    local($name_full) = $row[1];
    local($name_last) = $row[2];
    local($shortname) = $row[4];
    if (!$seq_num) {
	return (0,$fullname,$lastname,$shortname);  # return cleaned-up name from make_collector_names
    } else {
	return ($seq_num,$name_full,$name_last,$shortname);  # return DB stuff
    }
}

sub make_collector_names {  # returns $lastname,$fullname,$shortname
    local($name) = @_;
    
    local($lastname) = "";
    local($fullname) = "";
    local($shortname) = "";
    local($firstname) = "";    
    local($lastname2) = "";
    local($firstname2) = "";
    local($lastname3) = "";
    local($firstname3) = "";
    local($rest) = "";
    
    $name =~ s/\./\. /g;  # R.VandenBosch -> R. VandenBosch
    $name =~ s/\,/\, /g;  # Lieberman,F. V. -> Lieberman, F. V.
    $name = &strip($name);
    

    # special cases
    if ($name eq "Lagace Family") {
	$lastname = "Lagace Family";
	$fullname = "Lagace Family";
    }
    elsif ($name eq "British Museum") {
	$lastname = "British Museum";
	$fullname = "British Museum";
    }
    elsif ($name =~ /Hille Ris Lambers/) {
        $lastname = "Hille Ris Lambers";
        $fullname = "D. Hille Ris Lambers";
    }
    elsif ($name =~ /Chen Govt/) {
	$lastname = "Chen";
	$fullname = "Chen Govt.";
    }
    elsif (uc($name) eq "SENT BY MAIL") {
        $lastname = "Sent";
        $fullname = "Sent by Mail";
    }
    # Schouteden, H.;(J. Ghesquiere)
    elsif ($name eq "Schouteden, H. ;(J. Ghesquiere)") {
	$fullname = "H. Schouteden [J. Ghesquiere]";
	$lastname = "Schouteden";
    }
    elsif ($name =~ /State Dept\. of Agriculture/) {
        $lastname = "State";
        $fullname = "State Dept. of Agriculture";
    }
    elsif ($name eq "Ent 133 class") {
        $lastname = "Ent";
        $fullname = "Ent 133 Class";
    }
    elsif ($name eq "U. C. 49 Class") {
        $lastname = "U.C.";
        $fullname = "U. C. 49 Class";
    }

    elsif ($name eq "van der Meer Mohr") {
	$lastname = "van der Meer Mohr";
	$fullname = "van der Meer Mohr";
    }
     # "A. P."
    elsif ($name =~ /^(\w\.) *(\w\.)$/) {  
	$lastname = $2;
	$fullname = "$1 $2";
    }
    # "V. F. E."
    elsif ($name =~ /^(\w\.) (\w\.) (\w\.)$/) {
        $lastname = $3;
        $fullname = "$1 $2 $3";
    }
    # "H. L. G. S."
    elsif ($name =~ /^(\w\.) (\w\.) (\w\.) (\w\.)$/) {
        $lastname = $4;
        $fullname = "$1 $2 $3 $4";
    }
    # "YM"
    elsif ($name =~ /^(\w)(\w)$/) {   
        $lastname =  "$2" . ".";
        $firstname = "$1" . ".";
        $fullname = "$firstname $lastname";
    }
    # "VFE"
    elsif ($name =~ /^(\w)(\w)(\w)$/) {  
	$lastname = $3 . ".";
	$firstname = "$1" . ".";
	$rest = "$2" . ".";;
	$fullname = "$firstname $rest $lastname";
    }
    # "Knowlton"
    elsif ($name =~ /^\w+$/) {    
	$lastname = $name;
	$fullname = $name;
    }
    # Buckingham-Tessro
    elsif ($name =~ /^\w+\-\w+$/) {
        $lastname = $name;
        $fullname = $name;
    }
    # Gertsch, W. J. , Goodnight, C. , Cazier, M. A.
    elsif ($name =~ /^(\w+)\, *(\w.*)\, *(\w+)\, (\w.*)\, (\w+)\, (\w.*)$/) {   
        $firstname = &strip($2);
        $lastname = &strip($1);
        $firstname2 = &strip($4);
        $lastname2 = &strip($3);
	$firstname3 = &strip($6);
        $lastname3 = &strip($5);
        $fullname = "$firstname $lastname & $firstname2 $lastname2 & $firstname3 $lastname3";
    }
    # Christenson, L. D. ;& Jensen, D. D.
    elsif ($name =~ /^(\w+)\, (\w.*) *\;\& *(\w+)\, (\w.*)$/) {   
        $firstname = &strip($2);
        $lastname = &strip($1);
        $firstname2 = &strip($4);
        $lastname2 = &strip($3);
        $fullname = "$firstname $lastname & $firstname2 $lastname2";
    }
    # "Ryckman, R.E. &;K. Arakawa"
    elsif ($name =~ /^(\w+)\, (\w.*) *\& *\; *(\w.*) (\w+)$/) {   
        $firstname = &strip($2);
        $lastname = &strip($1);
        $firstname2 = &strip($3);
        $lastname2 = &strip($4);
        $fullname = "$firstname $lastname & $firstname2 $lastname2";
    }
    # Lieberman, F. V. , Knowlton, G. F. 
    elsif ($name =~ /^(\w+)\, (\w.*) *\, *(\w+)\, *(\w.*)$/) {   
        $lastname = &strip($1);
        $firstname = &strip($2);
	$lastname2 = &strip($3);
	$firstname2 = &strip($4);
        $fullname = "$firstname $lastname & $firstname2 $lastname2";
    }
    # HRL[HilleRisLambers]
    elsif ($name =~ /^(\w+) *\[(\w.*)\]$/) {    
	$shortname = &strip($1);
	$lastname = &strip($2);
	$fullname = $lastname;
    }
    # Bohart, R. M. ;Baker, K. F.
    elsif ($name =~ /^(\w+)\, (\w.*)\;(\w+)\, (\w.*)$/) {   
        $firstname = &strip($2);
        $lastname = &strip($1);
        $firstname2 = &strip($4);
        $lastname2 = &strip($3);
        $fullname = "$firstname $lastname & $firstname2 $lastname2";
    }
    # "Schlinger, E. &Hall, J."
    elsif ($name =~ /^(\w\w.*)\, (\w.*)\& *(\w\w.*)\, (\w.*)$/) {   
	$firstname = &strip($2);
	$lastname = &strip($1);
	$firstname2 = &strip($4);
	$lastname2 = &strip($3);
	$fullname = "$firstname $lastname & $firstname2 $lastname2";
    } 
    # "Schlinger,E.&R.VandenBosch"
    elsif ($name =~ /^(\w\w.*)\, (\w.*)\&(.*)$/) { 
        $firstname = &strip($2);
        $lastname = &strip($1);
	$rest = &strip($3);
        $fullname = "$firstname $lastname & $rest";
    }
    #  "J. S. & K. G."
    elsif ($name =~ /^(\w\.) *(\w\.) *\& *(\w\. \w\.)$/) { 	
	$firstname = &strip($1);
	$lastname = &strip($2);
	$firstname2 = &strip($3);
        $lastname2 = &strip($4);
	$fullname = "$firstname $lastname & $firstname2 $lastname2";
    }
    #  "Ryckman&Ames" 
    elsif ($name =~ /^(\w+) *\& *(\w+)$/) {   
        $lastname = &strip($1);
        $lastname2 = &strip($2);
        $fullname = "$lastname & $lastname2";
    }
    # Knowlton, G. F. , B. K. Callman
    elsif ($name =~ /^(\w+)\, (\w.*)\, (\w.*)$/) {   
	$lastname = &strip($1);
	$firstname = &strip($2);
	$rest = &strip($3);
	$fullname = "$firstname $lastname & $rest";
    }
    # "La Rivers, Ira
    elsif ($name =~ /^(\w+ \w+)\, (\w.*)$/) {
        $lastname = &strip($1);
        $firstname = &strip($2);
        $fullname = "$firstname $lastname";
    }
    # "Dreisbach, R.R."
    elsif ($name =~ /^(\w.*)\, (\w.*)$/) {  
	$lastname = &strip($1);
	$firstname = &strip($2);
	$fullname = "$firstname $lastname";
    
    } 
    # "Gordon Nishida"
    elsif ($name =~ /^(\w+) (\w+)$/) {
        $firstname = &strip($1);
        $lastname = &strip($2);
        $fullname = "$firstname $lastname";
    }

    elsif ($name =~ /\?/) {  # question mark in the name
	$fullname = &strip($name);
	$lastname = $fullname;
	# just ignore it
    }
    else {
	## error?
	$bad_msg .= "Error from make_collector_names: unknown name format: \"$name\"\n";
	$lastname = "$name";
	$fullname = $name;
    }
    return ($lastname,$fullname,$shortname);
}


sub print_verbatim_labels {
    
    print "<tr>\n";
    print "<td align=right>$help_win_link=VerbatimCollectingLabel')\">";
    print "Verbatim<br>Collecting<br>Label</a></td>\n";
    print "<td align=left>";
    print "<textarea wrap=hard name=VerbatimCollectingLabel ";
    print "cols=30 rows=4";
    if ($VerbatimCollectingLabel) { print " class=yellbg"; }
    print ">$VerbatimCollectingLabel</textarea></td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=VerbatimIDLabel')\">";
    print "Verbatim<br>ID Label</a></td>\n";
    print "<td align=left>";
    print "<textarea wrap=hard name=VerbatimIDLabel ";
    print "cols=30 rows=4";
    if ($VerbatimIDLabel) { print " class=yellbg"; }
    print ">$VerbatimIDLabel</textarea></td>\n";
    print "</tr>\n";
}


# used by /cgi/biocode_add_collect_event

sub print_locations {

    print "<tr>\n";
    print "<td align=right>$help_win_link=Continent')\">Continent";
    print "</a></td>\n";
    print "<td align=left>";
    print "<select size=1 name=ContinentOcean";
    if ($ContinentOcean) { print " class=yellbg"; }
    print ">";
    &print_ContinentOcean_options($ContinentOcean);
    print "</select>\n";
    print "</td>\n";
    print "</tr>\n";

    # Island Group
    print "<tr>\n";
    print "<td align=right>$help_win_link=IslandGroup')\">Island Grp";
    print "</td>\n";
    print "<td align=left>";
    print "<input size=20 name=IslandGroup value=\"$IslandGroup\"";
    if ($IslandGroup) { print " class=yellbg"; }
    print "></td>\n";
    print "</tr>\n";

    # Island
    print "<tr>\n";
    print "<td align=right>$help_win_link=Island')\">Island";
    print "</a></td>\n";
    print "<td align=left>";

    print "<input size=20 name=Island value=\"$Island\"";
    if ($Island) { print " class=yellbg"; }
    print ">\n";
    print "</td>\n";
    print "</tr>\n";

    # Country
    print "<tr>\n";
    print "<td align=right>$help_win_link=Country')\">Country";
    print "</a></td>\n";
    print "<td align=left>";
    print "<select size=1 name=Country";
    if ($Country) { print " class=yellbg"; }
    print ">";
    &print_country_options_all($Country);
    print "</select>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=US_State')\">US State";
    print "</a></td>\n";
    print "<td align=left>";
    print "<select size=1 name=US_State";
    if ($US_State) { print " class=yellbg"; }
    print ">";
    if ($US_State) {
	&print_state_options_all("$US_State");
    } else {
	&print_state_options_all("new");
    }
    print "</select>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=other_stateprovince')\">Non-US State/Prov";
    print "</a></td>\n";
    print "<td align=left>";
    print "<input name=other_stateprovince value=\"$other_stateprovince\"";
    if ($other_stateprovince) { print " class=yellbg"; }
    print ">";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=County')\">County";
    print "</a></td>\n";
    print "<td align=left>";
    print "<input size=20 name=County value=\"$County\"";
    if ($County) { print " class=yellbg"; }
    print ">";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=Locality')\">Locality";
    print "</a></td>\n";
    print "<td align=left>";
    print "<textarea wrap=hard name=Locality cols=30 rows=2";
    if ($Locality) { print " class=yellbg"; }
    print ">$Locality</textarea>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right valign=center>$help_win_link=Habitat')\">Habitat";
    print "</a></td>\n";
    print "<td><textarea wrap=hard name=Habitat ";
    print "cols=30 rows=2";
    if ($Habitat) { print " class=yellbg"; }
    print ">$Habitat</textarea>\n";
    print "</td>\n";
    print "</tr>\n";


    print "<tr>\n";
    print "<td align=right valign=center>$help_win_link=MicroHabitat')\">MicroHabitat";
    print "</a></td>\n";
    print "<td><textarea wrap=hard name=MicroHabitat ";
    print "cols=30 rows=2";
    if ($MicroHabitat) { print " class=yellbg"; }
    print ">$MicroHabitat</textarea>\n";
    print "</td>\n";
    print "</tr>\n";




}


sub print_locations_no_edit {

    print "<tr>\n";
    print "<td align=right>$help_win_link=Continent')\">Continent</a>";
    print "<input type=hidden name=ContinentOcean value=\"$ContinentOcean\">";
    print "</td>\n";
    print "<td align=left";    
    if ($ContinentOcean) { 
	print " class=yellbg>"; 
	print $ContinentOcean;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    # Island Group
    print "<tr>\n";
    print "<td align=right>$help_win_link=IslandGroup')\">Island Grp</a>";
    print "<input type=hidden name=IslandGroup value=\"$IslandGroup\">";
    print "</td>\n";
    print "<td align=left";
    if ($IslandGroup) { 
	print " class=yellbg>"; 
	print $IslandGroup;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    # Island
    print "<tr>\n";
    print "<td align=right>$help_win_link=Island')\">Island</a>";
    print "<input type=hidden name=Island value=\"$Island\">";
    print "</td>\n";
    print "<td align=left";
    if ($Island) { 
	print " class=yellbg>"; 
	print $Island;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    # Country
    print "<tr>\n";
    print "<td align=right>$help_win_link=Country')\">Country</a>";
    print "<input type=hidden name=Country value=\"$Country\">";
    print "</td>\n";
    print "<td align=left";
    if ($Country) { 
	print " class=yellbg>"; 
	print $Country;
    } else {
	print ">";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=US_State')\">US State</a>";
    print "<input type=hidden name=US_State value=\"$US_State\">";
    print "</td>\n";
    print "<td align=left";
    if ($US_State) { 
	print " class=yellbg>"; 
	print $US_State;
    } else {
	print ">\n";
    }
    print "</select>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=other_stateprovince')\">Non-US State/Prov</a>";
    print "<input type=hidden name=other_stateprovince value=\"$other_stateprovince\">";
    print "</td>\n";
    print "<td align=left";
    if ($other_stateprovince) { 
	print " class=yellbg>"; 
	print $other_stateprovince;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=County')\">County</a>";
    print "<input type=hidden name=County value=\"$County\">";
    print "</td>\n";
    print "<td align=left";
    if ($County) { 
	print " class=yellbg"; 
	print $County;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=Locality')\">Locality</a>";
    print "<input type=hidden name=Locality value=\"$Locality\">";    
    print "</td>\n";
    print "<td align=left";
    if ($Locality) { 
	print " class=yellbg>"; 
	print $Locality;
    } else {
	print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right valign=center>$help_win_link=Habitat')\">Habitat</a>";
    print "<input type=hidden name=Habitat value=\"$Habitat\">";
    print "</td>\n";
    print "<td align=left";
    if ($Habitat) { 
	print " class=yellbg>"; 
	print $Habitat;
    } else {
        print ">\n";
    }
    print "</td>\n";
    print "</tr>\n";


    print "<tr>\n";
    print "<td align=right valign=center>$help_win_link=Associated_Taxon')\">Associated Taxon";
    print "</a></td>\n";
    print "<td><textarea wrap=hard name=Associated_Taxon ";
    print "cols=30 rows=2";
    if ($Associated_Taxon) { print " class=yellbg"; }
    print ">$Associated_Taxon</textarea>\n";
    print "</td>\n";
    print "</tr>\n";


}


sub print_eight_collector_options {  # used for biocode_add and biocode_coll_event_add

    print "<tr>\n";
    print "<td colspan=2><br>\n";
    print "$help_win_link=Collector')\">Collectors</a>";
    print "&nbsp;&nbsp;enter up to eight";
    print "</td>\n";
    print "</tr>\n";

    ## Collector 1
    print "<tr>\n";
    print "<td>1 &nbsp;</td>\n";
    print "<td align=left><select size=1 name=Collector";
    
    if ($last_first_coll1) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll1);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},1); # mybiocode_utils.p 1765
    print "</nobr></td></tr>\n";

    ## Collector 2
    print "<tr>\n";
    print "<td>2 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector2";
    if ($last_first_coll2) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll2);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},2); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 3
    print "<tr>\n";
    print "<td>3 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector3";
    if ($last_first_coll3) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll3);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},3); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 4
    print "<tr>\n";
    print "<td>4 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector4";
    if ($last_first_coll4) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll4);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},4); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 5
    print "<tr>\n";
    print "<td>5 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector5";
    if ($last_first_coll5) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll5);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},5); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 6
    print "<tr>\n";
    print "<td>6 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector6";
    if ($last_first_coll6) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll6);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},6); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 7
    print "<tr>\n";
    print "<td>7 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector7";
    if ($last_first_coll7) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll7);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},7); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 8
    print "<tr>\n";
    print "<td>8 &nbsp;</td>\n";
    print "<td><select size=1 name=Collector8";
    if ($last_first_coll8) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll8);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},8); # mybiocode_utils.p 1765
    print "</tr>\n";
}


sub print_eight_collector_options_no_edit {  # if Coll_EventID, can't edit specimen

    print "<tr>\n";
    print "<td colspan=2><br>\n";
    print "$help_win_link=Collector')\">Collectors</a>";
    print "</td>\n";
    print "</tr>\n";

    ## Collector 1
    print "<tr>\n";
    print "<td>1 &nbsp;</td>\n";
    print "<input type=hidden name=Collector value=\"$Collector\">";
    print "<td align=left ";
    if ($last_first_coll1) { 
	print " class=yellbg>"; 
	print "$Collector";
    } else {
	print ">";
    }

    ## Collector 2
    print "<tr>\n";
    print "<td>2 &nbsp;</td>\n";
    print "<input type=hidden name=Collector2 value=\"$Collector2\">";
    print "<td align=left ";
    if ($last_first_coll2) {
        print " class=yellbg>";
        print "$Collector2";
    } else {
        print ">";
    }

    ## Collector 3
    print "<tr>\n";
    print "<td>3 &nbsp;</td>\n";
    print "<input type=hidden name=Collector3 value=\"$Collector3\">";
    print "<td align=left ";
    if ($last_first_coll3) {
        print " class=yellbg>";
        print "$Collector3";
    } else {
        print ">";
    }

    ## Collector 4
    print "<tr>\n";
    print "<td>4 &nbsp;</td>\n";
    print "<input type=hidden name=Collector4 value=\"$Collector4\">";
    print "<td align=left ";
    if ($last_first_coll4) {
        print " class=yellbg>";
        print "$Collector4";
    } else {
        print ">";
    }

    ## Collector 5
    print "<tr>\n";
    print "<td>5 &nbsp;</td>\n";
    print "<input type=hidden name=Collector5 value=\"$Collector5\">";
    print "<td align=left ";
    if ($last_first_coll5) {
        print " class=yellbg>";
        print "$Collector5";
    } else {
        print ">";
    }

    ## Collector 6
    print "<tr>\n";
    print "<td>6 &nbsp;</td>\n";
    print "<input type=hidden name=Collector6 value=\"$Collector6\">";
    print "<td align=left ";
    if ($last_first_coll6) {
        print " class=yellbg>";
        print "$Collector6";
    } else {
        print ">";
    }

    ## Collector 7
    print "<tr>\n";
    print "<td>7 &nbsp;</td>\n";
    print "<input type=hidden name=Collector7 value=\"$Collector7\">";
    print "<td align=left ";
    if ($last_first_coll7) {
        print " class=yellbg>";
        print "$Collector7";
    } else {
        print ">";
    }


    ## Collector 8
    print "<tr>\n";
    print "<td>8 &nbsp;</td>\n";
    print "<input type=hidden name=Collector8 value=\"$Collector8\">";
    print "<td align=left ";
    if ($last_first_coll8) {
        print " class=yellbg>";
        print "$Collector8";
    } else {
        print ">";
    }

}

sub print_three_collector_options {  # biocode_add_specimens

    print "<tr>\n";
    print "<td colspan=2><br>\n";
    print "$help_win_link=Collector')\">Collectors</a>";
    print "&nbsp;&nbsp;enter up to three";
    print "</td>\n";
    print "</tr>\n";

    ## Collector 1
    print "<tr>\n";
    print "<td><br></td>\n";
    print "<td align=left><select size=1 name=Collector";
    
    if ($last_first_coll1) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll1);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},1); # mybiocode_utils.p 1765
    print "</nobr></td></tr>\n";

    ## Collector 2
    print "<tr>\n";
    print "<td><br></td>\n";
    print "<td><select size=1 name=Collector2";
    if ($last_first_coll2) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll2);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},2); # mybiocode_utils.p 1765
    print "</tr>\n";

    ## Collector 3
    print "<tr>\n";
    print "<td><br></td>\n";
    print "<td><select size=1 name=Collector3";
    if ($last_first_coll3) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($last_first_coll3);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},3); # mybiocode_utils.p 1765
    print "</tr>\n";
}

sub print_one_subsampler_option {  # used for biocode_add_tissue

#    if (!$person_subsampling) {
#        $person_subsampling = "unselected";
#    }


    ## Person_subsampling
    print "<tr>\n";
    print "<td align=right>\n";
    print "$help_win_link=person_subsampling')\">Person Subsampling</a>";
    print "</td>\n";

    print "<td align=left>";
    print "<select size=1 name=person_subsampling ";
    if ($person_subsampling) { print " class=yellbg"; }
    print "><nobr>";
    &print_subsampler_options($person_subsampling);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},1); # mybiocode_utils.p 1765
    print "</nobr></td></tr>\n";

}

sub print_one_extractor_option {  # used for biocode_add_extract


    ## Person_extracting
    print "<tr>\n";
    print "<td align=right>\n";
    print "$help_win_link=person_extracting')\">Person Extracting</a>";
    print "</td>\n";

    print "<td align=left>";
    print "<select size=1 name=person_extracting ";
    if ($person_extracting) { print " class=yellbg"; }
    print "><nobr>";
    &print_extractor_options($person_extracting);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},1); # mybiocode_utils.p 1765
    print "</nobr></td></tr>\n";

}


sub print_one_photographer_option {  # used for biocode_add_photo

    $photographer = &make_lastnamefirst($photographer);


    ## Photographer
    print "<tr>\n";
    print "<td align=right>\n";
    print "$help_win_link=photographer')\">Photographer</a>";
    print "</td>\n";

    print "<td align=left><select size=1 name=photographer";
    if ($photographer) { print " class=yellbg"; }
    print "><nobr>";
    &print_collector_options($photographer);
    print "</select>";
    &print_add_a_new_collector_button($input{entry_by},1); # mybiocode_utils.p 1765
    print "</nobr></td></tr>\n";

}


sub print_collection_date_options { # used for biocode_add and biocode_coll_event_add
    local($notime) = @_;  # optional for don;t print time

    print "<tr>\n";
    print "<td align=right>$help_win_link=CollectionDate')\">Coll Date";
    print "</a></td>\n";
    print "<td><nobr>\n";
    print "<input size=4 maxlength=4 name=YearCollected value=$YearCollected";
    if ($YearCollected) { print " class=yellbg"; }
    print ">yyyy\n";
    print "<input size=2 maxlength=2 name=MonthCollected value=$MonthCollected";
    if ($MonthCollected) { print " class=yellbg"; }
    print ">mm\n";
    print "<input size=2 maxlength=2 name=DayCollected value=$DayCollected";
    if ($DayCollected) { print " class=yellbg"; }
    print ">dd\n";
    print "</nobr></td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=CollectionDate')\">Coll Date 2";
    print "</a></td>\n";
    print "<td><nobr>\n";
    print "<input size=4 maxlength=4 name=YearCollected2 value=$YearCollected2";
    if ($YearCollected2) { print " class=yellbg"; }
    print ">yyyy\n";
    print "<input size=2 maxlength=2 name=MonthCollected2 value=$MonthCollected2";
    if ($MonthCollected2) { print " class=yellbg"; }
    print ">mm\n";
    print "<input size=2 maxlength=2 name=DayCollected2 value=$DayCollected2";
    if ($DayCollected2) { print " class=yellbg"; }
    print ">dd\n";
    print "</nobr></td>\n";
    print "</tr>\n";

    if ($notime) {
	# don't print it
    } else {
	print "<tr>\n";
	print "<td align=right colspan=2>$help_win_link=TimeofDay')\">Time of Day</a>\n";
	print "<input size=12 name=TimeofDay value=\"$TimeofDay\"";
	if ($TimeofDay) { print " class=yellbg"; }
	print ">\n";
	print "</td>\n";
	print "</tr>\n";

	print "<tr>\n";
	print "<td align=right colspan=2>$help_win_link=TimeofDay')\">Time of Day 2</a>\n";
	print "<input size=12 name=TimeofDay2 value=\"$TimeofDay2\"";
	if ($TimeofDay2) { print " class=yellbg"; }
	print ">\n";
	print "</td>\n";
	print "</tr>\n";
    }

}
sub print_collection_date_options_no_edit { # biocode_add_specimens - use dates from coll. event

    print "<tr>\n";
    print "<td align=right>$help_win_link=CollectionDate')\">Coll Date";
    print "</a>\n";
    print "<input type=hidden name=YearCollected value=$YearCollected>";
    print "<input type=hidden name=MonthCollected value=$MonthCollected>";
    print "<input type=hidden name=DayCollected value=$DayCollected>";    
    print "</td>\n";
    print "<td\n";
    if ($YearCollected || $MonthCollected || $DayCollected) { 
	$date2print = &make_pretty_date3($MonthCollected,$DayCollected,$YearCollected);
	print " class=yellbg>"; 
	print $date2print;
    } else {
        print ">";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>$help_win_link=CollectionDate')\">Coll Date 2";
    print "</a>\n";
    print "<input type=hidden name=YearCollected2 value=$YearCollected2>";
    print "<input type=hidden name=MonthCollected2 value=$MonthCollected2>";
    print "<input type=hidden name=DayCollected2 value=$DayCollected2>";
    print "</td>\n";
    print "<td\n";
    if ($YearCollected2 || $MonthCollected2 || $DayCollected2) {
        $date2print = &make_pretty_date3($MonthCollected2,$DayCollected2,$YearCollected2);
        print " class=yellbg>";
        print $date2print;
    } else {
        print ">";
    }
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=left>$help_win_link=TimeofDay')\">Time of Day 1</a>\n";
    print "<input type=hidden name=TimeofDay value=\"$TimeofDay\">";
    print "</td>\n";
    print "<td\n";
    if ($TimeofDay) { 
	print " class=yellbg>"; 
	print $TimeofDay;
    } else {
        print ">";
    }
    print "</td>\n";
    print "</tr>\n";


    print "<tr>\n";
    print "<td align=left>$help_win_link=TimeofDay2')\">Time of Day 2</a>\n";
    print "<input type=hidden name=TimeofDay2 value=\"$TimeofDay2\">";
    print "</td>\n";
    print "<td\n";
    if ($TimeofDay2) {
        print " class=yellbg>";
        print $TimeofDay2;
    } else {
        print ">";
    }
    print "</td>\n";
    print "</tr>\n";


}




sub print_collection_date_options_tissue { # used for biocode_add_tissue
     my($Coll_EventID) = @_;

#    if(!$year) {  # quick and dirty date pre-entry for Chris
#        ($year,$month,$day) = split(/\-/,$TODAY);
#    }


    ### this is for pre-filling the date field with the collecting event date
    if(!$year) {
        $q  = "select YearCollected, MonthCollected, DayCollected, YearCollected2, MonthCollected2, DayCollected2 ";
        $q .= "from biocode where Coll_EventID = $Coll_EventID";
        ($YearCollected, $MonthCollected, $DayCollected, $YearCollected2, $MonthCollected2, $DayCollected2) = &get_one_record($q,"biocode");

        if($YearCollected2) {
            $year = $YearCollected2;
        } elsif($YearCollected) {
            $year = $YearCollected;
        } else {
            $year = "";
        }
        if($MonthCollected2) {
            $month = $MonthCollected2;
        } elsif($MonthCollected) {
            $month = $MonthCollected;
        } else {
            $month = "";
        }
        if($DayCollected2) {
            $day = $DayCollected2;
        } elsif($DayCollected) {
            $day = $DayCollected;
        } else {
            $day = "";
        }
    }
    ### end pre-fill for collecting event date
    print "<tr>\n";
    print "<td align=right>$help_win_link=CollectionDate')\">Date Taken";
    print "</a>\n";
    print "</td>\n";
    print "<td align=left><nobr>\n";
    print "<input size=4 maxlength=4 name=year value=$year";
    if ($year) { print " class=yellbg"; }
    print ">yyyy\n";
    print "<input size=2 maxlength=2 name=month value=$month";
    if ($month) { print " class=yellbg"; }
    print ">mm\n";
    print "<input size=2 maxlength=2 name=day value=$day";
    if ($day) { print " class=yellbg"; }
    print ">dd\n";
    print "</nobr></td>\n";
    print "</tr>\n";


}

sub print_collectors_id { # no longer used 5/7/2008
    print "<tr>\n";
    print "<td align=left colspan=2>$help_win_link=Collectors_ID')\">Collector's Field Number</a></td>\n";
    print "<td><input size=12 name=Collectors_ID value=\"$Collectors_ID\"";
    if ($Collectors_ID) { print " class=yellbg"; }
    print ">\n";
    print "</td>\n";
    print "</tr>\n";
}

sub print_collector_options {
    local($selected_collector) = @_;  

    # $bad_msg .= "<li>***** selected_collector: $selected_collector\n";

    if (!$selected_collector) {
	$selected_collector = "unselected";
    }
    
    $collector_list = "$select_list_path/collectors.txt";
    if ($selected_collector eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$collector_list) || die "Can't open $collector_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_collector) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
}

sub print_subsampler_options {
    local($selected_subsampler) = @_;  

    # $bad_msg .= "<li>***** selected_subsampler: $selected_subsampler\n";

    if (!$selected_subsampler) {
	$selected_subsampler = "unselected";
    }
    
    $subsampler_list = "$select_list_path/collectors.txt";
    if ($selected_subsampler eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$subsampler_list) || die "Can't open $subsampler_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_subsampler) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);


}


sub print_extractor_options {
    local($selected_extractor) = @_;  


    if (!$selected_extractor) {
	$selected_extractor = "unselected";
    }
    
    $extractor_list = "$select_list_path/collectors.txt";
    if ($selected_extractor eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$extractor_list) || die "Can't open $extractor_list";

    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_extractor) {
		print "<option selected>$1\n";
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);


}


sub print_container_options {
    local($selected_container) = @_;  

    #$bad_msg .= "<li>***** \n";

    if (!$selected_container) {
	$selected_container = "unselected";
    }
    
    $container_list = "$select_list_path/container.txt";
    if ($selected_container eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$container_list) || die "Can't open $container_list";

    while ($line = <G>) {
        chomp($line);
	if ($line eq $selected_container) {               # jg - biocode - why doesn't this work????? .. now it works.. (chomp)
#	if ($line =~ /^$selected_container$/) {
	    print "<option selected>$line\n";
        } else {
	    print "<option>$line\n";
	}
    }
    close(G);
}

sub print_preservative_options {
    local($selected_preservative) = @_;  

    #$bad_msg .= "<li>***** \n";

    if (!$selected_preservative) {
	$selected_preservative = "unselected";
    }
    
    $preservative_list = "$select_list_path/preservative.txt";
    if ($selected_preservative eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$preservative_list) || die "Can't open $preservative_list";

    while ($line = <G>) {
        chomp($line);
	if ($line eq $selected_preservative) {
#	if ($line =~ /^$selected_preservative$/) {
	    print "<option selected>$line\n";
	} else {
	    print "<option>$line\n";
        }
    }
    close(G);
}

sub print_relaxant_options {
    local($selected_relaxant) = @_;  

    #$bad_msg .= "<li>***** \n";

    if (!$selected_relaxant) {
	$selected_relaxant = "unselected";
    }
    
    $relaxant_list = "$select_list_path/relaxant.txt";
    if ($selected_relaxant eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$relaxant_list) || die "Can't open $relaxant_list";

    while ($line = <G>) {
        chomp($line);
	if ($line eq $selected_relaxant) {
#	if ($line =~ /^$selected_relaxant$/) {
	    print "<option selected>$line\n";
	} else {
	    print "<option>$line\n";
        }
    }
    close(G);
}

sub is_a_valid_tissuetype {
    local($inc_tissuetype) = @_;

    $tissuetype_list = "$select_list_path/tissuetype.txt";
    open(G,$tissuetype_list) || die "Can't open $tissuetype_list";
    while ($line = <G>) {
	if ($line =~ /^$inc_tissuetype$/) {
	    return 1;
	}
    }
    return 0;
}

sub print_tissuetype_options {
    local($selected_tissuetype) = @_;  

    #$bad_msg .= "<li>***** \n";

    if (!$selected_tissuetype) {
	$selected_tissuetype = "unselected";
    }
    
    $tissuetype_list = "$select_list_path/tissuetype.txt";
    if ($selected_tissuetype eq "unselected") {
	print "<option selected>unselected\n";
    } else {
	print "<option>unselected\n";
    }

    open(G,$tissuetype_list) || die "Can't open $tissuetype_list";

    while ($line = <G>) {
#	if ($line eq $selected_tissuetype) {
	if ($line =~ /^$selected_tissuetype$/) {
	    print "<option selected>$line\n";
	} else {
	    print "<option>$line\n";
	}
    }
    close(G);
}


sub print_submitter_options {
    local($selected_person) = @_;  

    if (!$selected_person) {
	$selected_person = "none";
    } elsif ($selected_person eq "new") {
        print "<option selected>unselected\n";
	$matched = 1;
    }
    $people_list = "$select_list_path/submitters.txt";
    open(G,$people_list) || die "Can't open $people_list";

    $matched = 0;
    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_person) {
		print "<option selected>$1\n";
		$matched = 1;
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
    if (!$matched) {
	print "<option selected>unselected\n";
    }
}

sub print_people_options {
    local($selected_person) = @_;  

    if (!$selected_person) {
	$selected_person = "none";
    } elsif ($selected_person eq "new") {
        print "<option selected>unselected\n";
	$matched = 1;
    }

    $people_list = "$select_list_path/people.txt";
    open(G,$people_list) || die "Can't open $people_list";

    $matched = 0;
    while ($line = <G>) {
	if ($line =~ /\<option.*\>(.+)$/) {
	    if ($1 eq $selected_person) {
		print "<option selected>$1\n";
		$matched = 1;
	    } else {
		print "<option>$1\n";
	    }
	}
    }
    close(G);
    if (!$matched) {
	print "<option selected>unselected\n";
    }
}

sub print_biocode_kingdom_options {
    local($selected_kingdom) = @_;

    if (!$selected_kingdom) {
        $selected_kingdom = "unselected";
    }
    push(@biocode_kingdoms,"unselected");   # utils.p
    foreach $s (@biocode_kingdoms) {
        if ($s eq $selected_kingdom) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}


sub print_phylum_options {
    local($selected_phylum) = @_;
# HERE -- not getting the phylum

    if (!$selected_phylum) {
        $selected_phylum = "unselected";
    }
    push(@biocode_phylums,"unselected");   # utils.p
    foreach $s (@biocode_phylums) {
        if ($s eq $selected_phylum) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}


sub print_class_options {
    local($selected_class) = @_;

    if (!$selected_class) {
        $selected_class = "unselected";
    }
    push(@arthropod_classes,"unselected");   # utils.p
    foreach $s (@arthropod_classes) {
        if ($s eq $selected_class) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}

sub print_institution_options {
    local($selected_inst) = @_;

    if (!$selected_inst) {
        $selected_inst = "MBIO";
    }
    # push(@project_codes,"unselected");  
#    foreach $s (@project_codes) {
    foreach $s (@ProjectCodes) {
#        if ($s eq $selected_inst) {
        if ($s =~ /^$selected_inst$/i) {  # JG changed to this -- otherwise no match
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}


sub print_TaxTeam_options {
    my ($selected_taxteam) = @_;

    if (!$selected_taxteam) {
        $selected_taxteam = "unselected";
        unshift(@TaxTeams,"unselected");
    }
    foreach my $s (@TaxTeams) {
        if ($s =~ /^$selected_taxteam$/i) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}






    
sub is_a_valid_HoldingInstitution {  # used by biocode_excel_datacheck
    my ($inc_holding_inst) = @_;
    
    foreach my $s (@institutions) {
        if ($s eq $inc_holding_inst) {
            return 1;
        } 
    }
    return 0;
}

sub is_a_valid_TaxTeam {  # used by biocode_excel_datacheck
    my ($inc_taxteam) = @_;
    
    foreach my $s (@TaxTeams) {
        if ($s eq $inc_taxteam) {
            return 1;
        } 
    }
    return 0;
}

sub print_holding_institution_options {
    local($selected_holding_inst) = @_;

    if (!$selected_holding_inst) {
        $selected_holding_inst = "unselected";
        push(@institutions,"unselected");
    }
    push(@institutions,"unselected");  
    foreach $s (@institutions) {
        if ($s eq $selected_holding_inst) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}

sub is_a_valid_Phylum {  # used by biocode_excel_datacheck
    my ($inc_phylum) = @_;
    
    foreach my $s (@Phyla) {
        if ($s eq $inc_phylum) {
            return 1;
        } 
    }
    return 0;
}


sub is_a_valid_ProjectCode {  
    my ($inc_ProjectCode) = @_;
    
    foreach my $s (@ProjectCodes) {
        if ($s eq $inc_ProjectCode) {
            return 1;
        } 
    }
    return 0;
}


sub print_order_options {
    local($selected_order) = @_;

    if (!$selected_order) {
        $selected_order = "unselected";
    }
    push(@arthropod_orders,"unselected");   # utils.p
    foreach $s (@arthropod_orders) {
        if ($s eq $selected_order) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}



sub print_prep_types_options {
    local($selected_prep_types) = @_;  

    if (!$selected_prep_types) {
	$selected_prep_types = "unselected";
    }
    push(@PreparationTypes,"unselected");
    foreach $s (@PreparationTypes) {
	if ($s eq $selected_prep_types) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}

sub print_sex_options {
    local($selected_sex) = @_;  

    if (!$selected_sex) {
	$selected_sex = "unselected";
    }
    push(@Sexes,"unselected");
    foreach $s (@Sexes) {
	if ($s eq $selected_sex) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}

sub print_stage_options {
    local($selected_stage) = @_;  

    if (!$selected_stage) {
	$selected_stage = "unselected";
    }
    push(@Stages,"unselected");
    foreach $s (@Stages) {
	if ($s eq $selected_stage) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}


# HERE
sub print_taxon_certainty_options {
    my ($selected_taxon_certainty) = @_;  

    if (!$selected_taxon_certainty) {
	$selected_taxon_certainty = "unselected";
    }
    push(@Taxon_Certainty,"unselected");
    foreach $s (@Taxon_Certainty) {
	if ($s eq $selected_taxon_certainty) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}

sub print_type_status_options {
    local($selected_type_status) = @_;  

    if (!$selected_type_status) {
	$selected_type_status = "unselected";
    }
    push(@TypeStatus,"unselected");
    foreach $s (@TypeStatus) {
	if ($s eq $selected_type_status) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}

sub print_Fiji_provinces {
    local($selected_prov) = @_;

    if (!$selected_prov) {
        $selected_prov = "unselected";
    }
    
    push(@fiji_provinces,"unselected");

    foreach $s (@fiji_provinces) {
        if ($s eq $selected_prov) {
            print "<option selected>$s\n";
        } else {
            print "<option>$s\n";
        }
    }
}

sub print_FijiIslands_options {
    local($selected_island) = @_;

    if (!$selected_island) {
        $selected_island = "unselected";
	print "<option selected>unselected\n";
    }
    
    $fiji_island_list = "$select_list_path/fiji_islands.txt";
    open(G,$fiji_island_list) || die "Can't open $fiji_island_list";

    while ($line = <G>) {
	chomp($line);
	if ($line eq $selected_island) {
	    print "<option selected>$line\n";
	} else {
	    print "<option>$line";
	}
    }
    close(G);
}

# -----------------
# Other Utilities
# --------------------


sub make_ScientificName {
    local($sciname) = &strip("$input{Genus} $input{SpecificEpithet} $input{SubspecificEpithet}");
    return $sciname;
}

sub get_CollectorNumber {
    local($name) = @_;

    local($query) = "select seq_num from biocode_people where name_full=\"$name\"";
    @row = &get_one_record($query,"biocode");
    local($num) = $row[0];
    return $num;
}


sub load_biocode_record {

    ## incoming:
    ##    load_record = a pipe-delimited load file
    ##    table = biocode, biocode_accessions, biocode_people

    my ($load_record,$table,$database) = @_;
    if(!$database) {
        $database = "biocode";
    }

    ## Make tmp files

    $tmpfile = rand(1000000);
    $tmpfile = sprintf("%d",$tmpfile);
    while(-e $tmpfile) {
        $tmpfile = rand(1000000);
        $tmpfile = sprintf("%d",$tmpfile);
    }
    $tmpfile2 = $tmpfile."_2";

    $loadfile = "$tmp_file_location/biocode_query/$tmpfile";
    $loadfile2 = "$tmp_file_location/biocode_query/$tmpfile2";

    chdir("$tmp_file_location/biocode_query") || die "Can't change to tmp/biocode_query directory";

    open(FH, ">$tmpfile") || die "Can't open temporary file ";
    print FH "$load_record\n";
    close(FH);

    $load = "load data local infile '$loadfile' into table $table fields terminated by '|';";


    open(FH, ">$loadfile2");
    print FH "$load\n";
    close(FH);


    `/bin/cat $loadfile2 | /usr/local/mysql/bin/mysql --password=$g_db_fullpass --user=$g_db_fulluser --host=$g_db_location $database`;

    # copy to Weekly

    chdir("$tmp_file_location/Weekly") || die "Can't change to tmp/Weekly directory";

    $tmpfile3 = rand(1000000);
    $tmpfile3 = sprintf("%d",$tmpfile3);
    while(-e $tmpfile3) {
        $tmpfile3 = rand(1000000);
        $tmpfile3 = sprintf("%d",$tmpfile3);
    }

    $weeklycopy = "$tmp_file_location/Weekly/$tmpfile3";

    `/bin/cp $loadfile $weeklycopy`;  # also copy to Weekly in case we need it...

}

sub load_biocode_tissue_record {

    ## incoming:
    ##    load_record = a pipe-delimited load file
    ##    table = biocode, biocode_accessions, biocode_people, biocode_tissue

    my ($load_record,$table) = @_;

    ## Make tmp files

    $tmpfile = rand(1000000);
    $tmpfile = sprintf("%d",$tmpfile);
    while(-e $tmpfile) {
        $tmpfile = rand(1000000);
        $tmpfile = sprintf("%d",$tmpfile);
    }
    $tmpfile2 = $tmpfile."_2";

    $loadfile = "$tmp_file_location/biocode_query/$tmpfile";
    $loadfile2 = "$tmp_file_location/biocode_query/$tmpfile2";

    chdir("$tmp_file_location/biocode_query") || die "Can't change to tmp/biocode_query directory";

    open(FH, ">$tmpfile") || die "Can't open temporary file ";
    print FH "$load_record\n";
    close(FH);

    $load = "load data infile '$loadfile' into table $table fields terminated by '|';";


    open(FH, ">$loadfile2");
    print FH "$load\n";
    close(FH);

    #`/bin/cat $loadfile2 | /usr/local/mysql/bin/mysql --password=$g_db_pass --user=$g_db_user biocode`;
    `/bin/cat $loadfile2 | /usr/local/mysql/bin/mysql --password=$g_db_fullpass --user=$g_db_fulluser --host=$g_db_location $database`;


    # copy to Weekly

    chdir("$tmp_file_location/Weekly") || die "Can't change to tmp/Weekly directory";

    $tmpfile3 = rand(1000000);
    $tmpfile3 = sprintf("%d",$tmpfile3);
    while(-e $tmpfile3) {
        $tmpfile3 = rand(1000000);
        $tmpfile3 = sprintf("%d",$tmpfile3);
    }

    $weeklycopy = "$tmp_file_location/Weekly/$tmpfile3";

    `/bin/cp $loadfile $weeklycopy`;  # also copy to Weekly in case we need it...

}

sub print_biocode_err_and_exit {
    ## assumes there is a bad_msg

    &print_biocode_header($heading);
    print "<h3>Sorry, there's an error</h3><font color=red><b>\n";
    if ($bad_msg) {
	print "<p>$bad_msg<p>\n";
    } else {
	print "<p>Unspecified error!<p>\n";
    }
    print "</b></font>\n";
    if ($DEBUG) {
	print $debug_msg;
    }
    &print_biocode_footer;
    exit;
}

## see instead print_add_a_new_collector_button 
sub print_add_a_new_collector_link {  
    # makes a link to a pop-up "add a new collector"

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_people_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>add a new collector</i>]</a>";        

}

sub print_add_a_new_container_button {  
    # makes a link to a pop-up "add a new container"

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_container_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}

sub print_add_a_new_preservative_button {  
    # makes a link to a pop-up "add a new preservative"

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_preservative_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}

sub print_add_a_new_tissuetype_button {  
    # makes a link to a pop-up "add a new tissue type"

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_tissuetype_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}

sub print_add_a_new_relaxant_button {  
    # makes a link to a pop-up "add a new relaxant type"

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_relaxant_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}

sub print_add_a_new_fixative_button {  
    # makes a link to a pop-up "add a new fixative" (= preservative)

    local($entry_by) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_fixative_add_update?special=pop&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}


sub print_add_a_new_collector_button {  
    # makes a link to a pop-up "add a new collector"

    local($entry_by,$collectornum) = @_;
    $entry_by_url =  $entry_by;
    $entry_by_url =~ s/ /\+/g;
    
    print "<a href=\"javascript:Open_Window('/cgi/biocode_people_add_update?special=pop&whichcol=$collectornum&action=new&step=form&entry_by=$entry_by_url')\">";
    print "[<i>new</i>]</a>";        

}


# Makes assumption that Institution is distinct across whole database
# this is probably only safe for biocode in finding catalognumbers
sub get_max_catalognumber_fast {
    local($table) = @_;
    local($seq) = "";

    $query  = "select max(CatalogNumberNumeric) from $table";
    @row = &get_one_record($query,"biocode");
    $seq = $row[0] +1;
    return $seq;
}

sub get_max_catalognumber {

    local($table,$inst_code) = @_;
    local($seq) = "";

    $query  = "select max(CatalogNumberNumeric) from $table where ProjectCode='$inst_code' ";
#    $query  .= "and CatalogNumberNumeric < $IGNORE_CATNUMS";
    @row = &get_one_record($query,"biocode");
    $seq = $row[0] +1;
    return $seq;
}

sub get_max_Eventid {

    local($table) = @_;
    local($seq) = "";

    $query  = "select max(EventID) from $table";

    @row = &get_one_record($query,"biocode");
    $seq = $row[0] +1;
    return $seq;
}

sub check_if_catalognumber_exists {

    ## we assume that we are getting an integer

    local($inst_code,$catnum) = @_;

    local($CatNumExists) = &get_count("biocode","ProjectCode='$inst_code' and CatalogNumberNumeric=$catnum");
    return $CatNumExists;
}


sub check_if_EventID_exists {

    ## we assume that we are getting an integer

    local($eventid) = @_;

    local($EventIDExists) = &get_count("biocode_collecting_event","EventID=$eventid");
    return $EventIDExists;
}

sub format_author_year {
    my ($author,$year) = @_;

    my $author_year = "";

    if($author =~ /\(/) {
        $parens = 1;
        $author =~ s/\(//g;
        $author =~ s/\)//g;
    } else {
        $parens = 0;
    }

    if($parens) {
        if($author && $year) {
            $author_year = "($author, $year)";
        } else {
            $author_year = "($author)";
        }
    } else {
        if($author && $year) {
            $author_year = "$author, $year";
        } elsif($year) {
            $author_year = "$year";
        } elsif($author) {
            $author_year = "$author";
        } else {
            $author_year = "";
        }
    }

    return $author_year;
}

# this does the reverse of the previous function
#  
sub format_author_year_for_biocode_species {
    my ($authoryear) = @_;
    my $author = "";
    my $year = "";

    if($authoryear =~ /\(/) {
	$parens = 1;
	$authoryear =~ s/\(//g;
	$authoryear =~ s/\)//g;
    }
    ($author,$year) = split(/\,/,$authoryear);
    $author = &strip($author);
    $year  = &strip($year);
    if ($parens) {
	$author = "($author)";
    }
    return($author,$year);
}


sub check_for_specimen_record {
    my ($bnhm_id) = @_;
    $query = "select count(*) from biocode where bnhm_id = \"$bnhm_id\"";
    ($count) = &get_one_record($query,"biocode");
    if($count) {
        return 1;
    } else {
        return 0;
    }
}


sub check_for_collecting_event_record {
    my ($EventID) = @_;
    $query = "select count(*) from biocode_collecting_event where EventID = \"$EventID\"";
    ($count) = &get_one_record($query,"biocode");
    if($count) {
        return 1;
    } else {
        return 0;
    }
}



sub print_length_unit_options {
    local($selected_length_unit) = @_;  

    if (!$selected_length_unit) {
	$selected_length_unit = "mm";
    }
    foreach $s (@LengthUnits) {
	if ($s eq $selected_length_unit) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}


sub print_weight_unit_options {
    local($selected_weight_unit) = @_;  

    if (!$selected_weight_unit) {
	$selected_weight_unit = "g";
    }
    foreach $s (@WeightUnits) {
	if ($s eq $selected_weight_unit) {
	    print "<option selected>$s\n";
	} else {
	    print "<option>$s\n";
	}
    }
}

sub print_one_biocode_species_pic {
    ($taxon) = @_;
    my $pic_count = 0;
    my $query;
	my $tmp;
	my $disknum;
	my $imgnum;
	my $photographer;
	my $copyright;
	my $a;
	my $b;
	my $mmyy;
	my $picfile;
	my $picurl;
	my $piclink;

    $taxon = &strip($taxon);

    # is there a photo for this specimen?
    $query = "select disknum, imgnum, photographer, copyright from img where taxon = '$taxon' and museum = 'Moorea Biocode'";
    $tmp = &get_multiple_records($query,"image");
    if(-s "$tmp_dir/$tmp") {
        open(FH, "$tmp_dir/$tmp") || die "Can't open photo tmp file $tmp ";
        while ($pic = <FH>) {
            ($disknum, $imgnum, $photographer, $copyright) = split(/\t/,$pic);
            ($a, $b, $mmyy) = split(/\s/,$disknum);
            $pic_count++;
            $copyright = "$photographer &copy $copyright";

            $picfile = "$calphotos_img_dir/$mmyy/$imgnum".".jpeg";
            $picurl = "$calphoto_thumb_path/$mmyy/$imgnum".".jpeg";

            if (-e $picfile) {
                $piclink= "<img src=\"$picurl\" border=0>";
            }
        }
    }

    if($piclink) {
       $taxon_url = $taxon;
       $taxon_url =~ s/ /+/g;
       print "<a href=http://calphotos.berkeley.edu/cgi/img_query?where-taxon=$taxon_url&where-museum=Moorea+Biocode>";
       print "$piclink</a><br>";

       if($pic_count == 1) {
           $copyright =~ s/\s/&nbsp;/g;
           print "<small>";
           print "$copyright<br>";
           print "<center>(1 of ";
           print "<a href=http://calphotos.berkeley.edu/cgi/img_query?where-taxon=$taxon_url&where-museum=Moorea+Biocode>";
           print "$pic_count photo</a>)\n";
           print "</small>";
       } else {
           $copyright =~ s/\s/&nbsp;/g;
           print "<small>";
           print "$copyright<br>";
           print "<center>(1 of ";
           print "<a href=http://calphotos.berkeley.edu/cgi/img_query?where-taxon=$taxon_url&where-museum=Moorea+Biocode>";
           print "$pic_count photos</a>)\n";
           print "</small>";
       }
    }
}

sub print_biocode_photo_type_options {   ## <option>Plant--fern
    local($selected_photo_type) = @_;

    @biocode_photo_types = ('Animal--Amphibian', 'Animal--Bird', 'Animal--Fish', 'Animal--Insect', 'Animal--Invertebrate',
        'Animal--Mammal', 'Animal--Reptile', 'Bacteria--bacteria',
        'Fungi--fungi', 'Fungi--lichen', 'Fungi--mold', 'Landscape--fieldsite',
        'Landscape--habitat', 'People--photographer', 'Plant--annual/perennial', 'Plant--fern', 'Plant--mosses/etc', 'Plant--shrub',
        'Plant--tree', 'Plant--tree/shrub', 'Plant--vine', 'Protista--algae', 'Protista--amoeba', 'Protista--slimemold');


    if ($selected_photo_type eq "") {
        print "\n<option selected>unselected\n";
    } elsif ($selected_photo_type eq "newphoto") {
        print "\n<option selected>unselected\n";
    }
    foreach $pt (@biocode_photo_types) {
        if ($selected_photo_type eq $pt) {
            print "<option selected>$pt\n";
        } else {
            print "<option>$pt\n";
        }
    }
}

#sub check_selectlist_for_name {  # biocode_upload
#    local($subdir,$list,$incname) = @_;  # subdir="biocode", list="people.txt"
#
#    $fname = $select_list_path . "/$list";
#    open(SEL, "$fname") || die "Can't open $fname ";
#    while(<SEL>) {
#        $line = $_;
#        $line =~ s/<option>//g;
#        $line = &strip($line);
#        #$bad_msg .= "<li>|$line|";
#        if ($line eq $incname) {
#            return(1);
#        }
#    }
#    return(0);
#    close(SEL);
#}



sub check_well_and_plate_name_formats {

    my($well_name, $plate_name, $its_an_update) = @_;
    my $letter = "";
    my $number = "";
    my $count = "";
    my $select = "";
    my $msg = "";

    #print "Content-type: text/html\n\n";
    #print "well_name: $well_name<p>";
    #print "plate_name: $plate_name<p>";
    #print "its_an_update: $its_an_update<p>";

    if($well_name) {
        # print "well_number96: $well_name<p>";
        if($well_name =~ /(^[A-Ha-h])(\d+)$/) {
            $letter = $1;
            $number = $2;
            if($number < 1 || $number > 12) {
                $msg .= "<li>Your well number $well_name is not in the correct format.\n";
            } elsif($number !~ /(^0)/ && $number < 10) {
                    $msg .= "<li>Your well number $field is not in the correct format on row $count (try adding a zero before numbers 1-9).\n";
            }
        } else {
            $msg .= "<li>Your well number $well_name is not in the correct format.\n";
        }
    }

    if($well_name && !$plate_name) {
        $msg .= "<li>A plate name is required with your well number ($well_name).\n";
    }
    if(!$well_name && $plate_name) {
        $msg .= "<li>A well number is required with your plate name ($plate_name).\n";
    }
    if($well_name && $plate_name) {
        $select = "select count(*) from biocode_tissue where well_number96 = '$well_name' and format_name96 = '$plate_name'";
        ($count) = &get_one_record("$select","biocode");
        if($its_an_update) {
            # it's an update, can be one record with plate/well number match already
            if($count > 1) {
            # if($count > 0) {    # should perhaps be combined with below lines, which are more or less the same...
                $msg .= "<li>[$count] (update) There is already a well number '$well_name' ";
                $msg .= "for plate '$plate_name' in the biocode_tissue table.\n";
            }
        } else {
            if($count > 0) {
                $msg .= "<li>[$count] (insert) There is already a well number '$well_name' ";
                $msg .= "for plate '$input{format_name96}' in the biocode_tissue table.\n";
            }
        }
    }

    #print "<p>message: $msg<p>";

    return $msg;

}


sub check_incoming_coll_eventid {
    my ($coll_eventid) = @_;
    my $select = "";
    my $count = 0;
    $select = "select count(*) from biocode_collecting_event where EventID = '$coll_eventid'";
    ($count) = &get_one_record($select,"biocode");

    return $count;
}





