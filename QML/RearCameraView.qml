import QtQuick
Rectangle{
    // anchors.fill: parent
    height:parent.height
    width:parent.width
    color:"black"
        AnimatedImage{
            height: parent.height
            anchors.fill:parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Resources/Resources/rearcam_view.gif"
        }
        // Text {
        //     text:"Top View"
        // }
}
