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

KeyboardLoopenLayout {
    letterCaptions:
    {
                "0-left":    ["h", "p", "."],
                "0-right":   ["u", "f", ","],
                "60-left":   ["v", "z", "?"],
                "60-right":  ["i", "g", "!"],
                "120-left":  ["o", "j", ";"],
                "120-right": ["e", "c", ":"],
                "180-left":  ["s", "k", "q"],
                "180-right": ["t", "a", "x"],
                "240-left":  ["n", "l", "£"],
                "240-right": ["m", "y", "("],
                "300-left":  ["r", "b", ")"],
                "300-right": ["d", "w", "&"]
            }
    numCaption:
    {
                "0-left":    ["4", "^", "§"],
                "0-right":   ["5", "é", ""],
                "60-left":   ["6", "/", "°"],
                "60-right":  ["7", "$", "£"],
                "120-left":  ["8", "=", "%"],
                "120-right": ["9", "*", "&"],
                "180-left":  [">", "}", "]"],
                "180-right": ["<", "{", "["],
                "240-left":  ["0", "+", "<"],
                "240-right": ["1", "-", "_"],
                "300-left":  ["2", "*", "#"],
                "300-right": ["3", "/", "\\"]
            }
    specialCaption:
    {
                "0-left":    ["a", "m", "y"],
                "0-right":   ["b", "n", "z"],
                "60-left":   ["c", "o", "."],
                "60-right":  ["d", "p", "?"],
                "120-left":  ["e", "q", "!"],
                "120-right": ["f", "r", ","],
                "180-left":  ["g", "s", ";"],
                "180-right": ["h", "t", ":"],
                "240-left":  ["i", "u", "'"],
                "240-right": ["j", "v", "("],
                "300-left":  ["k", "w", ")"],
                "300-right": ["l", "x", "$"]
            }
}
