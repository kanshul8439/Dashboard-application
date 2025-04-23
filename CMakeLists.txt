cmake_minimum_required(VERSION 3.16)

project(Samriddhi-Dashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED Core Qml
    COMPONENTS Quick
    QuickControls2 Charts
)

qt_standard_project_setup(REQUIRES 6.5)
qt_add_resources(SOURCES Resources.qrc )

qt_add_executable(appSamriddhi-Dashboard
    main.cpp
    ${SOURCES}
)

qt_add_qml_module(appSamriddhi-Dashboard
    URI Samriddhi-Dashboard
    VERSION 1.0
        RESOURCES Resources.qrc
        QML_FILES QML/BottomCamScreen.qml QML/ButtonOperations.qml QML/CameraView.qml QML/CameraViewButton.qml QML/CustomMusicButton.qml QML/CustomPlayButton.qml QML/FrontCameraView.qml QML/HomeView.qml QML/LeftCameraView.qml QML/LeftPanel.qml QML/Main.qml QML/MapView.qml QML/MusicView.qml QML/PhoneView.qml QML/PlayButton.qml QML/Player.qml QML/RearCameraView.qml QML/ReturnCameraButton.qml QML/RightCameraView.qml QML/RightPanel.qml QML/Speedometer.qml
        SOURCES backend.h backend.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSamriddhi-Dashboard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSamriddhi-Dashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSamriddhi-Dashboard
    PRIVATE Qt6::Quick
    Qt6::QuickControls2
    Qt6::Core
    Qt6::Charts
    Qt6::Qml

)

include(GNUInstallDirs)
install(TARGETS appSamriddhi-Dashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
