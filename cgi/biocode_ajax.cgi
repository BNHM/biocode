#!/usr/bin/perl -w
require "myschema.p";

use CGI::Session;
use CGI;
use DBI;
use File::Find;

require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "mybiocode_utils.p";
require "biocode_settings";

#use Spreadsheet::ParseExcel;
# Load subroutines
sub getBulkPhotoId();
sub getMeta();
sub writeMeta();
sub loadPics();
sub getFiles();
sub getSpreadsheet();
sub loadPicDirs();
sub getPicDirs();
sub loadSpreadsheetDirs();
sub getSpreadsheetDirs();
sub loadBatches;
#sub populateSpecimenInfo();
sub loadPhotographersWithDirs;
sub showStats;

# Parse picturename using noPlus
&readParseNoOutNoPlus(*input2);
warn "picturename:". $input2{picturename};
my $picturename= $input2{picturename};

# URL parsing utility
&readParseNoOut(*input);

# Print Header
my $query = new CGI;
print $query->header;
our $gBiocodeDbString="dbi:mysql:biocode:$g_db_location";#dbi:mysql:biocode:chignik.berkeley.edu";
our $gMetaDbString="dbi:mysql:biocode:$g_db_location";

# URL Key vars
my $sessionid= $input{sessionid};
my $option= $input{option};
my $dirFromInput= $input{directory}; 
my $specimenNumCollector= $input{specimen_num_collector}; #this doubles as coll_eventid_collector
#my $enteredby= $input{enteredby};
my $enteredby=$query->cookie("biocodeUser"); 
my $getspecimen= $input{getspecimen};
my $internalid= $input{internalid};
my $all= $input{all};
my $directory= $input{directory};
my $remove = $input{remove};
my $spreadsheetFile = $input{spreadsheet};
my $count = $input{count};
my $index= $input{index};
my $serverpath= $input{serverpath};
my $value= $input{value};
my $code= lc($input{code});
our $gPicturesPath=urldecode($input{picturespath});
our $gSpreadsheetPath=$input{spreadsheetpath};
#our $gBdbPath=$gPicturesPath."/data.dbl";

# Global Variables
our @files = ();
our @thumbs= ();
our @picDirs= ();
our @spreadsheetDirs= ();


# Paths to different options
if ($option =~ m/meta/) { getMeta();}
if ($option =~ m/write/) { writeMeta();}
if ($option =~ m/pics/) { loadPics();}
if ($option =~ m/picDirs/) { loadPicDirs();}
if ($option =~ m/spreadsheets/) { getSpreadsheet();}
if ($option =~ m/spreadsheetDirs/) { loadSpreadsheetDirs();}
if ($option =~ m/batchList/) {loadBatches("select batch_id,batch_id from biocode group by batch_id");}
if ($option =~ m/collectorList/) {loadBatches("select collector,collector from biocode group by collector"); }
if ($option =~ m/plateList/) {loadBatches("select format_name96,format_name96 from biocode_tissue group by format_name96");}
if ($option =~ m/phylumList/) {loadBatches("select phylum,phylum from biocode group by phylum");}
if ($option =~ m/enteredbyList/) { loadBatches("select EnteredBy,enteredby from biocode group by enteredby");}
if ($option =~ m/loginList/) { loadBatches("select name_full,name_full from biocode_people where collector=1 order by name_last");}
if ($option =~ m/photographerList/) { 
	loadPhotographersWithDirs();
	#loadBatches("select name_full,name_full from biocode_people group by name_full");
}
if ($option =~ m/showStats/) { showStats();}
# NOTE: option=<name of database field to search on>
# batch=<value>
#if ($option =~ m/batch/) { populateSpecimenInfo();}
if ($option =~ m/format_name96/) { populateSpecimenInfo();}
if ($option =~ m/enteredby/) { populateSpecimenInfo();}
if ($option =~ m/phylum/) { populateSpecimenInfo();}
if ($option =~ m/entered_specimen_num_collector/) { 
	$input{option}="specimen_num_collector";
	populateSpecimenInfo();
}

