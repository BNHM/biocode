// Get 4-letter code
// TODO: this should really go in config.js section but it doesn't want to load it there
var gTrueEditing=false;  // Set to true only after a user has double clicked in a cell
var gEditing=false;
var gClicked=false;
var gCode="";
var gPassword="";
var gBatch="";
var gCollecting="";

// Parse URL for code/password
if (location.search != "") {
    var x = location.search.substr(1).split("&")
    for (var i=0; i<x.length; i++) {
        var y = x[i].split("=");

        if (y[0]=="code") {
            gCode=unescape(y[1].replace(/\+/g, " ")).toLowerCase();
            document.cookie="code=" +gCode;
        }
        if (y[0]=="password") {
            gPassword=unescape(y[1].replace(/\+/g, " "));
            document.cookie="password=" +gPassword
        }
        if (y[0]=="batch") {
            gBatch=unescape(y[1].replace(/\+/g, " "));
        }
    }
}

// If password was not on URL, then can look it up on cache
if (gPassword=="") {
    gPassword=gc('password');
}
// If code was not on URL, then look it up on cache
if (gCode=="") {
    gCode=gc('code');
}

// ***************************************
// User Configurable Variables:
// ***************************************
// CHIGNIK
if (top.location.host=="biocode.berkeley.edu:8000") {
	var gURLPath = 'http://biocode.berkeley.edu:8000/biocode_data/'; 	// The URL of where biocode_data can be found
	var gPicturesPath="/data3/biocode/photos/ID_folders";
	var gSchemaPath="/usr/local/web/test/biocode/web/fma/schemas";
} else if (top.location.host=="biocode.berkeley.edu") {
	var gURLPath = 'http://biocode.berkeley.edu/biocode_data/'; 	// The URL of where biocode_data can be found
	var gPicturesPath="/data3/biocode/photos/ID_folders";
	var gSchemaPath="/usr/local/web/test/biocode/web/fma/schemas";
} else {
	var gURLPath = '/biocode_data/'; 	// The URL of where biocode_data can be found
	var gPicturesPath="/Users/biocode/Website/biocode/web/biocode_data/pictures";
	var gSchemaPath="/Users/biocode/Website/biocode/web/fma/schemas";
}

var gPicturesDir = 'pictures/';						// The name of the pictures directory
//var gURLPath = '/Users/jdeck/Website/biocode/web/biocode_data/'; 	// The URL of where biocode_data can be found
//var gSpreadsheetsDir = 'spreadsheets/';
//var gPicturesPath="/usr/local/web/html/biocode_data/pictures";
//var gSpreadsheetsPath="/usr/local/web/html/biocode_data/spreadsheets";

var imgsPerPg = 50; // number of img elements in the html
var tPath = 'thumbs/'; 		// gallery files directory name -- 100px wide
var sPath = 'lowres/';		// small images (for slideshow) -- 400px wide
//var tPath = '/'; 		// gallery files directory name -- 100px wide
//var sPath = '/';		// small images (for slideshow) -- 400px wide
var lPath = '/';				// large images (full size)


// ***************************************
// System Variables
// ***************************************
var gCount=-9999;
var gStart=1;
var gCurrent=1;
var gCurrentSpecimenID='';

// System Variables
var galMode = true;
var ssEle;				// Slideshow Element
var galEle;				// Image Gallery Element
var navEle;				// Navigation Element
var g_arrImages; 		// Global Image Array -- this holds all of the images for a particular directory
var curStart=0;
var curEnd=imgsPerPg;

var gSpreadsheets;
var gDirectory;

var gTabGroup;

