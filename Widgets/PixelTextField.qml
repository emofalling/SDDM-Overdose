import QtQuick
import QtQuick.Controls

TextField {
    id: root

    color: "#4e28cc"
    font.family: latinFont.name
    font.pixelSize: 20
    placeholderTextColor: "#c1bce7"
    verticalAlignment: TextInput.AlignVCenter
    leftPadding: 10
    rightPadding: 10

    background: Rectangle {
        color: "#fdfdfd"

        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 2
            color: "#8f8d89"
        }
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#8f8d89"
        }
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 2
            color: "#e2e2e1"
        }
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#e2e2e1"
        }
    }
}