import QtQuick
import QtMultimedia
Rectangle{
         // anchors.fill: parent
         height:parent.height
         width:parent.width
          color:"black"
          property string cameraDeviceName
          property var selectedDevice

          MediaDevices {
              id: mediaDevices
          }
              CaptureSession {
                  camera: Camera {
                      id: camera
                      cameraDevice: mediaDevices.videoInputs[0]
                      active: true
                      onErrorOccurred: {
                          console.log("Camera object has some error", errorString)
                      }
                  }

                  videoOutput: videoOutput
              }
          // }

          VideoOutput {
              id: videoOutput
              anchors.fill: parent
          }
     }

