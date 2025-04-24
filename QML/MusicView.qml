import QtQuick
Rectangle{
    color:"#05081c"
    border.color:"cyan"
    border.width:2
    // color:"cyan"
    Image{
        source:"qrc:/Resources/Resources/background_image.jpg"
        anchors.fill:parent
        fillMode:Image.PreserveAspectCrop
        anchors.margins: 5
    }

    Player{

    }
}