// Data Type Arrays
var gArr_lowesttaxonlevel=[ "Genus_and_Species", "Genus", "Tribe", "Subfamily", "Family", "Infraorder", "Suborder", "Ordr", "Subclass", "Class", "Phylum", "Kingdom"];
var gArr_destruct=["Y","N"];
var gArr_lowesttaxon=["Garbidae","Gallidae","Aedes","Africanus","Agyptii","Albopictus"];
gArr_Plate=["Plate_M001", "Plate_M002", "Plate_M003", "Plate_M004", "Plate_M005", "Plate_M006", "Plate_M007", "Plate_M008", "Plate_M009", "Plate_M010", "Plate_M011", "Plate_M012", "Plate_M013", "Plate_M014", "Plate_M015", "Plate_M016", "Plate_M017", "Plate_M018", "Plate_M019", "Plate_M020", "Plate_M021", "Plate_M022", "Plate_M023", "Plate_M024", "Plate_M025", "Plate_M026", "Plate_M027", "Plate_M028", "Plate_M029", "Plate_M030", "Plate_M031", "Plate_M032", "Plate_M033", "Plate_M034", "Plate_M035", "Plate_M036", "Plate_M037", "Plate_M038", "Plate_M039", "Plate_M040", "Plate_M041", "Plate_M042", "Plate_M043", "Plate_M044", "Plate_M045", "Plate_M046", "Plate_M047", "Plate_M048", "Plate_M049", "Plate_M050", "Plate_M051", "Plate_M052", "Plate_M053", "Plate_M054", "Plate_M055", "Plate_M056", "Plate_M057", "Plate_M058", "Plate_M059", "Plate_M060", "Plate_M061", "Plate_M062", "Plate_M063", "Plate_M064", "Plate_M065", "Plate_M066", "Plate_M067", "Plate_M068", "Plate_M069", "Plate_M070", "Plate_M071", "Plate_M072", "Plate_M073", "Plate_M074", "Plate_M075", "Plate_M076", "Plate_M077", "Plate_M078", "Plate_M079", "Plate_M080", "Plate_M081", "Plate_M082", "Plate_M083", "Plate_M084", "Plate_M085", "Plate_M086", "Plate_M087", "Plate_M088", "Plate_M089", "Plate_M090", "Plate_M091", "Plate_M092", "Plate_M093", "Plate_M094", "Plate_M095", "Plate_M096", "Plate_M097", "Plate_M098", "Plate_M099", "Plate_M100"];

// Get Cookies
function gc(Name) {
	var search = Name + "="
	var returnvalue = "";
	if (document.cookie.length > 0) {
		offset = document.cookie.indexOf(search)
		// if cookie exists
		if (offset != -1) {
			offset += search.length
			// set index of beginning of value
			end = document.cookie.indexOf(";", offset);
			// set index of end of cookie value
			if (end == -1) end = document.cookie.length;
			returnvalue=unescape(document.cookie.substring(offset, end))
		}
	}
	return returnvalue.toLowerCase();
}

// Set All Cookies
function setAllCookies(a) {
    for (var i in a) {
        document.cookie=i+"="+a[i];
    }
}

function cookieFormName() {
    var strCollecting="--";
    if (gBatch=="collecting") {
        strCollecting="-collecting-";
    }
    return strCollecting;
}   
    
function setWidthCookie(pIndex,value) {
    var cookie_name=gc('code')+cookieFormName()+pIndex;
    expiredays=60;
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+expiredays);
    document.cookie=cookie_name+ "=" +escape(value)+ ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
} 

// Header
function header(pApplication) {
    var strHeader="<center>";
    strHeader+="<b>"+gc('description')+"</b> ("+gc('code')+")</b>";

    strHeader+="<br><b>"+pApplication+"</b>";
    //if (gBatch=="collecting") {
     ////   strHeader+="<br><b>Collecting Events</b>";
    //} else if (gBatch!="") {
     //   strHeader+="<br><b>Specimen & Tissue Batch: "+getBatchName(gBatch)+"</b>";
    //}
    strHeader+="<br><a href='/fma/index.html?&code="+gc('code')+"'>Field Data Collecting Home</a>";

    if (gBatch!="collecting") {
        strHeader+=" | <a href='/fma/fma_form.htm?batch=collecting'>Collecting Events</a>";
    }
    strHeader+=" | <a href='/fma/photomatch.htm?code="+gc('code')+"'>"+gc('code')+" Photo Matching</a>";
    strHeader+=" | <a href='/fma/reports.htm'>Sortable grid of all batches</a>";
    strHeader+=" | <a href='http://www.itis.gov/' target='_blank'>ITIS <img src='/images/externallink.jpg' width=15 border=0></a>";
    strHeader+="</center>";
    strHeader+="<br>";
    return strHeader;
}

function getBatchName(batch) {
    var strURL="/cgi/biocode_fma_getbatch?batchname=true&batch_id="+batch+"&expedition="+gc('code');
    return xmlhttpString(strURL,"GET");
}
