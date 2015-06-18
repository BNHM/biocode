#!/usr/bin/perl
# createXML - John Deck, April 2010

push(@INC,"/usr/local/web/biocode/cgi/"); # so that biocode_settings can be found

# Called by Cron Job to create XML file for bioValidator
require "/usr/local/web/biocode/cgi/myquery_utils.p";
require "/usr/local/web/biocode/cgi/myschema.p";
require "/usr/local/web/biocode/cgi/utils.p";
require "/usr/local/web/biocode/cgi/cgi-lib.pl";
require "/usr/local/web/biocode/cgi/mybiocode_utils.p";
require "/usr/local/web/biocode/cgi/biocode_settings";

# globals 
$bad = "";
$xsd = "bioValidator-0.9.xsd";

$xsdfile = "/usr/local/web/biocode/web/$xsd";

$output = "<?xml version='1.0' encoding='UTF-8'?>\n";
$output .= "<Validate xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'\n";
$output .= "    xsi:noNamespaceSchemaLocation='$xsd'>\n\n";

$output .= "<Metadata>\n\n";

$output .= "<metadata name='displayFieldsSpreadsheet'>\n";
$output .= "<field>Specimen_Num_Collector</field>\n";
$output .= "<field>SpecificEpithet</field>\n";
$output .= "<field>LowestTaxonLevel</field>\n";
$output .= "<field>LowestTaxon</field>\n";
$output .= "</metadata>\n\n";

$output .= "<metadata name='displayFieldsDB'>\n";
$output .= "<field>specimen_num_collector</field>\n";
$output .= "<field>scientificname</field>\n";
$output .= "<field>lowesttaxonlevel</field>\n";
$output .= "<field>lowesttaxon</field>\n";
$output .= "</metadata>\n\n";

$output .= "<metadata name='list1' alias='projectCode'>\n";
$output .= getArrayAsFields(@ProjectCodes);
$output .= "</metadata>\n\n";

$output .= "<metadata name='loginNames'>\n";
$tmp = getSQLAsFields("select name_full from biocode_people where name_full != 'Danielle Pena & Maria Zizka' order by name_full");
if ($tmp eq "1") { $bad .= "\nFailed fetching SQL Fields for biocode_people"; } 
else { $output .= $tmp; }
$output .= "</metadata>\n\n";

$output .= "<metadata name='list2' alias='preservative'>\n";
$output .= getSQLAsFields("select preservative from biocode_preservative order by preservative");
$output .= "</metadata>\n\n";

$output .= "<metadata name='list3' alias='relaxant'>\n";
$output .= getSQLAsFields("select relaxant from biocode_relaxant order by relaxant");
$output .= "</metadata>\n\n";

$output .= "<metadata name='list4' alias='container'>\n";
$output .= getSQLAsFields("select container from biocode_container order by container"); 
$output .= "</metadata>\n\n";

$output .= "<metadata name='list5' alias='Country'>\n";
$output .= getSQLAsFields("select distinct(name) as country from country"); 
$output .= "</metadata>\n\n";

# no list6 in bioValidator yet
#$output .= "<metadata name='list6' alias='StateProvince'>\n";
#$output .= getSQLAsFields("select biocode_collecting_event.StateProvince from biocode_collecting_event, biocode where biocode.Coll_EventID = biocode_collecting_event.EventID group by StateProvince order by StateProvince"); 
#$output .= "</metadata>\n\n";

$output .= "</Metadata>\n\n";

$output .= "<Worksheet sheetname='Specimens'>\n\n";

$output .= "<rule type='checkInXMLFields' name='EnteredBy' level='warning' list='loginNames'></rule>\n\n";

$output .= "<rule type='RequiredColumns' name='RequiredColumns' level='error'>\n";
$output .= "<field>Coll_EventID_collector</field>\n";
$output .= "<field>EnteredBy</field>\n";
$output .= "<field>Specimen_Num_Collector</field>\n";
$output .= "<field>HoldingInstitution</field>\n";
$output .= "<field>Phylum</field>\n";
$output .= "<field>SubProject</field>\n";
$output .= "<field>SubSubProject</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='SubProject' level='error'>\n";
$output .= "<field>SIMINV</field>\n";
$output .= "<field>DRISKELL</field>\n";
$output .= "<field>SIBARCODE</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='LowestTaxonLevel' level='warning'>\n";
$output .= getArrayAsFields(@taxon_levels);
$output .= "<field>Subgenus</field>\n";
$output .= "<field>SpecificEpithet</field>\n";
$output .= "<field>SubspecificEpithet</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='HoldingInstitution' level='warning'>\n";
$output .= getArrayAsFields(@institutions);
$output .= "</rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='Phylum' level='warning'>\n";
$output .= getArrayAsFields(@Phyla);
$output .= "</rule>\n\n";

$output .= "<rule type='uniqueValue' name='Specimen_Num_Collector' level='error'></rule>\n\n";

$output .= "<rule type='checkMatchingFieldNameInSecondarySheet' name='Coll_EventID_collector' level='warning'></rule>\n\n";

$output .= "<rule type='checkLowestTaxonLevel' name='' level='error'></rule>\n\n";

$output .= "<rule type='checkTissueColumns' name='' plateName='format_name96' wellNumber='well_number96' level='warning'></rule>\n\n";

$output .= "<rule type='uniqueValue' name='format_name96,well_number96' level='error'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='preservative' level='warning' list='list2'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='relaxant' level='warning' list='list3'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='container' level='warning' list='list4'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='tissue_preservative' level='warning' list='list2'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue_container' level='warning' list='list4'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue2_preservative' level='warning' list='list2'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue2_container' level='warning' list='list4'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue3_preservative' level='warning' list='list2'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue3_container' level='warning' list='list4'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue4_preservative' level='warning' list='list2'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue4_container' level='warning' list='list4'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue5_preservative' level='warning' list='list2'></rule>\n\n";
$output .= "<rule type='checkInXMLFields' name='tissue5_container' level='warning' list='list4'></rule>\n\n";

