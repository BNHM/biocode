function xmlhttpString(strURL,pGETPOST) {
    var xmlHttpReq = false;
    var self = this;
    // Mozilla/Safari
    if (window.XMLHttpRequest) {
        self.xmlHttpReq = new XMLHttpRequest();
    }
    // IE
    else if (window.ActiveXObject) {
        self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
    // sync request to wait for all names to come in
    self.xmlHttpReq.open(pGETPOST, strURL, false);
    self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    // This line resulted in just biocode.berkeley.edu (not :8000 instance) throwing error
    //self.xmlHttpReq.send(null);
    self.xmlHttpReq.send("");
    var content=self.xmlHttpReq.responseText;
    return content;
}

function xmlhttpPostArr(strURL) {
    var xmlHttpReq = false;
    var self = this;
    // Mozilla/Safari
    if (window.XMLHttpRequest) {
        self.xmlHttpReq = new XMLHttpRequest();
    }
    // IE
    else if (window.ActiveXObject) {
        self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
    // sync request to wait for all names to come in
    self.xmlHttpReq.open('POST', strURL, false);
    self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    self.xmlHttpReq.send(null);
    var content=self.xmlHttpReq.responseText;
    arrContent=content.split( "|" ); 
    return arrContent;
}

function getquerystring() {
    var form     = document.forms['f1'];
    var word = form.word.value;
    qstr = 'w=' + escape(word);  // NOTE: no '?' before querystring
    return qstr;
}

function updatepage(str){
    document.getElementById("result").innerHTML = str;
}
