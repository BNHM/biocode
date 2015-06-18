// photo_upload functions and variables
import flash.events.*;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.net.URLRequest;
import flash.net.URLVariables;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

//import flash.filesystem.*;

import mx.collections.IViewCursor;

import mx.collections.ArrayCollection;
import mx.containers.FormItem;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.DataGrid;
import mx.controls.ProgressBar;
import mx.controls.TextInput;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.dataGridClasses.*;
import mx.events.CollectionEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ObjectUtil;;

// Ajax imports for Synchronous data calls via javascript
import AjaxRequestType;
import Ajax;

//SET AppID to correct one for this upload utility
private var _appID:String = '1';

private var _noFilesMessage:String = "Unable to parse a specimen_num_collector";

private var fileRef:FileReference;
public var _datagrid:DataGrid ;
private var _browsebutton:Button = BrowseBTN ;

private var _progressbar:ProgressBar = progressBar;

//dictionary object to store metadata validation types
private var validationTypes:Object = new Object();  
  
//File Reference Vars
[Bindable]
private var _files:ArrayCollection;
private var _selectedFiles:Array;
public var _fileref:FileReferenceList
//public var _file:FileReference;
private var _uploadURL:URLRequest;
private var  _totalbytes:Number;
   
                        
// Set the File Filters you wish to impose on the applicaton
public var imageTypes:FileFilter = new FileFilter("Images (*.jpg; *.jpeg;)" ,"*.jpg; *.jpeg;");
    
// Place File Filters into the Array that is passed to the MultiFileUpload instance
public var filesToFilter:Array = new Array(imageTypes);
private var _filefilter:Array = filesToFilter ;
                       
public function initApp(dataGrid:DataGrid, browseButton:Button):void{
    var postVariables:URLVariables = new URLVariables;
    postVariables.projectID = 55;
    postVariables.test ="Hello World";  
    _totalbytes = 0;
    _datagrid = dataGrid ;
    _browsebutton = browseButton ;
                
    // Setup File Array Collection and FileReference
    _files = new ArrayCollection();
    _fileref = new FileReferenceList;
    _browsebutton.addEventListener(MouseEvent.CLICK, browseFiles);
    _fileref.addEventListener(Event.SELECT, selectHandler);
    _files.addEventListener(CollectionEvent.COLLECTION_CHANGE,popDataGrid);

    // Set Up Progress Bar UI
    _progressbar = progressBar ;
    _progressbar.mode = "manual";
    _progressbar.label = "";

    // Set Up DataGrid UI
    filesDG.dataProvider = _files ;

    // Set Up URLRequest
    _uploadURL = new URLRequest;
    _uploadURL.url = "/cgi/photo.cgi";
    _uploadURL.contentType = "multipart/form-data";
    _uploadURL.method = "POST";  // this can also be set to "POST" depending on your needs 
    _uploadURL.contentType = "multipart/form-data";

    UploadBTN.enabled = false;
}
           
           
private function traceEvent(event:Event):void {
    var tmp:String = "================================\n";
    ta.text += tmp + event.type + " event:" + mx.utils.ObjectUtil.toString(event) + "\n" ;
    ta.verticalScrollPosition += 20;
}

private function traceString (newstr:String):void {
    var tmp:String = "================================\n";
    ta.text += tmp + newstr  + "\n";
    ta.verticalScrollPosition += 20;
}
        
private function ioErrorEvent(event:IOErrorEvent):void{
    Alert.show("IOError:" + event.text);
    traceEvent(event);
}
        
public function selectEvent(event:Event):void{
    //traceEvent(event);
    progressBar.setProgress(0, 100);
    progressBar.label = "Loading 0%";            
}
    
private function progressEvent(event:ProgressEvent):void {
    progressBar.setProgress(event.bytesLoaded, event.bytesTotal);
    traceEvent(event);
}
    
private function completeEvent(event:Event):void {
    progressBar.label = "Complete.";
    traceEvent(event);
    btn_cancel.enabled = false;
}
        
private function uploadFile(endpoint:String):void {
    var param:String = "author=";
    var req:URLRequest = new URLRequest(endpoint);
    req.method = URLRequestMethod.POST;
    fileRef.upload(req, param, false); 
    progressBar.label = "Uploading...";        
    btn_cancel.enabled = true;
}
        
