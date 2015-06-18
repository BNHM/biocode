// Populate Option List for each type of call
function getLists(Select,Call,selected) {
	strVal = "";
	if (Call == "photographerList") {
    	strVal="/cgi/biocode_ajax.cgi?option="+Call+"&picturespath="+gPicturesPath;
	} else {
    	strVal="/cgi/biocode_ajax.cgi?option="+Call;
	}
    data=populateSelects(strVal);
    Select.options.length=0;
    for ( var i=0; i < data.length; i++ ){
        if (data[i]!=0 && data[i]!="") {
            arrFields = data[i].split( ";" );
            if (arrFields[1]!="") {
                Select.options[i+1]=new Option(arrFields[0]);
                Select.options[i+1].value=arrFields[1];
                // Photomatcher can be called with name in the URL and so we want this to also populate getDirectory
                if (selected==arrFields[1] && Call=="photographerList") {
                    getDirectory(arrFields[1]);
                    Select.options[i+1].selected=true;

					// Loop through and assign a directory name here if the user poassed it in
					// (it would exist in the gDirectory global variable)
					DirectorySelect=document.myform.directory;
    				for ( var i=0; i < DirectorySelect.length; i++ ){
						if (DirectorySelect.options[i].value == gName+"-"+gDirectoryParam) {
							DirectorySelect.options[i].selected=true;
							xImgGallery();
							if (gPhotoParam != "") {
								galMode = false;
								gal_paint(gPhotoParam);
							}
							// page kept re-loading over and over in this routine so inserting this stopped this behaviour
							return false;
						}
					}
                }
            }
        }
    }
}

function populateSelects(a) {
    //strVal=xmlhttpString("/cgi/biocode_ajax.cgi?option="+a+"&picturespath="+gPicturesPath,"POST");
    strVal=xmlhttpString(a,"POST");
    if (strVal==990) {
        alert("trouble populating lookup lists.  This may mean the localhost computer may have a severed internet connection.");
    }
    arrNames = strVal.split( "|" );
    return arrNames;
}

function getDirs(a,b) {
	strVal=xmlhttpString("/cgi/biocode_ajax.cgi?code="+gc('code')+"&option="+a+b,"POST");
	arrNames = strVal.split( "|" );
	return arrNames;
}

function loadSpecimens(a) {
    gOption=a;
	clearThumbs();
	document.getElementById('rightContent').style.visibility='visible';

	// Reset other form elements
	switch (gOption) {
   		case 'entered_specimen_num_collector': 
			document.myform.enteredby.value="";
			document.myform.plate.value="";
			if (document.myform.entered_specimen_num_collector.value == "" && gSpecimenParam != "") {
				gValue=gSpecimenParam;
			} else {
				gValue=document.myform.entered_specimen_num_collector.value;
			}
			break;
  		case 'enteredby':
			document.myform.plate.value="";
			document.myform.entered_specimen_num_collector.value="";
			gValue=document.myform.enteredby.value;
			break;
        case 'format_name96':
			document.myform.enteredby.value="";
			document.myform.entered_specimen_num_collector.value="";
			gValue=document.myform.plate.value;
			break;
	}

	if (gCount=-9999) {
		gCount=xmlhttpString("/cgi/biocode_ajax.cgi?option="+gOption+"&value="+gValue+"&count=yes","POST");
	} 
	gCurrent=1;
	myString=xmlhttpString("/cgi/biocode_ajax.cgi?option="+a+"&value="+gValue+"&index="+gCurrent+"&count=no","POST");
	document.getElementById('specimentab').innerHTML='Specimen';
	populateSpecimen(myString);
}

function getHead(a) {
	if (arrHead[a]) {
		strRet=arrHead[a];
	} else {
		strRet="";
	}
	return strRet;
}

function getData(a) {
	if (arrData[a]) {
		strRet=arrData[a];
	} else {
		strRet="";
	}
	return strRet;
}

function listDetails() {
	strVal=xmlhttpString("/cgi/biocode_ajax.cgi?code="+gc('code')+"&option="+gOption+"&value="+gValue+"&index="+gCurrent+"&all=yes","POST");
	//arrContent=strVal.split( "\n" );
	//arrHead = arrContent[0].split( "|" );
	//arrData = arrContent[1].split( "|" );
	//content="<table>";
	//for (var i=0; i < arrHead.length; i++) {
	//	content+="<tr><td><b>"+getHead(i)+"</b></td><td>"+getData(i)+"</td></tr>";
	//}
	//content+="</table>";
	//document.getElementById('details').innerHTML=content;
	document.getElementById('details').innerHTML=strVal;
}

