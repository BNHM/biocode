package biocode_excel;
use Spreadsheet::ParseExcel;
use CGI;
#use DBI;
#use File::Find;

warn "biocode_excel.pm is loaded";
1;

sub new {
    my($class, $spreadsheetFullPath ) = @_;                      # Class name is in the first parameter
    my $self = { spreadsheetFullPath => $spreadsheetFullPath };  
    bless($self, $class);          # Say: $self is a $class

    #1 = no error
    $self->{error} = "";
    $self->{warn} = "";

    # Catch problems reading spreadsheet and populating array
    eval {
        $self->{spreadsheet} = populateArray($self,$spreadsheetFullPath);
    }; 
    if ($@) {
        $self->{error} .= "Problem returning array from populateArray class ($@).<br>";
    }

    return $self;
}

sub getData() {
    my($self) = @_;
    #TODO: right now this returns everything but ultimately this will not return Header (that will be seperate) 
    return \%{$self->{spreadsheet}};
}

# getColumn:
# pass in Object, worksheet, and columnName
sub getColumn() {
    my($self,$worksheet,$columnName) = @_;
    my @values=();
    my @tmpArray=();
    #for my $cell ( sort keys %{$self->{spreadsheet}->{ $worksheet }->{ $columnName}} ) {
    for my $cell ( keys %{$self->{spreadsheet}->{ $worksheet }->{ $columnName}} ) {
        my $value= $self->{spreadsheet}->{$worksheet}->{$columnName}->{$cell};
        my $rowcount= $self->{spreadsheet}->{$worksheet}->{"rowcount"}->{$cell};
		$tmpArray[$rowcount]=$value;
    } 
	# Need to remove first element of array
	# i don't know why an extra element was being added.
	# this is a bitof hack 
	splice (@tmpArray,0,1);
	# Sort Values and put into new array
	foreach (sort {$a <=> $b} @tmpArray) {
		push (@values, $_);
	} 
	return @values;
}

# getHeader:
# pass in Object and worksheet
sub getHeader() {
    my($self,$worksheet) = @_;
    my @header=();
    for my $list ( sort keys %{$self->{spreadsheet}->{$worksheet}}) {
        push (@header,$list);
    }
    return @header;
}

# Return error messages
sub getError {
    my $self = shift;
    return $self -> {error};
}

# Return warning messages
sub getWarn {
    my $self = shift;
    return $self -> {warn};
}

#populateArray: a method to read excel spreadsheet and return an array
sub populateArray() {
    my($self,$spreadsheetFullPath) = @_;
    my($oExcel,$oBook,$row, $iC, $oWkS, $oWkC);
    my %spreadsheet= ();
    my $count=0;
    # *********************************************
    # Create Spreadsheet Object
    # *********************************************
    eval {
        $oExcel = new Spreadsheet::ParseExcel;
    };
    if ($@) {
        $self->{error}.= "Problem creating spreadsheet object<br>";
        return 0;
    }
    # *********************************************
    # Parse Spreadsheet
    # *********************************************
    eval {
        $oBook = $oExcel->Parse($spreadsheetFullPath);
    };
    if ($@) {
        $self->{error}.= "Problem parsing spreadsheet: $spreadsheetFullPath.<br>$@<br>";
        return 0;
    }
    # *********************************************
    # Loop Spreadsheet and all workbooks
    # *********************************************
    foreach my $oWkS (@{$oBook->{Worksheet}}) {
        # *********************************************
        # Loop Each Row (start at the 2nd row)
        # *********************************************
        for(my $row = $oWkS->{MinRow} + 1; defined $oWkS->{MaxRow} && $row <= $oWkS->{MaxRow} ; $row++) {
            # *********************************************
            # First check that this whole row is valid -- must have some value somewhere!
            # *********************************************
            my $validRow = 0;
            for(my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
                eval {
                    $value=$oWkS->{Cells}[$row][$iC]->Value;
                }; if (!$@) {
                    if ($value ne "") {
                        $validRow = 1;
                    }
                }
            }
            # *********************************************
            # Loop through Row and assign values
            # *********************************************
            if ($validRow) {
                $count++;

                # initialize row
                for(my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
                    my $workbook = $oWkS->{Name};
                    my ($column,$cellValue);
                    eval {
                        $column=$oWkS->{Cells}[0][$iC]->Value;
                    }; if ($@) {
                        $self->{warn}.= "Blank column in $workbook<br>";
                    }
                    eval {
                        $cellValue = $oWkS->{Cells}[$row][$iC]->Value;
                    }; if ($@) {
                        $self->{warn}.= "Blank value in column $column<br>";
                        # need to put have empty space here otherwise it will skip column!!
                        $cellValue=" ";
                    }
                
                    if ($column && $cellValue) {
                        # this is a Hash of a Hash
                        #  {workboook} {column} {row} = $cellValue 
                        eval {
                            $spreadsheet {$workbook} {$column} {$row} = $cellValue;
                        }; if ($@) {
                            $self->{error}.= "Error populating array. column=$column and value=$cellValue. error: $@<br>";
                        }
                    }
                }
				# add a counter in the first column
                $spreadsheet {$oWkS->{Name}} {"rowcount"} {$row} = $row;
            }
        }
    }
    # *********************************************
    # Throw error if no rows found
    # *********************************************
    if ($count == 0) {
        $self->{error} .= "No rows found!<br>";
        return 0;
    }

	
    return \%spreadsheet;
}

#printAll: a method to directly read the spreadsheet and return data
#     usefull for testing
#sub printAll() {
#    my($self) = @_;
#    print "spreadsheet: ".$self->{spreadsheetFullPath}."<br>";
#    my $oExcel = new Spreadsheet::ParseExcel;
#    my $oBook = $oExcel->Parse($self->{spreadsheetFullPath});
#
#    my($iR, $iC, $oWkS, $oWkC);
#    print "=========================================<br>\n";
#    print "FILE  :", $oBook->{File} , "<br>\n";
#    print "COUNT :", $oBook->{SheetCount} , "<br>\n";
#    print "AUTHOR:", $oBook->{Author} , "<br>\n";
#    foreach my $oWkS (@{$oBook->{Worksheet}}) {
#        print "--------- SHEET:", $oWkS->{Name}, "<br>";
#        for(my $iR = $oWkS->{MinRow} ; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow} ; $iR++) {
#            for(my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol} ; $iC++) {
#                $oWkC = $oWkS->{Cells}[$iR][$iC];
#                print "( $iR , $iC ) =>", $oWkC->Value, "<br>" if($oWkC);
#                print $oWkC->{_Kind}, "<br>";
#            }
#        }
#    }
#}
