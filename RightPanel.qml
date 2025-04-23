import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: right_panel
    color: "black"
    clip: true
    border.width: 3
    height: parent.height
    radius: 20

    function changeView(index){
        screen_view.currentIndex = index
    }

    StackLayout {
        id: screen_view
        width: parent.width * 4 / 5
        currentIndex: 0
        anchors.fill: parent
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        HomeView {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            id: screen_1
        }

        MapView {
            // Layout.alignment: parent.fillHeight|parent.fillWidth
            Layout.preferredWidth: parent.width

            Layout.preferredHeight: parent.height
            id: screen_2
        }
        CameraView {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            id: screen_3
        }
        MusicView {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            id: screen_4
        }
        PhoneView {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height
            id: screen_5
        }
    }
}
