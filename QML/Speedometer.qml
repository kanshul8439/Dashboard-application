import QtQuick
import QtQuick.Window 2.15
// import QtQuick
// import QtQuick.Window 2.15

Rectangle {
    id: root
    property real speed: 100
    property color needlecolor: "red"
    property real heightcustom: 350
    property real widthcustom: 350
    property real arcProgress: 0

    height: root.heightcustom
    width: root.widthcustom
    radius: width / 2
    color: "transparent"
    border.color: "red"
    border.width: 10

    // Timer for animating the arc progress
    Timer {
        id: arcTimer
        interval: 16  // 60 FPS animation
        running: true
        repeat: true
        onTriggered: {
            if (root.speed < 0) {
                root.speed = 0;
            }
            if (root.speed > 180) {
                root.speed = 180; // Cap to 180
            }

            // Gradually adjust the arc progress for smooth transitions
            var speedDifference = root.speed - root.arcProgress;

            // Smooth transition (easing method)
            if (Math.abs(speedDifference) > 1) {
                root.arcProgress += speedDifference / 8;  // Dividing the difference for smoother transition
            } else {
                root.arcProgress = root.speed;  // If the difference is small, snap to the target value
            }

            canv.requestPaint();  // Request a redraw of the Canvas when the value changes
        }
    }

    Canvas {
        id: canv
        anchors.centerIn: parent
        width: root.heightcustom
        height: root.widthcustom

        onPaint: {
            var representingspeed;
            if (root.speed > 180) representingspeed = 180;
            else if (root.speed < 0) representingspeed = 0;
            else representingspeed = root.speed;

            var ctx = getContext("2d");
            ctx.reset();

            // Color coding for the arc sections
            const color_Codes = [
                "rgb(144, 238, 144)", "rgb(173, 255, 47)", "rgb(0, 255, 0)",
                "rgb(154, 205, 50)", "rgb(255, 255, 0)", "rgb(255, 165, 0)",
                "rgb(255, 140, 0)", "rgb(255, 69, 0)", "rgb(255, 0, 0)"
            ];

            // Draw the color-coded arc sections
            for (var i = 0; i <= 8; i++) {
                var localspeed = i * 20;
                var tempstartAngle = 3 * Math.PI / 4 + (Math.PI / 6 * i);
                var tempendAngle = tempstartAngle + Math.PI / 6;
                ctx.beginPath();
                ctx.arc(width / 2, width / 2, 125, tempstartAngle, tempendAngle);
                ctx.lineWidth = 15;
                ctx.strokeStyle = color_Codes[i];
                ctx.stroke();
            }

            // Arc representing speed (draw progressively)
            var startAngle = 3 * Math.PI / 4;
            var endAngle = startAngle + (root.arcProgress * 1.5 * Math.PI / 180);
            ctx.beginPath();
            ctx.arc(width / 2, width / 2, 125, startAngle, endAngle);
            ctx.lineWidth = 30;
            if (root.speed < 70) {
                ctx.strokeStyle = "green";
            } else if (root.speed < 130) {
                ctx.strokeStyle = "yellow";
            } else {
                ctx.strokeStyle = "red";
            }
            ctx.stroke();
        }
    }

    // Centered Text Component to show the current speed
    Text {
        id: speedText
        text: "  " + (root.speed < 0 ? 0 : (root.speed > 180 ? 180 : root.speed)) + "\nKm/h"
        anchors.centerIn: parent
        font.family: "Roboto"
        font.pixelSize: 48
        font.bold: true
        color: "#5ef4ef"
    }

    // Key Event Handling for speed control
    FocusScope {
        id: keyFocus
        focus: true  // Ensures that this component receives keyboard input
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Up) {
                // Increase speed when the Up arrow is pressed
                if (root.speed < 180) {
                    root.speed += 1;
                }
            } else if (event.key === Qt.Key_Down) {
                // Decrease speed when the Down arrow is pressed
                if (root.speed > 0) {
                    root.speed -= 1;
                }
            }
        }
    }
}

// Rectangle {
//     id: root
//     property real speed: 100
//     property color needlecolor: "red"
//     property real heightcustom: 350
//     property real widthcustom: 350
//     property real arcProgress: 0

//     height: root.heightcustom
//     width: root.widthcustom
//     radius: width / 2
//     color: "transparent"
//     border.color: "red"
//     border.width: 10

//     // Timer for animating the arc progress
//     Timer {
//         id: arcTimer
//         interval: 100
//         running: true
//         repeat: true
//         onTriggered: {
//             if (root.speed < 0) {
//                 root.speed = 0;
//             }
//             if (root.speed > 180) {
//                 root.speed = 180; // Cap to 180
//             }

