import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
// import com.mycompany 1.0

Rectangle{
    border.color:"#5ef4ef"
    border.width:2
    color:"transparent"
    id:root

    property string prev_speed: "0"
    property string prev_avg_speed:"0"
    property string prev_avg_fuel_usage: "0"
    property string prev_distance: "0"
    property string prev_battery_pct: "0"
    Image{
         source:"qrc:/Resources/Resources/background_image.jpg"
        anchors.fill:parent
        fillMode:Image.PreserveAspectCrop
        anchors.margins: 5
    }

    Row {
            id:batteryusageinfo
            y:250
            spacing: 30
            anchors.left: currentTime.left
            Image {
                height:55
                anchors.bottom: fuelcol.bottom
                anchors.bottomMargin: 5
                fillMode:Image.PreserveAspectFit
                source: "qrc:/Resources/Resources/battery_usage.png"
            }
            // }
            ColumnLayout {
                id:fuelcol
                Text {
                    id:avg_fuel_usage
                    text: "34 kWh/km"
                    font.pixelSize: 30
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color:"orange"
                }

                Text {
                    text: "Avg. Battery Usage"
                    font.pixelSize: 20
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color: "white"
                }
            }
        }
    RowLayout {
            id:speedinfo
            anchors.top:batteryusageinfo.bottom
            // anchors.left:batteryusageinfo.left
            anchors.topMargin: 25
            // anchors.leftMargin:25
            spacing: 30
            Image {
                Layout.preferredWidth:55
                fillMode:Image.PreserveAspectFit
                Layout.leftMargin:25
                source: "qrc:/Resources/Resources/speed_icon.svg"
            }
            ColumnLayout {
                Text {
                    id:avg_speed
                    text: backend.isConnected ? avg_speed.text  :prev_avg_speed
                    font.pixelSize: 30
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color: "#5ef4ef"
                }

                Text {
                    text: "Avg. Speed"
                    font.pixelSize: 20
                    font.family: "Inter"
                    font.bold: Font.Normal
                    opacity: 0.8
                    color: "white"
                }
            }
        }
    RowLayout {
        id:distanceinfo
        anchors.top:batteryusageinfo.top
        anchors.bottom: batteryusageinfo.bottom
        // anchors.topMargin: 25
        anchors.rightMargin:25
         anchors.right:root.right
        spacing: 30
        Image {
            Layout.leftMargin:25
            source: "qrc:/Resources/Resources/road_icon.svg"
        }
        ColumnLayout {
            Text {
                id:id_distance
                text: "188 Kms"
                font.pixelSize: 30
                font.family: "Inter"
                font.bold: Font.Normal
                opacity: 0.8
                color: "#5ef4ef"
            }

            Text {
                text: "Odometer"
                font.pixelSize: 20
                font.family: "Inter"
                font.bold: Font.Normal
                opacity: 0.8
                color: "white"
            }
        }
    }
    Row {
        id:charging_statusinfo
        anchors.bottom: speedinfo.bottom
        anchors.top:speedinfo.top
        anchors.left:distanceinfo.left
        anchors.right: root.right
        anchors.leftMargin: 25
        // anchors.rightMargin:25
         // anchors.right:root.right
        spacing: 45
        Image {
            // Layout.leftMargin:25
            height:60
            fillMode:Image.PreserveAspectFit
            anchors.rightMargin: 15
            anchors.bottom:charging_column.bottom
            anchors.bottomMargin: 5
            source: "qrc:/Resources/Resources/charger_icon.png"
        }
        ColumnLayout {
            id:charging_column
            Text {
                id:charging_percent
                text: "64"+"%"
                font.pixelSize: 30
                font.family: "Inter"
                font.bold: Font.Normal
                opacity: 0.8
                color:"green"
            }

            Text {
                text: "Charging"
                font.pixelSize: 20
                font.family: "Inter"
                font.bold: Font.Normal
                opacity: 0.8
                color: "white"
            }
        }
    }


    Text{
        id: currentTime
        text: Qt.formatDateTime(new Date(), "hh:mm")
        font.pixelSize: 32
        font.family: "Inter"
        font.bold: Font.DemiBold
        color: "white"

        anchors.top:currentDate.bottom
        anchors.left:parent.left
        anchors.topMargin: 15
        anchors.leftMargin:25
        // anchors.horizontalCenter: parent.horizontalCenter
    }

    Text{                        // Should include QtQuickControl module for it.
        id: currentDate
        text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
        font.pixelSize: 32
        font.family: "Inter"
        font.bold: Font.DemiBold
        color: "white"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.topMargin: 15
    }

    Text {

        anchors.top:parent.top
        anchors.topMargin:20
        id:titletext
        anchors.horizontalCenter:parent.horizontalCenter
        text: "SAMRIDDHI"
        font.family: "Roboto"
        font.pixelSize: 48
        font.bold: true

        color:"#5ef4ef"
    }
    Speedometer{
        id:speedmtr

        border.color:"#5ef4ef"
        speed:prev_speed
        needlecolor:"#5ef4ef"
        anchors.centerIn:parent
    }

    Connections {
        target: backend
        function onUpdateParameter(params) {
            // Check if the key exists before accessing its value

            if (params.hasOwnProperty("speed")) {
                speedmtr.speed = params["speed"];
                prev_speed = params["speed"];
            }

            if (params.hasOwnProperty("avgspeed")) {
                avg_speed.text = params["avgspeed"] + " km/h";
                prev_avg_speed = params["avgspeed"];
            }

            if (params.hasOwnProperty("avgbatteryusage")) {
                avg_fuel_usage.text = params["avgbatteryusage"] + " kWh/km";
                prev_avg_fuel_usage = params["avgbatteryusage"];
            }

            if (params.hasOwnProperty("distance")) {
                id_distance.text = params["distance"] + " kms";
                prev_distance = params["distance"];
            }

            if (params.hasOwnProperty("leftindicator")) {
                if (params["leftindicator"].toUpperCase() === "ON") {
                    indicatorleft.visible = true;
                } else {
                    indicatorleft.visible = false;
                }
            }

            if (params.hasOwnProperty("rightindicator")) {
                if (params["rightindicator"].toUpperCase() === "ON") {
                    indicatorright.visible = true;
                } else {
                    indicatorright.visible = false;
                }
            }

            if (params.hasOwnProperty("chargingstatus")) {
                if (params["chargingstatus"].toUpperCase() === "TRUE") {
                    charging_statusinfo.visible = true;
                } else {
                    charging_statusinfo.visible = false;
                }
            }

            if (params.hasOwnProperty("chargingpercentage")) {
                var charging_pct = parseInt(params["chargingpercentage"]);
                if (isNaN(charging_pct)) {
                    console.log("The parsing was unsuccessful. 'chargingpercentage' is not a valid number.");
                } else {
                    if (charging_pct > 0 && charging_pct <= 100) {
                        charging_percent.text = params["chargingpercentage"] + "%";
                    } else {
                        console.log("Charging percentage invalid");
                    }
                }
            }

            if (params.hasOwnProperty("tyrepressure")) {
                var tyrepressure = parseInt(params["tyrepressure"]);
                if (isNaN(tyrepressure)) {
                    console.log("The parsing was unsuccessful. 'tyrepressure' is not a valid number.");
                } else {
                    if (tyrepressure > 0) {
                        tyre_pressure_text.text = params["tyrepressure"];
                    }
                }
            }

            if (params.hasOwnProperty("warningsignflag")) {
                if (params["warningsignflag"].toUpperCase() === "ON") {
                    warning_hazard_icon.visible = true;
                } else {
                    warning_hazard_icon.visible = false;
                }
            }

            if (params.hasOwnProperty("range")) {
                var range = parseInt(params["range"].trim());
                if (isNaN(range)) {
                    console.log("The parsing was unsuccessful. 'range' is not a valid number.");
                } else {
                    estd_range_kms.text = params["range"] + " Kms\n" + "RANGE";
                }
            }
        }

    }

    Image{
        id:indicatorleft
        source:"qrc:/Resources/Resources/indicator_active.png"
        visible: true
        height:35
        fillMode:Image.PreserveAspectFit
        y:120
        x:300
        // anchors.left:speedinfo.right
        anchors.leftMargin: 60
        // anchors.bottom: batteryusageinfo.top
        // anchors.centerIn: parent
    }
    Image{
        id:indicatorright
        source:"qrc:/Resources/Resources/indicator_active.png"
        visible: false
        height:35
        // y:120
        x:785
        rotation:180
        fillMode:Image.PreserveAspectFit
        anchors.top:indicatorleft.top
        anchors.leftMargin: 5
        anchors.bottom: indicatorleft.bottom
        // anchors.centerIn: parent
        // anchors.right:distanceinfo.left
    }
    Image{
        id:tyre_pressure_icon
        source:"qrc:/Resources/Resources/tyre_pressure_icon.png"
        height:35
        fillMode:Image.PreserveAspectFit
        anchors.left: currentDate.left
        anchors.bottomMargin: 20
        anchors.bottom:parent.bottom
    }
    Column{
        anchors.left: tyre_pressure_icon.right
        anchors.top:tyre_pressure_icon.top
        anchors.bottom:tyre_pressure_icon.bottom
        anchors.leftMargin: 5
        spacing:1
        Text{
            id:tyre_pressure_text
            text:"32"
            font.pixelSize: 13
            color:"yellow"
            font.bold: true
        }
        Text {
            text: "psi"
            color:"white"
            font.pixelSize: 11
            font.bold: true

        }
    }


    Image{
        id:warning_hazard_icon
        source:"qrc:/Resources/Resources/warning_icon.png"
        height:35
        fillMode:Image.PreserveAspectFit
        anchors.bottomMargin: 20
        anchors.right:distanceinfo.right
        anchors.bottom:parent.bottom
    }


    Text{
        id:estd_range_kms
        text:"290 Kms\n"+"RANGE"
        font.pixelSize: 25
        color:"#FEC819"
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.bottom: warning_hazard_icon.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }


    Rectangle {
            width: 200
            height: 50
            color: backend.value ? "darkblue" : "green"
            anchors.right:parent.right
            anchors.top:parent.top
            anchors.margins: 15
            radius:8

            Text {
                text: backend.value ? "Disconnect" : "Connect"
                color:"white"
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (backend.value) {
                        backend.disconnectfromserver()
                    } else {
                        backend.connecttoserver()
                    }

                }
            }
        }

}
