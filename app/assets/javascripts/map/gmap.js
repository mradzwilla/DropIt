function initMap(position, posts) {
    var latitude = parseFloat(position.coords.latitude);
    var longitude = parseFloat(position.coords.longitude);
	var currentPosition = {lat: latitude, lng: longitude};

	var map = new google.maps.Map(document.getElementById('map'), {
  		zoom: 18,
 		center: currentPosition
	});

    var nearbyPosts = posts
    for (i=0;i<nearbyPosts.length;i++){
        makeMarker(nearbyPosts[i], map)
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

function getNearbyPosts(coords){
    //Receives coords as parameter to pass to initMap
    //Get nearby posts. Call marker maker function on success
    $.ajax({
        url: "/getNearbyPosts",
        type: "GET",
        dataType: "JSON",
        success: function(posts){
            initMap(coords, posts)
        },
        error: function(){
            console.log('Error in getNearbyPosts')
        }
    })
}
var getPosition = function (options) {
    var deferred = $.Deferred();

    navigator.geolocation.getCurrentPosition(
        deferred.resolve,
        deferred.reject
    );

    return deferred.promise();
};

$(document).ready(function(){
    //Make ajax call to geolocation and perform following functions once coordinates are returned
    getPosition().then(function(result){
        setUserLocation(result);
        addLocationToForm(result);
        getNearbyPosts(result)
    })
})