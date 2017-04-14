/*
 * Copyright (C) 2012-2013 Jolla ltd and/or its subsidiary(-ies). All rights reserved.
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
import ".."
import Sailfish.Silica 1.0

KeyboardEaseLayout {
    KeyboardRow { 
        CharacterEaseKey {
            caption:        "a"; swipeCaption:        ["", "", "", "", "", "", "", "v"]; swipeSpecial: ["", "", "", "", "-", "", "", ""];
            captionShifted: "A"; swipeCaptionShifted: ["", "", "", "", "", "", "", "V"]; symView: "1"; symView2: caption }
        CharacterEaseKey {
            caption:        "n"; swipeCaption:        ["", "", "", "", "", "", "l", ""]; swipeSpecial: ["`", "^", "", "+", "!", "/", "", "\\"];
            captionShifted: "N"; swipeCaptionShifted: ["", "", "", "", "", "", "L", ""]; symView: "2"; symView2: caption }
        CharacterEaseKey {
            caption:        "i"; swipeCaption:        ["", "", "", "", "", "x", "", ""]; swipeSpecial: ["", "", "", "?", "", "", "=", "£"];
            captionShifted: "I"; swipeCaptionShifted: ["", "", "", "", "", "X", "", ""]; symView: "3"; symView2: caption }

        BackspaceKey {implicitWidth: symbol.width}
    }
    KeyboardRow { 
        CharacterEaseKey {
            caption:        "h"; swipeCaption:        ["", "", "", "", "k", "", "", ""]; swipeSpecial: ["{", "", "%", "(", "", "[", "", "_"];
            captionShifted: "H"; swipeCaptionShifted: ["", "", "", "", "K", "", "", ""]; symView: "4"; symView2: caption }
        CharacterEaseKey {
            caption:        "o"; swipeCaption:        ["q", "u", "p", "c", "b", "g", "d", "j"]; swipeSpecial: ["", "", "", "", "", "", "", ""];
            captionShifted: "O"; swipeCaptionShifted: ["Q", "U", "P", "C", "B", "G", "D", "J"]; symView: "5"; symView2: caption }
        CharacterEaseKey {
            caption:        "r"; swipeCaption:        ["", "", "", "m", "", "", "", ""]; swipeSpecial: ["|", "", "}", "", ")", "@", "", "]"];
            captionShifted: "R"; swipeCaptionShifted: ["", "", "", "M", "", "", "", ""]; symView: "6"; symView2: caption }

        ShiftKey {implicitWidth: symbol.width}
    }
    KeyboardRow { 
        CharacterEaseKey {
            caption:        "t"; swipeCaption:        ["", "", "y", "", "", "", "", ""]; swipeSpecial: ["~", "", "", "<", "*", "", "", ""];
            captionShifted: "T"; swipeCaptionShifted: ["", "", "Y", "", "", "", "", ""]; symView: "7"; symView2: caption }
        CharacterEaseKey {
            caption:        "e"; swipeCaption:        ["", "w", "", "", "z", "", "", ""]; swipeSpecial: ["\"", "", "'", "", "", ",", ".", ":"];
            captionShifted: "E"; swipeCaptionShifted: ["", "W", "", "", "Z", "", "", ""]; symView: "8"; symView2: caption }
        CharacterEaseKey {
            caption:        "s"; swipeCaption:        ["f", "", "", "", "", "", "", ""]; swipeSpecial: ["", "&", "", "#", ">", ";", "", ""];
            captionShifted: "S"; swipeCaptionShifted: ["F", "", "", "", "", "", "", ""]; symView: "9"; symView2: caption }

        SymbolKey {id: symbol}
    }

    SpacebarEaseRow {}
}
