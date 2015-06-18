function listMeta() {
	document.getElementById('meta').innerHTML=xmlhttpString("/cgi/biocode_ajax.cgi?option=meta&server="+gURLPath+ gPicturesDir+"&picturespath="+gPicturesPath+"&code="+gc('code'),"POST");
}
