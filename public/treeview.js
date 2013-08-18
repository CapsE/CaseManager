
function Toggle(event, id){
	var childs = document.getElementById(id).childNodes;
	var sender = event.target;
	for(var i = 0; i < childs.length; i++){
		if(childs[i].style.display == "none"){
			childs[i].style.display = childs[i].dataset.disp;
			sender.src = "Icons/hide.png";
		}else{
			childs[i].dataset.disp = childs[i].style.display;
			childs[i].style.display = "none";
			sender.src = "Icons/show.png";
		}
	}
}