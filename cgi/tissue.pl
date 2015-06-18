#!/usr/bin/perl -w
#recursive directory listing
use CGI;
use DBI;
use File::Find;

our @arrPeople = ('John Deck','Chris Meyer','Amy Driskell','Allen Collins');
our @arrCollectingEvents = qw(080603_minv_001 080605_minv_003 080605_minv_004);
our @arrTaxonLevels = qw(Kingdom Phylum Subphylum Superclass Class Subclass Infraclass Superorder Ordr Suborder Infraorder Superfamily Family Subfamily Tribe Subtribe Genus Subgenus SpecificEpithet SubspecificEpithet);
our @arrWells=formWell();
our $gRowNum=0;

# Print Header
my $query = new CGI;
print $query->header;

print head();

print "<body>\n" . specimen() . "</body>\n";

sub specimen {
	$strSpecimen="";
	$strSpecimen.="<table width=100%><td alight=right>";
	$strSpecimen.="<h1>Tissue Data Entry</h1>";
  	$strSpecimen.="<p><b>Project Setup -> Collection Event -> Specimen -> Tissue</b></p>";
	#$strSpecimen.="<br><input type=button name=download value='Send to Server'>";
	$strSpecimen.="<table>";
	$strSpecimen.="<tr><td>Plate(format_name96)</td><td><b>plate_m001</b></td></tr>";
	$strSpecimen.="<tr><td>Year</td><td><input type=textbox name=year value=2008></td></tr>";
	$strSpecimen.="<tr><td>Month</td><td><input type=textbox name=month value=6></td></tr>";
	$strSpecimen.="<tr><td>Day</td><td><input type=textbox name=day value=8></td></tr>";
	$strSpecimen.="<tr><td>EnteredBy</td><td>".formEnteredBy()."</td></tr>";
	$strSpecimen.="</table>";
	$strSpecimen.="<br><a href='javascript: void(0);' onclick=\"window.open('/cgi/specimen_popup.pl', 'Field Options', 'width=200, height=400'); return false;\">Fields</a>";
	$strSpecimen.="</td><td align=right>";
	$strSpecimen.="<img src='/images/96well.jpg' alight=right width=170>";
	$strSpecimen.="</td>";
	$strSpecimen.="</table>";

	$strSpecimen.="<table width=100%>";
	$strSpecimen.=specimenRowHead();
	#for ($i=0;$i<96; $i++) {
	#	$strSpecimen.=specimenRow();
	#}
	$strSpecimen.=specimenRow();
	$strSpecimen.="</table>";
}

sub specimenRowHead {
	$strRow="";

	$strRow.="<tr>";
	$strRow.="<td><b><u>Specimen_Num_Collector</u></b></td>";
	$strRow.="<td><b><u>Preservative</u></b></td>";
	$strRow.="<td><b><u>TissueType</u></b>";
	$strRow.="<td><b><u>Well</u></b></td>";
	$strRow.="<td><b><u>TissueBarcode</u></b></td>";
	$strRow.="<td><b><u>Notes</u></b></td>";
	$strRow.="</tr>\n";
	
	$strRow.="<tr>";
	$strRow.="<td><a href='/cgi/specimen.pl'>XMOO_0001</a></td>";
	$strRow.="<td>90% ethanol</td>";
	$strRow.="<td>foreleg</td>";
	$strRow.="<td>A1</td>";
	$strRow.="<td>123456789</td>";
	$strRow.="<td>notes</td>";
	$strRow.="<td><a href='#'>Edit</a></td>";
	$strRow.="</tr>\n";

	$strRow.="<tr>";
	$strRow.="<td><a href='/cgi/specimen.pl'>XMOO_0002</a></td>";
	$strRow.="<td>90% ethanol</td>";
	$strRow.="<td>foreleg</td>";
	$strRow.="<td>A2</td>";
	$strRow.="<td>123456789</td>";
	$strRow.="<td>notes</td>";
	$strRow.="<td><a href='#'>Edit</a></td>";
	$strRow.="</tr>\n";

	$strRow.="<tr>";
	$strRow.="<td><a href='/cgi/specimen.pl'>XMOO_0002</a></td>";
	$strRow.="<td>90% ethanol</td>";
	$strRow.="<td>middle</td>";
	$strRow.="<td>A3</td>";
	$strRow.="<td>123456789</td>";
	$strRow.="<td>notes</td>";
	$strRow.="<td><a href='#'>Edit</a></td>";
	$strRow.="</tr>\n";

	return $strRow;
}

