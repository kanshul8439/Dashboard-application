import QtQuick 2.15

import QtQuick.Controls 2.15

import QtQuick.Layouts 1.15

import QtLocation 5.15

import QtPositioning 5.15

// pragma ComponentBehavior: Bound

Rectangle {

    id: root
    // title: qsTr("Map")

    Plugin {

        id: mapPlugin

        name: "osm"

        PluginParameter { name: "osm.mapping.custom.host"; value: "https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=apikey=c94eaa3b77ea489db143c6d034ad7f7f" }

        PluginParameter { name: "osm.mapping.providerrepository.address"; value: "https://{s}.tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=c94eaa3b77ea489db143c6d034ad7f7f" }

    }

    RouteQuery {

        id: routeQuery

    }

    RouteModel {

        id: routeModel

        plugin: mapPlugin

        query: routeQuery

        autoUpdate: true

    }

    Map {

        id: map

        anchors.fill: parent

        plugin: mapPlugin

        property var dynamicLatitude: 12.9565

        property var dynamicLongitude: 77.7019

        center: QtPositioning.coordinate(dynamicLatitude, dynamicLongitude) // Oslo

        zoomLevel: 14

        property geoCoordinate startCentroid

        property var dynamicLatitudeArray: []

        property var dynamicLongitudeArray: []

        property int currentlocation: 0

        MapItemView {

            model: routeModel

            delegate: MapRoute {

                route: routeData

                line.color: "blue"

                line.width: 5

                smooth: true

                opacity: 0.8

            }

        }

        MapItemView {

            model: routeModel.status == RouteModel.Ready ? routeModel.get(0).path : null

            delegate: MapQuickItem {

                anchorPoint.x: pathMarker.width / 2

                anchorPoint.y: pathMarker.height / 2

                coordinate: modelData

                Component.onCompleted: {

                    map.dynamicLatitudeArray.push(coordinate.latitude); // Add the coordinate to the array when the delegate is created

                    map.dynamicLongitudeArray.push(coordinate.longitude);

                    console.log("Stored coordinate: " + JSON.stringify(coordinate));

                }

            //     sourceItem: Rectangle {

            //         id: pathMarker

            //         width: 8

            //         height: 8

            //         radius: 8

            //         border.width: 1

            //         border.color: "black"

            //         color: "yellow"

            //     }

            }

        }

        MapItemView {

            model: routeQuery.waypoints

            delegate: MapQuickItem {

                anchorPoint.x: waypointMarker.width / 2

                anchorPoint.y: waypointMarker.height / 2

                coordinate: modelData

                sourceItem: Rectangle {

                    id: waypointMarker

                    width: 10

                    height: 10

                    radius: 10

                    border.width: 1

                    border.color: "black"

                    color: "red"

                }

            }

        }

        Timer {

            id: timerstart

            interval: 2000; running: false; repeat: true

            onTriggered: {

                routeQuery.clearWaypoints()

                // routeModel.reset()

                routeQuery.addWaypoint(QtPositioning.coordinate(map.dynamicLatitude, map.dynamicLongitude)); // Marathahalli

                if (map.currentlocation < map.dynamicLatitudeArray.length) {

                    // Add the dynamic coordinate from the array

                    routeQuery.addWaypoint(QtPositioning.coordinate(map.dynamicLatitudeArray[map.currentlocation], map.dynamicLongitudeArray[map.currentlocation]))

                    map.center = QtPositioning.coordinate(map.dynamicLatitudeArray[map.currentlocation], map.dynamicLongitudeArray[map.currentlocation])

                    console.log(map.dynamicLatitudeArray[map.currentlocation])

                    console.log(map.dynamicLongitudeArray[map.currentlocation])

                }

                map.currentlocation += 1

                console.log(map.currentlocation)

                console.log(map.dynamicLongitudeArray.length)

                if (map.currentlocation == map.center)

                {

                    routeQuery.clearWaypoints()

                    routeModel.reset()

                    map.dynamicLatitudeArray = []

                    map.dynamicLongitudeArray = []

                    timerstart.running = false

                }

                // routeModel.update()

            }

        }

        MouseArea {

            anchors.fill: parent

            onClicked: {

                routeQuery.clearWaypoints()

                routeModel.reset()

                map.dynamicLatitudeArray = []

                map.dynamicLongitudeArray = []

                // routeQuery.addWaypoint(map.toCoordinate(Qt.point(mouse.x,mouse.y)))

                routeQuery.addWaypoint(QtPositioning.coordinate(map.dynamicLatitude, map.dynamicLongitude)); // Marathahalli

                routeQuery.addWaypoint(map.toCoordinate(Qt.point(mouse.x,mouse.y)))

                /*                routeQuery.addWaypoint(QtPositioning.coordinate(12.9716, 77.6958)); // Doddanekundi

                routeQuery.addWaypoint(QtPositioning.coordinate(12.9916, 77.6958)); // KR Puram

                routeQuery.addWaypoint(QtPositioning.coordinate(13.0358, 77.6200)); // Nagawara

                routeQuery.addWaypoint(QtPositioning.coordinate(13.0352, 77.5887));*/ // Hebbal

                routeModel.update()

                timerstart.running = false

            }

        }

        PinchHandler {

            id: pinch

            target: null

            onActiveChanged: if (active) {

                                 map.startCentroid = map.toCoordinate(pinch.centroid.position, false)

                             }

            onScaleChanged: (delta) => {

                                map.zoomLevel += Math.log2(delta)

                                map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)

                            }

            onRotationChanged: (delta) => {

                                   map.bearing -= delta

                                   map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)

                               }

            grabPermissions: PointerHandler.TakeOverForbidden

        }

        WheelHandler {

            id: wheel

            // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:

            // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler

            // and we don't yet distinguish mice and trackpads on Wayland either

            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"

                             ? PointerDevice.Mouse | PointerDevice.TouchPad

                             : PointerDevice.Mouse

            rotationScale: 1/120

            property: "zoomLevel"

        }

        DragHandler {

            id: drag

            target: null

            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)

        }

        Shortcut {

            enabled: map.zoomLevel < map.maximumZoomLevel

            sequence: "Up"

            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)

        }

        Shortcut {

            enabled: map.zoomLevel > map.minimumZoomLevel

            sequence: "Down"

            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)

        }

    }

    RowLayout {

        anchors.bottom: map.bottom

        anchors.horizontalCenter: map.horizontalCenter

        Button {

            text: "Start"

            onClicked: {timerstart.running = true; map.zoomLevel = 16}

        }

        Button {

            text: "Pause"

            onClicked: timerstart.running = false

        }

        Button {

            text: "Reset"

            onClicked: {

                routeQuery.clearWaypoints()

                routeModel.reset()

                map.dynamicLatitudeArray = []

                map.dynamicLongitudeArray = []

                timerstart.running = false

            }

        }

    }

}

