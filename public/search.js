var cases = [];
var tags = "";

function GetDivs(){
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
		if((divs[i].className == "case" || divs[i].className == "tree_group") && typeof(divs[i].dataset.searchid) !== "undefined") {
			cases.push(divs[i]);
		}
	}
	divs = document.getElementsByTagName("li");
	for(var i = 0; i < divs.length; i++){
		if((divs[i].className == "case" || divs[i].className == "tree_group")&& typeof(divs[i].dataset.searchid) !== "undefined") {
			cases.push(divs[i]);
		}
	}
}

function SearchCases(){
	var search = document.getElementById("suche").value;
	
	for(var i = 0; i < cases.length; i++){
		if(cases[i].dataset.searchid.substr(0, search.length)  == search){
			if(cases[i].dataset.visible == "false"){
				cases[i].style.display = "block";
				cases[i].dataset.visible = true;
			}
		}else{
			if(cases[i].style.display != "none"){
				cases[i].dataset.style = cases[i].style.display;
				cases[i].style.display = "none";
				cases[i].dataset.visible = false;
			}
		}
	}
}

function RemoveTag(elem){
    document.getElementById("tagHolder").removeChild(elem);
    obj = tags.split(",");
    tags = "";
    for(var i = 0; i < obj.length; i++){
        if(obj[i] != elem.innerHTML){
            tags += "," + obj[i];
        }
    }
    setCookie("tags", tags, 365);
}

function CreateTagsDom(){
   var val = document.getElementById("suche").value;
   tags = document.getElementById("tagHolder").dataset.tags;
   tags += "," + val;
   obj = tags.split(",");
   for(var i = 0; i < obj.length; i++){
       if(obj[i] != ""){
           var div = document.createElement("div");
           div.className = "tag";
           div.innerHTML = obj[i];
           div.onclick = function(){RemoveTag(this);};
           document.getElementById("tagHolder").appendChild(div);
       }
   }
   setCookie("tags", tags, 365);
}

function GlobalSearch(event){
	if(typeof document.activeElement.value === "undefined"){
		document.getElementById("suche").style.position = "fixed";
		document.getElementById("suche").style.right = "10px";
		
		document.getElementById("suche").focus();
	}
	if(event.keyCode == 13 && document.getElementById("suche").value != ""){
	    CreateTagsDom();
	}
}

function ClearSearch(){
	document.getElementById("suche").value = "";
	document.getElementById("suche").style.position = "relative";
}

function setCookie(c_name,value,exdays){
    var exdate=new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
    document.cookie=c_name + "=" + c_value;
    console.debug("Cookie gesetzt. Cookie ist: " + getCookie(c_name));
}

function getCookie(c_name){
    var c_value = document.cookie;
    var c_start = c_value.indexOf(" " + c_name + "=");
    if (c_start == -1)
      {
      c_start = c_value.indexOf(c_name + "=");
      }
    if (c_start == -1)
      {
      c_value = null;
      }
    else
      {
      c_start = c_value.indexOf("=", c_start) + 1;
      var c_end = c_value.indexOf(";", c_start);
      if (c_end == -1)
      {
    c_end = c_value.length;
    }
    c_value = unescape(c_value.substring(c_start,c_end));
    }
    return c_value;
}

window.addEventListener('keydown', GlobalSearch,true);