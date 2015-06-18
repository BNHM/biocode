#!/usr/bin/perl


use CGI::Session;
use CGI;
use DBI;
use File::Find;

require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "mybiocode_utils.p";
require "biocode_settings";

# URL parsing utility
&readParseNoOut(*input);

#URL parameters
#photographer
#number
$msg="Some photos were bulk-uploaded by \n\nphotographer=".&urldecode($input{photographer})."\nnumber of photos=".&urldecode($input{number})." (yet to implement this part)\ndirectory=".&urldecode($input{directory});
$url="http://biocode.berkeley.edu/photomanager/photomatch.htm?name=".$input{photographer}."&directory=".$input{directory};
$msg.="\n\n".$url;
&send_email($msg);
print "Content-type: text/html;\n\n";
print "$msg";

sub send_email {
    ($msg) = @_;
    my $recipients = "jdeck\@berkeley.edu, joyceg\@berkeley.edu";
    #my $recipients = "jdeck\@berkeley.edu";
    open(MESSAGE, "| mail -s \"Biocode Bulk Photo Upload\" $recipients");
    print MESSAGE $msg;
    close(MESSAGE);
}

sub urldecode {
    my $str = shift;
    if ($str) {
        $str =~ s/%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    }
    return $str;
}
