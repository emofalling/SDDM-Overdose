import QtQuick
import QtMultimedia
import QtQuick.Controls
import "Widgets" as Widgets

Rectangle {
    id: root
    anchors.fill: parent
    color: "#fde1f1"

    Image {
        anchors.fill: parent
        source: "Images/bg.png"
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
        id: latinFont
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
        width: parent.width * 0.2
        anchors.centerIn: parent
        // color: "#fdfdfd"
        // radius: 20
        Column {
            anchors.centerIn: parent
            width: parent.width
            spacing: 24

            Row {
                spacing: 24
                anchors.horizontalCenter: parent.horizontalCenter
                Widgets.PixelImageButton {
                    iconSource: "../Images/arrow_l.png"
                    width: 24
                    height: 92
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
                    width: 96
                    height: 96
                    fillMode: Image.PreserveAspectFit
                    // anchors.horizontalCenter: parent.horizontalCenter
                }
                Widgets.PixelImageButton {
                    iconSource: "../Images/arrow_r.png"
                    width: 24
                    height: 92
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
                font.pixelSize: 30
                color: "#4e28cc"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: latinFont.name
                visible: currentUserIndex !== -1
            }

            Widgets.PixelTextField {
                id: usernameField
                placeholderText: qsTr("Username")

                anchors.left: parent ? parent.left : undefined
                anchors.right: parent ? parent.right : undefined
                anchors.leftMargin: 40
                anchors.rightMargin: 40

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
                anchors.leftMargin: 40
                anchors.rightMargin: 40

                focus: currentUserIndex === -1 ? false : true
                Keys.onUpPressed: usernameField.forceActiveFocus()
                Keys.onReturnPressed: loginButton.clicked()
            }

            Widgets.PixelButton {
                id: loginButton
                text: qsTr("Login")

                anchors.left: parent ? parent.left : undefined
                anchors.right: parent ? parent.right : undefined
                anchors.leftMargin: 40
                anchors.rightMargin: 40 

                onClicked: {
                    buttonSound.stop()
                    buttonSound.play()
                    if(currentUserIndex === -1){
                        sddm.login(usernameField.text, passwordField.text, sessionModel.lastIndex)
                    }
                    else{
                        sddm.login(userNames[currentUserIndex], passwordField.text, sessionModel.lastIndex)
                    }
                    usernameField.enabled = false
                    passwordField.enabled = false
                    loginButton.enabled = false
                    infoText.text = qsTr("Logging in...")
                    infoText.color = "#4e28cc"
                    // delayLogin_debug.start()
                }
            }

            Text {
                id: infoText
                text: " "
                font.pixelSize: 20
                color: "#4e28cc"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: latinFont.name

            } 
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
        usernameField.enabled = true
        passwordField.enabled = true
        loginButton.enabled = true
        console.log("Login succeeded")
    }

    function loginFailure() {
        failed.play()
        infoText.text = qsTr("Login Failure!")
        infoText.color = "#cc2828"
        usernameField.enabled = true
        passwordField.enabled = true
        loginButton.enabled = true
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