var DNSTOOL = {};

$(document).ready(function() {
	$('form.resolve-form .form-actions button.btn-primary').click(function() {
		$('form.resolve-form .form-actions .progress .bar').css(
			{'width': '100%'}
		);
	});
	
	if( $('#geoip-map').size() > 0 ) {
        // add leaflet map
		
        DNSTOOL.map = new L.Map('geoip-map');
		var mapnik_osm = new L.TileLayer(
			"http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", 
			{
				maxZoom: 24,
				minZoom: 1, 
				attribution: "Map: &copy; <a href=\"http://www.openstreetmap.org\" target=\"_blank\" style=\"\">OpenStreetMap contributors</a>, "
					+"<a href=\"http://creativecommons.org/licenses/by-sa/2.0/\" target=\"_blank\">CC-BY-SA</a>"
			}
		);
		
		DNSTOOL.map.addLayer(mapnik_osm);
		
		if( $('#geoip-map').data('lat') != '' && $('#geoip-map').data('lon') != '' ) {
			DNSTOOL.map.setView(new L.LatLng($('#geoip-map').data('lat'), $('#geoip-map').data('lon')), 9);
			var markerLocation = new L.LatLng($('#geoip-map').data('lat'), $('#geoip-map').data('lon'));
			var marker = new L.Marker(markerLocation);
			DNSTOOL.map.addLayer(marker);
			marker.bindPopup($('#geoip-map').data('description')); // .openPopup();
		}
		
		$('body').on('shown', 'a[data-toggle="tab"].map', function(e) {
			// avoid errors b/c map was initialized while being hidden, so recalculate
			// dimensions when tab is shown
			DNSTOOL.map.invalidateSize();
		});
	}
});