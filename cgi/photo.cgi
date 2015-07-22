#!/usr/bin/perl

use CGI qw/ :standard /;
use Digest::MD5 qw(md5_hex);
use Data::Dumper ;
use File::Find;
use File::Basename;
use URI::Escape;

use CGI;
use DBI;
use File::Find;
use XML::Simple;

require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "mybiocode_utils.p";
require "biocode_settings";

our $gBiocodeDbString="dbi:mysql:biocode:$g_db_location";#;bi:mysql:biocode:chignik.berkeley.edu";
our $gMetaDbString="dbi:mysql:biocode:$g_db_location";

=head1 photo.cgi
warn "photo.cgi header";

Backend script to manage photo uploads
Functions:
   - Process new uploads for file batches, group by directory name
   - return XML for specified app configurations

=cut

#my $appDirectory = '/Users/biocode/Website/biocode/web/fma/ryanphoto/configs/';
my $photoDirectory = '/data/biocode/web/biocode_data/pictures/';
my $convert= '/usr/local/bin/convert';
our $expeditionPhotoDirectory='';
our $photoSubDirectory='';
our $metadata;
our @files = ();

### process input
my @names = param();
#warn 'paramdump - '.join(' ',@names);
my $infos = param('infos');
#warn 'infos- '.Dumper(\$infos);

&readParseNoOutPhoto(param('infos'));

##########################################################################
## First loop all filenames and if user wants to insert names into database
## they must all match a valid specimen name!
##########################################################################
#my $filefound = 0;
#if ($metadata{specimen_num_collector_match} eq "true") {
#	for $name (@names){
#		if( ref(param($name)) eq 'Fh'){
#			if (checkSpecimenNumCollector(param($name)) eq "-9999") {
#	    		xmlError("Filename parsing checkbox is selected and one or more files could not be parsed.  All files must be parseable.  Check the Specimen_Num_Collector column in the datagrid for any unmatcheable filenames and fix them.  "); 
#        		exit();
#			}
#		}
#	}
#}

#########################################################################
# Check for file handle param and loop through all uploaded files to 
# upload them
#########################################################################
for $name (@names){
	if( ref(param($name)) eq 'Fh'){
		$filefound = 1;
		doUpload($name);
	}
}

exit;

### default function - display general error
print header().start_html()."<h3>Error:</h3>No request type specified. ".
	"This page should only be called from the upload utility<br>";

##debug dump multipart form data
print "All Params:<br>"; print Dump()."<br>";
print (($filefound)? 'Found file handle' : 'No file handle found')."<br>";

##debug show multipart form
#my $form = <<EOF;
#FORM ENCTYPE="multipart/form-data" ACTION="photo.cgi" METHOD="POST"> 
#Please choose directory to upload to:<br> 
#Author: <input type=text name='author'><br>
#Taken: <input type=text name='taken'><br>
#Expedition: <input type=text name='expedition'><br>
#ppID (hidden dont look at me): <input type=text name='appID'><br>
#<p> Please select a file to upload: <BR> 
#<INPUT TYPE="FILE" NAME="file"> <p> 
#<INPUT TYPE="submit"> </FORM>
#EOF
#
#print $form ;
exit; 


sub xmlError {
=head2 xmlError(errorSTR)
	Generate an xml file with the included error message, output and exit
=cut

    my ($errorSTR) = @_ ;
    warn 'xmlError received the following string: '.$errorSTR;
    print header('text/xml');
    my $xml = <<EOF;
<?xml version="1.0" encoding="iso-8859-1"?>
<Error>
	<Message>$errorSTR</Message>
</Error>
EOF
    print $xml ;
    exit;
}

