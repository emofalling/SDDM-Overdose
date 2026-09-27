import QtQuick
import QtQuick.Controls

TextField {
    id: root

    color: "#4e28cc"
    font.family: pixelFont.name
    font.pixelSize: 10 * config.Scale
    placeholderTextColor: "#c1bce7"
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 5 * config.Scale
    rightPadding: 5 * config.Scale
    topPadding: 5 * config.Scale
    bottomPadding: 5 * config.Scale

    background: Rectangle {
        color: "#fdfdfd"

        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 1 * config.Scale
            color: "#8f8d89"
        }
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 1 * config.Scale
            color: "#8f8d89"
        }
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 1 * config.Scale
            color: "#e2e2e1"
        }
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 1 * config.Scale
            color: "#e2e2e1"
        }
    }
}