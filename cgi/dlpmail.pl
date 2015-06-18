#!/usr/bin/perl
#
#
#print "Content-type: text/html\n\n";

# mod for calphotos on BSCIT GO 12/5/05

# links on /questions.html
# /cgi/dlpmail.pl?step=form&site=dlp&receiver=DLP
# /cgi/dlpmail.pl?step=form&site=atree&receiver=ATREE
# /cgi/dlpmail.pl?step=form&site=digimorph&receiver=DIGIMORPH
# /cgi/dlpmail.pl?step=form&site=calphotos&receiver=CALPHOTOS
# /cgi/dlpmail.pl?step=form&site=calmoth&receiver=calmoth

&readParse(*input) || print "    <p>No input data processed.<p>\n";


# These values arrive from both the initial call (form creation) and 
# from the final call (form submission).

$receiver = $input{'receiver'};
$site = $input{'site'};
$step = $input{'step'};
$name = $input{'reload'};


# These values come in on the form (step = submit).

$sendername   = "$input{'sendername'}";
$senderemail = "$input{'senderemail'}";
$subject  = "$input{'subject'}";
$message = "$input{'message'}";


# Other variables:


if($site eq "aw") {
    $heading = "Send a message to AmphibiaWeb";
    $assigned_subject = "AmphibiaWeb web site";

} elsif($site eq "calphotos") {
    $heading = "Send a message to CalPhotos";
    $assigned_subject = "Mail for CalPhotos";

} elsif($site eq "dlp" || $site eq "bscit") {
    $heading = "Send a message to the UC Berkeley BSCIT group";
    $assigned_subject = "Mail for BSCIT www";
} elsif($site eq "db") {
    $heading = "Send a message to the BSCIT database group";
    $assigned_subject = "Mail for BSCIT DB";
} elsif($site eq "atree") {
    $heading = "Participate in AmphibiaTree";
    $assigned_subject = "Mail for AmphibiaTree";
} elsif($site eq "mvz") {
    $heading = "Send a message to the Museum of Vertebrate Zoology";
    $assigned_subject = "Mail for the Museum of Vertebrate Zoology";
} elsif($site eq "mvzkaren") {
    $heading = "Send a message to Karen Klitz";
    $assigned_subject = "Mail for Karen Klitz";
} elsif($site eq "digimorph") {
    $heading = "Submit Species Name(s) to Digimorph";
    $assigned_subject = "Mail for AmphibiaTree/Digimorph";
} elsif($site eq "calphotos") {
    $heading = "Send a question to CalPhotos";
    $assigned_subject = "Mail for CalPhotos";
}  elsif($site eq "calmoth") {
    $heading = "Send a message to Kelly Richers about the California Moth Database";
    $assigned_subject = "Mail for Cal. Moths";
} 




################################ BEGIN #####################################

if($step eq "form" || $name eq "Clear") {
    &print_form;
} elsif($step eq "submit") {
    &check_values;
    &spam_check;
    if($error) {
        &print_form;
    } else {
        $receiver = &get_receiver_email("$receiver");
        &send_email;
        &print_nice_message;
    }
}

################################# END ######################################