sub specimenRow {
	$strRow="";
	$strRow.="<tr>";
	$strRow.="<td>".formSpecimen_Num_Collector("Specimen_Num_Collector","XMOO_0004")."</td>";
	$strRow.="<td>".formTextbox("Preservative")."</td>";
	$strRow.="<td>".formTextbox("TissueType")."</td>";
	$strRow.="<td>".formWell()."</td>";
	$strRow.="<td>".formTextbox("TissueBarcode")."</td>";
	$strRow.="<td>".formTextbox("notes")."</td>";
	$strRow.="<td><input type=button name=saveandnext value='Save And Next' onclick='test();'></td>";
	$strRow.="</tr>\n";
	$gRowNum++;
	return $strRow;
}

sub formWell{
	my $id=$gRowNum."_well";
	@arrWellLetters=qw(A B C D E F G H);
	my $well;
	my $strRet="";
	$strRet.="<select name=$id id=$id>";
	$strRet.="<option value=>A5";
	foreach $wl (@arrWellLetters) {
		for ($i=1;$i<=12;$i++) {
			$well=$wl.$i;
			##push @arrWells, $well;
			$strRet.="<option value=$well>$well";
		}
	}
	$strRet.="</select>";
	#return @arrWells;
	return $strRet;
}

sub formFormat_name96{
	my $id=$gRowNum."_".$_[0];
	return "<input id=$id name=$id type=textbox size=15 value='plate_m001'>".$_[1];
}
sub formTextbox {
	my $id=$gRowNum."_".$_[0];
	return "<input id=$id name=$id type=textbox size=15>".$_[1];
}
sub formSpecimen_Num_Collector{
	my $id=$gRowNum."_".$_[0];;
	return "<input id=$id name=$id type=textbox value=$_[1]>";
}

sub formYear{
	#my $id=$gRowNum."_year";
	#$strRet="<select name=$id id=$id>";
	#$strRet.="<option value=08>8";
	#$strRet.="</select>";
	#return $strRet;
	my $id=$gRowNum."_year";
	return "<input id=$id name=$id type=textbox size=4 value=2008>";
}
sub formMonth{
	#my $id=$gRowNum."_month";
	#$strRet="<select name=$id id=$id>";
	#for ($i=0;$i<=11;$i++) {
	#	$strRet.="<option value=$i>$i";
	#}
	#$strRet.="</select>";
	#return $strRet;
	my $id=$gRowNum."_month";
	return "<input id=$id name=$id type=textbox size=4 value=06>";
}
sub formDay{
	#my $id=$gRowNum."_day";
	#$strRet="<select name=$id id=$id>";
	#for ($i=0;$i<=31;$i++) {
	#	$strRet.="<option value=$i>$i";
	#}
	#$strRet.="</select>";
	#return $strRet;
	my $id=$gRowNum."_day";
	return "<input id=$id name=$id type=textbox size=4 value=08>";
}
sub formDestructive{
	my $id=$gRowNum."_destructive";
	$strRet="<select name=$id id=$id>";
	$strRet.="<option value=N>N";
	$strRet.="<option value=Y>Y";
	$strRet.="</select>";
}

sub formLowestTaxonLevel {
	my $id=$gRowNum."_".$_[0];
	$strRet="<select name=$id id=$id>";
	$strRet.="<option value=''>";
	foreach $m (@arrTaxonLevels) {
		$strRet.="<option value=$m>$m";
	}
	$strRet.="</select>";
	return $strRet;
}
sub formColl_EventID_collector {
	my $id=$gRowNum."_".$_[0];
	$strRet="<select name=$id id=$id>";
	$strRet.="<option value=''>080608_minv_0001";
	foreach $m (@arrCollectingEvents) {
		$strRet.="<option value='$m'>$m";
	}
	$strRet.="</select>";
	return $strRet;
}
sub formEnteredBy {
	my $id=$gRowNum."_".$_[0];
	$strRet="<select name=$id id=$id>";
	$strRet.="<option value='Chris Meyer'>Chris Meyer";
	foreach $m (@arrPeople) {
		$strRet.="<option value='$m'>$m";
	}
	$strRet.="</select>";
	return $strRet;
}
sub head {
	$strReturn="";
	$strReturn.="<head>\n";
	$strReturn.="<style>\n";
	$strReturn.="th { font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="td { font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="body { font-family: lucida grande, verdana; font-size: 10px; }\n";
	$strReturn.="h1{ font-family: lucida grande, verdana; font-size: 18px; }\n";
	$strReturn.="option{ font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="input{ font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="textbox{ font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="select{ font-family: lucida grande, verdana; font-size: 9px; }\n";
	$strReturn.="</style>\n";
	$strReturn.="<script>\n";
	$strReturn.="function test() {alert('add a row');}";
	$strReturn.="</script>\n";
	$strReturn.="</head>\n";
	return $strReturn;
}
