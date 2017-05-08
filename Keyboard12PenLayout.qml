// Copyright (C) 2013 Jolla Ltd.
// Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>

import QtQuick 2.0
import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0

Item {
    id: layout8Pen
    width: parent ? parent.width : 0
    height: width * 0.7

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
    property string selection: ""
    property bool capitalSelected: false
    property int selectionNumber: -1
    property var selectionMapping: {"0-left": "upright", "0-right": "downright",
                                    "60-left": "downright", "60-right": "down",
                                    "120-left": "down", "120-right": "downleft",
                                    "180-left": "downleft", "180-right": "upleft",
                                    "240-left": "upleft", "240-right": "up",
                                    "300-left": "up", "300-right": "upright"}

    Component.onCompleted: updateSizes()
    onWidthChanged: updateSizes()
    onPortraitModeChanged: updateSizes()

    Rectangle {
        id: centerDot
        anchors.centerIn: parent
        //anchors.verticalCenterOffset: layout8Pen.parent.width / 20
        anchors.horizontalCenterOffset: - layout8Pen.parent.width / 10
        width: layout8Pen.parent.width / 4
        height: width
        color: selection === "center" ? Theme.highlightColor : Theme.primaryColor
        opacity: 0.5
        radius: width / 2
    }

    property real xCenter: centerDot.x + centerDot.width / 2
    property real yCenter: centerDot.y + centerDot.height / 2

    Repeater {
        model: Object.keys(centerLetterMove)
        delegate: Item {
            id: branch
            anchors.centerIn: centerDot;
            property string  key: modelData
            property real angle: (parseInt (key.split ("-") [0].toString ()) * Math.PI / 180)
            property real sin: Math.sin(angle)
            property real cos: Math.cos(angle)
            property int side: (key.indexOf("left") !== -1 ? -1 : 1)
            property bool selected: selectionMapping[key] === selection.split("-")[0]
                                    && (selection.split("-").length === 1 || key.split("-")[1] === selection.split("-")[1])

            Repeater {
                model: centerLetterMove[key]
                delegate: Item {
                    width: 1
                    height: 1
                    anchors {
                        centerIn: parent;
                        horizontalCenterOffset: (branch.cos * radius) - charText.height * 0.4 * side * branch.sin
                        verticalCenterOffset:   (branch.sin * radius) + charText.height * 0.4 * side * branch.cos
                    }

                    readonly property real radius : (centerDot.radius + (model.index + 1) * charText.height * 0.8);

                    Text {
                        id: charText
                        anchors.verticalCenter: parent.top
                        anchors.horizontalCenter: parent.left
                        text: capitalSelected && lowercase.indexOf(modelData) !== -1 ? uppercase.charAt(lowercase.indexOf(modelData)) : modelData
                        font.family: Theme.fontFamily
                        font.bold: branch.selected && selectionNumber === index ? true : false
                        font.pixelSize: Theme.fontSizeMedium
                        color: branch.selected ? Theme.highlightColor : Theme.primaryColor
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
            moveSerie.push(pos)
            evaluateSelection()
        }
        onUpdated: {
            var touchpoint = touchPoints[0]
            var pos = getPos(touchpoint.x, touchpoint.y)
            if (pos !== moveSerie[moveSerie.length - 1]) {
                if (moveSerie.length > 1 && pos === moveSerie[moveSerie.length - 2]) {
                    moveSerie.splice(-1,1)
                } else {
                    if (pos === "center") {
                        processInput()
                    }
                    moveSerie.push(pos)
                }
            }
            evaluateSelection()
        }

        onReleased: {
            processInput()
            moveSerie = []
            evaluateSelection()
        }
        //onCanceled: keyboard.handleCanceled(touchPoints)
    }

    property var mapInput: {"upleft-up": "240-left",
                            "downleft-upleft": "180-left",
                            "down-downleft": "120-left",
                            "downright-down": "60-left",
                            "upright-downright": "0-left",
                            "up-upright": "300-left",

                            "up-upleft": "240-right",
                            "upleft-downleft": "180-right",
                            "downleft-down": "120-right",
                            "down-downright": "60-right",
                            "downright-upright": "0-right",
                            "upright-up": "300-right"}

    function processInput() {
        if (moveSerie.length >= 8 && moveSerie[moveSerie.length - 1] !== "center") {
            if (selection.indexOf("left") !== -1) {
                numActive = !numActive
            } else {
                specialActive = !specialActive
            }
        } else if (moveSerie[0] === "center") {
            if (moveSerie.length >= 3 && moveSerie.length < 7) {
                var hand = centerLetterMove[mapInput[moveSerie[1] + "-" + moveSerie[2]]]
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
            var hand = centerLetterMove[mapInput[moveSerie[0] + "-" + moveSerie[1]]]
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
        var sqrt3 = Math.sqrt(3)
        if (Math.abs(xDistFromCenter) <= centerDot.radius && Math.abs(yDistFromCenter) <= centerDot.radius) {
            return "center"
        } else if (yDistFromCenter > 0) {
            if (xDistFromCenter < 0 &&  Math.abs(xDistFromCenter) * sqrt3 > Math.abs(yDistFromCenter)) {
                return "downleft"
            } else if (xDistFromCenter > 0 &&  Math.abs(xDistFromCenter) * sqrt3 > Math.abs(yDistFromCenter)){
                return "downright"
            } else {
                return "down"
            }

        } else {
            if (xDistFromCenter < 0 &&  Math.abs(xDistFromCenter) * sqrt3 > Math.abs(yDistFromCenter)) {
                return "upleft"
            } else if (xDistFromCenter > 0 &&  Math.abs(xDistFromCenter) * sqrt3 > Math.abs(yDistFromCenter)){
                return "upright"
            } else {
                return "up"
            }
        }
    }

    function evaluateSelection () {
        if (moveSerie.length === 1) {
            selection = moveSerie[0]
            selectionNumber = -1
        } else if (moveSerie[0] === "center" && moveSerie.length === 2) {
            selection = moveSerie[1]
            selectionNumber = -1
        } else if (moveSerie.length > 1) {
            var startIndex = 0
            if (moveSerie[0] === "center")
                startIndex = 1
            var direction = mapInput[moveSerie[startIndex] + "-" + moveSerie[startIndex + 1]].split("-")[1]
            selection = moveSerie[startIndex] + "-" + direction
            selectionNumber = moveSerie.length - startIndex - 2
        } else {
            selection = ""
            selectionNumber = -1
        }
        if (moveSerie.length < 1 || moveSerie[0] === "center") {
            capitalSelected = false
        } else {
            capitalSelected = true
        }
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
        anchors.verticalCenterOffset:  - parent.height / 2 + height * 0.5
        anchors.horizontalCenterOffset:  parent.height / 2

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

    FunctionKey {
        id:specialKey
        repeat: true
        key: Qt.Key_Backspace
        height: width * 0.6
        implicitWidth: shiftKeyWidth
        background.visible: true
        anchors.centerIn: parent
        anchors.verticalCenterOffset:  - parent.height / 2 - height * 0.5
        anchors.horizontalCenterOffset:  parent.height / 2

        property bool pressed: false

        MultiPointTouchArea {
            anchors.fill: backspaceKey
            maximumTouchPoints: 1

            onReleased: {

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