$output .= "</Worksheet>\n\n";

$output .= "<Worksheet sheetname='Collecting_Events'>\n\n";

$output .= "<rule type='checkInXMLFields' name='EnteredBy,Collector,Collector2,Collector3,Collector4,Collector5,Collector6,Collector7,Collector8' level='warning' list='loginNames'></rule>";

$output .= "<rule type='RequiredColumns' name='RequiredColumns' level='error'>\n";
$output .= "<field>Coll_EventID_collector</field>\n";
$output .= "<field>EnteredBy</field>\n";
$output .= "<field>Country</field>\n";
$output .= "<field>TaxTeam</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='RequiredColumns' name='RequiredColumns' level='warning'>\n";
$output .= "<field>YearCollected</field>\n";
$output .= "<field>MonthCollected</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='DwCLatLngChecker'
        decimalLatitude='DecimalLatitude'
        decimalLongitude='DecimalLongitude'
        maxErrorInMeters='MaxErrorInMeters'
        horizontalDatum='HorizontalDatum' level='warning'></rule>\n\n";

$output .= "<rule type='DwCLatLngChecker'
    decimalLatitude='DecimalLatitude2'
    decimalLongitude='DecimalLongitude2' level='warning'></rule>\n\n";

$output .= "<rule type='uniqueValue' name='Coll_EventID_collector' level='error'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='HorizontalDatum' level='warning'>\n";
$output .= "<field>WGS1984</field>\n";
$output .= "<field>NAD1927</field>\n";
$output .= "<field>NAD1983</field>\n";
$output .= "<field>unknown</field>\n";
$output .= "</rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='TaxTeam' level='warning'>\n";
$output .= getArrayAsFields(@TaxTeams);
$output .= "</rule>\n\n";

$output .= "<rule type='isNumber' name='MinElevationMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='MaxElevationMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='MinDepthMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='MaxDepthMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='MaxErrorInMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='DepthOfBottomMeters' level='error'></rule>\n\n";

$output .= "<rule type='isNumber' name='DepthErrorMeters' level='error'></rule>\n\n";

$output .= "<rule type='validYearMonthDay' name='YearCollected,MonthCollected,DayCollected' level='warning'></rule>\n\n";

$output .= "<rule type='validYearMonthDay' name='YearIdentified,MonthIdentified,DayIdentified' level='warning'></rule>\n\n";

$output .= "<rule type='checkInXMLFields' name='Country' level='warning' list='list5'></rule>\n\n";

#No list6 in bioValidator yet
#$output .= "<rule type='checkInXMLFields' name='StateProvince' level='warning' list='list6'></rule>\n\n";


$output .= "</Worksheet>\n\n";

$output .= "</Validate>\n\n";


#################################################
# Output
#################################################
# Turn this off since validitor gets annoyed with character encodings
#no strict 'refs';
if (!$bad) {
	# make output utf8
	use Encode qw(encode_utf8);
	open (MYFILE,'>/tmp/slab.tmp');
	print MYFILE encode_utf8 $output;
	close (MYFILE); 

	# Once the file is written, then try to parse it!
	use XML::SAX::ParserFactory;
  	use XML::Validator::Schema;

  	# create a new validator object, using foo.xsd
  	$validator = XML::Validator::Schema->new(file => $xsdfile);

  	# create a SAX parser and assign the validator as a Handler
  	$parser = XML::SAX::ParserFactory->parser(Handler => $validator);

  	# validate xml against xsd
  	eval { $parser->parse_uri("/tmp/slab.tmp") };
  	#die "File failed validation: $@" if $@;
	if ($@) {
	   $bad .= "\n\nXML File Validation Error: " . $@;
	} else {
	    `cp /tmp/slab.tmp /usr/local/web/biocode/web/slabValidator.xml`;
	}

} 

if (!$bad) {
    send_email($output,"GOOD");
} else {
    # TODO: implement email saying this was bad
    print "\nNOT LOADED: $bad";
    print "\n\n";
    send_email("Error creating the bioValidator XML file and it was NOT written to its output directory\n\n".$bad,"BAD");
}

sub send_email {
    ($msg,$status) = @_;
    my $recipients = "jdeck\@berkeley.edu, joyceg\@berkeley.edu";
    #my $recipients = "jdeck\@berkeley.edu";
    open(MESSAGE, "| mailx -s \"bioValidator XML creation script ($status)\" $recipients");
    print MESSAGE $msg;
    close(MESSAGE);
}


#################################################
# Subroutines
#################################################
# Return a List of Field Tags given an Array
sub getArrayAsFields {
	$ret = '';
    my (@myArray) = @_;
	foreach my $field (@myArray) {
		$ret .= "<field>".$field."</field>\n";
	}
	return $ret;
}

# Return a List of Field Tags given a query
sub getSQLAsFields {
	$strRet = "";
    my ($query) = @_;
  	my ($count, $field, @row, $tmp);
	$database="biocode";

 	$dbh = DBI->connect("dbi:mysql:$database:$g_db_location","$g_db_user","$g_db_pass");
    if ( !defined $dbh ) { 
		return 1;
	}
    $sth = $dbh->prepare( $query ) or return 1;
    $sth->execute or return 1;

	# clear out array
    foreach $clear (@row) { $clear = ""; }    
    $row_count = 0;

    while ( @row = $sth->fetchrow ) {
        $count = 0;
		$strRet .= "<field>".@row[0]."</field>\n";
    }

    $sth->finish;
    $dbh->disconnect;
    return $strRet;
}

