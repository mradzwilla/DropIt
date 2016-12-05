function initMap(latitude, longitude) {
	var currentPosition = {lat: parseFloat(latitude), lng: parseFloat(longitude)};
	var map = new google.maps.Map(document.getElementById('map'), {
  		zoom: 15,
 		center: currentPosition
	});
	var marker = new google.maps.Marker({
 		position: currentPosition,
  		map: map
	});
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}
function showPosition(position) {
    var result = "Latitude: " + position.coords.latitude + 
    "<br>Longitude: " + position.coords.longitude;
    console.log(result)
    initMap(position.coords.latitude, position.coords.longitude)
}

getLocation();

function getLocationForForm(){
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(addLocationToForm);
        navigator.geolocation.getCurrentPosition(setUserLocation);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function addLocationToForm(position){
    $('#post_latitude').val(position.coords.latitude)
    $('#post_longitude').val(position.coords.longitude)
}

function setUserLocation(position){
    $.ajax({
        url:"/updateUserCoordinates",
        type:"POST",
        data:{
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
        }
    })
}
$(document).ready(function(){
    getLocationForForm();
})