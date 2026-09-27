import QtQuick

Item {
    id: root

    property var items             // 会话名数组对象
    property string fontFamily: ""

    property int menuX: 0
    property int menuY: 0

    signal itemSelected(int index, var model)

    property var textProvider: null

    visible: false
    z: 100

    // ---------- 1. 测量：用隐藏 Text 算出最宽文本 ----------
    Item {
        id: measurer
        visible: false
        width: 0
        height: 0

        Repeater {
            model: root.items

            Text {
                text: root.textProvider ? root.textProvider(index, model) : modelData
                font.family: root.fontFamily
                font.pixelSize: 10 * config.Scale
            }
        }
    }

    // 遍历 measurer 的子项，取最大 implicitWidth
    property real maxTextWidth: {
        var w = 0
        for (var i = 0; i < measurer.children.length; ++i) {
            var c = measurer.children[i]
            if (c && c.implicitWidth !== undefined && c.implicitWidth > w)
                w = c.implicitWidth
        }
        return w
    }

    // 统一的每行宽度
    property real rowWidth: Math.ceil(maxTextWidth) + 16 * config.Scale

    // ---------- 2. 全屏遮罩 ----------
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false
    }

    // ---------- 3. 菜单列表 ----------
    Column {
        id: listColumn

        x: root.menuX
        y: root.menuY - listColumn.height

        Repeater {
            model: root.items

            Item {
                id: itemRoot

                // 关键：所有行统一宽度
                width: root.rowWidth
                height: 20 * config.Scale

                Rectangle {
                    anchors.fill: parent
                    color: mouseArea.containsMouse ? "#e0d0e8" : "transparent"
                }

                Text {
                    id: itemText
                    anchors.fill: parent
                    anchors.leftMargin: 8 * config.Scale
                    anchors.rightMargin: 8 * config.Scale
                    text: root.textProvider ? root.textProvider(index, model) : modelData
                    font.family: root.fontFamily
                    font.pixelSize: 10 * config.Scale
                    color: "#4e28cc"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        itemSelected(index, model)
                        root.visible = false
                    }
                }
            }
        }
    }

    // ---------- 4. 背景框 ----------
    Rectangle {
        anchors.fill: listColumn
        anchors.margins: -1 * config.Scale
        color: "#f1ecf1"
        z: -1

        // 顶部高光
        Rectangle {
            anchors { left: parent.left; right: parent.right; top: parent.top }
            height: 2
            color: "#fdebfd"
        }
        // 左侧高光
        Rectangle {
            anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#fdebfd"
        }
        // 底部阴影
        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 2
            color: "#8459da"
        }
        // 右侧阴影
        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            width: 2
            color: "#8459da"
        }
    }
}