# getMeta() returns information on what has already been entered
sub getMeta() {
	$dbh = DBI->connect($gMetaDbString,"$g_db_user","$g_db_pass");

	###########################################################
	# Option to just get photos that match a specimen
	###########################################################
	if ($getspecimen =~ m/yes/) {
		my $sql="SELECT p.internalid,concat(bp.serverpath,bp.directory,'/',bp.picturename) as totalpath,bp.directory as directory from photomatch as p,bulkphoto as bp WHERE ";
		$sql.=" bp.bulkphoto_id=p.bulkphoto_id AND ";
		$sql.= "p.specimennumcollector = '".$specimenNumCollector."'";
		$res=$dbh->selectall_arrayref($sql);
		foreach( @$res ) {
			#internalid;picture|internalid2;picture2|etc...
   	 		print $_->[0].";;".$_->[1].";;".$_->[2]."|";
		}
	###########################################################
	# Display data for "Batch List"
	###########################################################
	} else {
		#$sql="SELECT enteredby,picturename,specimenNumCollector,colleventidcollector,internalid from photomatch";
		$sql="SELECT p.enteredby,bp.picturename,p.specimenNumCollector,'' as colleventidcollector,p.internalid from photomatch as p,bulkphoto as bp where p.bulkphoto_id=bp.bulkphoto_id";
		my $header="<tr><th>delete</th><th>enteredby</th><th>picturename</th><th>specimen_num_collector</th><th>coll_eventid_collector</th><th>internalid</th></tr>";
		$res=$dbh->selectall_arrayref($sql);
		print "<table border=1>";
		print $header;
		foreach( @$res ) {
			print "<tr>";
			my $deleteOption="<td><a href='javascript:listRemove(\"$_->[3]\");'>Delete</a></td>";
			print $deleteOption;
   			foreach $i (0..$#$_) { 
           		print "<td>$_->[$i]</td>"
        	}
			print "</tr>\n";
		}
		print "</table>";
	}

	$dbh->disconnect;
}

sub loadPlates() {
 	$dbh = DBI->connect("dbi:mysql:biocode:$g_db_location",$g_db_user,$g_db_pass);
	my $sql="SELECT format_name96,concat(format_name96,' (',count(*),')')";
        $sql.=" FROM biocode_tissue";
        $sql.=" WHERE well_number96 is not NULL";
        $sql.=" GROUP BY format_name96";
	$sql.=" ORDER BY  IF (format_name96 REGEXP '^[A-Za-z]',  CONCAT(LEFT(format_name96,1), LPAD(SUBSTRING(format_name96,2),20,'0')), CONCAT('\@',LPAD(format_name96,20,'0')))";
	$res=$dbh->selectall_arrayref($sql);
	$i=0;
	foreach( @$res ) {
		$i++;
   		print $_->[0].";".$_->[1]."|";
	}
	# Error msg saying nothing came up
	if ($i == 0) {
		print "99";
	}
	$dbh->disconnect;
}
sub loadBatches() {
 	$dbh = DBI->connect($gBiocodeDbString,$g_db_user,$g_db_pass);
        my $sql= @_[0];
	$res=$dbh->selectall_arrayref($sql);
	$i=0;
	foreach ( @$res ) { 
            $i++; 
            print $_->[0].";".$_->[1]."|"; 
        }
	# Error msg saying nothing came up
	if ($i == 0) { print "99"; }
	$dbh->disconnect;
}

#############################################################
# writeMeta() is functions to remove a line or add a line
# Error Messages NOTE:
# Error 10= unable to select internalid from photomatch table
# Error 20= no matching record found
# Error 30= unable to delete record from photomatch table
# Error 99= not logged in or invalid session
#############################################################
sub writeMeta() {
 	$dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
	my $sql="";

	##########################################################
	# First check sessionid value to be sure user has a session on server 
	# that matches cookie
	##########################################################
	$cookieSessionID = $query->cookie("id");
	if ($cookieSessionID ne $sessionid ||
		$sessionid eq "") {
		print "99";
		return;
	}

	#########################################################
	# Remove a Line
	#########################################################
	if ($remove eq "yes") {
		$sql="DELETE FROM photomatch WHERE internalid=$internalid";
   		$dbh->do( $sql ) or print "30";
		print "0";
	#########################################################
	# Add a line
	#########################################################
	} else {
		$maxselect="SELECT max(internalid) from photomatch";
        ($maxnum1) = &get_one_record("$maxselect","biocode");

		($bulkphoto_id) = getBulkPhotoId();
		my $sql="INSERT INTO photomatch (internalid,specimennumcollector,enteredby,datefirstentered,bulkphoto_id) VALUES ( unix_timestamp(),'".$specimenNumCollector."','".$enteredby."',now(),'".$bulkphoto_id."' ) ";
        eval {
   			$dbh->do( $sql );
        }; if ($@) { 
	    	$dbh->disconnect;
            print "1"; 
            return;
        }
        ($maxnum2) = &get_one_record("$maxselect","biocode");

         # a double check to be sure the insert worked
         if ($maxnum1 == $maxnum2) {
        	print "1";
         } else {
         	print $maxnum2;
         }
	     $dbh->disconnect;
	}
    return;
}

