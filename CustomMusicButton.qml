import QtQuick

Rectangle{
    id: root
    // signal next()
    property bool checked : false
    property real rotationangle: 0

    anchors.margins: 8
    width: 50
    height: 50
    radius: width/2
    // anchors.top: car.bottom
    // anchors.horizontalCenter: car.horizontalCenter
    border.color: "cyan"
    color: "black"
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { parent.color = 'cyan' }
        onClicked: {

            // if(root.checked == true){
            //     root.scale = 2
            // }
            // else
            //     root.scale = 1

            // parent.next()
        }

        onExited: { parent.color = 'black' }
    }
}
