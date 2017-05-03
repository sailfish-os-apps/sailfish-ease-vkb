// Copyright (C) 2013 Jolla Ltd.
// Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>

import QtQuick 2.0
import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0

Item {
    id: layout8Pen
    width: parent ? parent.width : 0
    height: width

    property string type
    property bool portraitMode
    property int keyHeight
    property int punctuationKeyWidth
    property int punctuationKeyWidthNarrow
    property int shiftKeyWidth
    property int functionKeyWidth
    property int shiftKeyWidthNarrow
    property int symbolKeyWidthNarrow
    property QtObject attributes: visible ? keyboard : keyboard.emptyAttributes
    property string languageCode
    property string inputMode
    property int avoidanceWidth
    property bool splitActive
    property bool splitSupported
    property bool useTopItem: !splitActive
    property bool capsLockSupported: true

    property bool is8Pen: true
    property var accentMap: ({})
    property string lastAccentMerge: ""

    property var moveSerie: []

    property string lowercase: "abcdefghijklmnopqrstuvwxyz"
    property string uppercase: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    property bool numActive: false
    property bool specialActive: false

    property var centerLetterMove: specialActive ? specialCaption : (numActive? numCaption : letterCaptions)

    property var letterCaptions: ({})
    property var numCaption:({})
    property var specialCaption:({})

    Component.onCompleted: updateSizes()
    onWidthChanged: updateSizes()
    onPortraitModeChanged: updateSizes()

    Rectangle {
        id: centerDot
        property bool selected: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset: - layout8Pen.parent.width / 10
        anchors.horizontalCenterOffset: - layout8Pen.parent.width / 10
        width: layout8Pen.parent.width / 5
        height: width
        color: selected ? Theme.highlightColor : Theme.primaryColor
        opacity: 0.5
        radius: width / 2
    }

    property real xCenter: centerDot.x + centerDot.width / 2
    property real yCenter: centerDot.y + centerDot.height / 2

    Repeater {
        model: Object.keys(centerLetterMove)
        delegate: Item {
            property var key: modelData
            Repeater {
                model: centerLetterMove[key]
                delegate: Item {
                    width: 1
                    height: 1
                    property int directionX: key.indexOf("left") !== -1 ? -1 : 1
                    property int directionY: key.indexOf("up") !== -1 ? -1 : 1
                    x: xCenter + (centerDot.radius + index * charText.height * 0.8) * directionX + (key[0] === "l" ? (- charText.height * 0.6) : key[0] === "r" ? charText.height * 0.6 : 0)
                    y: yCenter + (centerDot.radius + index * charText.height * 0.8) * directionY + (key[0] === "u" ? (- charText.height * 0.6) : key[0] === "d" ? charText.height * 0.6 : 0)
                    Text {
                        id: charText
                        anchors.verticalCenter: parent.top
                        anchors.horizontalCenter: parent.left
                        text: modelData
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.primaryColor
                    }
                }
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        maximumTouchPoints: 1

        onPressed: {
            moveSerie = []
            var touchpoint = touchPoints[0]
            var pos = getPos(touchpoint.x, touchpoint.y)
            if (pos === "center") {
                centerDot.selected = true
            }
            moveSerie.push(pos)
        }
        onUpdated: {
            var touchpoint = touchPoints[0]
            var pos = getPos(touchpoint.x, touchpoint.y)
            if (pos !== moveSerie[moveSerie.length - 1]) {
                if (pos === "center") {
                    processInput()
                }
                moveSerie.push(pos)
            }
        }

        onReleased: {
            processInput()

            moveSerie = []
            centerDot.selected = false

        }
        //onCanceled: keyboard.handleCanceled(touchPoints)
    }

    function processInput() {
        if (moveSerie[0] === "center") {
            if (moveSerie.length >= 3 && moveSerie.length < 7) {
                var hand = centerLetterMove[moveSerie[1] + "-" + moveSerie[2]]
                var letter = hand[(moveSerie.length - 3) % 4]
                commitText(letter)
            } else if (moveSerie.length === 2 && moveSerie[1] === "up") {
                numActive = !numActive
            } else if (moveSerie.length === 2 && moveSerie[1] === "left") {
                specialActive = !specialActive
            } else if (moveSerie.length === 2 && moveSerie[1] === "right") {
                backSpace()
            } else {
                commitText(" ")
            }
        } else if (moveSerie.length >= 2 && moveSerie.length < 6 && moveSerie[moveSerie.length - 1] !== "center") {
            var hand = centerLetterMove[moveSerie[0] + "-" + moveSerie[1]]
            var letter = hand[(moveSerie.length - 2) % 4]
            if (lowercase.indexOf(letter) !== -1) {
                letter = uppercase.charAt(lowercase.indexOf(letter))
            }
            commitText(letter)
        } else if (moveSerie.length === 2 && moveSerie[1] === "center") {
            backSpace()
        }
        moveSerie = []
    }

    function commitText(text) {
        if (text in accentMap) {
            var previousChar = MInputMethodQuick.surroundingText.charAt(MInputMethodQuick.surroundingText.length - 1)
            if (previousChar in accentMap[text]) {
                var merge = accentMap[text][previousChar]
                lastAccentMerge = previousChar + text
                MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
                MInputMethodQuick.sendCommit(merge)
            } else {
                MInputMethodQuick.sendCommit(text)
                lastAccentMerge = ""
            }
        } else {
            MInputMethodQuick.sendCommit(text)
            lastAccentMerge = ""
        }
        specialActive = false
    }

    function backSpace() {
        MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
        if (lastAccentMerge !== "") {
            MInputMethodQuick.sendCommit(layout.lastAccentMerge)
            layout.lastAccentMerge = ""
        }
        moveSerie = []
    }

    function getPos(x, y) {
        var xDistFromCenter = x - xCenter
        var yDistFromCenter = y - yCenter
        if (Math.abs(xDistFromCenter) <= centerDot.radius && Math.abs(yDistFromCenter) <= centerDot.radius) {
            return "center"
        } else if (Math.abs(xDistFromCenter) >= Math.abs(yDistFromCenter)) {
            if (xDistFromCenter < 0) {
                return "left"
            } else {
                return "right"
            }

        } else if (Math.abs(xDistFromCenter) < Math.abs(yDistFromCenter)) {
            if (yDistFromCenter < 0) {
                return "up"
            } else {
                return "down"
            }
        }
        return "error"
    }

    Connections {
        target: keyboard
        onSplitEnabledChanged: updateSizes()
    }

    Binding on portraitMode {
        when: visible
        value: keyboard.portraitMode
    }

    function updateSizes () {
        if (width === 0) {
            return
        }

        if (portraitMode) {
            keyHeight = geometry.keyHeightPortrait
            punctuationKeyWidth = geometry.punctuationKeyPortait
            punctuationKeyWidthNarrow = geometry.punctuationKeyPortraitNarrow
            shiftKeyWidth = geometry.shiftKeyWidthPortrait
            functionKeyWidth = geometry.functionKeyWidthPortrait
            shiftKeyWidthNarrow = geometry.shiftKeyWidthPortraitNarrow
            symbolKeyWidthNarrow = geometry.symbolKeyWidthPortraitNarrow
            avoidanceWidth = 0
            splitActive = false
        } else {
            keyHeight = geometry.keyHeightLandscape
            punctuationKeyWidth = geometry.punctuationKeyLandscape
            punctuationKeyWidthNarrow = geometry.punctuationKeyLandscapeNarrow
            functionKeyWidth = geometry.functionKeyWidthLandscape

            var shouldSplit = keyboard.splitEnabled && splitSupported
            if (shouldSplit) {
                avoidanceWidth = geometry.middleBarWidth
                shiftKeyWidth = geometry.shiftKeyWidthLandscapeSplit
                shiftKeyWidthNarrow = geometry.shiftKeyWidthLandscapeSplit
                symbolKeyWidthNarrow = geometry.symbolKeyWidthLandscapeNarrowSplit
            } else {
                avoidanceWidth = 0
                shiftKeyWidth = geometry.shiftKeyWidthLandscape
                shiftKeyWidthNarrow = geometry.shiftKeyWidthLandscapeNarrow
                symbolKeyWidthNarrow = geometry.symbolKeyWidthLandscapeNarrow
            }
            splitActive = shouldSplit
        }
    }

    FunctionKey {
        id:backspaceKey
        icon.source: "image://theme/icon-m-backspace" + (pressed ? ("?" + Theme.highlightColor) : "")
        repeat: true
        key: Qt.Key_Backspace
        height: width * 0.6
        implicitWidth: shiftKeyWidth
        background.visible: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset:  - parent.height / 2 + height
        anchors.horizontalCenterOffset:  parent.height / 2 - height

        property bool pressed: false

        MultiPointTouchArea {
            anchors.fill: backspaceKey
            maximumTouchPoints: 1
            onPressed: {
                backspaceKey.pressed = true
                backSpace()
                autorepeatTimer.start()
            }

            onReleased: {
                backspaceKey.pressed = false
                moveSerie = []
            }
        }

        Timer {
            id: autorepeatTimer
            repeat: true
            interval: 80

            onTriggered: {
                if (backspaceKey.pressed) {
                    backSpace()
                } else {
                    stop()
                    moveSerie = []
                }
            }
        }
    }

    SpacebarKey {
        height: backspaceKey.height
        implicitWidth: shiftKeyWidth
        anchors.centerIn: parent
        anchors.verticalCenterOffset:  parent.height / 2 + height
    }


}