sub getBulkPhotoId() {
    $dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
    my $sql="SELECT bp.bulkphoto_id from bulkphoto as bp where bp.directory=\"".$directory  ."\"  AND bp.picturename=\"".$picturename."\"";
    warn $sql;
    ($bulkphoto_id) = &get_one_record("$sql","biocode");
    return $bulkphoto_id;
}

our $last='';
sub loadSpreadsheetDirs() {
    $last='';
    find(\&getSpreadsheetDirs,"$gSpreadsheetPath"); #custom subroutine find, parse $dir
    my $content='';
    foreach my $i (@arrSpreadsheets) { $content.=$i."|\n"; } 
    $content =~ s/\|$//;
    print $content;
}

sub getSpreadsheetDirs() {
    # Take off leading directory name
    my $fn;
    $fn=$File::Find::name;
    $fn=~s/$gSpreadsheetPath//;
    $fn=~s/\///g;
    if ($fn =~ m/$last/) {
        # do nothing
    } else {
        if ($fn) {
            if ($fn !~ m/^\./ && $fn =~ m/xls/) {
                $last=$fn;
     	        push @arrSpreadsheets, $fn;
	    }
        }
    }
}

# Purpose of this function is to read the pictures directory and return a list of only 
# unique names before the "-" in the directory name.
# This assumes directories all have photographer name in the beginning of the name
sub loadPhotographersWithDirs() {
    $last='';
    find({ wanted => \&getPicDirs, no_chdir => 0},"$gPicturesPath"); #custom subroutine find, parse $dir
    @picDirs=sort(@picDirs);
    $prev = 'nonesuch';
    @picDirs= grep($_ ne $prev && (($prev) = $_), @picDirs);
    # loop all directories returned in the photo directory
	@arrTrimmedDirs=();
    foreach my $i (@picDirs) { 
		#delete everything after the first dash -- this gives us groups to use and usually photographer names
        $i =~ s/-.*//;
		push(@arrTrimmedDirs,$i);
    } 

	# Sort and get only unique values
	undef %saw;
    @saw{@arrTrimmedDirs} = ();
    @arrPhotographers = sort keys %saw;

	# Loop through Sorted, unique array and write to content var
    my $content='';
    foreach my $i (@arrPhotographers) { 
		$content.=$i.";".$i."|";
	}
    $content =~ s/\|$//;
	print $content;
}

sub loadPicDirs() {
    $last='';
   	#find({ wanted => \&getPicDirs, no_chdir => 0},"$gPicturesPath"); #custom subroutine find, parse $dir
   	find({ wanted => \&getPicDirs, no_chdir => 0,follow=>1},"$gPicturesPath"); #custom subroutine find, parse $dir

    my $content='';
    my $xmlcontent='';
    $xmlcontent.='<?xml version="1.0" encoding="utf-8"?>';
    $xmlcontent.='<directories>';
    @picDirs=sort(@picDirs);
    $prev = 'nonesuch';
    @picDirs= grep($_ ne $prev && (($prev) = $_), @picDirs);

    # loop all directories returned in the photo directory
    foreach my $i (@picDirs) { 
        # only match directories beginning with a particular photographer name
        if ($i =~ $input{photographer}) {
            $content.=$i."|\n"; 
            my $label = $i;
            $label =~ s/^$input{photographer}\-//;
            $xmlcontent.='<directory photographer="'.$input{photographer}.'" label="'.$label.'" data="'.$i.'"></directory>';
        }
    } 
    $xmlcontent.='</directories>';
    $content =~ s/\|$//;

    if ($input{format} eq 'xml') {
        print $xmlcontent;
    } else {
        print $content;
    }
}

sub getPicDirs() {
    # Take off leading directory name
    my $fn;
    $fn=$File::Find::name;
    $dn=$File::Find::dir;
    $dn=~s/$gPicturesPath//;
    $dn=~s/\/lowres//;
    $dn=~s/\/midres//;
    $dn=~s/\/calthumbs//;
    $dn=~s/\/thumbs//;
    $dn=~s/^\///g;
# JBD NOTE (if statement commented out for some reason but really this does not make much sense so I put it back in)
# However, there could be consequences
    if ($dn =~ m/$last/) {
	# do nothing
    } else {
        if ($dn) {
            $last=$dn;
            push @picDirs, $dn;
        }
    }
}

