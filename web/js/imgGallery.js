/* xImgGallery, Copyright (C) 2004,2005 Michael Foster (Cross-Browser.com)
   Distributed under the terms of the GNU LGPL.
*/

function xImgGallery() {
	directory = document.getElementById('directory');
	if (directory.selectedIndex > 0) {
		gDirectoryPath=directory.options[directory.selectedIndex].value;
	} else {
		gDirectoryPath="";
	}
	ssEle = document.getElementById('slideshow');
	galEle = document.getElementById('gallery');
 	navEle = document.getElementById('navigation');
   	ssEle.style.display = 'none';
   	galEle.style.display = 'block';
   	navEle.style.display = 'block';
  	gal_initImgs(0,imgsPerPg);
  	setNav();
}

function getImgPosition(pImgSrc) {
	for (var i= 0; i<g_arrImages.length; i++) {
		if (g_arrImages[i]==pImgSrc) return i;
	}
}

// pImgSrc is either img name OR full source
// when fullSrc is true then send complete src
function gal_paint(pImgSrc,fullSrc) {
  	//next = goto the next image after the current image
	//prev = goto the image previous to the current image
	//current = goto current image
   if (fullSrc) {
  		ssEle.style.display = 'block';
    	galEle.style.display = 'none';
  		galMode = false;
		ss_setImgs(pImgSrc,true);
   } else {
  		if (galMode) {
    		ssEle.style.display = 'none';
    		galEle.style.display = 'block';
  			setNav();
  		} else {
    		ssEle.style.display = 'block';
    		galEle.style.display = 'none';
  			galMode = false;
			ss_setImgs(pImgSrc);
  			setNav();
  		}
	}
	document.getElementById('imagename').style.visibility='visible';
	document.getElementById('imagename').innerHTML=pImgSrc;
}

// SETTINGS TO USE FOR GALLERY VS. SLIDESHOW
  //var ssEle = document.getElementById('slideshow');
  //var galEle = document.getElementById('gallery');
  //var i, imgTitle, pth, img, id, src, ipp, idPrefix, imgSuffix, imgPrefix;
  //var zeros, digits, capEle, capPar;
  //if (galMode) {
  //  ipp = imgsPerPg;
  //  idPrefix = 'g';
  //  ssEle.style.display = 'none';
   // galEle.style.display = 'block';
  //  pth = gPath;
 // }
  //else {
  //  currentSlide = pCurrentSlide;
  //  ipp = 1;
  //  imgTitle = '';
  //  ssEle.style.display = 'block';
  //  galEle.style.display = 'none';
 // }

function ss_setImgs(src,fullSrc) {

  	img = document.getElementById('s1');
	if (fullSrc) {
		// don't display thumbs for full source, we want low-res
		img.src=src.replace(tPath,sPath);
	} else {
		img.src=gURLPath+ gPicturesDir+gDirectoryPath+'/'+sPath+src;
	}

 	img.style.display = 'inline';
    img.onclick = imgOnClick;
    //img.title = 'Shift-click to add image to specimen';
    img.title = src;
	img.alt=src;
}

function removeChildrenFromNode(node) {
	var len = node.childNodes.length;
	while (node.hasChildNodes()) {
	  node.removeChild(node.firstChild);
	}
}

