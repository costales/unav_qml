import QtQuick 2.4
import QtLocation 5.9
import QtPositioning 5.9
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0

import "js/markers.js" as Markers

MainView {

	id: unav
	applicationName: "navigatortest.costales"

	Settings {
		id: settings
		property bool online: true
	}
	property bool centerOnPos: false

	width: units.gu(40)
	height: units.gu(70)

	Page {

		header: PageHeader {
			id: header
			title: "uNav"

			StyleHints {
				backgroundColor: "#398DFF"
				foregroundColor: "White"
				dividerColor: "White"
			}

			trailingActionBar {
				numberOfSlots: 3
				actions: [
					Action {
						id: actionSettings
						iconName: "settings"
						text: i18n.tr("Settings")
						onTriggered: {
						}
					},
					Action {
						id: centerPosAction
						iconName: centerOnPos ? "media-optical-symbolic" : "gps"
						text: i18n.tr("Center on Position")
						onTriggered: {
							centerOnPos = true
							if (!gps.active) {
								gps.start()
							}
						}
					},
					Action {
						id: searchAction
						iconName: "find"
						shortcut: "Ctrl+F"
						text: i18n.tr("Search")
						onTriggered: {
						}
					}
				]
			}
		}

		Map {
			id: map

			zoomLevel: 11
			center {
				latitude:  43.547366
				longitude: -5.661973
			}
			Behavior on center {
				CoordinateAnimation {
					duration: 300
					easing.type: Easing.InOutQuad
				}
			}
			
			plugin: Plugin {
				id: mapProvider
				name: "mapboxgl"
				PluginParameter {
					name: "mapboxgl.mapping.additional_style_urls"
					value: "http://localhost:8553/v1/mbgl/style?style=osmbright"
				}
			}
			MapParameter {
				type: "source"

				property var name: "routeSource"
				property var sourceType: "geojson"
				property var data: '{ "type": "FeatureCollection", "features": \
					[{ "type": "Feature", "properties": {}, "geometry": { \
					"type": "LineString", "coordinates": [[ 43.547366, \
					-5.661973 ], [ 43.47366, -5.561973 ]]}}]}'
			}
			//activeMapType: supportedMapTypes[supportedMapTypes.length - 1]
			//plugin: Plugin {
            //    id: mapProvider
            //    preferred: ["osm"]
            //}

			anchors.fill: parent
			anchors.margins: units.gu(-60) // Hack: Don't show map borders

			gesture.enabled: true
			gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
			gesture.onPanStarted: {
				centerOnPos = false
				map.rotation = 0
			}
			gesture.onPanFinished: {
			}
			MouseArea {
				anchors.fill: parent
				onPressAndHold: {
					var coord = map.toCoordinate(Qt.point(mouse.x,mouse.y))
					Markers.delete_all()
					Markers.add(coord, "../img/marker.png")

					centerOnPos = false
					map.rotation = 0
					map.center = coord
				}
			}

			MapPolyline {
				id: route
				line.width: 5
				line.color: '#398DFF'
				path: [
					{ latitude: 43.547366, longitude: -5.661973 },
					{ latitude: 43.447366, longitude: -5.561973 },
					{ latitude: 43.437366, longitude: -5.641973 },
					{ latitude: 43.244373, longitude: -5.663973 }
				]
			}
		}		
	}

	// Model for dynamic makers
	Component {
		id: markerComponent
		MapQuickItem {
			anchorPoint.x: image.width/2
			anchorPoint.y: image.height
			sourceItem: Image {
				id: image
				source: "img/marker.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: {
					console.log("You clicked the marker!");
				}
			}
		}
	}
	
	// GPS position
	PositionSource {
		id: gps
		active: false
		updateInterval: 1000
		preferredPositioningMethods: PositionSource.AllPositioningMethods
		onPositionChanged: {
			console.log('nueva posicion GPS')
			map.center = position.coordinate
		}
	}

	Component.onCompleted: {
		console.log('mapa cargado')
	}

}

