/*
 * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
 * Copyright (C) 2012-2013 Jolla Ltd.
 *
 * Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Nokia Corporation nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

import QtQuick 2.0
import com.jolla.keyboard 1.0
import Sailfish.Silica 1.0

KeyBase {
    id: aCharKey
    height: width

    property string captionShifted
    property string symView
    property string symView2
    property int separator: SeparatorState.AutomaticSeparator
    property bool implicitSeparator: true // set by layouting
    property bool showHighlight: true
    property string accents
    property string accentsShifted
    property string nativeAccents // accents considered native to the written language. not rendered.
    property string nativeAccentsShifted
    property bool fixedWidth
    property alias useBoldFont: textItem.font.bold
    property alias pixelSize: textItem.font.pixelSize
    property alias fontSizeMode: textItem.fontSizeMode
    property alias textAnchors: textItem.anchors

    property var swipeCaption: ["", "", "", "", "", "", "", ""]
    property var swipeCaptionShifted: ["", "", "", "", "", "", "", ""]
    property var swipeSpecial: ["", "", "", "", "", "", "", ""]
    property int swipeValue: -1
    property point tempPoint: Qt.point(0,0)
    property point startPoint:Qt.point(0,0)
    property point currentPoint:Qt.point(0,0)

    property var swipeArray: attributes.isShifted ? swipeCaptionShifted : swipeCaption

    keyType: KeyType.CharacterKey
    text: keyText
    keyText: swipeValue >= 0 ? (swipeArray[swipeValue] === "" ? swipeSpecial[swipeValue] : swipeArray[swipeValue])
                             : (attributes.inSymView && symView.length > 0 ? symView
                                                                           : (attributes.isShifted ? captionShifted : caption))

    Text {
        id: textItem
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSizeExtraLarge
        color: pressed ? Theme.highlightColor : Theme.primaryColor
        text: aCharKey.keyText
    }

    Repeater {
        model: swipeArray
        delegate: Text {
            anchors.centerIn: textItem
            anchors.verticalCenterOffset: index < 3 ? -aCharKey.height * 0.4
                                                    : index > 4 ? aCharKey.height * 0.4
                                                                : 0
            anchors.horizontalCenterOffset: index == 0 || index == 3 || index == 5 ? -aCharKey.width * 0.3
                                                    : index == 2 || index == 4 || index == 7 ? aCharKey.width * 0.3
                                                                : 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            text: modelData === "" ? swipeSpecial[index] : !attributes.inSymView ? modelData : ""
            opacity: modelData !== "" ? 0.8 : attributes.inSymView2 ? 0.5 : 0
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.max(textItem.implicitWidth, textItem.implicitHeight)
        height: width
        radius: width / 2
        z: -1
        color: Theme.highlightBackgroundColor
        opacity: 0.5
        visible: pressed && showHighlight
    }

    Rectangle {
        x: startPoint.x
        y: startPoint.y
        width: Math.sqrt(Math.pow(xDist, 2) + Math.pow(yDist, 2) )
        height: Math.max(textItem.implicitWidth, textItem.implicitHeight) * 0.4
        radius: height / 2
        z: -1
        color: Theme.highlightBackgroundColor
        opacity: 0.3
        transformOrigin: Item.Left

        property real xDist: startPoint.x - currentPoint.x
        property real yDist: startPoint.y - currentPoint.y
        property real rotValue: Math.atan(Math.abs(yDist) / Math.abs(xDist)) * 180 / Math.PI
        rotation: xDist > 0 && yDist > 0 ? 180 + rotValue
                                         : xDist < 0 && yDist < 0 ? rotValue
                                                                  : xDist < 0 && yDist > 0 ? - rotValue
                                                                                           : 180 - rotValue
    }
}