sub doUpload {
=head2 doUpload($filename)
	take in the param of a file handle, and upload the file with the associated metadata
	If missing appID or metadata, return error in xml
	otherwise success in xml and exit
=cut
	my ($filefield) = @_;
	my $fh = param($filefield);
	my $infostr;
	my $expedition ;
    my $directory;
	my $sql;

    # Extract variables that are NOT in XML file:
    #&readParseNoOutPhoto(param('infos'));

    # Perform Validations
    # Check that directory parameter, if passed in, is valid
	unless($metadata{'directory'} && $metadata{'directory'} =~ /^[\w\d\_\-]{1,60}$/ ){
	    xmlError("Invalid directory name: ". $metadata{'directory'}.". It must be 1-60 digits alphanumeric and contain no spaces or special characters. "); 
        exit();
	}
	unless($metadata{'phototype'}) {
	    xmlError("You must specify a phototype. "); 
        exit();
	}
	unless($metadata{'end_date'} && $metadata{'begin_date'}) {
	    xmlError("You must specify a begin and end date. "); 
        exit();
	}

        # Dates on form are forced to specific value

        # Assign Directory Name
        if ($metadata{'directory'}) {
            $directory=$metadata{'photographer'}."-".$metadata{'directory'};
        } else {
            $directory=$metadata{'photographer'};
        }

	$expeditionPhotoDirectory = $photoDirectory.$directory;
        $photoSubDirectory=$expeditionPhotoDirectory;
	unless(-e $expeditionPhotoDirectory){
	    #make photo directory
	    mkdir($expeditionPhotoDirectory, 0777) or xmlError('Unable to create photo directory='.$expeditionPhotoDirectory);
            # Only make these directories if they do not already exist
            if (! -e $expeditionPhotoDirectory."/lowres") {
                mkdir($expeditionPhotoDirectory."/lowres", 0777) if (! -e) || xmlError("can't make new lowres directory ");
            }
            if (! -e $expeditionPhotoDirectory."/thumbs") {
                mkdir($expeditionPhotoDirectory."/thumbs", 0777) if (! -e) || xmlError("can't make new thumbs directory ");
            }
            if (! -e $expeditionPhotoDirectory."/calthumbs") {
                mkdir($expeditionPhotoDirectory."/calthumbs", 0777) if (! -e) || xmlError("can't make new calthumbs directory ");
            }
            if (! -e $expeditionPhotoDirectory."/midres") {
                mkdir($expeditionPhotoDirectory."/midres", 0777) if (! -e) || xmlError("can't make new midres directory ");
            }
	}
	
	my $filepath = $expeditionPhotoDirectory.'/'.$fh;
        # Throw a warning instead of an error
        if (checkFileExists($filepath)) { 
            xmlError("$filepath already exists. ");       
        }

	open(NEWFILE, ">$filepath") or xmlError("Unable to create file $fh ");
	while(<$fh>){
		print NEWFILE $_ ;
	}
	close(NEWFILE);

    #create thumbs, etc...
    if (! -e $expeditionPhotoDirectory."/thumbs/".$filepath) { convertPhoto($fh,"thumbs"); }
    if (! -e $expeditionPhotoDirectory."/calthumbs/".$filepath) { convertPhoto($fh,"calthumbs"); }
    if (! -e $expeditionPhotoDirectory."/lowres/".$filepath) { convertPhoto($fh,"lowres"); } 
    if (! -e $expeditionPhotoDirectory."/midres/".$filepath) { convertPhoto($fh,"midres"); } 

	$exists=false;
	# check to be sure there is no directory/picturename already in photomatch table
	$sql="SELECT count(*) FROM bulkphoto as bp,photomatch as p ";
	$sql.="WHERE bp.directory=\"".$directory."\" and bp.picturename =\"".$fh."\" AND bp.bulkphoto_id=p.bulkphoto_id"; 
	($count)=&get_one_record("select count(*) from bulkphoto as bp,photomatch as p where bp.directory=\"".$directory."\" and bp.picturename =\"".$fh."\" ");
	if ($count > 0) {
		$exists="true";
	}	
	# First grab UUID for insert so we can refer to it later
	($uuid)=&get_one_record("select uuid()");

	# Write data to mysql 
  	$sql="INSERT INTO bulkphoto (";
	$sql.="bulkphoto_id,datefirstentered,photographer,cameratype,end_date,begin_date,phototype,picturename,directory,serverpath";
	$sql.=") VALUES (";
	$sql.="'".$uuid."',";
	$sql.="now(),";
	$sql.="\"".$metadata{photographer}."\",";
	$sql.="\"".$metadata{cameratype}."\",";
	$sql.="\"".$metadata{end_date}."\",";
	$sql.="\"".$metadata{begin_date}."\",";
	$sql.="\"".$metadata{phototype}."\",";
	$sql.="\"".$fh."\",";
	$sql.="\"".$directory."\",";
	$sql.="'/biocode_data/pictures/'";
	$sql.=");";
 	$dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
     eval {
		$dbh->do( $sql );
     }; if ($@) {
		warn $sql;
         $dbh->disconnect;
         xmlError("problem inserting request into bulkphoto table in database.  SQL: $sql ");       
    }


	# If user indicated they wished to insert matches into database, then do it here
	# NOTE: This method relies on Flex application to ensure all data has a match if the 
	# specimen_num_collector_match checkbox is set to true
	if (checkSpecimenNumCollector($fh) ne "-9999") {
		if ($exists ne "true") { 
  			$sql="INSERT INTO photomatch (";
			$sql.="internalid, DateFirstEntered, enteredby, specimenNumCollector, bulkphoto_id";
			$sql.=") VALUES (";
			$sql.="unix_timestamp(),";
			$sql.="now(),";
			$sql.="\"".$metadata{photographer}."\",";
			$sql.="'".checkSpecimenNumCollector($fh)."',";
			$sql.="'".$uuid."'";
			$sql.=");";

 			$dbh = DBI->connect($gMetaDbString,$g_db_user,$g_db_pass);
     		eval {
				$dbh->do( $sql );
     		}; if ($@) {
				warn $sql;
         		$dbh->disconnect;
         		xmlError("problem inserting request into photomatch table.  SQL: $sql ");       
    		}
		}
	}

	#create metadata file/upload to mysql depending on datasource
	my $newxml = '<?xml version="1.0" encoding="iso-8859-1"?>'."\n".
	"<metadata>\n".
	"<original_filename value='$fh' />\n";
	foreach my $key (keys %metadata){
		$newxml .= "<$key value='".$metadata{$key}."' />\n";
	}
	$newxml .= "</metadata>";
	open(NEWMETA, ">$filepath.info") or xmlError('Upload file $fh but unable to create metadata for it. ');
	print NEWMETA $newxml ;
	close(NEWMETA);
	print header('text/xml').$newxml ;

        # Remove the uploaded file upon upload...
        unlink $filepath;


	exit();
}