//             // Gradually adjust the arc progress for smooth transitions
//             if (root.arcProgress < root.speed) {
//                 root.arcProgress += 1.5;
//             } else if (root.arcProgress > root.speed) {
//                 root.arcProgress -= 1.5;  // Gradually decrease the arc if speed decreases
//             }
//            // if(onSpeedChanged())
//            // {
//            //
//            // }
//              canv.requestPaint();
//         }
//     }
//     onSpeedChanged: {
//         arcTimer.running=true;
//     }

//     Canvas {
//         id: canv
//         anchors.centerIn: parent
//         width: root.heightcustom
//         height: root.widthcustom

//         onPaint: {
//             var representingspeed;
//             if (root.speed > 180) representingspeed = 180;
//             else if (root.speed < 0) representingspeed = 0;
//             else representingspeed = root.speed;

//             var ctx = getContext("2d");
//             ctx.reset();

//             // Markings (e.g., for each 20 km/h increment)
//             // ctx.lineWidth = 3;
//             // ctx.strokeStyle = "yellow";
//             // var radiusformarking = 140;
//             // for (var i = 0; i <= 9; i++) {
//             //     var angle = 3 * Math.PI / 4 + i * Math.PI / 6;
//             //     var x = width / 2 + (radiusformarking * Math.cos(angle));
//             //     var y = width / 2 + (radiusformarking * Math.sin(angle));
//             //     ctx.beginPath();
//             //     ctx.moveTo(x - 10 * Math.cos(angle), y - 10 * Math.sin(angle));
//             //     ctx.lineTo(x, y);
//             //     ctx.stroke();
//             // }

//             // Color coding for the arc sections
//             const color_Codes = [
//                 "rgb(144, 238, 144)", "rgb(173, 255, 47)", "rgb(0, 255, 0)",
//                 "rgb(154, 205, 50)", "rgb(255, 255, 0)", "rgb(255, 165, 0)",
//                 "rgb(255, 140, 0)", "rgb(255, 69, 0)", "rgb(255, 0, 0)"
//             ];

//             for (var i = 0; i <= 8; i++) {
//                 var localspeed = i * 20;
//                 var tempstartAngle = 3 * Math.PI / 4 + (Math.PI / 6 * i);
//                 var tempendAngle = tempstartAngle + Math.PI / 6;
//                 ctx.beginPath();
//                 ctx.arc(width / 2, width / 2, 125, tempstartAngle, tempendAngle);
//                 ctx.lineWidth = 15;
//                 ctx.strokeStyle = color_Codes[i];
//                 ctx.stroke();
//             }

//             // Arc representing speed (draw progressively)
//             var startAngle = 3 * Math.PI / 4;
//             var endAngle = startAngle + (root.arcProgress * 1.5 * Math.PI / 180);
//             ctx.beginPath();
//             ctx.arc(width / 2, width / 2, 125, startAngle, endAngle);
//             ctx.lineWidth = 30;
//             if(root.speed<70)
//             {
//                 ctx.strokeStyle = "green";
//             }else if(root.speed<130)
//             {
//                 ctx.strokeStyle = "yellow";
//             }
//             else
//             {
//                 ctx.strokeStyle = "red";
//             }
//             ctx.stroke();
//         }
//     }

//     // Centered Text Component to show the current speed
//     Text {
//         id: speedText
//         text:"  " + (root.speed < 0 ? 0 : (root.speed > 180 ? 180 : root.speed)) + "\nKm/h"
//         anchors.centerIn: parent
//         font.family: "Roboto"
//         font.pixelSize: 48
//         font.bold: true
//         // onTextChanged: {
//         //     canv.requestPaint();
//         // }

//         color:"#5ef4ef"
//         // color: "black"
//     }

//     // Key Event Handling for speed control
//     FocusScope {
//         id: keyFocus
//         focus: true  // Ensures that this component receives keyboard input
//         Keys.onPressed: function (event){
//             // arcTimer.start();
//             // We use a flag to avoid triggering multiple rapid key events
//             // if (event.key === Qt.Key_Up) {
//             //     // Increase speed when the Up arrow is pressed
//             //     if (!arcTimer.running) {
//             //         arcTimer.start();
//             //         arcTimer.running=true;/// Start the animation timer only if it's not already running
//             //     }
//             //     if (root.speed < 180) {
//             //         root.speed += 1;
//             //     }
//             // } else if (event.key === Qt.Key_Down) {
//             //     // Decrease speed when the Down arrow is pressed
//             //     if (!arcTimer.running) {
//             //         arcTimer.start();  // Start the animation timer only if it's not already running

//             //     }
//             //     if (root.speed > 0) {
//             //         root.speed -= 1;
//             //     }
//             // }
//         }
//     }
// }