# loadPics()
sub loadPics() {
    find(\&getPics,"$gPicturesPath"); #custom subroutine find, parse $dir
    # print list of Thumbnails
    my $content='';
    @thumbs=sort(@thumbs);
    # call either thumbs OR files
    foreach my $i (@thumbs) {
        $content.=$i."|";
    } 
    $content =~ s/\|$//;
    print $content;
}

# Following gets called recursively for each file in $dir, check $_ to see if you want the file!
sub getPics() {
    #push @files, $File::Find::name #if(/\.pl$/i); # modify the regex as per your needs or pass it as another arg
    # Take off leading directory name
    my $fn;
    $fn=$File::Find::name;
    $fn =~ s/$gPicturesPath\///;
    # must have a . in the name, but not at the beginning (excludes directories and hidden files)
    if ($fn =~ m/\./  &&
        $fn !~ m/\/\./ &&
        $fn !~ m/\/\.info/ &&
        $fn =~ m/$dirFromInput/) {
#print "fn:".$fn."<br>";
       if ($fn =~ m/\/thumbs\//) {
           $fn =~ s/thumbs\///;
           $fn =~ s/$dirFromInput\///;
           push @thumbs, $fn;
       }
       else { push @files, $fn;}
    }
}

sub showStats() {
    # Date last updated
    my $strRet="<i>";
    eval {
        # Count number of specimen records
        $select = "select count(*) from biocode"; 
        ($count) = &get_one_record("$select","biocode");
        $strRet.="$count specimens, ";

        # Count number of collecting events
        $select = "select count(*) from biocode_collecting_event"; 
        ($count) = &get_one_record("$select","biocode");
        $strRet.="$count collecting events";

        # Count number of photos matched
    };
    if ($@) {
        #print "990";
        print $@."</i>";
        return;
    }
    print $strRet."</i>";
    return;
}

