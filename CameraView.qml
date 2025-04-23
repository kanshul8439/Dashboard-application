import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    border.color:"transparent"
    border.width:2
    color:"transparent"
    // color:"#05081c"
    id:root
    StackLayout {
        id: contentAreaStackView
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        currentIndex:0
        Rectangle {
            id: cam_menu
            // color: "#05081c"
            Layout.preferredWidth: parent.width
            Layout.preferredHeight:parent.height
            border.color:"#5ef4ef"
            color:"transparent"
            border.width:2

            Image{
                 source:"qrc:/Resources/Resources/background_image.jpg"
                anchors.fill:parent
                fillMode:Image.PreserveAspectCrop
                anchors.margins: 5
            }

            Image {
                id: car
                width: parent.height*0.38
                anchors.centerIn:parent

                fillMode: Image.PreserveAspectFit
                source: "qrc:/Resources/Resources/car_icon.png"
                horizontalAlignment: Image.AlignHCenter
                anchors.topMargin: 30
                anchors.bottomMargin: 30
                verticalAlignment: Image.AlignVCenter
            }
            CameraViewButton{
                anchors.top: car.bottom
                anchors.horizontalCenter: car.horizontalCenter
                rotation:90
                height:car.height/3
                width:car.height/3
                radius:car.height/3
                onNext:{
                    contentAreaStackView.currentIndex = 2;
                    root.buttonscale(contentAreaStackView.currentIndex)
                }
            }

            CameraViewButton{
                anchors.right: car.left
                anchors.verticalCenter: car.verticalCenter
                height:car.height/3
                rotation:180
                width:car.height/3
                radius:car.height/3
                onNext:{
                    contentAreaStackView.currentIndex = 3;
                    root.buttonscale(contentAreaStackView.currentIndex)
                }

            }
            CameraViewButton{
                anchors.left: car.right
                anchors.verticalCenter: car.verticalCenter
                height:car.height/3
                width:car.height/3
                radius:car.height/3
                onNext:{
                    contentAreaStackView.currentIndex = 4;
                    root.buttonscale(contentAreaStackView.currentIndex)
                }

            }
            CameraViewButton{
                anchors.bottom: car.top
                anchors.horizontalCenter: car.horizontalCenter
                rotation:-90
                height:car.height/3
                width:car.height/3
                radius:car.height/3
                onNext:{
                    contentAreaStackView.currentIndex = 1;
                    root.buttonscale(contentAreaStackView.currentIndex)
                }
            }
        }
        FrontCameraView{
            id:screen_2
        }

        RearCameraView{

            id:screen_3
        }
        LeftCameraView{
            id:screen_4
            // anchors.fill: parent
        }
        RightCameraView{
            id:screen_5
            // anchors.fill: parent
        }
    }
    ButtonGroup{
        id: buttongroup

    }
    function buttonscale(index)
    {
        back.scale = 1
        back.scale = 1.5
        top.scale = 1
        down.scale = 1
        left.scale = 1
        right.scale = 1
        if(index === 1){
            top.scale = 1.5
        }
        else if(index=== 2)
            down.scale = 1.5
        else if(index === 3)
            left.scale = 1.5
        else if(index === 4)
            right.scale = 1.5
    }

    Column{
        id: sidebuttons
        spacing:30
        anchors.left:parent.left
        anchors.leftMargin:40
        anchors.verticalCenter:parent.verticalCenter
        z:contentAreaStackView.currentIndex!==0?sidebuttons.visible=true:sidebuttons.visible=false;
        CameraViewButton{
            id: top
            rotation:-90
            // y:300
            onNext:{
                contentAreaStackView.currentIndex = 1;
                root.buttonscale(contentAreaStackView.currentIndex)

            }
        }
        CameraViewButton{
            id: down
            rotation:90
            onNext:{
                contentAreaStackView.currentIndex = 2;
                root.buttonscale(contentAreaStackView.currentIndex)
            }
        }

        CameraViewButton{
            id: right

            onNext:{
                contentAreaStackView.currentIndex = 4;
                root.buttonscale(contentAreaStackView.currentIndex)
            }
        }
        CameraViewButton{
            id: left
            rotation:180
            onNext:{
                contentAreaStackView.currentIndex = 3;
                root.buttonscale(contentAreaStackView.currentIndex)
            }
            // anchors.horizontalCenter:parent.horizontalCenter

        }
        ReturnCameraButton{
            id: back
            onAdjust:{
                contentAreaStackView.currentIndex = 0;
                root.buttonscale(contentAreaStackView.currentIndex)
            }

            // anchors.horizontalCenter:parent.horizontalCenter

        }


    }
}