// Initialize images and gallery
function gal_initImgs(pStart,pEnd) {

	removeChildrenFromNode(galEle);

  	var i, imgTitle, pth, img, id, src, idPrefix, imgSuffix, imgPrefix;
  	var capEle, capPar;

    idPrefix = 'g';
    //imgTitle = 'Shift-click to add image to specimen';
    imgTitle = src;
    pth = gURLPath +  gPicturesDir+  gDirectoryPath + '/' + tPath;
	// Fetch array of image src tags via ajax
  	g_arrImages = xmlhttpPostArr("/cgi/biocode_ajax.cgi?option=pics&directory="+gDirectoryPath+"&picturespath="+gPicturesPath+"&code="+gCode,"POST");
	thisCon=new Array();
	if (g_arrImages.length < 1) {
            alert('thumbnails not found in this directory.  run "resize" script in directory root');
        }
	if (pEnd > g_arrImages.length) {
		lEnd=g_arrImages.length;
	} else {
		lEnd=pEnd;
	}

	for (var i= pStart; i<lEnd; i++) {
    	src=g_arrImages[i];
 		var img = document.createElement('img');
 		img.id=src;
   		img.title = imgTitle;
   		img.alt = src;
		img.directory= gDirectoryPath;
		img.path=gURLPath+ gPicturesDir;
   		img.src =  pth + src; // img to load now
   		img.width = 80;
  		img.onerror = imgOnError;
   		img.style.cursor = 'pointer';
   		img.slideNum = i; // slide img to load onclick
   		img.onclick = imgOnClick;
   		img.style.display = 'inline';
		galEle.appendChild(img); 
  	}  

	// put clearall at end
	var ca=document.createElement('div');
	ca.className='clearAll';
	galEle.appendChild(ca);
}

function saveMsg(a) {
/*
	if (a) {
 		xGetElementById('submitmsg').innerHTML = 'Record Saved!';
	} else {
 		xGetElementById('submitmsg').innerHTML = '';
	}
*/
}

function addImage(path,src,internalid,directory) {
 	var img = document.createElement('img');
	img.src=path+'/'+tPath+src;
	bigimg=path+'/'+src;
	img.path=path;
	img.alt=src;			// photo name
	img.directory=directory;		// directory name
	img.path=path;			// root path
    img.onclick = imgOnClick;
	img.specimen=true;
	img.internalid=internalid;
	img.id=internalid;
	var msgBox = document.getElementById('msgs');
    msgBox.appendChild(img);
}

function writeMeta(pServerpath,pDirectory,pPicturename) {
/*
    // Write to meta file
    var specimen_num_collector= xGetElementById('specimen_num_collector').innerHTML;
    var enteredby= xGetElementById('diventeredby').innerHTML;
	var sessionid=getCookie('id');
    var internalid=xmlhttpString("/cgi/biocode_ajax.cgi?value="+gValue+"&option=write&specimen_num_collector="+specimen_num_collector+"&enteredby="+enteredby+"&picturename="+pPicturename+"&directory="+pDirectory+"&remove=no&serverpath="+pServerpath+"&sessionid="+sessionid,"POST");
    return internalid;
*/
}

// Remove Images using the "Delete" option in Match List
function listRemove(internalid) {
 	if(confirm('Do you want to remove this image from this specimen?')) {
		removeMeta(internalid);
		listMeta();
		removeImage(document.getElementById(internalid));
	}
}

// Remove MetaData by clicking Image
function removeMeta(internalid) {
	if (!specimen_num_collector) 
    	var specimen_num_collector= xGetElementById('specimen_num_collector').innerHTML;
	if (!enteredby)
    	var enteredby= xGetElementById('enteredby').innerHTML;

 	var results=xmlhttpString("/cgi/biocode_ajax.cgi?option=write&internalid="+internalid+"&remove=yes"+"&sessionid="+getCookie('id'),"POST");

	if (results!=0) {
		if (results==10 || results==20) {
			alert('Unable to remove data from metaFile, notifiy administrator.  error='+results);
		} else if (results==30) {
			alert('No matching record found in local database');
		} else {
			alert(results);
		}
	}
}

function removeImage(a) { 
	a.parentNode.removeChild(a); 
}