public function browseFiles(event:Event):void{        
   _fileref.browse(_filefilter);
}

// TESTING ONLY FOR NOW
//private var stream:FileStream;

public function uploadFiles():void{
//// TESTING ONLY FOR NOW
//var file:File = File.documentsDirectory;
//file = file.resolvePath("AIR Test/testFile.txt");
//var stream:FileStream = new FileStream()
//stream.open(file, FileMode.WRITE);
//var str:String = "Here is some text to send to a file";
//stream.writeUTFBytes(str);
//stream.close();

    UploadBTN.enabled = false;
    var allValid:Boolean = uploadAddData();
    if(allValid == false){
        UploadBTN.enabled = true;
        return;
    }



	// Check to see if all filenames are valid for specimen_num_collector matching 
	// -- if there are any filenames unmatcheable then it kicks out error
	//if(specimen_num_collector_match.selected == true) { 

  var dp:Object=filesDG.dataProvider;
      var cursor:IViewCursor=dp.createCursor();
      while( !cursor.afterLast ) {
        if (cursor.current.specimen_num_collector == _noFilesMessage) {
 	     	UploadBTN.enabled = true;
			Alert.show('Filename parsing checkbox is selected and one or more files could not be parsed.  All files must be parseable.  Check the Specimen_Num_Collector column in the datagrid for any unmatcheable filenames and fix them or remove them.');
			return;
		}
        // Obviously don't forget to move to next row:
        cursor.moveNext();
      }

	//} 

    if (_files.length > 0){                
        var _fileObj:Object = _files.getItemAt(0);  
        var _file:FileReference = _fileObj.object ;
        traceString("Uploading file "+_file.name);  
        _file.addEventListener(Event.OPEN, openHandler);
        _file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        _file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeDataHandler);
        _file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
        _file.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
        _file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
    
        _file.upload(_uploadURL);
    }

}

