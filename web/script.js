// Copyright 2016
// University of Freiburg - Chair of Algorithms and Data Structures
// Author: Patrick Brosi <brosi@informatik.uni-freiburg.de>

var networks = [
  {"id":"turin","name":"Turin (Tram)","bounds":[[44.972898,7.387699],[45.421676,7.825031]]},
  {"id":"freiburg","name":"Freiburg (Stadtbahn)","bounds":[[47.963754,7.786318],[48.03588,7.896592]]},
  {"id":"nyc_subway","name":"New York (Subway)","bounds":[[40.510988,-74.254297],[40.90489,-73.752195]]},
  {"id":"chicago","name":"Chicago (\"L\" train)","bounds":[[41.720955,-87.906127],[42.074566,-87.603802]]},
  {"id":"stuttgart","name":"Stuttgart (Stadtbahn)","bounds":[[48.696459,9.061769],[48.875005,9.299399]]},
  {"id":"sydney","name":"Sydney (Light rail)","bounds":[[-34.135709,150.670375],[-33.597455,151.25056]]},
  {"id":"dallas","name":"Dallas (Light rail)","bounds":[[32.682006,-97.329609],[33.034948,-96.559026]]}
];

var map = L.map('map').setView([48.7792, 9.1788], 15);
    var datasetLayer, resLayer;

L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
  maxZoom: 17,
  attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
    'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
  id: 'mapbox/light-v9',
  tileSize: 512,
  zoomOffset: -1
}).addTo(map);


for (var n in networks) {
  var net = networks[n];

  $("#layerlist")
    .append('<li class="" id="layer-' + net['id'] + '">' +
      '<div class="flink">' +
        '' + net['name'] + '' +
        '<div class="buttons-row">' +
          '<a target="_blank" href="/datasets/' + net['id'] + '.json" type="button" class="btn btn-default btn-xs">GRAPH</a>' +
          '<a target="_blank" href="/results/' + net['id'] + '/ilp-sep-cbc/untangled/render/full.pdf" type="button" class="btn btn-default btn-xs">PDF</a>' +
        '</div>' +
      '</div>' +
    '</li>'
  );
}