# populateSpecimenInfo()
sub populateSpecimenInfo {
	my $where = "";
	my $sql="";

	# Create hash versions of schemas so i can query values in them more easily in this function
	# force all values to be lowercase here
 	undef %biocode_schema_hash;
    for (@biocode_schema) { $biocode_schema_hash{lc($_)} = 1; }
 	undef %biocode_tissue_schema_hash;
    for (@biocode_tissue_schema) { $biocode_tissue_schema_hash{lc($_)} = 1; }

	# Populate the WHERE clause
	if ($biocode_schema_hash{$input{option}}) {
    	$where=" WHERE b.$input{option} like '".$input{value}."'";
	} elsif ($biocode_tissue_schema_hash{$input{option}}) {
    	$where=" WHERE b.bnhm_id=t.bnhm_id AND t.$input{option} like '".$input{value}."'";
	}

	# First time, will run query off of Biocode table
	if ($count =~ m/yes/) {
 		$dbh = DBI->connect($gBiocodeDbString,$g_db_user,$g_db_pass);
		$sql="SELECT b.specimen_num_collector FROM biocode as b ";
		if ($biocode_tissue_schema_hash{$input{option}}) {
			$sql.=",biocode_tissue as t "; 
		}
		$sql.="$where";
		$res=$dbh->selectall_arrayref($sql);
		$dbh->disconnect;
	# Second time, run query off of local table
	} else {
		if ($all =~ m/yes/) {
 			$dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
			$sql="SELECT ";
			$sql.="count(photomatch.specimenNumCollector) as count,";
			$sql.="ifnull(b.Specimen_Num_Collector,'') as Specimen_Num_Collector,";
			$sql.="ifnull(b.MorphoSpecies_Description,'') as MorphoSpecies,";
			$sql.="ifnull(b.LowestTaxon,'') as LowestTaxon,";
			$sql.="ifnull(b.Notes,'') as Notes";
			$sql.=" FROM";
			if ($biocode_tissue_schema_hash{$input{option}}) {
				$sql.=" biocode_tissue as t,"; 
			}
			$sql.=" biocode as b";
			$sql.=" left join photomatch on";
			$sql.=" photomatch.specimenNumCollector=b.Specimen_Num_Collector"; 
			$sql.= $where;
			$sql.=" GROUP BY b.Specimen_Num_Collector";
			#$sql.=" ORDER BY b.Specimen_Num_Collector";
			# Natural Ordering ignores leading characters yet retains numeric sort
			$sql.=" ORDER BY  IF (b.Specimen_Num_Collector REGEXP '^[A-Za-z]',  CONCAT(LEFT(b.Specimen_Num_Collector,1), LPAD(SUBSTRING(b.Specimen_Num_Collector,2),20,'0')), CONCAT('\@',LPAD(b.Specimen_Num_Collector,20,'0')))";
			print $sql;
			$res=$dbh->selectall_arrayref($sql);
			$dbh->disconnect;
		} else {
 			$dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
			$sql="SELECT ";
			my $i=0;
 			foreach $m (@biocode_schema) {
				if ($i>0) { $sql.=",";}
				$sql.="ifnull(b.".$m.",'NULL') as ".$m;
				$i++;
			}
			$sql.=" FROM biocode as b ";
			if ($biocode_tissue_schema_hash{$input{option}}) {
				$sql.=",biocode_tissue as t "; 
			}
			#$sql.="$where ORDER BY Specimen_Num_Collector";
			# Natural Ordering ignores leading characters yet retains numeric sort
			$sql.="$where ORDER BY  IF (b.Specimen_Num_Collector REGEXP '^[A-Za-z]',  CONCAT(LEFT(b.Specimen_Num_Collector,1), LPAD(SUBSTRING(b.Specimen_Num_Collector,2),20,'0')), CONCAT('\@',LPAD(b.Specimen_Num_Collector,20,'0')))";
			$res=$dbh->selectall_arrayref($sql);
			$dbh->disconnect;
		}
	}

	my $total= @{$res};
	################################
	# Count is done on first time
	# TODO -- introduce error trapping for this
	################################
	if ($count =~ m/yes/) {
		print $total;  # print total # of rows
	################################
	# Grab data from local database
	################################
	} elsif ($all =~ m/yes/) {
		print "<table border=1>";
		print "<tr>";
		print "<th></th>";
		print "<th>count</th>";
		print "<th>Coll_EventID_collector</th>";
		print "<th>Specimen_Num_Collector</th>";
		print "<th>MorphoSpecies</th>";
		print "<th>LowestTaxon</th>";
		print "<th>Notes</th>";
		print "<tr>";
		$row=1;
		foreach ( @$res ) {
			print "<tr>";
   	 		print "<td><a href='javascript:gotoSpecimen(".$row.");'>goto $row</a></td>";
			print "<td>$_->[0]</td>";
			print "<td>$_->[1]</td>";
			print "<td>$_->[2]</td>";
			print "<td>$_->[3]</td>";
			print "<td>$_->[4]</td>";
			print "<td>$_->[5]</td>";
			print "</tr>";
			$row++;
		}
		print "</table>";
	} elsif ($index>0) {
		# Column Headings
		$i=0;
		print "msg";
 		foreach $m (@biocode_schema) {
			print "|".$m;
			$i++;
		}
		print "\n";

		# Data Section
		$msg= "Displaying ".$index." of ".$total." records";
		print $msg."|";

		foreach ( @$res->[$index-1] ) {
			for($i=0;$i<=scalar(@biocode_schema);$i++) {
   	 			print "$_->[$i]|";
			}
		}
		print "\n";

	} else {
		print "0";
	}
}

# getSpreadsheet()
sub getSpreadsheet() {
	my $spreadSheetFullPath=$gSpreadsheetPath.'/'.$spreadsheetFile;

	my $oExcel = new Spreadsheet::ParseExcel;
	my $oBook = $oExcel->Parse($spreadSheetFullPath);
	my($iR, $iC, $oWkS, $oWkC);
	$oWkS = $oBook->Worksheet("Specimen_Master");

	$total= $oWkS->{MaxRow};

	# Count option
	if ($count =~ m/yes/) {
		print $total;
	} elsif ($index>0) {
		# Column Headings
		print "msg|";
		for(my $iC = $oWkS->{MinCol}; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol}; $iC++) {
   			$oWkC = $oWkS->{Cells}[0][$iC];
			print $oWkC->Value."|";
		}
		print "\n";

		# Field Values
		$msg= "Displaying ".$index." of ".$total." records";
		print $msg."|";
		for(my $iC = $oWkS->{MinCol}; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol}; $iC++) {
   			$oWkC = $oWkS->{Cells}[$index][$iC];
			if ($oWkC) {
				$value=$oWkC->Value;
			} else {
				$value="";
			}
			print $value."|";
		}
		print "\n";
	} else {
		print "0";
	}
}


sub urldecode {
    my $str = shift;
    if ($str) {
        $str =~ s/%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    }
    return $str;
}
