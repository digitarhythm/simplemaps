var map;
var svmode = 0;
var zoomlevel = 16;
var maptypeid = 'roadmap';
var timer1;
var keepCurrentLocation = 0;
var panorama;
var center;

//############################################
// 起動時に実行される
//############################################
$(function() {
	if (navigator.geolocation) {
		$("#world").width(document.body.clientWidth);
		$("#world").height(document.documentElement.clientHeight);
		mapInit();
		dispCurrentCenterGoogleMap();
  } else {
		alert("位置情報が使えません。");
	}
});

function mapInit() {
	map = new google.maps.Map(document.getElementById("world"));

	// 地図を移動した
	google.maps.event.addListener(map, 'dragend', function() {
		if (keepCurrentLocation == 1) {
			setKeepCurrentLocationFlag(0);
			document.location = "tv.prominence.simplemap://releaseCurrentLocation(YES)";
		}
	});

	// 縮尺を変更した
	google.maps.event.addListener(map, 'zoom_changed', function() {
		zoomlevel = map.getZoom();
	});
 
	// 地図の種類を変更した
	google.maps.event.addListener(map, 'maptypeid_changed', function() {
		maptypeid = map.getMapTypeId();
	});

	// 地図のデフォルトパノラマオブジェクト取得
	var panorama = map.getStreetView();
	map.setStreetView(panorama);
	map.bindTo("center", panorama, "position");

	// ストリートビューを開始
	google.maps.event.addListener(panorama,'visible_changed',function () {
		if (panorama.getVisible() && svmode == 0) {
			document.location = "tv.prominence.simplemap://streetviewControl(YES)";
			svmode = 1;
		}
	});

	// ストリートビューで移動した
	google.maps.event.addListener(panorama, 'pano_changed', function() {
	});

	// ストリートビューを終了した
	google.maps.event.addListener(panorama, 'closeclick', function() {
	});
}

//############################################
// ストリートビュー開始
//############################################
function dispStreetView() {
	panorama = map.getStreetView();
	map.setStreetView(panorama);
	map.bindTo("center", panorama, "position");
	// 地図のデフォルトパノラマオブジェクト取得
	var panorama = map.getStreetView();
	// ストリートビュー非表示
	panorama.setVisible(true);
	svmode = 1;
}

//############################################
// ストリートビューを非表示
//############################################
function hideStreetView() {
	// 現在の中心座標取得
	var bounds = map.getBounds();
	center = bounds.getCenter();
	// 地図のデフォルトパノラマオブジェクト取得
	var panorama = map.getStreetView();
	// ストリートビュー非表示
	panorama.setVisible(false);
	// 地図のデフォルトパノラマオブジェクト取得
	map = new google.maps.Map(document.getElementById("world"));
	// 地図の初期化
	mapInit();
	dispGoogleMap(center);
	svmode = 0;
}

//############################################
// 現在地を中心にしてGoogleMapを表示する
//############################################
function dispCurrentCenterGoogleMap() {
	moveCurrentCenter();
	dispGoogleMap(null);
}

//############################################
// GoogleMapを表示する
// 座標を渡すとそこを中心にする
// 座標を変えない場合はnullを渡す
//############################################
function dispGoogleMap(latlng) {
	map.setZoom(zoomlevel);
	map.setMapTypeId(maptypeid);
	var myOptions = {
		streetViewControl: false,
		mapTypeControl: true,
		mapTypeControlOptions: {
			style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
		}
	}
	map.setOptions(myOptions);
	if (latlng != null) {
		map.setCenter(latlng);
	}
}

//############################################
// 地図の中心を現在地にする
// 表示はしない
//############################################
function moveCurrentCenter() {
	navigator.geolocation.getCurrentPosition(function(p){
		var lat = p.coords.latitude;
		var lng = p.coords.longitude;
		var acc = p.coords.accuracy;
		var latlng = new google.maps.LatLng(lat, lng);
		map.setCenter(latlng);
	});
}

//############################################
// 現在地を画面の中心に固定するかのフラグに値を設定する
//############################################
function setKeepCurrentLocationFlag(flag) {
	keepCurrentLocation = flag;
	if (flag == 1) {
		timer1 = setInterval("moveCurrentCenter()", 3000);
	} else {
		clearInterval(timer1);
	}
}

//############################################
// 住所から座標を検索
//############################################
function searchAddress(sad) {
	var geocoder = new google.maps.Geocoder();
	geocoder.geocode({ 'address': sad}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			marker.setPosition(results[0].geometry.location);
			var p = marker.position;
			var lat = p.lat;
			var lng = p.lng;
			var latlng = new google.maps.LatLng(lat, lng);
			dispGoogleMap(latlng);
		} else {
			document.location = "tv.prominence.simplemap://alertDialog(0)";
		}
	});
}