<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta tietoja</title>
</head>
<body onkeydown = tutkiKeyX(event)>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="oikealle"><a href="listaaAsiakkaat.jsp">Takaisin listaukseen</a></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sähköposti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="button" id="tallenna" value="Hyväksy" onclick = "vieTiedot()"></td>
				<td><input type="hidden" name="vanhasposti" id="vanhasposti"></td>	
			</tr>
		</tbody>
	</table>
	
</form>
<span id="ilmo"></span>
</body>
<script>

docReady( function () {
	
	document.getElementById("etunimi").focus()
	
	const sposti = requestURLParam("sposti");
	
	fetch("asiakkaat/haeyksi/" + sposti).then((response => response.json())).then(json => {
		
		return json;
	}).then((asiakas) => {
		document.getElementById('etunimi').value = asiakas.etunimi;
		document.getElementById('sukunimi').value = asiakas.sukunimi;
		document.getElementById('puhelin').value = asiakas.puhelin;
		document.getElementById('sposti').value = asiakas.sposti;
		document.getElementById("vanhasposti").value = sposti;
	})
	
	
})
function vieTiedot(){
		var ilmo="";
		var d = new Date();
		if(document.getElementById("etunimi").value.length<1){
			ilmo="Etunimi ei kelpaa!";		
		}else if(document.getElementById("sukunimi").value.length<1){
			ilmo="Sukunimi!";		
		}else if(document.getElementById("puhelin").value.length<7){
			ilmo="Puhelinnumero ei kelpaa!";		
		}else if(document.getElementById("sposti").value<4){
			ilmo="Sähköposti ei kelpaa";		
		}
		if(ilmo!=""){
			document.getElementById("ilmo").innerHTML=ilmo;
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
			return;
		}
		document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
		document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
		document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
		document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
		
		var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
		console.log(formJsonStr);
		//L�het��n muutetut tiedot backendiin
		fetch("asiakkaat",{//L�hetet��n kutsu backendiin
		      method: 'PUT',
		      body:formJsonStr
		    })
		.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
			return response.json();
		})
		.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametriss�	
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Tietojen päivitys epäonnistui";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML= "Tietojen päivitys onnistui";			      	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		});	
		document.getElementById("tiedot").reset(); //tyhjennet��n tiedot -lomake
	}
function tutkiKeyX(event){
		if(event.keyCode==13){//Enter
			vieTiedot();
		}		
	}


function docReady(fn) {
    // see if DOM is already available
    if (document.readyState === "complete" || document.readyState === "interactive") {
        // call on next available tick
        setTimeout(fn, 1);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}    
/*$(document).ready(function(){
	$("#takaisin").click(function(){
		document.location="listaaAsiakkaat.jsp";
	});
	
	var sposti = requestURLParam("sposti");
	console.log(vanhasposti);
	$.ajax({url:"asiakkaat/haeyksi/"+sposti, type:"GET", dataType:"json", success:function(result){			
		$("#etunimi").val(result.etunimi);	
		$("#sukunimi").val(result.sukunimi);
		$("#puhelin").val(result.puhelin);
		$("#sposti").val(result.sposti);	
    }});
	
	$("#tiedot").validate({						
		rules: {
			etunimi:  {
				required: true,
				minlength: 1				
			},	
			sukunimi:  {
				required: true,
				minlength: 1			
			},
			puhelin:  {
				required: true,
				minlength: 7,
				maxlength:13
			},	
			sposti:  {
				required: true,
				minlength: 4
			}	
		},
		messages: {
			etunimi: {     
				required: "Puuttuu",
				minlength: "Liian lyhyt"			
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sposti: {
				required: "Puuttuu",
				number: "Ei kelpaa",
				minlength: "Liian lyhyt",
				maxlength: "Liian pitk�",
				min: "Liian pieni",
				max: "Liian suuri"
			}
		},			
		submitHandler: function(form) {	
			paivitaTiedot();
		}		
	}); 	
})*/;

function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); 
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) {
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan päivittäminen epäonnistui.");
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan päivittäminen onnistui.");
      	$("#etunimi", "#sukunimi", "#puhelin", "#sposti").val("");
	  }
  }});	
}
</script>
</html>