function populateSpecimen(pString) {
	arrContent=pString.split( "\n" );
	arrHead = arrContent[0].split( "|" );
	arrData = arrContent[1].split( "|" );

	// Clear out old values
	document.getElementById('field2head').innerHTML="";
	document.getElementById('field2').innerHTML="";
	document.getElementById('field3head').innerHTML="";
	document.getElementById('field3').innerHTML="";
	document.getElementById('field4head').innerHTML="";
	document.getElementById('field4').innerHTML="";
	document.getElementById('field5head').innerHTML="";
	document.getElementById('field5').innerHTML="";

	for (var i=0; i < arrHead.length; i++) {
		// Validate Data

		// Mandatory Fields To Display
		if (arrHead[i]=="msg") specimenmsg=getData(i);

/*
 		if (document.getElementById('batch').value == "collecting") {
			if (arrHead[i]=="EnteredBy") enteredby=getData(i);
			if (arrHead[i]=="Coll_EventID_collector") specimen_num_collector=getData(i);

			// Potential for User Definitions
			if (arrHead[i]=="Collector") {
				document.getElementById('field2head').innerHTML=arrHead[i]+": ";
				document.getElementById('field2').innerHTML=getData(i);
			}
			if (arrHead[i]=="Locality") {
				document.getElementById('field3head').innerHTML=arrHead[i]+": ";
				document.getElementById('field3').innerHTML=getData(i);
			}
			if (arrHead[i]=="DecimalLatitude") {
				document.getElementById('field4head').innerHTML=arrHead[i]+": ";
				document.getElementById('field4').innerHTML=getData(i);
			}
			if (arrHead[i]=="DecimalLongitude") {
				document.getElementById('field5head').innerHTML=arrHead[i]+": ";
				document.getElementById('field5').innerHTML=getData(i);
			}

		} else {
*/
			if (arrHead[i]=="EnteredBy") diventeredby=getData(i);
			if (arrHead[i]=="Specimen_Num_Collector") specimen_num_collector=getData(i);

			// Potential for User Definitions
			if (arrHead[i]=="IdentifiedBy") {
				document.getElementById('field2head').innerHTML=arrHead[i]+": ";
				document.getElementById('field2').innerHTML=getData(i);
			}
			if (arrHead[i]=="LowestTaxon") {
				document.getElementById('field3head').innerHTML=arrHead[i]+": ";
				document.getElementById('field3').innerHTML=getData(i);
			}
			if (arrHead[i]=="MorphoSpecies") {
				document.getElementById('field4head').innerHTML=arrHead[i]+": ";
				document.getElementById('field4').innerHTML=getData(i);
			}
			if (arrHead[i]=="Notes") {
				document.getElementById('field5head').innerHTML=arrHead[i]+": ";
				document.getElementById('field5').innerHTML=getData(i);
			}
			if (arrHead[i]=="HoldingInstitution") holdinginstitution=getData(i);
//		}
	}

	//uniqueid = enteredby+"_"+collectors_id;

	// Fill out collecting data
/*
 	if (document.getElementById('batch').value == "collecting") {
		document.getElementById('specimenmsg').innerHTML=specimenmsg;
		document.getElementById('diventeredby').innerHTML=diventeredby;
		document.getElementById('specimen_num_collector').innerHTML=specimen_num_collector;
	} else {
*/
		document.getElementById('specimenmsg').innerHTML=specimenmsg;
		document.getElementById('diventeredby').innerHTML=diventeredby;
		document.getElementById('specimen_num_collector').innerHTML=specimen_num_collector;
//	}

	// Search for pictures associated with this specimen
	var strPhotos=xmlhttpString("/cgi/biocode_ajax.cgi?value="+gValue+"&option=meta&specimen_num_collector="+specimen_num_collector+"&enteredby="+diventeredby+"&getspecimen=yes&serverpath="+gURLPath+gPicturesDir+"&picturespath="+gPicturesPath,"POST");

    if (strPhotos != "") {
		var arrPhotos=strPhotos.split("|");
		// loop all photos that were returned
    	for (var i=0; i<arrPhotos.length; i++) {
			if (arrPhotos[i]) {
				// double semicolon here because some photos have semicolons
				var photoComponents=arrPhotos[i].split(";;");
				// split path string to get src element at end
				pathArr=photoComponents[1].split("/");
				// check to be sure there is a value
				if (pathArr[pathArr.length-1] != "") {
					// reconstruct path element
					strPath="";
    				for (var j=0; j<pathArr.length-1; j++) {
						strPath+=pathArr[j]+"/";
					}
					addImage(strPath,pathArr[pathArr.length-1],photoComponents[0],photoComponents[2]);
				}
			}
		}
    }
}

function save_onClick() {
    alert('save this record');
}
function prevspecimen_onClick() {
	//var sd=document.getElementById('specimenData');
	gCurrent--;
	if (!checkCount()) {
		alert('at beginning of set already');
		gCurrent++;
	} else {
		clearThumbs();
		//sd.innerHTML=xmlhttpPostArr("/cgi/biocode_ajax.cgi?option=spreadsheet&spreadsheet="+gSpreadsheet+"&index="+gCurrent+"&code="+gc('code'));
		populateSpecimen(xmlhttpString("/cgi/biocode_ajax.cgi?option="+gOption+"&value="+gValue+"&index="+gCurrent+"&code="+gc('code'),"POST"));
	}
}
function gotoSpecimen(r) {
	clearThumbs();
	gCurrent=r;
	// Selected the specimen tab
	gTabGroup.select(1);
	populateSpecimen(xmlhttpString("/cgi/biocode_ajax.cgi?option="+gOption+"&value="+gValue+"&index="+gCurrent+"&code="+gc('code'),"POST"));
}
function nextspecimen_onClick() {
	//var sd=document.getElementById('specimenData');
	gCurrent++;
	if (!checkCount()) {
		alert('no more records');
		gCurrent--;
	} else {
		clearThumbs();
		//sd.innerHTML=xmlhttpPostArr("/cgi/biocode_ajax.cgi?option=spreadsheet&spreadsheet="+gSpreadsheet+"&index="+gCurrent+"&code="+gc('code'));
		populateSpecimen(xmlhttpString("/cgi/biocode_ajax.cgi?option="+gOption+"&value="+gValue+"&index="+gCurrent+"&code="+gc('code'),"POST"));
	}
}   
function checkCount() {
	if (gCurrent > gCount) return false;
	if (gCurrent < 1) return false;
	return true;
}

// Clear all thumbs from the msg box
function clearThumbs() {
    var msgBox = document.getElementById('msgs');
    if ( msgBox.hasChildNodes() ) {
        while ( msgBox.childNodes.length >= 1 ) {
            msgBox.removeChild( msgBox.firstChild );
        }
    }
}
