import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Rectangle{
    id:left_panel
    color:"black"
    width:parent.width/8
    height:parent.height
   anchors.left: parent.left
   anchors.top:parent.top
   signal changeScreensByIndex(int index)
    function changeButton(index){

        //make all button set to normal
        for(var i=0;i<left_panel_button_selection.children.length;i++)
        {
             left_panel_button_selection.children[i].checked=false;
             left_panel_button_selection.children[i].scale=1;
        }
        left_panel_button_selection.children[index].checked=true;
        left_panel_button_selection.children[index].scale=1.2;
    }
   ColumnLayout{
       id:left_panel_button_selection
        spacing:50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        ButtonOperations{
            checked: true
            scale:1.2
            Image{
                clip: true
            source: "qrc:/Resources/Resources/home_icon.png"
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            }
            onClick: {

                leftPanel.changeButton(0);
                changeScreensByIndex(0)
            }
        }
        ButtonOperations{
            Image{
                clip: true
            source: "qrc:/Resources/Resources/map_icon.png"
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            }
            onClick: {
                leftPanel.changeButton(1);
                changeScreensByIndex(1)
            }
        }
        ButtonOperations{
            Image{
                clip: true
            source: "qrc:/Resources/Resources/video_icon.png"
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            }
            onClick: {

                leftPanel.changeButton(2);
                changeScreensByIndex(2)
            }
        }

        ButtonOperations{
            Image{
                clip: true
            source: "qrc:/Resources/Resources/music_icon.png"
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            }
            onClick: {
                leftPanel.changeButton(3);
                changeScreensByIndex(3)
            }
        }
        ButtonOperations{
            Image{
                clip: true
            source: "qrc:/Resources/Resources/chart_icon.png"
            anchors.fill: parent
            fillMode: Image.Stretch
            smooth: true
            }
            onClick: {

                leftPanel.changeButton(4);
                changeScreensByIndex(4)
            }
        }
    }
}


// Rectangle {
//     id: left_panel
//     color: "#D3D3D3"
//     width: parent.width
//     height: parent.height
//     border.color: "cyan"
//     border.width: 1.5
//     radius: 20


//     ColumnLayout {
//         id: left_panel_button_selection
//         anchors.centerIn: parent
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.leftMargin: 10
//         spacing: 30

//         ButtonOperations {
//             id: button_1
//             checked: true
//             btngroup: left_panel_buttons_group
//             Image {
//                 anchors.centerIn: parent
//                 height: 50
//                 width: 50
//                 source: "qrc:/Resources/Resources/menuhome_icon.png"
//             }
//             onWork:{
//                 button_1.checked = true
//                 left_panel_buttons_group.checkedButtonItem = button_1
//                 changeScreensByIndex(0)
//             }
//         }

//         ButtonOperations {
//             id: button_2
//             checked: false
//             btngroup: left_panel_buttons_group

//             Image {
//                 anchors.centerIn: parent
//                 height: 50
//                 width: 50
//                 source: "qrc:/Resources/Resources/menumap_icon.png"
//             }

//             onWork: {
//                 button_2.checked = true
//                 left_panel_buttons_group.checkedButtonItem = button_2
//                 changeScreensByIndex(1)
//             }
//         }

//         ButtonOperations{
//             id:button_3
//             checked:false
//             btngroup:left_panel_buttons_group
//             Image{
//                 anchors.centerIn:parent
//                 height:50
//                 width:50
//                 source:"qrc:/Resources/Resources/menucam_icon.png"
//             }
//             onWork:{
//                 button_3.checked=true
//                 left_panel_buttons_group.checkedButtonItem=button_3
//                 changeScreensByIndex(2)
//             }
//         }

//         ButtonOperations{
//             id:button_4
//             checked:false
//             btngroup:left_panel_buttons_group
//             Image{
//                 anchors.centerIn:parent
//                 height:50
//                 width:50
//                 source:"qrc:/Resources/Resources/menuphone_icon.png"
//             }
//             onWork:{
//                 button_4.checked=true
//                 left_panel_buttons_group.checkedButtonItem=button_4
//                 changeScreensByIndex(3)
//             }
//         }

//         ButtonOperations{
//             id:button_5
//             checked:false
//             btngroup:left_panel_buttons_group
//             Image{
//                 anchors.centerIn:parent
//                 height:50
//                 width:50
//                 source:"qrc:/Resources/Resources/menumusic_icon.png"
//             }
//             onWork:{
//                 button_5.checked=true
//                 left_panel_buttons_group.checkedButtonItem=button_5
//                 changeScreensByIndex(4)
//             }
//         }
//     }

//     ButtonGroup {
//         id: left_panel_buttons_group
//         exclusive: true
//         onCheckedButtonItemChanged: {
//             for (var i = 0; i < left_panel_button_selection.children.length; i++) {
//                 var temp = left_panel_button_selection.children[i];
//                 if (temp !== checkedButtonItem) {
//                     temp.checked = false;
//                 }
//             }
//         }
//         property Item checkedButtonItem
//     }
// }
