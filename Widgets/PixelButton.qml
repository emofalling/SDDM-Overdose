import QtQuick
import QtQuick.Controls

Button {
    id: root

    height: 48
    font.family: latinFont.name
    font.pixelSize: 20

    contentItem: Text {
        text: root.text
        font: root.font
        color: "#4e28cc"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        color: root.pressed ? "#f7e0fa" : "#f1ecf1"

        // 顶部高光
        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 2
            color: root.pressed ? "#815cda" : "#fdebfd"
        }

        // 左侧高光
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 2
            color: root.pressed ? "#815cda" : "#fdebfd"
        }

        // 底部阴影
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 2
            color: root.pressed ? "#fcf1fc" : "#8459da"
        }

        // 右侧阴影
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 2
            color: root.pressed ? "#fcf1fc" : "#8459da"
        }
    }
}