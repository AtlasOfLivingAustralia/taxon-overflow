L.Control.Measure = L.Control.extend({
	options: {
		position: 'topleft'
	},

	onAdd: function (map) {

		var className = 'leaflet-control-zoom leaflet-bar leaflet-control';
		var container = L.DomUtil.create('div', className);

		this._createButton('', 'Measure', 'leaflet-control-measure leaflet-bar-part leaflet-bar-part-top fa fa-arrows-h', container, this._toggleMeasure, this);
        if (!this.hideCalibration) {
            this._createButton('', 'Calibrate', 'viewer-custom-buttons leaflet-disabled leaflet-control-measure leaflet-bar-part leaflet-bar-bottom fa fa-sliders btnCalibrateMMPerPixels', container, this._calibrate, this);
        }

		return container;
	},
    _calibrate : function(e) {
        this.mmPerPixel = this.onCalibration(this._pixelDistance);
        this._toggleMeasure();
    },
    _disableCalibration: function() {
        $(".btnCalibrateMMPerPixels").addClass("leaflet-disabled");
    },
    _enableCalibration: function() {
        $(".btnCalibrateMMPerPixels").removeClass("leaflet-disabled");
    },
	_createButton: function (html, title, className, container, fn, context) {
		var link = L.DomUtil.create('a', className, container);
		link.innerHTML = html;
		link.href = '#';
		link.title = title;

		L.DomEvent
			.on(link, 'click', L.DomEvent.stopPropagation)
			.on(link, 'click', L.DomEvent.preventDefault)
			.on(link, 'click', fn, context)
			.on(link, 'dblclick', L.DomEvent.stopPropagation);

		return link;
	},

	_toggleMeasure: function () {
		this._measuring = !this._measuring;

		if(this._measuring) {
			L.DomUtil.addClass(this._container, 'leaflet-control-measure-on');
			this._startMeasuring();
		} else {
			L.DomUtil.removeClass(this._container, 'leaflet-control-measure-on');
			this._stopMeasuring();
		}
	},

	_startMeasuring: function() {
		this._oldCursor = this._map._container.style.cursor;
		this._map._container.style.cursor = 'crosshair';

		this._doubleClickZoom = this._map.doubleClickZoom.enabled();
		this._map.doubleClickZoom.disable();

		L.DomEvent
			.on(this._map, 'mousemove', this._mouseMove, this)
			.on(this._map, 'click', this._mouseClick, this)
			.on(this._map, 'dblclick', this._finishPath, this)
			.on(document, 'keydown', this._onKeyDown, this);

		if(!this._layerPaint) {
			this._layerPaint = L.layerGroup().addTo(this._map);	
		}

	},

	_stopMeasuring: function() {
		this._map._container.style.cursor = this._oldCursor;

		L.DomEvent
			.off(document, 'keydown', this._onKeyDown, this)
			.off(this._map, 'mousemove', this._mouseMove, this)
			.off(this._map, 'click', this._mouseClick, this)
			.off(this._map, 'dblclick', this._mouseClick, this);

		if(this._doubleClickZoom) {
			this._map.doubleClickZoom.enable();
		}

		if(this._layerPaint) {
			this._layerPaint.clearLayers();
		}
		
		this._restartPath();

        this._disableCalibration();
	},

	_mouseMove: function(e) {
		if(!e.latlng || !this._lastPoint) {
			return;
		}
		
		if(!this._layerPaintPathTemp) {
			this._layerPaintPathTemp = L.polyline([this._lastPoint, e.latlng], { 
				color: 'black',
				weight: 1.5,
				clickable: false,
				dashArray: '6,3'
			}).addTo(this._layerPaint);
		} else {
			this._layerPaintPathTemp.spliceLatLngs(0, 2, this._lastPoint, e.latlng);
		}

		if(this._tooltip) {
			if(!this._distance) {
				this._distance = 0;
			}

			this._updateTooltipPosition(e.latlng);

			// var distance = e.latlng.distanceTo(this._lastPoint);
            var currentPixelPoint = this._getPixelPoint(e.latlng);
            var pixelDistance = this._lastPixelPoint.pixelDistanceTo(currentPixelPoint);
			this._updateTooltipDistance(this._pixelDistance + pixelDistance, pixelDistance);
		}
	},

	_mouseClick: function(e) {
		// Skip if no coordinates
		if(!e.latlng) {
			return;
		}

		// If we have a tooltip, update the distance and create a new tooltip, leaving the old one exactly where it is (i.e. where the user has clicked)
		if(this._lastPoint && this._tooltip) {

			if(!this._distance) {
				this._distance = 0;
			}

            if (!this._pixelDistance) {
                this._pixelDistance = 0;
            }

			this._updateTooltipPosition(e.latlng);

            var pixelDistance = this._getPixelPoint(e.latlng).pixelDistanceTo(this._lastPixelPoint);
            this._pixelDistance += pixelDistance;

			var distance = e.latlng.distanceTo(this._lastPoint);
			this._updateTooltipDistance(this._pixelDistance, pixelDistance);

			this._distance += distance;

            this._enableCalibration();
		}
		this._createTooltip(e.latlng);
		

		// If this is already the second click, add the location to the fix path (create one first if we don't have one)
		if(this._lastPoint && !this._layerPaintPath) {
			this._layerPaintPath = L.polyline([this._lastPoint], { 
				color: 'black',
				weight: 2,
				clickable: false
			}).addTo(this._layerPaint);
		}

		if(this._layerPaintPath) {
			this._layerPaintPath.addLatLng(e.latlng);
		}

		// Upate the end marker to the current location
		if(this._lastCircle) {
			this._layerPaint.removeLayer(this._lastCircle);
		}

		this._lastCircle = new L.CircleMarker(e.latlng, { 
			color: 'black', 
			opacity: 1, 
			weight: 1, 
			fill: true, 
			fillOpacity: 1,
			radius:2,
			clickable: this._lastCircle ? true : false
		}).addTo(this._layerPaint);
		
		this._lastCircle.on('click', function() { this._finishPath(); }, this);

		// Save current location as last location
		this._lastPoint = e.latlng;
        this._lastPixelPoint = this._getPixelPoint(e.latlng);
	},

	_finishPath: function() {
		// Remove the last end marker as well as the last (moving tooltip)
		if(this._lastCircle) {
			this._layerPaint.removeLayer(this._lastCircle);
		}
		if(this._tooltip) {
			this._layerPaint.removeLayer(this._tooltip);
		}
		if(this._layerPaint && this._layerPaintPathTemp) {
			this._layerPaint.removeLayer(this._layerPaintPathTemp);
		}

		// Reset everything
		this._restartPath();
	},

	_restartPath: function() {
		this._distance = 0;
		this._tooltip = undefined;
		this._lastCircle = undefined;
		this._lastPoint = undefined;
		this._layerPaintPath = undefined;
		this._layerPaintPathTemp = undefined;

        this._pixelDistance = 0;
        this._lastPixelPoint = undefined;
	},
	
	_createTooltip: function(position) {
		var icon = L.divIcon({
			className: 'leaflet-measure-tooltip',
			iconAnchor: [-5, -5]
		});
		this._tooltip = L.marker(position, { 
			icon: icon,
			clickable: false
		}).addTo(this._layerPaint);
	},

	_updateTooltipPosition: function(position) {
		this._tooltip.setLatLng(position);
	},

	_updateTooltipDistance: function(total, difference) {
		var displayTotal = total;

        if (!displayTotal) {
            displayTotal = difference;
        }
	    var displayDifference = difference;
        var units = " pixels";
        if (this.mmPerPixel && this.mmPerPixel != 0) {
            units = " mm";
            displayTotal = displayTotal * this.mmPerPixel;
            displayDifference = displayDifference * this.mmPerPixel;
        }

        var text = '<div class="leaflet-measure-tooltip-total">' + displayTotal.toFixed(2) + units + '</div>';
		if(displayDifference > 0 && displayTotal != displayDifference) {
			text += '<div class="leaflet-measure-tooltip-difference">(+' + displayDifference.toFixed(2) + units + ')</div>';
		}

		this._tooltip._icon.innerHTML = text;
	},

	_onKeyDown: function (e) {
		if(e.keyCode == 27) {
			// If not in path exit measuring mode, else just finish path
			if(!this._lastPoint) {
				this._toggleMeasure();
			} else {
				this._finishPath();
			}
		}
	},

    _getPixelPoint: function(latlng) {

        var pixelx = Math.round(latlng.lng * this.imageScaleFactor);
        var pixely = this.imageHeight - Math.round(latlng.lat * this.imageScaleFactor);
        return {
            x: pixelx,
            y: pixely,
            pixelDistanceTo: function(other) {
                if (other) {
                    // Distance formula!
                    return Math.sqrt(Math.pow(other.x - this.x, 2) + Math.pow(other.y - this.y, 2));
                }
                return 0;
            }
        };
    },
    mmPerPixel: 0,
    imageScaleFactor: 0,
    imageHeight: 0,
    imageWidth: 0,
    hideCalibration: false,
    onCalibration: function(pixelDistance) {
        return 0;
    }

});

L.Map.mergeOptions({
	measureControl: false
});

L.Map.addInitHook(function () {
	if (this.options.measureControl) {
		this.measureControl = new L.Control.Measure();

        if (typeof this.options.measureControl === 'object') {
            var opts = this.options.measureControl;
            if (opts.mmPerPixel) {
                this.measureControl.mmPerPixel = opts.mmPerPixel;
            }
            if (opts.imageScaleFactor) {
                this.measureControl.imageScaleFactor = opts.imageScaleFactor;
            }
            if (opts.imageHeight) {
                this.measureControl.imageHeight = opts.imageHeight;
            }
            if (opts.imageWidth) {
                this.measureControl.imageWidth = opts.imageWidth;
            }
            if (opts.onCalibration) {
                this.measureControl.onCalibration = opts.onCalibration;
            }
            if (opts.hideCalibration) {
                this.measureControl.hideCalibration = opts.hideCalibration;
            }
        }

		this.addControl(this.measureControl);
	}
});

L.control.measure = function (options) {
	return new L.Control.Measure(options);
};