sub print_form {

    print "Content-type: text/html\n\n";
    print "<body bgcolor=FFFFFF>\n";

    print "<form method=post action=/cgi-bin/dlpmail.pl>\n";
    print "<input type=hidden name=step value=submit>\n";
    print "<input type=hidden name=receiver value=\"$receiver\">\n";
    print "<input type=hidden name=site value=\"$site\">\n";



    &print_top_of_page;

    if ($site eq "calphotos") {
        print "<table width=70%>\n";
        print "<tr>\n";
        print "<td>\n";
        print "<b>Note</b> If you need to include an attachment, such as a photo, ";
        print "please send email to <a href=mailto:calphotos\@lists.berkeley.edu> ";
        print "calphotos\@lists.berkeley.edu</a> ";
        print "instead of filling out this form.";
        print "<p>\n";
        print "<b>Also Note</b> If you would like to inquire about an <b>identification</b> of a plant or animal ";
        print "please look at <a href=/identify.html>Identifying Plants and Animals</a>. You can also send an ";
        print "email with an identification question to <a href=mailto:naturalist_questions\@lists.berkeley.edu>";
        print "naturalist_questions\@lists.berkeley.edu</a>. These identification requests go to the Naturalist Center ";
        print "at the California Academy of Sciences.";

#        print "<b>Also Note</b> We do not have staff at CalPhotos that can identify plants and animals. ";
#        print "See <a href=/identify.html>Identifying Plants and Animals</a> ";
#        print "for resources you can use to identify plants, insects, and other creatures. ";
        print "</td>\n";
        print "</tr>\n";
        print "</table>\n";

        print "<p>\n";
    }

    print "<table cellspacing=0 cellpadding=0 border=0>\n";
    print "<tr>\n";
    print "<td align=right>\n";
    print "Your Name:\n";
    print "</td>\n";

    print "<td>\n";
    print "<input type=text name=sendername size=60 value=\"$sendername\">\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>\n";
    print "Your E-mail Address:\n";
    print "</td>\n";

    print "<td>\n";
    print "<input type=text name=senderemail size=60 value=\"$senderemail\">\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right>\n";
    if($receiver eq "ATREE") {
        print "Field of Interest:\n";
    } elsif($receiver eq "DIGIMORPH") {
        print "Proposed Species:\n";
    } else {
        print "Subject:\n";
    }
    print "</td>\n";

    print "<td>\n";
    print "<input type=text name=subject size=60 value=\"$subject\">\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td align=right valign=top>\n";
    if($receiver eq "DIGIMORPH") {
        print "Rationale:\n";
    } else {
        print "Message:\n";
    }
    print "</td>\n";

    print "<td>\n";
    print "<textarea name=message cols=60 rows=15 wrap=physical>\n";
    print "$message";
    print "</textarea>\n";
    print "</td>\n";
    print "</tr>\n";

    print "<tr>\n";
    print "<td>\n";
    print "</td>\n";
    print "<td>\n";
    print "<input type=submit value=Submit>\n";
    print "<input type=button value=Clear ";
    print "onClick=\"window.location='/cgi-bin/dlpmail.pl?step=form&site=$site&receiver=$receiver'\";>\n";
    print "</td>\n";

    print "</table>\n";

}






sub readParse {
    local (*in) = @_ if @_;
    local ($i, $key, $val);

    # Read in text
    if (&MethGet) {
       $in = $ENV{'QUERY_STRING'};
    } elsif (&MethPost) {
        read(STDIN,$in,$ENV{'CONTENT_LENGTH'});
    }

    $debug_msg .= "\n\n <b>IN</b> = $in\n\n<p>";

    $query_string = $in;
    foreach $clear (@in) { $clear = ""; }  # clear out array

    # changed 7/19/99 G.O.
    #@in = split(/[&;]/,$in);
    @in = split(/&/,$in);
    foreach $i (0 .. $#in) {
    # Convert plus's to spaces
     #   $debug_msg .= "$in[$i]<br>";
        $in[$i] =~ s/\+/ /g;

        # Split into key and value.
        ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.
        if ($val eq "any" || $val eq "none") {next;}
    # Convert %XX from hex numbers to alphanumeric
        $key =~ s/%(..)/pack("c",hex($1))/ge;
        $val =~ s/%(..)/pack("c",hex($1))/ge;
    # Associate key and value
        $in{$key} .= "|" if (defined($in{$key})); # multiple separator
        $in{$key} .= $val;
  }
   return scalar(@in);
}


sub MethGet {
    return ($ENV{'REQUEST_METHOD'} eq "GET");
}

sub MethPost {
    return ($ENV{'REQUEST_METHOD'} eq "POST");
}




sub get_receiver_email {

    my ($receiver) = @_;

    if($receiver eq "AmphibiaWeb") {
        $receiver = "amphibiaweb\@lists.berkeley.edu";

    } elsif($receiver eq "BSCIT") {  # Ginger, Joyce and John
        $receiver = "bscit\@berkeley.edu";

    } elsif($receiver eq "DB") {  # Ginger & Joyce
        $receiver = "bscit_db\@lists.berkeley.edu";

    } elsif($receiver eq "DLP") {
        $receiver = "bscit\@berkeley.edu";

    } elsif($receiver eq "ATREE") {
        $receiver = "tatet2\@berkeley.edu";

    } elsif($receiver eq "MVZ") {
        $receiver = "mvzdata\@lists.berkeley.edu";

    } elsif($receiver eq "MVZKAREN") {
        $receiver = "kklitz\@berkeley.edu";

    } elsif($receiver eq "DIGIMORPH") {
        $receiver = "tatet2\@berkeley.edu";

    } elsif($receiver eq "CALPHOTOS") {
        $receiver = "calphotos\@lists.berkeley.edu";
	
    } elsif($receiver eq "calmoth") {
        $receiver = "krichers\@bak.rr.com";

    } else {
        exit;
    }
    return $receiver;

}