// Click an image to send it to list of photos i want to keep
function imgOnClick(e) {
	// TODO: detect specific keystrokes.  These doesn't work so well in firefox, but shift & alt keys work OK
  	 if (e.shiftKey) {
		alert('functionality removed');
   	} else if (e.altKey) {
		alert('no action defined for alt key yet');
   	} else if (e.ctrlKey) {
		alert('no action defined for control key yet');
   	//} else if (galMode) {
   	} else {
		if (galMode) galMode=false;
		
		// load the directory associated with this picture when someone clicks it
		directoryInt=0;
		if (document.getElementById('directory').value!=this.directory) {
			directoryInt=getDirectoryInt(this.directory);
			if (directoryInt>=0) {
				document.myform.directory.selectedIndex=directoryInt;
				xImgGallery();
			}
		}
		// error getting directory
		if (directoryInt==-1) {
			alert('Photo associated with this thumbnail cannot be found (directory='+this.directory+')');
		} else {
 			document.getElementById('navigation').style.visibility='visible';
			gal_paint(this.alt);
		}
  	}
}
function getDirectoryInt(pDirectory) {
    arrDir=pDirectory.split('-');
    getDirectory(arrDir[0]);
    arrDir=document.myform.directory.options;
    for (var i=0; i<arrDir.length; i++) {
        if (arrDir[i].value==pDirectory) {
	    return i;
        }
    }
    return -1;
}

function imgOnError() {
  var p = this.parentNode;
  if (p) p.style.display = 'none';
}

function setNav() {
  	// Next
  	var e = document.getElementById('next');

	e.onclick = next_onClick;
    e.style.display = 'inline';

  	// Previous
  	e = document.getElementById('prev');
  	e.style.display = 'inline';
  	e.onclick = prev_onClick;

  	// Back
  	e = document.getElementById('back');
  	if (!galMode) {
    	e.onclick = back_onClick;
    	e.style.display = 'inline';
  	}
  	else {
   	 	e.style.display = 'none';
  	}
}

function mainmenu_onClick() {
	window.location = "/index.html";
}
function spreadsheet_onClick(pBoo) {
	alert('Spreadsheet View not yet implemented');
}

function next_onClick(e) { 
	if (galMode) {
		curStart=curEnd;
		curEnd=curEnd+imgsPerPg;
		gal_initImgs(curStart,curEnd);
		alt = document.getElementById('s1').alt;
	} else {
		alt = document.getElementById('s1').alt;
		var pos=getImgPosition(alt)+1;	
		if (pos >= g_arrImages.length) {
			pos=g_arrImages.length-1;
			alert('this is the last image');
		}
		gal_paint(g_arrImages[pos]); 
	}
}

function prev_onClick(e) { 
	if (galMode) {
		curStart=curStart-imgsPerPg;
		curEnd=curStart+imgsPerPg;
		if (curStart< 0) {
			curStart=0; 
			curEnd=imgsPerPg;
		}
		gal_initImgs(curStart,curEnd);
	} else {
		alt = document.getElementById('s1').alt;
		var pos=getImgPosition(alt)-1;	
		if (pos <= 0) {
			pos=0;
			alert('no images before this one');
		}
		gal_paint(g_arrImages[pos]); 
	}
}

function back_onClick(e) {
  	galMode = true;
  	gal_paint('current');
	document.getElementById('imagename').style.visibility='hidden';
}

/* xGetURLArguments and xPad are part of the X library,
   distributed under the terms of the GNU LGPL,
   and maintained at Cross-Browser.com.
*/
function xGetURLArguments() {
  var idx = location.href.indexOf('?');
  var params = new Array();
  if (idx != -1) {
    var pairs = location.href.substring(idx+1, location.href.length).split('&');
    for (var i=0; i<pairs.length; i++) {
      nameVal = pairs[i].split('=');
      params[i] = nameVal[1];
      params[nameVal[0]] = nameVal[1];
    }
  }
  return params;
}

function xPad(str, finalLen, padChar, left) {
  if (typeof str != 'string') str = str + '';
  if (left) { for (var i=str.length; i<finalLen; ++i) str = padChar + str; }
  else { for (var i=str.length; i<finalLen; ++i) str += padChar; }
  return str;
}

function pausecomp(millis) {
    var date = new Date();
    var curDate = null;

    do { curDate = new Date(); }
    while(curDate-date < millis);
}
