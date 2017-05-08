/*
 * Copyright (C) 2012-2013 Jolla ltd and/or its subsidiary(-ies). All rights reserved.
 *
 * Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *l'orario 
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Jolla Ltd nor the names of its contributors may be
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

KeyboardEaseLayout {
    id: mylay
    splitSupported: true
    useTopItem: !mylay.isLandscape
    height: portraitMode ? width * .75 : width * .32
    accentMap: {
        "´": {"e": "é", "E": "É", "a": "á", "A": "Á", "o": "ó", "O": "Ó", "i": "í", "I": "Í", "u": "ú", "U": "Ú", "y": "ý", "Y": "Ý"                   },
        "^": {"e": "ê", "E": "Ê", "a": "â", "A": "Â", "o": "ô", "O": "Ô", "i": "î", "I": "Î", "u": "û", "U": "Û"                                       },
        "¨": {"e": "ë", "E": "Ë", "a": "ä", "A": "Ä", "o": "ö", "O": "Ö", "i": "ï", "I": "Ï", "u": "ü", "U": "Ü", "y": "ÿ", "Y": "Ϋ"                   },
        "`": {"e": "è", "E": "È", "a": "à", "A": "À", "o": "ò", "O": "Ò", "i": "ì", "I": "Ì", "u": "ù", "U": "Ù"                                       },
        "°": {                    "a": "å", "A": "Å"                                                                                                   },
        "~": {                    "a": "ã", "A": "Ã", "o": "õ", "O": "Õ"                                                           , "n": "ñ", "N": "Ñ"},
        "¸": {"c": "ç", "C": "Ç"}
    }

    property var easeLayout: ({})

    KeyboardRow {
        splitIndex: 3

        CharacterEaseKey { keyValue: easeLayout["topLeft"] }
        CharacterEaseKey { keyValue: easeLayout["top"] }
        CharacterEaseKey { keyValue: easeLayout["topRight"] }

        BackspaceKey { implicitWidth: symbol.width; active: !mylay.isLandscape }
        KeyBase {
            implicitWidth: symbol.width * 3
            active: mylay.isLandscape
            clip: true

            Loader {
                id: topItem
                sourceComponent: mylay.isLandscape && keyboard.inputHandler ? keyboard.inputHandler.topItem : null
                anchors.fill: parent
                anchors.leftMargin: symbol.width / 2
            }
        }


    }

    KeyboardRow {
        splitIndex: 3

        CharacterEaseKey { keyValue: easeLayout["left"] }
        CharacterEaseKey { keyValue: easeLayout["center"] }
        CharacterEaseKey { keyValue: easeLayout["right"] }

        SpecialEaseKey { active: mylay.isLandscape}
        ShiftEaseKey { implicitWidth: symbol.width;  active: !mylay.isLandscape }
        SymbolKey    { active: mylay.isLandscape}
        BackspaceKey { implicitWidth: symbol.width; active: mylay.isLandscape }
    }

    KeyboardRow {
        splitIndex: 3


        CharacterEaseKey { keyValue: easeLayout["bottomLeft"] }
        CharacterEaseKey { keyValue: easeLayout["bottom"] }
        CharacterEaseKey { keyValue: easeLayout["bottomRight"] }

        SymbolKey {
            id: symbol
            active: !mylay.isLandscape
        }
        ShiftEaseKey { active: mylay.isLandscape && !splitActive}
        SpacebarKey  { active: mylay.isLandscape }
        FunctionKey { // copied  EnterKey: i don't know why but it doesn't like as an element
                  active: mylay.isLandscape
                  icon.source: MInputMethodQuick.actionKeyOverride.icon
                  caption:  MInputMethodQuick.actionKeyOverride.label
                  key: Qt.Key_Return
                  implicitWidth: symbol.width
                  enabled: MInputMethodQuick.actionKeyOverride.enabled
                  background.opacity: pressed ? 0.6 : MInputMethodQuick.actionKeyOverride.highlighted ? 0.4 : 0.17
        }
    } 
    SpacebarEaseRow {visible: portraitMode ? true : false}
}