sub convertPhoto() {
    $filename=@_[0];
    $dir=@_[1];

 $pic = "$photoSubDirectory/$filename";
   $pic =~ s/ /\\ /g;
  $pic =~ s/\'/\\'/g; # sub apostrophes

   # Determine Portrait or Landscape

   $identify = `/usr/local/bin/identify $pic`;
warn $identify;


    # Determine Portrait or Landscape
    #$identify = `/usr/local/bin/identify "$photoSubDirectory/$filename"`;
    #warn $identify;
    #($junk1, $junk2, $dimensions, $junk3, $junk4, $junk5) = split(/\s+/,$identify);
#	($width,$height) = split(/x/,$dimensions);
    if($identify =~ /JPEG (\d+)x(\d+) /) {
        $width = $1;
        $height = $2;
    }

#	if($width >= $height) {
#   	    $orient = "H";
#	} else {
#    	    $orient = "V";
#	}


    if ($width < $height){
       $orient = "V";
    } else  {
       $orient = "H";
    }

	# Set Dimensions
	if ($orient eq "H") {
		if ($dir eq "thumbs") {
    		    $dim = "85x85";
		} elsif ($dir eq "calthumbs") {
    		    $dim = "192x128";
		} elsif ($dir eq "midres") {
    		    $dim = "1000x800";
		} else {
    		    $dim = "500x400";
		}
	} else {              # $orient = "V"
		if ($dir eq "thumbs") {
    		    $dim = "85x85";
		} elsif ($dir eq "calthumbs") {
    		    $dim = "128x192";
		} elsif ($dir eq "midres") {
    		    $dim = "800x1000";
		} else {
    		    $dim = "400x500";
		}
	}

    $command = "$convert -density 72x72 -units PixelsPerInch -geometry $dim \"$photoSubDirectory/$filename\" \"$photoSubDirectory/$dir/$filename\""; 
    warn $command;
    $err=system($command);
}

sub checkFileExists {
    my $filepath = @_;
    # simple method just checks filename
    if (-e $filepath) { 
        return 1;
    } else {
        return 0;
    } 

    # method to check matching filenames
    # 1. Read all XML files and check new filename against array of original filenames
    # 2. If original filenames match then check filesize
    # 3. If filesizes match then return true to show that this file already has been uploaded
}

sub getNewFileName() {
    my $filename = @_;
    find(\&getFiles,"$gPicturesPath"); 

    return sprintf('%d',getNextFileIncrement())."-".$filename;
}

sub getFiles() {
    # Only match the root directory
    if ($File::Find::dir."/" ne $gPicturesPath) {
        return;
    }

    # File name
    my $fn=$File::Find::name;
    $fn =~ s/$gPicturesPath//g;

    # Must have a . in the name, but not at the beginning (excludes directories and hidden files)
    if ($fn =~ m/\./  &&
        $fn =~ m/.info/  &&
        $fn !~ m/\/\./ ) { 

        # delete up to last decimal
        #$fn =~ s/^.*\./\./;
        # delete after last decimal
        $fn =~ s/\..*$//;
        # only return integers
        if ($fn =~ /^\d+$/) {
            push @files, $fn;
        }
    }
}

sub getNextFileIncrement() {
    @files=sort(@files);
    if (@files > 0) { return $files[@files]+1; } 
    else { return 1; }
}


sub readParseNoOutPhoto {
    my ($metadata) = @_;
    local ($i, $key, $val);

    foreach $clear (@metadata) { $clear = ""; }  # clear out array

    @metadata = split(/&/,$metadata);
    foreach $i (0 .. $#metadata) {
        # Convert plus's to spaces
        #   $debug_msg .= "$metadata[$i]<br>";
        $metadata[$i] =~ s/\+/ /g;
        # Split into key and value.
        ($key, $val) = split(/=/,$metadata[$i],2); # splits on the first =.
        if ($val eq "any" || $val eq "none") {next;}
        # Convert %XX from hex numbers to alphanumeric
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
        # Associate key and value
        $metadata{$key} .= "|" if (defined($metadata{$key})); # multiple separator
        $metadata{$key} .= $val;
    }
}
