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

Keyboard12PenLayout {
    letterCaptions:
    {
                "45-left":   ["n", "m", "f", "!"],
                "45-right":  ["o", "u", "v", "w"],
                "135-left":  ["e", "l", "k", "@"],
                "135-right": ["i", "h", "j", ","],
                "225-left":  ["t", "c", "z", "."],
                "225-right": ["s", "d", "g", "#"],
                "315-left":  ["y", "b", "p", "q"],
                "315-right": ["a", "r", "x", "?"]
    }
    numCaption:
    {
                "45-left":   ["5", "}", "'", ""],
                "45-right":  ["7", "]", "$", ""],
                "135-left":  ["6", "[", "~", "|"],
                "135-right": ["3", "^", "/", "*"],
                "225-left":  ["2", "`", "\\", "-"],
                "225-right": ["0", "8", "<", "£"],
                "315-left":  ["1", "9", ">", "+"],
                "315-right": ["4", "{", "\"", "="]
    }
    specialCaption:
    {
                "45-left":   ["^", "¨", "", ""],
                "45-right":  ["¸", "", "", ""],
                "135-left":  ["", "", "", ""],
                "135-right": ["", "", "", ""],
                "225-left":  ["", "", "", ""],
                "225-right": ["", "", "", ""],
                "315-left":  ["°", "~", "", ""],
                "315-right": ["´", "`", "", ""]
    }
}
