#!/usr/bin/perl

require "myquery_utils.p";
require "myschema.p";
require "utils.p";
require "biocode_settings";

use CGI;
use CGI qw(:standard);


#$CRASH = 1;  ## queries will just exit out of readParse
#$crash_date = "Tue Apr 21 18:30:54 PDT 2009";


&readParse(*input);  # if there is any... for login/logout
&parse_input;

$port = $ENV{'SERVER_PORT'};
$request_uri = $ENV{'REQUEST_URI'};
if($input{referer}) {
    $referer_tmp = $input{referer};
} else {
    $http_referer = $ENV{'HTTP_REFERER'};
}

$tmp_login_dir = "$tmp_file_location/unknown_query";

if($port eq "8000") {
    $html_dir = "$port_8000_html_dir";
} else {
    $html_dir = "$port_80_html_dir";
}






if($input{login} eq "logout") {
    &logout;
} elsif($input{login} eq "printform") {
    &save_originating_url;
    &printform;
} elsif($input{login} eq "check") {
    &checklogin;
}


sub printform {

    print "Content-type: text/html\n\n";

    #### <!--#include virtual="http://biocode.berkeley.edu/headers_footers/title.html" -->
    open(FH,"$html_dir/$headers_footers/title.html") || die "Can't open $html_dir/$headers_footers/title.html";
    while(<FH>) {
        print "$_";
    }
    close(FH);


    print "Moorea Biocode Species Database Login\n";

    #### <!--#include virtual="http://biocode.berkeley.edu/headers_footers/head1css.html" -->
    open(FH,"$html_dir/$headers_footers/head1css.html") || die "Can't open $html_dir/$headers_footers/head1css.html";
    while(<FH>) {
        print "$_";
    }
    close(FH);


    print "Moorea Biocode Species Database Login\n";


    #### <!--#include virtual="http://biocode.berkeley.edu/headers_footers/head2.html" -->
    if($input{lfile}) {
        open(FH,"$html_dir/$headers_footers/head2.html") || die "Can't open $html_dir/$headers_footers/head2.html";
    } else {
        open(FH,"$html_dir/$headers_footers/head2.html") || die "Can't open $html_dir/$headers_footers/head2.html";
    }
    while(<FH>) {
        print "$_";
    }
    close(FH);


    #### <!--#include virtual="http://biocode.berkeley.edu/headers_footers/head3.html" -->
    open(FH,"$html_dir/$headers_footers/head3.html") || die "Can't open $html_dir/$headers_footers/head3.html";
    while(<FH>) {
        print "$_";
    }
    close(FH);





    print "<center>\n";
    print "<small>\n";
    print "<i>\n";
    print "Back to: <a href=/cgi-bin/biocode_species_query_form>Moorea Biocode Species Search</a>\n";
    print "</small>\n";
    print "</i>\n";
    print "</center>\n";

    if($error) {
        print "<p>&nbsp;&nbsp;$error\n";
    }


    print "<p>\n";
    print "<form method=get action=\"/cgi/biocode_login.pl\" method=\"get\">\n";
    print "<input type=hidden name=referer value=$referer_tmp>\n";
    print "<input type=hidden name=login value=check>\n";

print <<END;

    <table>
    <tr>
    <td>
    Your name
    </td>
    <td>
    <input size=40 type=text name=name value=$input{name}>
    </td>
    </tr>

    <tr>
    <td>
    Your password
    </td>
    <td>
    <input size=40 type=password name=password value=$input{password}>
    </td>
    </tr>

    <tr>
    <td>
    </td>
    <td>
    <input type="submit" value="Submit">
    <input type="reset" value="Clear Form">
    </td>
    </tr>
    </table>

    </form>


END


    #### <!--#include file="http://biocode.berkeley.edu/headers_footers/footer.txt" -->
    open(FH,"$html_dir/$headers_footers/footer.html") || die "Can't open $html_dir/$headers_footers/footer.html";
    while(<FH>) {
        print "$_";
    }
    close(FH);

}



sub checklogin {

    $query = "select * from biocode_people where name_initials = '$input{name}' and passwd = '$input{password}' ";
    $query .= " and name_initials is not null and edit_species = 1 ";
    @row = &get_one_record("$query");
    &fill_fields_with_values("biocode_people");
    if($row[1]) {
        # User found with password entered on form. 
        # Make tmp file for this user, to track name & login privileges.
        $date = `date`;
        chdir($tmp_login_dir);
        $login_tmp = rand(1000000);
        $login_tmp = sprintf("%d",$login_tmp);

        while(-e $login_tmp) {
            $login_tmp = rand(1000000);
            $login_tmp = sprintf("%d",$login_tmp);
        }

        open(FH,">$login_tmp") || die "can't open $tmp file ";
        print FH "$name_full|$name_initials|$email|$date";
        close(FH);

        # Go back to last page user was on.

        open(FH,"$input{referer}") || die "can't open $login_tmp file ";
        while(<FH>) {
            $http_referer = $_;
        }
        close(FH);

        if($http_referer !~ /lfile=/) {
            chomp($http_referer);
            if($http_referer =~ /biocode_species_query_form\?$/) {
                $http_referer .= "&lfile=$login_tmp";
            } elsif($http_referer =~ /biocode_species_query_form$/) {
                $http_referer .= "?lfile=$login_tmp";
            } else {
                $http_referer .= "&lfile=$login_tmp";
            }
        } else {
            $http_referer =~ s/&lfile=\d*/&lfile=$login_tmp/g;
        }

        print "Location: $http_referer\n\n";
    } else {
        # User not found, or incorrect password.
        $error = "<font color=red>Invalid user or password. Please try again.</font><br>$query";
        &printform;
    }


}





sub logout {

    # delete tmp file with login information
    $tmpfile = $input{lfile};
    chdir($tmp_login_dir);
    `/bin/rm -f $tmpfile`;
    $http_referer =~ s/lfile=\d+//g;

    print "Content-type: text/html\n";
    print "Location: $http_referer\n\n";

}



sub save_originating_url {

        chdir($tmp_login_dir) || die "Can't change to $tmp_login_dir ";
        $referer_tmp = rand(1000000);
        $referer_tmp = sprintf("%d",$referer_tmp);

        while(-e $referer_tmp) {
            $referer_tmp = rand(1000000);
            $referer_tmp = sprintf("%d",$referer_tmp);
        }

        open(FH,">$referer_tmp") || die "can't open $referer_tmp file ";
        print FH "$http_referer\n";
        close(FH);


}




