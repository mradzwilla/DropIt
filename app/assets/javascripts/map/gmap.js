function initMap(pos) {
    var latitude = parseFloat(pos.coords.latitude);
    var longitude = parseFloat(pos.coords.longitude);
	var currentPosition = {lat: latitude, lng: longitude};

	var map = new google.maps.Map(document.getElementById('map'), {
  		zoom: 18,
 		center: currentPosition
	});

    var posts = gon.nearbyPosts
    for (i=0;i<posts.length;i++){
        makeMarker(posts[i], map)
    }
}

function makeMarker(post, map){
    var markerPosition = {lat: post.latitude, lng: post.longitude}
    var marker = new google.maps.Marker({
        position: markerPosition,
        map: map,
        });

    marker.addListener('click', function(){
        displayInfo(post)
    })
    // createInfoWindow(post.content, map, marker)
}

function displayInfo(post){
    $('#post_content').text(post.content)
}
function createInfoWindow(contentString, map, marker){
    var infowindow = new google.maps.InfoWindow({
    content: contentString
    });
    infowindow.open(map, marker);
}

function getLocation() {
//This is assigned to the map callback in index.html.erb
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(initMap);
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function getLocationForForm(){
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(addLocationToForm, function(){}, {enableHighAccuracy: true});
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
    getLocation();
    getLocationForForm();

})