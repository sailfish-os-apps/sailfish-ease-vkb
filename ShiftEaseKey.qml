/*
 * Copyright (C) 2013 Jolla ltd. and/or its subsidiary(-ies). All rights reserved.
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
 * Neither the name of Jolla ltd nor the names of its contributors may be
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

FunctionKey {
    id: shiftKey

    property int _charactersWhenPressed
    property bool _quickPicking

    implicitWidth: shiftKeyWidth
    icon.source: (attributes.isShifted && !attributes.isShiftLocked ? "image://theme/icon-m-autocaps"
                                                                    : "image://theme/icon-m-capslock")
                 + (pressed ? ("?" + Theme.highlightColor) : "")

    // dim normal shift mode
    icon.opacity: (!attributes.isShiftLocked && !attributes.isShifted) ? 0.2 : 1.0
    caption: ""
    key: Qt.Key_Shift
    keyType: KeyType.ShiftKey
    background.visible: false

    onPressedChanged: {
        if (pressed && !keyboard.isShifted && keyboard.lastInitialKey === shiftKey) {
            _quickPicking = true
            keyboard.shiftState = ShiftState.LatchedShift
        } else {
            _quickPicking = false
        }

        _charactersWhenPressed = keyboard.characterKeyCounter
        keyboard.shiftKeyPressed = pressed
        keyboard.updatePopper()
    }

    onClicked: {
        if (keyboard.characterKeyCounter > _charactersWhenPressed) {
            keyboard.shiftState = ShiftState.NoShift
        } else if (!_quickPicking) {
            keyboard.cycleShift()
        }
    }
}
