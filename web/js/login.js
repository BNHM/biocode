gSpacer = "&nbsp;|&nbsp;";

// Simple cookie test
var cookieEnabled=true;
setCookie( 'test', 'none');
if (getCookie( 'test' ) ) { 
	deleteCookie('test'); 
} else {
	cookieEnabled=false;
}


function getCookie(pName) {
    var search = pName + "="
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
    return returnvalue;
}

function setCookie(pName,pValue) {
    var cookie_name=pName;
    expiredays=1;
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+expiredays);
	// do not specify cookie expirition so it is trashed when browser is closed
    document.cookie=cookie_name+ "=" +escape(pValue);
}

function deleteCookie( pName ) {
	// Repeat this several times just to be sure we eliminate cruft
	if ( getCookie( pName ) ) {
		document.cookie = pName+"="+getCookie( pName ) +";path=/;expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
	if ( getCookie( pName ) ) {
		document.cookie = pName+"="+getCookie( pName ) +";path=/;expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
	if ( getCookie( pName ) ) {
		document.cookie = pName+"="+getCookie( pName ) +";path=/;expires=Thu, 01-Jan-1970 00:00:01 GMT";
	}
}

function logControlClick(pValue) {
	if (pValue=="logout") {
		logout();
	} else {
		login();
	}
}

// logout means delete biocodeUser cookie
function logout() {
	deleteCookie("id");
	deleteCookie("biocodeUser");
	document.getElementById('identity').innerHTML='';
	document.getElementById('spacer').innerHTML='';
	document.getElementById('logcontrol').innerHTML='login';
	alert('You have now been logged out.  You will be returned to the biocode homepage');
	window.location='/index.html';
	exit;
}

// Setup form elements if user is logged in
function loginFormElements() {
	document.getElementById('identity').innerHTML='<b>'+ getCookie('biocodeUser')+'</b>';
	document.getElementById('spacer').innerHTML=gSpacer;
	document.getElementById('logcontrol').innerHTML='logout';
}

// login
function login() {
	if (!cookieEnabled) {
		alert( 'cookies are not currently enabled on this browser.  Please enable cookies and then you can use login features.' );
	} else {
		document.getElementById('loginBox').style.visibility='visible';
		checkLogin();
	}
}

function checkLogin() {
	getLists(document.loginform.login,'loginList');
	// biocodeUser cookie set
	if (getCookie('id')) {
		loginFormElements();
	}
}

