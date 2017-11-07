var user = "";
function loadFamilies(values,u,mode){
  user = u;
  if (!("mine" in values)){
    values.mine = "";
  }
  $.get( "/family_api?mine="+values.mine+"&mode="+values.mode+"&cost="+values.cost+"&item="+values.item+"&donor="+values.donor, function( data ) {
    if (values.mode == "donor"){
      values.mine = "true";
    }
    renderFamilies(data,values.mine,values.donor,mode);
  });
}
function renderFamilies(families,mine,donor,mode){
  $("#famCol").empty();
  for(i =0;i<families.length;i++){
    var li = document.createElement("li");
    li.className = "collection-item avatar";
    var image = document.createElement("img");
    image.src = 'http://freeflaticons.com/wp-content/uploads/2014/11/family-copy-14164737688nk4g.png';
    image.className = "circle";
    var title = document.createElement("span");
    title.className = "title";
    if (mine == "true" || mine == true){
      title.innerHTML = "<a href='/my_family/"+families[i].id+"?user="+donor+"'>"+families[i].name+"</a>";
    }else if( mode == "admin"){
      title.innerHTML = "<a href='/family_admin/"+families[i].id+"'>"+families[i].name+"</a>";
    }else if (donor != null && donor != undefined && donor != ""){
      title.innerHTML = "<a href='/my_family/"+families[i].id+"?user="+donor+"'>"+families[i].name+"</a>";
    }else{
      title.innerHTML = "<a href='/family/"+families[i].id+"'>"+families[i].name+"</a>";
    }
    li.append(image);
    li.append(title);
    var p = document.createElement("p");
    if (mine == "true" || mine == true){
      p.innerHTML = "$"+parseFloat(families[i].myCost).toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"<br>"+families[i].myItems+" items";
    }else{
      p.innerHTML = "$"+parseFloat(families[i].cost).toFixed(2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"<br>"+families[i].left+" items";
    }
    var secondContent = document.createElement("div");
    secondContent.className = "secondary-content";
    var delLink = document.createElement("a");
    delLink.innerHTML = "Delete";
    delLink.href = "family/"+families[i].id;
    if (mode == "admin"){
      delLink.href = "family/"+families[i].id+"?mode=admin";
    }
    var att = document.createAttribute("data-method");       // Create a "class" attribute
    att.value = "delete";                           // Set the value of the class attribute
    delLink.setAttributeNode(att);
    secondContent.append(delLink);
    if (user == true || mode == "admin" || mode == 1 || mode != ""){
      var checkDiv = document.createElement("div");
      var checkBox = document.createElement("input");
      checkBox.type = "checkbox";
      checkBox.id = families[i].id;
      checkBox.name = families[i].id;
      checkBox.value = "true";
      if (families[i].recieved){
        checkBox.checked = true;
      }
      var checkLabel = document.createElement("label");
      checkLabel.htmlFor = families[i].id;
      checkLabel.innerHTML = "Recieved";
      checkDiv.append(checkBox);
      checkDiv.append(checkLabel);
      if (donor != null && donor != undefined && donor != ""){
        secondContent.append(checkDiv);
      }
      li.append(secondContent);
    }
    li.append(p);
    $("#famCol").append(li);
  }
}
