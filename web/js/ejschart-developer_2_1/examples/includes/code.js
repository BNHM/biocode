if (window.attachEvent) {
	window.attachEvent("onload", displayCode);
	window.attachEvent("onload", displayData);
} else {
	window.addEventListener("load", displayCode, false);
	window.addEventListener("load", displayData, false);
}

function randomArray(count, min, max, labels, data, interval, start_x) {
	if (count == undefined) { count = 10; }
	if (count == "seconds") { count = 10; interval = 1000; }
	if (count == "minutes") { count = 10; interval = (1000*60); }
	if (count == "hours") { count = 10; interval = (1000*60*60); }
	if (count == "days") { count = 10; interval = (1000*60*60*24); }
	if (min == undefined) { min = -10; }
	if (max == undefined) { max = 90; }
	if (labels == undefined) { labels = false; }
	if (data == undefined) { data = false; }
	if (interval == undefined) { interval = 1; }
	if (start_x == undefined) { start_x = 0; }
	var result = [];
	var point;
	var difference = max - min;
	for (var i = 0; i < count; i++) {
		point = [start_x + (i * interval),(Math.random(difference)*difference)+min];
		if (labels) {
			point.push("Label " + i);
		} else {
			point.push(null);
		}
		if (data) {
			point.push("Data " + i);
		} else {
			point.push(null);
		}
		result.push(point);
	}
	return result;
}				


function displayCode() {

	var scripts = document.getElementsByTagName("script");
	for (var i = 0; i < scripts.length; i++) {
		if (scripts[i].id) {
			var match = scripts[i].id.match(/script([0-9]+[a-zA-Z]+)/);
			if (match == null) { continue; }
			
			var code = document.getElementById("code" + match[1]);
			if (code == undefined) { continue; }
				
			var script = document.getElementById(match[0]).innerHTML;
			var lines = script.split("\n");

			var html = "<li><span>&lt;script type=\"text/javascript\"&gt;</span></li>";

			var l = 0;
			while (lines[l].match(/^\s$/) != null) { l++; }
			for (; l < lines.length; l++) {
			
				var hl = (lines[l].match(/\/\*H\*\//) != null);
			
				line = lines[l].replace(/\/\*H\*\//, "");
				line = line.replace(/\t/g, "&nbsp;&nbsp;");
				line = line.replace(/\</g, "&lt;");
				line = line.replace(/\</g, "&gt;");
				
				line = line.replace(/\/\*B-\*\/(.*)\/\*-B\*\//g, function(str, match) { return "<strong>" + match + "</strong>"; });
				line = line.replace(/\/\*H-\*\/(.*)\/\*-H\*\//g, function(str, match) { return "<span class=\"highlight\">" + match + "</span>"; });
				
				if (line.match(/^\s$/) != null) {
					html += "<li><span" + (hl?" class=\"highlight\"":"") + ">&nbsp;</span></li>\n";
				} else {
					html += "<li><span" + (hl?" class=\"highlight\"":"") + ">" + line + "</span></li>\n";
				}
				
			}
			
			html += "<li><span>&lt;/script&gt;</span></li>";
			
			code.innerHTML = html;			
			
		}
	}

}

function displayData() {

	var dataLists = document.getElementsByTagName("ol");
	for (var i = 0; i < dataLists.length; i++) {
		if (dataLists[i].id) {
			var match = dataLists[i].id.match(/data([0-9]+[a-zA-Z]+)/);
			if (match == null) { continue; }
			
			var file = dataLists[i].title;
			if (file == undefined || file == null) { continue; }

			var fileContents = EJSC.utility.XMLRequestPool.sendRequest(file).responseText;
				
			var lines = fileContents.split("\n");

			var html = "";

			var l = 0;
			while (lines[l].match(/^\s$/) != null) { l++; }
			for (; l < lines.length; l++) {

				if (l == (lines.length-1) && (lines[l].match(/\S/) == null)) {
					break;
				}
			
				var hl = (lines[l].match(/\<!--\*H\*--\>/) != null);
			
				line = lines[l].replace(/\<!--\*H\*--\>/, "");
				line = line.replace(/\t/g, "&nbsp;&nbsp;");
				line = line.replace(/\</g, "&lt;");
				line = line.replace(/\</g, "&gt;");
				
				if (line.match(/^\s$/) != null) {
					html += "<li><span" + (hl?" class=\"highlight\"":"") + ">&nbsp;</span></li>\n";
				} else {
					html += "<li><span" + (hl?" class=\"highlight\"":"") + ">" + line + "</span></li>\n";
				}
				
			}
			
			dataLists[i].innerHTML = html;			
			
		}
	}

}