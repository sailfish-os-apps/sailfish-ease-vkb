// Copyright (C) 2013 Jolla Ltd.
// Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>

import QtQuick 2.0
import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0
import com.jolla.keyboard 1.0

Item {
    id: layoutLoopen
    width: parent ? parent.width : 0
    height: portraitMode ? width * 0.7 : width * 0.3

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
    property var accentMap: {
        "´": {"e": "é", "E": "É", "a": "á", "A": "Á", "o": "ó", "O": "Ó", "i": "í", "I": "Í", "u": "ú", "U": "Ú", "y": "ý", "Y": "Ý"                   },
        "^": {"e": "ê", "E": "Ê", "a": "â", "A": "Â", "o": "ô", "O": "Ô", "i": "î", "I": "Î", "u": "û", "U": "Û"                                       },
        "¨": {"e": "ë", "E": "Ë", "a": "ä", "A": "Ä", "o": "ö", "O": "Ö", "i": "ï", "I": "Ï", "u": "ü", "U": "Ü", "y": "ÿ", "Y": "Ϋ"                   },
        "`": {"e": "è", "E": "È", "a": "à", "A": "À", "o": "ò", "O": "Ò", "i": "ì", "I": "Ì", "u": "ù", "U": "Ù"                                       },
        "°": {                    "a": "å", "A": "Å"                                                                                                   },
        "~": {                    "a": "ã", "A": "Ã", "o": "õ", "O": "Õ"                                                           , "n": "ñ", "N": "Ñ"},
        "¸": {"c": "ç", "C": "Ç"}
    }
    property string lastAccentMerge: ""

    property var moveSerie: []
    property var fullMoveSerie: []

    property string lowercase: "abcdefghijklmnopqrstuvwxyz"
    property string uppercase: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    property bool numActive: false
    property bool specialActive: false

    property var centerLetterMove: specialActive ? specialCaption : (numActive? numCaption : letterCaptions)

    property var letterCaptions: ({})
    property var numCaption:({})
    property var specialCaption:({})
    property string selection: ""
    property bool capitalMove: false
    property int selectionNumber: -1

    Component.onCompleted: updateSizes()
    onWidthChanged: updateSizes()
    onPortraitModeChanged: updateSizes()

    Rectangle {
        id: centerDot
        anchors.centerIn: parent
        //anchors.verticalCenterOffset: layout8Pen.parent.width / 20
        anchors.horizontalCenterOffset: - layoutLoopen.parent.width / 10
        width: layoutLoopen.parent.height / (4 * 0.7)
        height: width
        color: selection === "-1" ? Theme.highlightBackgroundColor : Theme.primaryColor
        opacity: selection === "-1" ? 0.6 : 0.07
        radius: width / 2


    }

    Text {
        id: textField
        anchors.centerIn: centerDot
        width: centerDot.width / 2
        height: centerDot.height / 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: languageCode
        color: Theme.primaryColor
        opacity: 0.4
        font.pixelSize: Theme.fontSizeSmall
        fontSizeMode: Text.Fit
    }

    Timer {
        id: languageSwitchTimer
        interval: 1000
        onTriggered: {
            var point = new Object
            point.pointId = 1
            point.x = xCenter
            point.y = yCenter
            point.startX = xCenter
            point.startY = yCenter
            point.pressedKey = centerDot
            point.initialKey = null
            keyboard.languageSelectionItem.show(point)
        }
    }

    property real xCenter: centerDot.x + centerDot.width / 2
    property real yCenter: centerDot.y + centerDot.height / 2

    property var branchAngles: {
        var ret = []
        var keys = Object.keys(centerLetterMove)
        for (var i = 0; i < keys.length; i++) {
            var angle = parseInt(keys[i].split("-")[0])
            if (ret.indexOf(angle) === -1) {
                for (var j = 0; j < ret.length; j++) {
                    if (ret[j] > angle) {
                        ret.splice(j,0,angle)
                        break
                    }
                }
                if (ret.indexOf(angle) === -1) {
                    ret.push(angle)
                }
            }
        }
        return ret
    }
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
            property bool selected: selection !== "-1" && selection !== "-2"
                                    && (selection.indexOf("-") !== -1
                                        ? selection === key
                                        : (key.indexOf("right") !== -1
                                           ? branchAngles[parseInt(selection)] === parseInt (key.split("-")[0])
                                           : branchAngles[(parseInt(selection) + 1) % branchAngles.length] === parseInt (key.split("-")[0])))

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
                        text: attributes.isShifted !== capitalMove && lowercase.indexOf(modelData) !== -1 ? uppercase.charAt(lowercase.indexOf(modelData)) : modelData
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
            pushMove(pos)
            evaluateSelection()
            paint.pathData = "M%1,%2".arg (touchpoint.x).arg (touchpoint.y);
            paint.canErase = false
            if (pos === -1)
                languageSwitchTimer.start()
        }
        onUpdated: {
            var touchpoint = touchPoints[0]
            if (keyboard.languageSelectionItem.visible) {
                var point = new Object
                point.pointId = 1
                point.x = touchpoint.x
                point.y = touchpoint.y
                point.startX = xCenter
                point.startY = yCenter
                point.pressedKey = centerDot
                point.initialKey = null
                keyboard.languageSelectionItem.handleMove(point)
                return
            }
            var pos = getPos(touchpoint.x, touchpoint.y)
            if (pos !== moveSerie[moveSerie.length - 1]) {
                if (moveSerie.length > 1 && pos === moveSerie[moveSerie.length - 2]) {
                    moveSerie.splice(-1,1)
                } else {
                    if (pos === -1) {
                        processInput()
                    }
                    pushMove(pos)
                }
            }
            evaluateSelection()
            paint.pathData += "L%1,%2".arg (touchpoint.x).arg (touchpoint.y);
        }

        onReleased: {
            if (!keyboard.languageSelectionItem.visible) {
                processInput()
            }
            if (keyboard.languageSelectionItem.visible) {
                canvas.switchLayout(keyboard.languageSelectionItem.activeCell)
                keyboard.languageSelectionItem.hide()
            }
            moveSerie = []
            fullMoveSerie = []
            evaluateSelection()
            paint.pathData = ""
            paint.canErase = true
            languageSwitchTimer.stop()
        }
    }

    function pushMove(pos) {
        languageSwitchTimer.stop()
        moveSerie.push(pos)
        fullMoveSerie.push(pos)
        SampleCache.play("/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav")
        buttonPressEffect.play()
    }

    function processInput() {
        var letter = ""
        var startIdx = (capitalMove ? 0 : 1)
        if ((moveSerie.length >= 3 && moveSerie[0] === -1) || (moveSerie.length >= 2 && moveSerie[0] !== -1)) {
            var direction = moveSerie[startIdx + 1] === (moveSerie[startIdx] + 1) % branchAngles.length ? "left" : "right"
            var branchAngle = branchAngles[(direction === "left" ? (moveSerie[startIdx] + 1) : moveSerie[startIdx]) % branchAngles.length]
            var branchKey = branchAngle + "-" + direction
            var branch = centerLetterMove[branchKey]
            letter = branch[(moveSerie.length - (2 + startIdx)) % 4]
        }
        if (moveSerie.length >= startIdx + 2 && moveSerie.length < startIdx + 6) {
            if (lowercase.indexOf(letter) !== -1 && attributes.isShifted !== capitalMove) {
                letter = uppercase.charAt(lowercase.indexOf(letter))
            }
            commitText(letter)
        } else if (moveSerie.length === 1 && moveSerie[0] === -1) {
            commitText(" ")
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
        if (Math.abs(xDistFromCenter) <= centerDot.radius && Math.abs(yDistFromCenter) <= centerDot.radius)
            return -1
        var rad = Math.atan2(yDistFromCenter, xDistFromCenter);
        var angle = (rad * (180 / Math.PI) + 360) % 360
        for (var i = 0; i < branchAngles.length; i++) {
            if (branchAngles[i] > angle) {
                return (i + branchAngles.length - 1) % branchAngles.length
            }
        }
        return (i - 1) % branchAngles.length
    }

    function evaluateSelection () {
        if (moveSerie.length === 1) {
            selection = moveSerie[0]
            selectionNumber = -1
        } else if (moveSerie[0] === -1 && moveSerie.length === 2) {
            selection = moveSerie[1]
            selectionNumber = -1
        } else if (moveSerie.length > 1) {
            var startIndex = 0
            if (moveSerie[0] === -1)
                startIndex = 1
            var direction = moveSerie[1 + startIndex] === (moveSerie[startIndex] + 1) % branchAngles.length ? "left" : "right"
            var branchAngle = branchAngles[(direction === "left" ? (moveSerie[startIndex] + 1) : moveSerie[startIndex]) % branchAngles.length]
            selection = branchAngle + "-" + direction
            selectionNumber = moveSerie.length - startIndex - 2
        } else {
            selection = -2
            selectionNumber = -1
        }
        if (moveSerie.length < 1 || moveSerie[0] === -1) {
            capitalMove = false
        } else {
            capitalMove = true
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
        anchors.verticalCenterOffset:  - parent.height / 2 + height * 2.5
        anchors.horizontalCenterOffset:  parent.height / 2

        property bool pressed: false

        MultiPointTouchArea {
            anchors.fill: specialKey
            maximumTouchPoints: 1

            onReleased: {

            }
        }
    }

    FunctionKey { // copied  EnterKey: i don't know why but it doesn't like as an element
        id: enterKey
        active: mylay.isLandscape
        icon.source: MInputMethodQuick.actionKeyOverride.icon
        caption:  MInputMethodQuick.actionKeyOverride.label
        key: Qt.Key_Return
        enabled: MInputMethodQuick.actionKeyOverride.enabled
        background.opacity: pressed ? 0.6 : MInputMethodQuick.actionKeyOverride.highlighted ? 0.4 : 0.17
        height: width * 0.7
        implicitWidth: shiftKeyWidth * 1.5
        background.visible: true
        anchors.centerIn: parent
        anchors.verticalCenterOffset:    parent.height / 2 - height * 0.6
        anchors.horizontalCenterOffset:  parent.height / 2

        MultiPointTouchArea {
            anchors.fill: enterKey
            maximumTouchPoints: 1
            onPressed: {
                enterKey.pressed = true
                commitText("\n")
            }

            onReleased: {
                enterKey.pressed = false
                moveSerie = []
            }
        }
    }

    ShiftEaseKey {
        id: shiftKey
        height: width * 0.7
        implicitWidth: shiftKeyWidth * 1.5
        anchors.centerIn: parent
        anchors.verticalCenterOffset:    parent.height / 2 - height * 1.5
        anchors.horizontalCenterOffset:  parent.height / 2

        MultiPointTouchArea {
            anchors.fill: shiftKey
            maximumTouchPoints: 1
            onPressed: {
                shiftKey.clicked()
            }
        }
    }

    Paint {
        id: paint
        anchors.fill: parent
        lineColor: Theme.primaryColor
        lineSize: 10
        baseOpacity: 0.3
    }
}
