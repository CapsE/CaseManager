function Toggle(event, id){
	var childs = document.getElementById(id).childNodes;
	if(typeof event.target !== "undefined"){
		var sender = event.target;
	}else{
		var sender = event;
	}
	
	for(var i = 0; i < childs.length; i++){
		if(childs[i].style.display == "none"){
			childs[i].style.display = childs[i].dataset.disp;
			sender.src = "/Icons/hide.png";
		}else{
			childs[i].dataset.disp = childs[i].style.display;
			childs[i].style.display = "none";
			sender.src = "/Icons/show.png";
		}
	}
}

function Activate(event){
	var obj = event.target;
	if(obj.dataset.active == false || obj.dataset.active == "false"){
		obj.dataset.active = true;
		obj.setAttribute("class", "tree_active");
	}else{
		obj.dataset.active = false;
		obj.setAttribute("class", "tree_case");
	}
	
}

function HideAll(){
	var img = document.getElementsByTagName("img");
	for(var i = 0; i < img.length; i++){
		if(img[i].className == "identifier"){
			var childs = document.getElementById(img[i].getAttribute("data-id")).childNodes;
			for(var h = 0; h < childs.length; h++){			
				if(childs[h].style.display != "none"){
					childs[h].dataset.disp = childs[h].style.display;
					childs[h].style.display = "none";
					img[i].src = "/Icons/show.png";
				}
			}
		}
	}
}

function ShowAll(){
	var img = document.getElementsByTagName("img");
	for(var i = 0; i < img.length; i++){
		if(img[i].className == "identifier"){
			var childs = document.getElementById(img[i].getAttribute("data-id")).childNodes;
			for(var h = 0; h < childs.length; h++){		
				if(childs[h].style.display == "none"){				
					childs[h].style.display = childs[h].dataset.disp;
					img[i].src = "/Icons/hide.png";
				}
			}
		}
	}
}