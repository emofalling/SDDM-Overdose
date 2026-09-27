import QtQuick

Image {
    id: root
    source: "Images/separator.png"
    width: 5 * config.Scale / 2
    height: 33 * config.Scale / 2
    smooth: false
    anchors.verticalCenter: parent.verticalCenter
}