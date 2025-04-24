import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle{
id:button
 color: mouseArea.containsMouse ? (button.checked ? "gray" : "white") : (button.checked ? "white" : "gray")
 height:50
 width:50
 border.width:1
signal click()
 property bool checked: false
 MouseArea {
         id: mouseArea
         anchors.fill: parent
         hoverEnabled: button.checked?false:true  // Enable hover detection

         onClicked: {
             checked=true;
             click();
         }
 }
}
