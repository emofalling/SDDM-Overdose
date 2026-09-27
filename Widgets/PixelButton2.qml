import QtQuick
import QtQuick.Controls

Button {
    id: root

    background: Rectangle {
        color: root.pressed ? "#f7e0fa" : "#f7e0fa"

        // 顶部高光
        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 1 * config.Scale
            color: root.pressed ? "#815cda" : "#fdfdfd"
        }

        // 左侧高光
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 1 * config.Scale
            color: root.pressed ? "#815cda" : "#fdfdfd"
        }

        // 底部阴影
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 1 * config.Scale
            color: root.pressed ? "#fdfdfd" : "#815cda"
        }

        // 右侧阴影
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 1 * config.Scale
            color: root.pressed ? "#fdfdfd" : "#815cda"
        }
    }
}