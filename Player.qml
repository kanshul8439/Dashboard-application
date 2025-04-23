import QtQuick
import QtMultimedia
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    id:root
    color:"transparent"
    anchors.fill: parent
Rectangle {
    id: guage
    width: 450
    height: 450
    anchors.centerIn: parent
    color: "transparent"
    property real speed: 0  // This will be the current speed (0 - 100)
    property variant songs: ["audio-1", "audio-2", "audio-3", "audio-4", "audio-5"]
    property real index: 0
    MediaPlayer {
        id: playMusic
        Component.onCompleted:{
            if(guage.index >= guage.songs.length){
                guage.index = 0;
            }
            if(guage.index < 0){
                guage.index = guage.songs.length-1;
            }
        }
        source: "qrc:/Music/Music/" + guage.songs[guage.index] + ".mp3"
        audioOutput: AudioOutput {}
    }

    Canvas {
        id: speedCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var centreX = width / 2;
            var centreY = height / 2;
            var radius = width / 2 - 20;  // Radius of the circle
            var startAngle = Math.PI * 0.5;  // Start angle (top left)
            var endAngle = Math.PI * 2.5;  // End angle (top right)
            var needleAngle = startAngle + (playMusic.position / playMusic.duration) * (endAngle - startAngle);  // Needle angle

            // Draw the background (arc representing the speed range)
            ctx.beginPath();
            ctx.arc(centreX, centreY, radius, startAngle, endAngle, false);
            ctx.lineWidth = 22;
            ctx.strokeStyle = "cyan";  // Light gray for the background arc
            ctx.lineCap = "round";
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(centreX, centreY, radius, startAngle, endAngle, false);
            ctx.lineWidth = 20;
            ctx.strokeStyle = "black";  // Light gray for the background arc
            ctx.lineCap = "round";
            ctx.stroke();

            // Draw the filled arc representing the speed range
            ctx.beginPath();
            ctx.arc(centreX, centreY, radius, startAngle, needleAngle, false);
            ctx.lineWidth = 22;
            ctx.strokeStyle = "white";  // Green for the filled arc
            ctx.lineCap = "round";
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(centreX, centreY, radius, startAngle, needleAngle, false);
            ctx.lineWidth = 20;
            ctx.strokeStyle = "cyan";  // Green for the filled arc
            ctx.lineCap = "round";
            ctx.stroke();
            // Draw the needle (pointer)
            var needleLength = radius;  // Length of the needle
            var needleX = centreX + needleLength * Math.cos(needleAngle);
            var needleY = centreY + needleLength * Math.sin(needleAngle);

            // Optional: Draw a circle in the middle for the dial's center
            ctx.beginPath();
            ctx.arc(needleX, needleY, 10, 0, Math.PI * 2, false);
            ctx.fillStyle = "white";
            ctx.fill();
        }
    }

    // Property change handler for `speed`
    onSpeedChanged: {
        speedCanvas.requestPaint();  // Request a repaint on the canvas when speed changes
    }

    Timer {
        id: musictimer
        running: true
        repeat: true
        interval: 200
        onTriggered: {
            if(guage.speed == 99)
                guage.speed = 100
            else if(guage.speed == 100)
                guage.speed = 0
            else
                guage.speed = (guage.speed + 0.5) % 100;  // Increment speed and reset after 100
        }
    }

    AnimatedImage {
        width: 200
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        id: musicicon
        source: "qrc:/Resources/Resources/musicalcd_icon.gif"
    }

    Text {
        text: "Now Playing: " + guage.songs[guage.index]
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        anchors.horizontalCenter: musicicon.horizontalCenter
        anchors.bottom: musicicon.top
        color: "white"
    }

    Row {
        spacing: 5
        anchors.horizontalCenter: musicicon.horizontalCenter
        anchors.top: musicicon.bottom
        CustomPlayButton {
            Image {
                height: parent.height / 2
                width: parent.width
                rotation: parent.rotationangle
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/Resources/Resources/track_icon.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                antialiasing: true
                mirror: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    guage.index -= 1
                    if (guage.index < 0) {
                        guage.index = guage.songs.length - 1;
                    }
                    playMusic.play();
                }
            }
        }

        CustomPlayButton {
            Image {
                height: parent.height / 2
                width: parent.width
                rotation: parent.rotationangle
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: playMusic.playing !== 0 ? "qrc:/Resources/Resources/play_icon.png" : "qrc:/Resources/Resources/pause_icon.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                antialiasing: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (playMusic.playing === true) {
                        playMusic.pause()
                    }
                    else {
                        playMusic.play()
                    }
                }
            }
        }

        CustomPlayButton {
            Image {
                height: parent.height / 2
                width: parent.width
                rotation: parent.rotationangle
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/Resources/Resources/track_icon.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                antialiasing: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    guage.index += 1
                    if (guage.index >= guage.songs.length) {
                        guage.index = 0;
                    }
                    playMusic.play();
                }
            }
        }
    }

    // Right-aligned rectangle
}

Rectangle {

    border.color: "cyan"
    border.width: 2
    color: "transparent"
    anchors.right: root.right
    width: 200
    height: 250
    anchors.verticalCenter: root.verticalCenter
    anchors.rightMargin:50
    Rectangle {
        id:playlistrect
        width: parent.width
        height: 40
        color:  "cyan"
        Text{
            anchors.centerIn: parent
            text:"Playlist"
        }
    }
    ColumnLayout {
        width: parent.width-10
        height: parent.height-50
        // anchors.right: parent.right // Ensure the ColumnLayout aligns with the right edge of the parent
        // anchors.centerIn: parent
        anchors.top: playlistrect.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins:3
        spacing: 4
        Repeater {
            id: count
            model: guage.songs.length
            Rectangle {
                id: songName
                width: parent.width
                // anchors.margins:2
                anchors.topMargin:2
                anchors.leftMargin:5
                // anchors.horizontalCenter: parent.horizontalCenter
                // anchors.alignWhenCentered: parent
                height: 30
                radius: 5
                color: guage.index === index ? "cyan" : "black"
                border.color: "cyan"
                required property int index
                Text {
                    anchors.centerIn: parent
                    color: guage.index === parent.index ? "black" : "white"
                    text: guage.songs[parent.index]
                    font.pointSize: 10
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        guage.index = parent.index
                    }
                }
            }
        }
    }
}

}
