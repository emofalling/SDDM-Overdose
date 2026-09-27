import QtQuick
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls
import "Widgets" as Widgets

Rectangle {
    id: root
    anchors.fill: parent
    color: "#fde1f1"


    Image {
        anchors.fill: parent
        source: "Images/tile.png"
        fillMode: Image.Tile
    }

    MediaPlayer {
        id: bgm
        source: "Sounds/bgm.ogg"
        audioOutput: AudioOutput {
            volume: 0.15
        }
        loops: MediaPlayer.Infinite
    }

    MediaPlayer {
        id: buttonSound
        source: "Sounds/button.ogg"
        audioOutput: AudioOutput {
            volume: 1.0
        }
    }

    MediaPlayer {
        id: welcome
        source: "Sounds/welcome.ogg"
        audioOutput: AudioOutput {
            volume: 1.0
        }
    }

    MediaPlayer {
        id: failed
        source: "Sounds/failed.ogg"
        audioOutput: AudioOutput {
            volume: 1.0
        }
    }

    FontLoader {
        id: pixelFont
        source: "Fonts/fusion-pixel/fusion-pixel-10px-proportional-latin.ttf"
    }

    property var userNames: []
    property var userIcons: []

    Repeater {
        model: userModel
        delegate: Item {
            Component.onCompleted: {
                var names = userNames.slice()
                var icons = userIcons.slice()
                names.push(model.name)
                print("Add user: " + model.name)
                print("Add icon: " + model.icon)
                icons.push(model.icon)
                userNames = names
                userIcons = icons
            }
        }
    }

    property string curSessionName: ""
    property int curSessionIndex: -1

    Repeater {
        model: sessionModel
        delegate: Item {
            Component.onCompleted: {
                if (index === sessionModel.lastIndex) {
                    curSessionName = model.name
                    curSessionIndex = index
                }
            }
        }
    }

    // 处理用户索引
    property int currentUserIndex: userModel.lastIndex >= 0 ? userModel.lastIndex : -1

    function switchUser(direction) {
        var count = userModel.count

        if (count === 0) {
            // 没有系统用户，只能在自定义用户上
            currentUserIndex = -1
            return
        }

        if (direction === 1) {
            // 往右
            if (currentUserIndex === -1) {
                currentUserIndex = 0
            } else {
                currentUserIndex = (currentUserIndex + 1) % (count + 1)
                if (currentUserIndex === count) {
                    currentUserIndex = -1
                }
            }
        } else if (direction === -1) {
            // 往左
            if (currentUserIndex === -1) {
                currentUserIndex = count - 1
            } else {
                currentUserIndex = (currentUserIndex - 1 + count + 1) % (count + 1)
                if (currentUserIndex === count) {
                    currentUserIndex = -1
                }
            }
        }
    }


    Rectangle {
        id: loginRect
        width: parent.width * 0.2
        anchors.centerIn: parent
        // color: "#fdfdfd"
        // radius: 20
        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 12 * config.Scale

            Row {
                spacing: 12 * config.Scale
                anchors.horizontalCenter: parent.horizontalCenter
                Widgets.PixelImageButton {
                    iconSource: "../Images/arrow_l.png"
                    width: 12 * config.Scale
                    height: 46 * config.Scale
                    onClicked: {
                        buttonSound.stop()
                        buttonSound.play()
                        switchUser(-1)
                    }
                    opacity: currentUserIndex !== 0 ? 1 : 0
                    enabled: currentUserIndex !== 0
                }
                Image {
                    source: currentUserIndex === -1
                            ? "Images/newuser_icon.jpg"
                            : (
                                userIcons[currentUserIndex] && !userIcons[currentUserIndex].startsWith("file:///usr/share/sddm/faces/")
                                ? userIcons[currentUserIndex]
                                : "Images/default_icon.jpg"
                            )
                    width: 48 * config.Scale
                    height: 48 * config.Scale
                    fillMode: Image.PreserveAspectFit
                    // anchors.horizontalCenter: parent.horizontalCenter
                }
                Widgets.PixelImageButton {
                    iconSource: "../Images/arrow_r.png"
                    width: 12 * config.Scale
                    height: 46 * config.Scale
                    onClicked: {
                        buttonSound.stop()
                        buttonSound.play()
                        switchUser(1)
                    }
                    opacity: currentUserIndex !== -1 ? 1 : 0
                    enabled: currentUserIndex !== -1
                }
            }

            Text {
                id: usernameText
                text: userNames[currentUserIndex]
                height: 24 * config.Scale
                font.pixelSize: 20 * config.Scale
                color: "#4e28cc"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: pixelFont.name
                visible: currentUserIndex !== -1
            }

            Widgets.PixelTextField {
                id: usernameField
                placeholderText: qsTr("Username")

                anchors.left: parent ? parent.left : undefined
                anchors.right: parent ? parent.right : undefined
                anchors.leftMargin: 20 * config.Scale
                anchors.rightMargin: 20 * config.Scale

                focus: currentUserIndex === -1 ? true : false
                Keys.onReturnPressed: passwordField.forceActiveFocus()
                Keys.onDownPressed: passwordField.forceActiveFocus()

                visible: currentUserIndex === -1
            }

            Widgets.PixelTextField {
                id: passwordField
                placeholderText: qsTr("Password")

                anchors.left: parent ? parent.left : undefined
                anchors.right: parent ? parent.right : undefined
                anchors.leftMargin: 20 * config.Scale
                anchors.rightMargin: 20 * config.Scale

                focus: currentUserIndex === -1 ? false : true
                Keys.onUpPressed: usernameField.forceActiveFocus()
                Keys.onReturnPressed: loginButton.clicked()
            }

            Widgets.PixelButton {
                id: loginButton

                height: 24 * config.Scale
                font.family: pixelFont.name
                font.pixelSize: 10 * config.Scale

                anchors.left: parent ? parent.left : undefined
                anchors.right: parent ? parent.right : undefined
                anchors.leftMargin: 20 * config.Scale
                anchors.rightMargin: 20 * config.Scale

                contentItem: Text {
                    text: qsTr("Login")
                    font: parent.font
                    color: "#4e28cc"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    buttonSound.stop()
                    buttonSound.play()
                    if(currentUserIndex === -1){
                        sddm.login(usernameField.text, passwordField.text, curSessionIndex)
                    }
                    else{
                        sddm.login(userNames[currentUserIndex], passwordField.text, curSessionIndex)
                    }
                    loginRect.enabled = false
                    infoText.text = qsTr("Logging in...")
                    infoText.color = "#4e28cc"
                    // delayLogin_debug.start()
                }
            }

            Text {
                id: infoText
                text: " "
                font.pixelSize: 10 * config.Scale
                color: "#4e28cc"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: pixelFont.name

            }
        }
    }

    Rectangle {
        id: bottomTab

        height: 22 * config.Scale
        color: "#f7e0fa"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // 顶部装饰
        Rectangle {
            height: 1 * config.Scale
            color: "#fdfdfd"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.top
        }

        Row{
            spacing: 2 * config.Scale
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 5 * config.Scale
            anchors.verticalCenter: parent.verticalCenter
            Widgets.PixelButton2 {
                id: optionsButton
                width: 75 * config.Scale
                height: 16 * config.Scale
                contentItem: Item {
                    anchors.fill: parent

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 2 * config.Scale
                        spacing: 4 * config.Scale

                        Image {
                            source: "Images/windose.png"
                            Layout.preferredWidth: 16 * config.Scale
                            Layout.preferredHeight: 12 * config.Scale
                            Layout.alignment: Qt.AlignVCenter
                            smooth: false
                        }

                        Text {
                            text: qsTr("Options...")
                            font.family: pixelFont.name
                            font.pixelSize: 10 * config.Scale
                            color: "#000000"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }
                }

                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    buttonSound.stop()
                    buttonSound.play()
                }
            }

            Widgets.PixelSeparator{}

            Item {
                id: sessionButton

                implicitWidth: sessionText.implicitWidth + 8 * config.Scale
                implicitHeight: 16 * config.Scale

                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: sessionText
                    anchors.centerIn: parent
                    text: curSessionName !== "" ? curSessionName : qsTr("Choose a session...")
                    font.family: pixelFont.name
                    font.pixelSize: 10 * config.Scale
                    color: "#4e28cc"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sessionMenu.visible = true
                        buttonSound.stop()
                        buttonSound.play()
                    }
                }
                /*
                Menu {
                    id: sessionMenu
                    y: -height

                        padding: 0


                    Repeater {
                        model: sessionModel

                        MenuItem {
                            text: model.name
                            onTriggered: {
                                curSessionName = model.name
                                curSessionIndex = model.index
                            }
                        }
                    }
                }
                */
            }


        }            
        


    }
        // 下拉列表放在根层级，撑满屏幕
        Widgets.PixelDropdown {
            id: sessionMenu
            anchors.fill: parent

            menuX: sessionButton.x
            menuY: bottomTab.y - 1 * config.Scale

            z: 100
            items: sessionModel
            fontFamily: pixelFont.name

            textProvider: function(index, model) {
                return model.name
            }

            onItemSelected: function(index, model) {
                curSessionIndex = index
                curSessionName = model.name
                buttonSound.stop()
                buttonSound.play()
            }
        }

    Component.onCompleted: bgm.play()

    Timer {
        id: delayLogin_debug
        interval: 1000
        repeat: false
        onTriggered: {
            loginSuccess()
        }
    }

    function loginSuccess() {
        bgm.stop()
        welcome.play()
        infoText.text = qsTr("Login Success!")
        infoText.color = "#28cc28"
        loginRect.enabled = true
        console.log("Login succeeded")
    }

    function loginFailure() {
        failed.play()
        infoText.text = qsTr("Login Failure!")
        infoText.color = "#cc2828"
        loginRect.enabled = true
        console.log("Login failed")
    }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            loginSuccess()
        }

        function onLoginFailed() {
            loginFailure()
        }
    }
}