function update() {
  var z = map.getZoom();

  var mid = document.getElementById("optmethod").value + "-" +  document.getElementById("simplmethod").value;
  if (document.getElementById("check-sep").checked) mid += "-sep";

  for (var n in networks) {
    if (!networks[n]['layers']) networks[n]['layers'] = {};
    if (!networks[n]['layers'][mid]) networks[n]['layers'][mid] = {};

    for (var midl in networks[n]['layers']) {
      for (var zoom in networks[n]['layers'][midl]) {
        if (midl != mid && map.hasLayer(networks[n]['layers'][midl][zoom])) {
          map.removeLayer(networks[n]['layers'][midl][zoom]);
        }
      }
    }

    for (var zoom in networks[n]['layers'][mid]) {
      if (zoom != z && map.hasLayer(networks[n]['layers'][mid][zoom])) {
        map.removeLayer(networks[n]['layers'][mid][zoom]);
      }
    }
    if (!isVisible(n)) {
      for (var zoom in networks[n]['layers'][mid]) {
        if (map.hasLayer(networks[n]['layers'][mid][zoom])) {
          map.removeLayer(networks[n]['layers'][mid][zoom]);
        }
      }
      continue;
    }

    if (networks[n]['layers'] && networks[n]['layers'][mid] && networks[n]['layers'][mid][z] && map.hasLayer(networks[n]['layers'][mid][z])) continue;

    var net = networks[n];
    if (networks[n]['layers'] && networks[n]['layers'][mid] && networks[n]['layers'][z]) {
      networks[n]['layers'][mid][z].addTo(map);
    } else {
      xhr = new XMLHttpRequest();
      xhr.open("GET","/results/" + net["id"] + "/" + document.getElementById("optmethod").value + (document.getElementById("check-sep").checked ? "-sep" : "") + (document.getElementById("optmethod").value == "ilp" ? "-cbc" : "") + "/" + document.getElementById("simplmethod").value  + "/render/" + z + ".svg",false);
      (function(xhr, net) {
        xhr.onload = function(e) {
          if (!xhr.responseXML) {
            console.log("Dataset not found: " + net["id"] + "/" + document.getElementById("optmethod").value + (document.getElementById("check-sep").checked ? "-sep" : "") + "/" + document.getElementById("simplmethod").value + "/render/" + z + ".svg")
            return;
          }
          var e = xhr.responseXML.documentElement;
          $(e).find(".transit-edge, .transit-edge-outline, .inner-geom, .inner-geom-outline").each(function(a) {
            this.setAttribute("orig-width", parseFloat(this.style.strokeWidth));
          });
          e.addEventListener('mouseover', function(e) {
            if (!e.target.getAttribute("class") || (!e.target.getAttribute("class").includes("inner-geom") && !e.target.getAttribute("class").includes("transit-edge"))) return;
            var line = e.target.getAttribute("class").match(/line-([a-zA-Z0-9]*)\s*/);
            $(".line-" + line[1]).each(function() {
              
              $(this).css("stroke-width", parseFloat(this.getAttribute("orig-width") * 1.75)) ;
              $(this).addClass("transit-edge-open");
            }
            );
          });
          e.addEventListener('mouseout', function(e) {
            if (!e.target.getAttribute("class") || !e.target.getAttribute("class").includes("transit-edge-open")) return;
            if  (!e.target.getAttribute("orig-width")) return;
            var line = e.target.getAttribute("class").match(/line-([a-zA-Z0-9]*)\s*/);
            $(".line-" + line[1]).each(function() {
              $(this).css("stroke-width", parseFloat(this.getAttribute("orig-width"))) ;
              $(this).removeClass("transit-edge-open");
            }
            );
          });
          var ll = e.getAttribute("latlng-box").split(",");
          var bounds = [[parseFloat(ll[1]), parseFloat(ll[0])], [parseFloat(ll[3]), parseFloat(ll[2])]];
          net['layers'][mid][z] = L.svgOverlay(e, bounds, {"interactive" : true});
          if (map.getZoom() == z && !map.hasLayer(net['layers'][mid][z])) {
            net['layers'][mid][z].addTo(map);
          }
        };
        xhr.send("");
      })(xhr, net);
    }
  }
}

document.getElementById("optmethod").onchange = update;
document.getElementById("simplmethod").onchange = update;
document.getElementById("check-sep").onchange = update;

map.on('moveend', function() {
  update();
  setVisibleNetwork(getVisibleNetwork());
});

update();
setVisibleNetwork(getVisibleNetwork());

function isVisible(n) {
  var net = networks[n];
  return map.getBounds().intersects(net["bounds"]);
}

function getVisibleNetwork() {
  if (map.getZoom() < 6) return undefined;
  for (var n in networks) {
    if (isVisible(n)) return networks[n]["id"];
  }
  return undefined;
}

function setVisibleNetwork(id) {
  if (id === undefined) location.hash = "";
  for (var n in networks) {
    var net = networks[n];

    if (id == net["id"]) {
      $("#layer-" + net["id"]).addClass("active");
      location.hash = "#" + id;
      if (id != getVisibleNetwork()) {
        map.fitBounds(net['bounds']);
      }
    } else {
      $("#layer-" + net["id"]).removeClass("active");
    }
  }
}

for (var n in networks) {
  (function(n) {
  $("#layer-" + networks[n]["id"]).click(function() {
    setVisibleNetwork(networks[n]["id"]);
  });})(n);
}

document.getElementById("stat-cb").onchange = function() {
    if (!this.checked) {
    $("body").addClass("no-stats");
  } else {
    $("body").removeClass("no-stats");
  }
};

document.getElementById("edge-cb").onchange = function() {
    if (!this.checked) {
    $("body").addClass("no-edgs");
  } else {
    $("body").removeClass("no-edgs");
  }
};

document.getElementById("con-cb").onchange = function() {
    if (!this.checked) {
    $("body").addClass("no-cons");
  } else {
    $("body").removeClass("no-cons");
  }
};

document.getElementById("lbl-cb").onchange = function() {
  if (!this.checked) {
    $("body").addClass("no-labels");
  } else {
    $("body").removeClass("no-labels");
  }
};

$(window).on('hashchange',function(){
  setVisibleNetwork(location.hash.slice(1));
});

setVisibleNetwork(location.hash.slice(1));