// Parse metadata fields and generate a string to send in POST
// with images for upload
private function uploadAddData():Boolean {
    var dataStr:String = new String();
    _uploadURL.data = new URLVariables();

    // NOTE: Validation is all performed in photo.cgi script
    // Construct GET portion of CGI request
    dataStr += "photographer=" + escapeMultiByte(photographerName)+"&";
    dataStr += escapeMultiByte(directory.name) + "=" + escapeMultiByte(directory.text)+"&";
    dataStr += escapeMultiByte(cameratype.name) + "=" + escapeMultiByte(cameratype.text)+"&";
    dataStr += escapeMultiByte(phototype.name) + "=" + escapeMultiByte(phototype.text)+"&";
    dataStr += escapeMultiByte(begin_date.name) + "=" + escapeMultiByte(begin_date.text)+"&";
    dataStr += escapeMultiByte(end_date.name) + "=" + escapeMultiByte(end_date.text)+"&";
	//if(specimen_num_collector_match.selected == true) { 
    	dataStr += "specimen_num_collector_match=true&";
    //} else {
    //	dataStr += "specimen_num_collector_match=false&";
	//}

    _uploadURL.data.infos = dataStr;
    traceString("dataStr set to "+_uploadURL.data.infos);
    return true;
}
       
        
//Remove Selected File From Cue
private function removeSelectedFileFromCue(event:Event):void{
    if (_datagrid.selectedIndex >= 0){
        _files.removeItemAt( _datagrid.selectedIndex);
    }
}
        
        public function clearSelected():void{
            if (filesDG.selectedIndex >= 0){
            _files.removeItemAt( filesDG.selectedIndex);
            }
        }
        
        public function clearAll():void{
            _files.removeAll();
            UploadBTN.enabled = false;
            UploadBTN.label = "No Files Selected";
        }


         //Remove all files from the upload cue;
        private function clearFileCue(event:Event):void{
       
            _files.removeAll();
        }
        
        //label function for the datagird File Size Column
        private function bytesToKilobytes(data:Object):String {
            var kilobytes:String;
            kilobytes = String(Math.round(data.size/ 1024)) + ' kb';
            return kilobytes
        }
        
        // Feed the progress bar a meaningful label
        private function getByteCount():void{
            var i:int;
            _totalbytes = 0;
                for(i=0;i < _files.length;i++){
                _totalbytes +=  _files[i].size;
                }
            _progressbar.label = "Total Files: "+  _files.length+ " Total Size: " + Math.round(_totalbytes/1024) + " kb"
        }    
        
        private function resetForm():void{
           // _uploadbutton.enabled = false;
            _progressbar.maximum = 0;
            _totalbytes = 0;
            _progressbar.label = "";
            _browsebutton.enabled = true;
        }   
        
        private function popDataGrid(event:CollectionEvent):void{                
            getByteCount();
        }
        

     public function selectHandler(event:Event):void {
    		traceString("In selectHandler Event");  
            var i:int;
			var strNames:String;
			var strResult:String;

			// Loop files and return matches for all files just entered
            for (i=0;i < event.currentTarget.fileList.length; i ++){
                var fileCheck:FileReference = FileReference(event.currentTarget.fileList[i]);
				strNames+=fileCheck.name+"|";
			}
			// check to see if this name is a parseable specimen_num_collector
			// NOTE: this is a bit inefficient to check every single time but easier to go for now
			// to speed things up better to send one check for all files added
/*
  			var url:String = '/cgi-bin/biocode_checkfiles';//?names='+strNames;
        	var ajax:Ajax = new Ajax(url);
        	ajax.requestType = AjaxRequestType.POST;
        	ajax.async = false;               
			strResult=ajax.send('"names='+strNames+'"');

			var specimen_match:Array=strResult.split("|");
*/

			// Loop files and add to _files object
            for (i=0;i < event.currentTarget.fileList.length; i ++){
				// get file name and size information
                var file:FileReference = FileReference(event.currentTarget.fileList[i]);
                var kilob:String = bytesToKilobytes(file);
//				var specimen_num_collector_responsetext:String = specimen_match[i];
				var array:Array=file.name.split("+");
				var specimen:String=array[0];

				//if (specimen_num_collector_responsetext == "-9999") {
				//		specimen_match[i]=_noFilesMessage;
				//}
           		//_files.addItem({name:file.name, size:kilob, specimen_num_collector:specimen_match[i], object:file});
           		_files.addItem({name:file.name, size:kilob, specimen_num_collector:specimen, object:file});
                traceString("Added photo: "+file.name); 
            }

            UploadBTN.enabled = true;
           	UploadBTN.label = "Upload Files";                 
                     
           	filesDG.dataProvider = _files ;                         
        } 
        
       
       // called after the file is opened before upload    
        private function openHandler(event:Event):void{
            //traceString('openHandler triggered\n');
            _files;
        }
        
        // called during the file upload of each file being uploaded | we use this to feed the progress bar its data
        private function progressHandler(event:ProgressEvent):void {        
            _progressbar.setProgress(event.bytesLoaded,event.bytesTotal);
            _progressbar.label = "Uploading " + Math.round(event.bytesLoaded / 1024) + " kb of " + Math.round(event.bytesTotal / 1024) + " kb " + (_files.length - 1) + " files remaining";
        }

        private function completeDataHandler(event:Event):void{
            
            var uploadOK:int = checkUploadResponse(event.toString());
            if(uploadOK < 1){ 
                _progressbar.label = "Uploads Encountered Errors";
                return ;
                 }
            _files.removeItemAt(0);
            if (_files.length > 0){
                _totalbytes = 0;
                uploadFiles();
            }else{
                 _progressbar.label = "Uploads Complete";
                 var uploadCompleted:Event = new Event(Event.COMPLETE);
                dispatchEvent(uploadCompleted);
				photo_email.send();
            }
            UploadBTN.enabled = true ;
        }  
        
        private function checkUploadResponse(response:String):int {
            var _fileObj:Object = _files.getItemAt(0);  
            var _file:FileReference = _fileObj.object ;
            if(response.search("<metadata>") > 0){ 
                traceString(_file.name+" uploaded\n");
                return 1;
                }
   
            if(response.search("<Error>")){
                //Alert.show("Found error message..splitting now");
                var respAr:Array = response.split("Message>");
                var respMsg:String = respAr[1].toString().slice(0,-3);
                Alert.show("Unable to upload "+_file.name+": "+respMsg);
                traceString("UPLOAD FAILED FOR "+_file.name
                            +": "+respMsg+"\n");
                UploadBTN.enabled = true ;
                return 0;
            }
            return 0;
        }
          
        // only called if there is an  error detected by flash player browsing or uploading a file   
        private function ioErrorHandler(event:IOErrorEvent):void{
            //trace('And IO Error has occured:' +  event);
            mx.controls.Alert.show(String(event),"ioError",0);
            UploadBTN.enabled = true ;
        }    
        // only called if a security error detected by flash player such as a sandbox violation
        private function securityErrorHandler(event:SecurityErrorEvent):void{
            //trace("securityErrorHandler: " + event);
            mx.controls.Alert.show(String(event),"Security Error",0);
            UploadBTN.enabled = true ;
        }
        
        //  This function its not required
        private function cancelHandler(event:Event):void{
            // cancel button has been clicked;
            traceString('cancelled upload\n');
            UploadBTN.enabled = true ;
        }
        
        //  after a file upload is complete or attemted the server will return an http status code, code 200 means all is good anything else is bad.
        private function httpStatusHandler(event:HTTPStatusEvent):void {
            if (event.status != 200){
                mx.controls.Alert.show(String(event),"Error",0);
            }
        }
        
        //parse the xml returned from perl backend and update the app config
        // Pretty sure i don't even need this anymore
        public function configUpdate(xmlResult:XMLDocument):XMLNode {
            var configCollection:ArrayCollection = new ArrayCollection();
            var i:int;
            var j:int;
/*
            var name = 'uploadedby';
            var ubForm:FormItem = new FormItem();
            ubForm.label='Uploaded By:';
            ubForm.name = 'frmAttributes';
            ubInput:TextInput = new TextInput();

            ubInput.id="text"+name;
            ub.width='100';
            ubInput.name=name;
            ubInput.text='';
            validationTypes[tmpInput.name] = '[\s\w\d]+';
            ubForm.addChild(ubInput);
*/

            var tmpNode:XMLNode ;
            var tmpOptionNode:XMLNode ;
            UploadBTN.enabled = true;
            var xmlDecoder:SimpleXMLDecoder = new SimpleXMLDecoder();
            if(xmlResult.firstChild.nodeName == 'Error'){
                //received xml error
                mx.controls.Alert.show("Error retrieving configuration data\n"+xmlResult.firstChild.firstChild.toString());
                return xmlResult.firstChild;
            }
            //mx.controls.Alert.show("parsing "+xmlResult.firstChild.childNodes[1].childNodes.length+" configuration details");
            for (i=0;i < xmlResult.firstChild.childNodes[1].childNodes.length; i ++){
                tmpNode = xmlResult.firstChild.childNodes[1].childNodes[i];
                var tmpForm:FormItem = new FormItem() ;
                tmpForm.label = tmpNode.attributes.label ;
                tmpForm.name = 'frmAttributes';
                if(tmpNode.attributes.type == "text"){
                    // Input box
                    var tmpInput:TextInput = new TextInput();
                    tmpInput.id = "text"+i ;            
                    tmpInput.width = tmpNode.attributes.width ;
                    tmpInput.name = tmpNode.attributes.mysql_name ;
                    tmpInput.text=tmpNode.attributes.default;
                    if(tmpNode.attributes.validation ){
                        validationTypes[tmpNode.attributes.mysql_name] = tmpNode.attributes.validation ;
                    }
                    tmpForm.addChild(tmpInput);
                } else if (tmpNode.attributes.type == "uploadedby") {
//                    var tmpComboBox:ComboBox;
//
//                    tmpComboBox.enabled=true;
//                    tmpComboBox.id='uploadedby';
//                    for (j=0;j < tmpNode.childNodes.length; j ++){
//                        // The option value (populated from perl)
//                        tmpOptionNode = tmpNode.childNodes[j];
//                        //tmpComboBox.addItem({data:j, label:tmpOptionNode.attributes.value});
//                        //tmpComboBox.addItem(tmpOptionNode.attributes.value);
//                        // Add each item to the combobox
//                        tmpComboBox.addItemAt(j,"hello");
//
 //                       traceString(tmpOptionNode.attributes.value);
 //                   }
                    //#tmpComboBox.addChild(tmpArrayColl);
                    traceString(tmpForm.label+" is a "+tmpNode.attributes.type);
 //                   tmpForm.addChild(tmpComboBox);

                } else { 
                    traceString(tmpForm.label+" is a "+tmpNode.attributes.type);
                }

                pnCustom.addChild(tmpForm);
                pnCustom.height += 40;
                traceString("Adding element "+tmpForm.label);
            }

            return xmlResult.firstChild ;
        }
