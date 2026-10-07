import QtQuick

Item {
    id: root

    property var texts: []
    property var images: []
    property var funcs: []
    property var enableds: [] // false禁用，true启用，null表示占位用
    property string fontFamily: ""

    property int menuX: 0
    property int menuY: 0

    property real menuWidth: 0      // 新增：外部传入的菜单宽度

    visible: false
    z: 100

    /*
    // 全屏遮罩，点击关闭
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }
    */

    // 菜单列表
    Column {
        id: listColumn

        x: root.menuX
        y: root.menuY - listColumn.height
        width: root.menuWidth       // 新增：列宽跟随传入值

        Repeater {
            model: root.texts

            Item {
                id: itemRoot

                width: root.menuWidth   // 新增：每行宽度跟随列宽
                implicitHeight: 20 * config.Scale


                Row {
                    id: itemRow
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 4 * config.Scale
                    spacing: 2 * config.Scale

                    Image {
                        source: root.images[index] || ""
                        width: 16 * config.Scale
                        height: 16 * config.Scale
                        fillMode: Image.PreserveAspectFit
                        smooth: false
                        visible: source !== ""
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: root.texts[index]
                        font.family: root.fontFamily
                        font.pixelSize: 10 * config.Scale
                        color: root.enableds[index] ? "#4e28cc" : "#8d7ccc"
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse && root.enableds[index] ? "#f9e0fa" : "#f7e0fa"
                    z: -1

                    Rectangle {
                        anchors { left: parent.left; right: parent.right; top: parent.top }
                        height: 1 * config.Scale
                        color: mouseArea.containsMouse && root.enableds[index] ? "#815cda" : "transparent"
                    }
                    Rectangle {
                        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                        width: 1 * config.Scale
                        color: mouseArea.containsMouse && root.enableds[index] ? "#815cda" : "transparent"
                    }
                    Rectangle {
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        height: 1 * config.Scale
                        color: mouseArea.containsMouse && root.enableds[index] ? "#fdfdfd" : "transparent"
                    }
                    Rectangle {
                        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
                        width: 1 * config.Scale
                        color: mouseArea.containsMouse && root.enableds[index] ? "#fdfdfd" : "transparent"
                    }
                }

                // enabled: root.enableds[index]
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: root.enableds[index] || root.enableds[index] === null ? Qt.ArrowCursor : Qt.ForbiddenCursor
                    onClicked: {
                        if (root.funcs[index] && enableds[index]) root.funcs[index]()
                        if(enableds[index]/* !== null*/) {
                            root.visible = false
                        }

                    }
                }
            }
        }
    }

    // 背景框
    Rectangle {
        anchors.fill: listColumn
        anchors.margins: -1 * config.Scale
        color: "#f1ecf1"
        z: -2

        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 2
            color: "#fdebfd"
        }
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#fdebfd"
        }
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 2
            color: "#8459da"
        }
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#8459da"
        }
    }
}