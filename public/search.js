var cases = [];

function GetDivs(){
	var divs = document.getElementsByTagName("div");
	for(var i = 0; i < divs.length; i++){
		if(divs[i].className == "case" || divs[i].className == "tree_group"){
			cases.push(divs[i]);
		}
	}
}

function SearchCases(){
	var search = document.getElementById("suche").value;
	
	for(var i = 0; i < cases.length; i++){
		if(cases[i].id.substr(0, search.length)  == search){
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

function GlobalSearch(event){
	if(typeof document.activeElement.value === "undefined"){
		document.getElementById("suche").style.position = "fixed";
		document.getElementById("suche").style.right = "10px";
		
		document.getElementById("suche").focus();
	}
}

function ClearSearch(){
	document.getElementById("suche").value = "";
	document.getElementById("suche").style.position = "relative";
}

window.addEventListener('keydown', GlobalSearch,true);