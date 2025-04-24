import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 1600
    height: 800
    title: qsTr("VROOOM")
    // Left Panel
    // visibility: Window.FullScreen

    Rectangle{
    color:"black"
    anchors.fill:parent
    }
    LeftPanel {
        id: leftPanel
        // anchors.left: rightPanel.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        // color: "transparent"
    }

    // Right Panel
    RightPanel {
        id: rightPanel
        // anchors.left: parent.left
        anchors.left: leftPanel.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "transparent"

        Component.onCompleted:{
            leftPanel.changeScreensByIndex.connect(rightPanel.changeView)
        }


    }

}
