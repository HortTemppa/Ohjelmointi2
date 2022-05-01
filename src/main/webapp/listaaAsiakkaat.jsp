<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Tittelimies</title>
<style>
.oikealle{
	text-align: right;
}
</style>
</head>
<body>
<table id="listaus">
	<thead>	
	<tr>
			<th colspan="4" class="oikealle"><a href = "lisaaasiakas.jsp" id="uusiAsiakas">Lisää uusi asiakas</a></th>
		</tr>	
		<tr>
			<th class="oikealle">Hakusana:</th>
			<th colspan="2"><input type="text" id="hakusana"></th>
			<th><input type="button" value="hae" id="hakunappi"></th>
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
	</tbody>
</table>
<script>
$(document).ready(function(){
	

	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	
	
	haeAsiakkaat();
	$("#hakunappi").click(function(){		
		haeAsiakkaat();
	});
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ 
			  haeAsiakkaat();
		  }
	});
	$("#hakusana").focus();
});	

function haeAsiakkaat(){
	$("#listaus tbody").empty();
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){//Funktio palauttaa tiedot json-objektina		
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr>";
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>"; 
        	htmlStr+="<td><span class='poista' onclick=poista('" +field.etunimi + "','" + field.sukunimi +"','" + field.sposti+"')>Poista</span></td>";
        	htmlStr+="</tr>"; 
        	$("#listaus tbody").append(htmlStr);
        });	
    }});
	
	
}
function poista(etunimi, sukunimi, sposti){
	if(confirm("Poista auto " + etunimi + " " + sukunimi +"?")){
		$.ajax({url:"asiakkaat/"+sposti, type:"DELETE", dataType:"json", success:function(result){
	        if(result.response==0){
	        	$("#ilmo").html("Henkilön poisto epäonnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+etunimi+sukunimi).css("background-color", "red");
	        	alert("Henkilön " + etunimi + sukunimi +" poisto onnistui.");
				haeAsiakkaat();        	
			}
	    }});
	}
}
</script>
</body>
</html>