import QtQuick

Item {
    id: root

    property string iconSource
    property alias pressed: mouse.pressed

    signal clicked()

    Image {
        id: image
        source: root.iconSource
        width: root.width
        height: root.height
        fillMode: Image.Stretch
        smooth: false
        opacity: mouse.pressed ? 0.6 : 1.0
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()
    }
}