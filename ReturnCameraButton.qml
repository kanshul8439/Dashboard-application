import QtQuick

Rectangle{
    id: root
    anchors.margins: 8
    width: 50
    height: 50
    radius: width/2
    border.color: "cyan"
    color: "black"

    signal adjust()
    property bool checked : false

    Image {
        height: parent.height
        width: parent.width
        anchors.centerIn:parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Resources/Resources/back_icon.png"
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        antialiasing: true
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            parent.color = 'cyan'
        }
        onClicked: {
            if(root.checked == true){
                root.scale = 2
            }
            else{
                root.scale = 1
            }
            parent.adjust()
        }
        onExited: {
            parent.color = 'black'
        }
    }
}
