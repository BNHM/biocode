#!/usr/bin/perl
use CGI::Session;
use CGI;
use DBI;
use File::Find;
my $q = new CGI;

require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "mybiocode_utils.p";
require "biocode_settings";

# URL parsing utility
&readParse(*input);
&parse_input;

#URL parameters
#photographer
#number
$msg = $q->param( "message" );
&send_email($msg);
print "Content-type: text/html;\n\n";
print "$msg";

sub send_email {
    ($msg) = @_;
    #my $recipients = "jdeck\@berkeley.edu, joyceg\@berkeley.edu";
    my $recipients = "jdeck\@berkeley.edu";
    open(MESSAGE, "| mail -s \"bioValidator Photos uploaded to Flickr\" $recipients");
    print MESSAGE $msg;
    close(MESSAGE);
}
