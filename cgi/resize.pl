#!/usr/bin/perl
use File::Find;
use File::Basename;
#
#  John Deck, October 2008
#
#  Takes a large image and makes it into 3 size images for FIMS Photomatch:
#  midres (1000px)
#  lowres (500px)
#  thumbs (85px)
#  calthumbs (192px)

sub convertPhoto;

$convert= "/usr/local/bin/convert";

#if ($ARGV[0] eq "") {
#	print "\nUSAGE: resize.pl {directory name}\n\n";
#	exit;
#}
#our $rootdir = "./".$ARGV[0];

our $rootdir="./";
#if ($input{directory}) {
 #   $rootdir=$input{directory};
#} 
    
# Only make these directories if they do not already exist
if (! -e $rootdir."/lowres") {
    mkdir($rootdir."/lowres", 0777) if (! -e) || die "can't make new lowres directory in $rootdir";
}
if (! -e $rootdir."/thumbs") {
    mkdir($rootdir."/thumbs", 0777) if (! -e) || die "can't make new thumbs directory in $rootdir";
}
if (! -e $rootdir."/calthumbs") {
    mkdir($rootdir."/calthumbs", 0777) if (! -e) || die "can't make new calthumbs directory in $rootdir";
}
if (! -e $rootdir."/midres") {
    mkdir($rootdir."/midres", 0777) if (! -e) || die "can't make new midres directory in $rootdir";
}

loopPics();

# loadPics()
sub loopPics() {
print $rootdir;
    opendir (DIR, $rootdir) or die "$!";
    my @files = grep {/.jpg|.JPG|.jpeg|.JPEG|.gif|.GIF|.png|.PNG/}  readdir DIR;
    #my @files = readdir DIR;
    close DIR;
    $num=@files;
    $count=0;
    foreach my $file (@files) {
        $count=$count+1;
        print "processing $file (".$count." of ".$num.")\n";
        if (! -e $rootdir."/thumbs/".$file) {
            convertPhoto($file,"thumbs");
        } else {
            print "    NOTE: ".$rootdir."/thumbs/".$file." exists\n";
        }
        if (! -e $rootdir."/calthumbs/".$file) {
            convertPhoto($file,"calthumbs");
        } else {
            print "    NOTE: ".$rootdir."/calthumbs/".$file." exists\n";
        }
        if (! -e $rootdir."/lowres/".$file) {
            convertPhoto($file,"lowres");
        } else {
            print "    NOTE: ".$rootdir."/lowres/".$file." exists\n";
        }
        if (! -e $rootdir."/midres/".$file) {
            convertPhoto($file,"midres");
        } else {
            print "    NOTE: ".$rootdir."/midres/".$file." exists\n";
        }
   }
}

sub convertPhoto() {
	$filename=@_[0];
	$dir=@_[1];
	# Determine Portrait or Landscape
	$identify = `/usr/local/bin/identify $rootdir/$filename`;
	($junk1, $junk2, $dimensions, $junk3, $junk4, $junk5) = split(/\s+/,$identify);
	($width,$height) = split(/x/,$dimensions);

	if($width >= $height) {
   	    $orient = "H";
	} else {
   	    $orient = "V";
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

    $command = "$convert -density 72x72 -units PixelsPerInch -geometry $dim '$rootdir/$filename' '$rootdir/$dir/$filename'"; 
    print $command."\n\n";
    $err=system($command);
}

