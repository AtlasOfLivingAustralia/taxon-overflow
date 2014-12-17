<style>
    #map {
        margin-top: 10px;
        margin-bottom: 10px;
        border-radius: 3px;
    }
</style>
<div id="map" class="span12" style="height: 400px;">

</div>

<script>

    if (!GSP_VARS) {
        alert('GSP_VARS not set in page - required for map widget JS');
    }

    L.Icon.Default.imagePath = GSP_VARS.leafletImagesDir;

    var osm = L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>',
        id: 'nickdos.kf2g7gpb'  // TODO: we should get an ALA account for mapbox.com
    });

    // in case mapbox images start failing... fall back to plain OSM
    var osm1 = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a>'
    });
    // OR
    var OpenMapSurfer_Roads = L.tileLayer('http://openmapsurfer.uni-hd.de/tiles/roads/x={x}&y={y}&z={z}', {
        minZoom: 0,
        maxZoom: 20,
        attribution: 'Imagery from <a href="http://giscience.uni-hd.de/">GIScience Research Group @ University of Heidelberg</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    });

    var Esri_WorldImagery = L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
        maxZoom: 17
    });

    var pos = L.latLng(${coordinates.latitude}, ${coordinates.longitude});

    var map = L.map('map', {
        center: pos,
        zoom: 4,
        scrollWheelZoom: true
        //layers: [osm, MapQuestOpen_Aerial]
    });

    var initalBounds = map.getBounds().toBBoxString(); // save for geocoding lookups

    var baseLayers = {
        "Street": osm,
        "Satellite": Esri_WorldImagery
    };

    map.addLayer(osm);

    L.control.layers(baseLayers).addTo(map);

    var marker = L.marker(pos, {draggable: false}).addTo(map);


</script>