sub send_email {


    $sendmail = "/usr/lib/sendmail";


    if(!$sendername) {
        $sendername = "Web Server";
    }
    if(!$senderemail) {
        $senderemail = "joyceg\@berkeley.edu";
    }
    if(!$subject) {
        $subject = "No Subject";
    }


    open (MAIL, "| $sendmail $receiver") ||  die ("Can't open mail: $!\n");
    select((select(MAIL), $| = 1)[0]);      # Make MAIL unbuffered
    $| = 1;                                 # Make STDOUT unbuffered

    print MAIL "Reply-to: $senderemail ($sendername)\n";
    print MAIL "From: $senderemail ($sendername)\n";
    print MAIL "To: $receiver\n";
    if($subject ne "No Subject") {
        print MAIL "Subject: $subject\n";
    } else {
        print MAIL "Subject: $assigned_subject\n";
    }

    print MAIL "\n";
    print MAIL "Sender's Name:    $sendername\n";
    print MAIL "Sender's E-mail:  $senderemail\n";
    print MAIL "Sender's Subject: $subject\n\n";

    print MAIL "$message\n";

    close MAIL;



}




sub print_nice_message {

    print "Content-type: text/html\n\n";
    print "<body bgcolor=FFFFFF>\n";

    if($site eq "aw") {
        print "Thank you for contacting the AmphibiaWeb team.\n";
    } elsif($site eq "dlp" || $site eq "bscit" || site eq "db") {
        print "Thank you for contacting BSCIT.\n";

    } elsif($site eq "calphotos") {
        print "Thank you for contacting Calphotos.\n";
 
    } elsif($site eq "atree") {
        print "Thank you for contacting the Tree of Life.\n";
    } elsif($site eq "mvz" || $site eq "mvzkaren") {
        print "Thank you for contacting the Museum of Vertebrate Zoology.\n";
    } elsif($site eq "digimorph") {
        print "Thank you for contacting us about Digimorph.\n";
    }  elsif($site eq "calmoth") {
        print "Thank you for contacting the California Moth Database.\n";
    } 



    print "<p>\n";
    print "Go <a href=\"javascript:history.go(-2);\">back</a> to the page you were reading.";

}



sub check_values {
    $error = "";
    if(!$sendername) {
        $error .= "<font color=red>Please enter your name.</font><br>\n";
    }
    if(!$senderemail) {
        $error .= "<font color=red>Please enter your e-mail address.</font><br>\n";
    } elsif($senderemail !~ /.+\@.+\..+/) {
        $error .= "<font color=red>Please enter a valid e-mail address. (example: you\@aol.com)</font><br>\n";
    }
    if(!$subject) {
        $error .= "<font color=red>Please enter a subject.</font><br>\n";
    }
    if(!$message) {
        $error .= "<font color=red>Please enter a message.</font><br>\n";
    }

}





sub print_top_of_page {


#    print "<tr>\n";
#    print "<td><br>\n";
#    print "</td>\n";
#    print "<td align=center>\n";

    print "<h2 align=center>$heading</h2>";
    print "<p>";

    if($error) {
        print "<br>";
        print "<font color=red><b>To send a message:</b></font><br>";
        print "$error";
    }
#    print "</td>\n";
#    print "</tr>\n";

}



sub spam_check {

    ### check for spam....

    my $strike = 0;
    my $strike2 = 0;


    ### sendername and subject fields -- no "http:" allowed
    while($sendername =~ /http:/gi) {
        ++$strike;
    }
    while($subject =~ /http:/gi) {
        ++$strike;
    }


    ### message field ....
    while($message =~ /http:/gi) {
        ++$strike2;
    }
    while($message =~ /\.com\//gi) {
        ++$strike2;
    }
    while($message =~ /\.biz\//gi) {
        ++$strike2;
    }
    while($message =~ /\.info\//gi) {
        ++$strike2;
    }
    while($message =~ /a href/gi) {
        ++$strike2;
        ++$strike2;
    }
    while($message =~ /href/gi) {
        ++$strike2;
    }
    while($message =~ /\[URL/gi) {
        ++$strike2;
    }


    ### say bye if it's spam
    if($strike > 0 || $strike2 > 2) {
        # it's probably spam
        print "Content-type: text/html\n\n";
        print "bye";
        exit;
    }
 
}


