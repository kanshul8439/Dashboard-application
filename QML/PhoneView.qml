import QtQuick 2.15

import QtCharts 2.15

Rectangle {

    id: chart

    // height: parent.height

    // width: parent.width

    // visible: true
    // color:"gra"

    border.color: "cyan"


    Rectangle {

        width: 200

        height: 50

        color: backend.value ? "darkblue" : "green"

        anchors.right: parent.right

        anchors.top: parent.top

        anchors.margins: 15

        radius: 8

        Text {

            text: backend.value ? "Disconnect" : "Connect"

            color: "white"

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

    Canvas {

        id: radialGauge

        width: 350

        height: 350

        anchors.right: parent.right

        anchors.rightMargin: 20

        anchors.bottom: chartView.bottom

        property real startAngle: 270

        property real spanAngle: 180

        property real minValue: 0

        property real maxValue: 3000

        property real value: 0  // Initialize the value property

        property int dialWidth: 50

        property color backgroundColor: "transparent"

        property color dialColor: "lightgrey"

        property bool showText: true

        property real lastValue: 0 // Checking the last value of CO2

        onValueChanged: {

                   if (value !== lastValue) {

                       lastValue = value;

                       requestPaint(); // Force canvas to repaint

                   }

               }

        onPaint: {

            var ctx = getContext("2d");

            ctx.reset();

            // Calculate dimensions

            var centerX = width / 2;

            var centerY = height / 2;

            var radius = Math.min(width, height) / 2 - dialWidth / 2;

            // Draw background

            ctx.beginPath();

            ctx.fillStyle = backgroundColor;

            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);

            ctx.fill();

            // Draw outer dial

            ctx.beginPath();

            ctx.strokeStyle = dialColor;

            ctx.lineWidth = dialWidth;

            var startRadians = (startAngle - 90) * Math.PI / 180;

            var spanRadians = spanAngle * Math.PI / 180;

            ctx.arc(centerX, centerY, radius, startRadians, startRadians + spanRadians);

            ctx.stroke();

            // Calculate progress angles

            var progressAngle = ((value - minValue) / (maxValue - minValue)) * spanRadians;

            var greenAngle = Math.min(progressAngle, ((1500 - minValue) / (maxValue - minValue)) * spanRadians);

            var yellowAngle = Math.min(progressAngle, ((2500 - minValue) / (maxValue - minValue)) * spanRadians) - greenAngle;

            var redAngle = progressAngle - greenAngle - yellowAngle;

            console.log("progressAngle greenAngle yellowAngle redAngle",progressAngle,greenAngle,yellowAngle,redAngle)

            console.log("centerX centerY radius startRadians spanRadians",centerX,centerY,radius,startRadians,spanRadians)

            // Draw green arc

            if (greenAngle > 0) {

                ctx.beginPath();

                ctx.strokeStyle = "green";

                ctx.lineWidth = dialWidth;

                ctx.arc(centerX, centerY, radius, startRadians, startRadians + greenAngle);

                ctx.stroke();

            }

            // Draw yellow arc

            if (yellowAngle > 0) {

                ctx.beginPath();

                ctx.strokeStyle = "yellow";

                ctx.lineWidth = dialWidth;

                ctx.arc(centerX, centerY, radius, startRadians + greenAngle, startRadians + greenAngle + yellowAngle);

                ctx.stroke();

            }

            // Draw red arc

            if (redAngle > 0) {

                ctx.beginPath();

                ctx.strokeStyle = "red";

                ctx.lineWidth = dialWidth;

                ctx.arc(centerX, centerY, radius, startRadians + greenAngle + yellowAngle, startRadians + greenAngle + yellowAngle + redAngle);

                ctx.stroke();

            }

            // Draw text

            if (showText) {

                ctx.font = '25px sans-serif';

                ctx.fillStyle = "black";

                ctx.textAlign = "center";

                ctx.textBaseline = "middle";

                var text = value.toFixed(0) + " ppm";

                ctx.fillText(text, centerX, centerY);

            }

        }

    }


    ChartView {

        id: chartView

        width: 700

        height: 650

        anchors.leftMargin: 20

        anchors.bottom: parent.bottom

        antialiasing: true

        Text {

            text: "CO2 Level Monitoring System"

            font.pixelSize: 30

            anchors.horizontalCenter: parent.horizontalCenter

            color: "black"

        }

        ValuesAxis {

            id: xAxis

            min: 0

            max: 100

            tickCount: 11

            titleText: "Time (seconds)"

            labelsFont.pixelSize: 30

            labelFormat: "%.0f"

        }

        ValuesAxis {
            id: yAxis
            min: 0
            max: 3000
            tickCount: 7
            titleText: "CO2 Values (ppm)"
            labelsFont.pixelSize: 30
            labelFormat: "%.0f"

        }

        LineSeries {
            id: lineSeries
            axisX: xAxis
            axisY: yAxis
        }

        ScatterSeries {

            id: scatterSeries
            axisX: xAxis
            axisY: yAxis
            markerShape: ScatterSeries.MarkerShapeCircle
            markerSize: 15
            color: "green"

        }

        Connections {

            target: backend

            property int prev_x: 0

            function onUpdateParameter(params) {

                // var values = params.split("#");

                if (params.hasOwnProperty("X")&&params.hasOwnProperty("Y") ) {
                    var x = parseFloat(params["X"]);
                    var y = parseFloat(params["Y"]);
                    radialGauge.value = y; // Update the Canvas value directly

                    console.log("x value:", x);
                    console.log("y value:", y);

                    // Add new data point
                    lineSeries.append(x, y);
                    scatterSeries.append(x, y);

                    // Remove old data points if x exceeds 100
                    if (prev_x === 100 && x !== 100) {
                        lineSeries.clear();
                        scatterSeries.clear();
                        xAxis.min = 0;
                        xAxis.max = 100;
                    }
                    if (prev_x !== x) {
                        prev_x = x;
                        console.log("prev value", prev_x);
                    }

                }

                else
                {
                console.log("x y coordinate not given properly");
                }
            }

        }

    }

}

