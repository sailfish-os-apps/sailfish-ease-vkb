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
    accentMap: {
        "´": {"e": "é", "E": "É", "a": "á", "A": "Á", "o": "ó", "O": "Ó", "i": "í", "I": "Í", "u": "ú", "U": "Ú", "y": "ý", "Y": "Ý"                   },
        "^": {"e": "ê", "E": "Ê", "a": "â", "A": "Â", "o": "ô", "O": "Ô", "i": "î", "I": "Î", "u": "û", "U": "Û"                                       },
        "¨": {"e": "ë", "E": "Ë", "a": "ä", "A": "Ä", "o": "ö", "O": "Ö", "i": "ï", "I": "Ï", "u": "ü", "U": "Ü", "y": "ÿ", "Y": "Ϋ"                   },
        "`": {"e": "è", "E": "È", "a": "à", "A": "À", "o": "ò", "O": "Ò", "i": "ì", "I": "Ì", "u": "ù", "U": "Ù"                                       },
        "°": {                    "a": "å", "A": "Å"                                                                                                   },
        "~": {                    "a": "ã", "A": "Ã", "o": "õ", "O": "Õ"                                                           , "n": "ñ", "N": "Ñ"},
        "¸": {"c": "ç", "C": "Ç"}
    }
    letterCaptions:
    {
                "0-left": ["h", "p", ".",],
                "0-right": ["u", "f", ",",],
                "60-left": ["v", "z", "?",],
                "60-right": ["i", "g", "!",],
                "120-left": ["o", "j", ";",],
                "120-right": ["e", "c", ":",],
                "180-left": ["s", "k", "q",],
                "180-right": ["t", "a", "x",],
                "240-left": ["n", "l", "£",],
                "240-right": ["m", "y", "(",],
                "300-left": ["r", "b", ")",],
                "300-right": ["d", "w", "&",]
            }
    numCaption:
    {
                "0-left": ["a", "m", "y",],
                "0-right": ["b", "n", "z"],
                "60-left": ["c", "o", "."],
                "60-right": ["d", "p", "?"],
                "120-left": ["e", "q", "!"],
                "120-right": ["f", "r", ","],
                "180-left": ["g", "s", ";",],
                "180-right": ["h", "t", ":"],
                "240-left": ["i", "u", "'"],
                "240-right": ["j", "v", "("],
                "300-left": ["k", "w", ")"],
                "300-right": ["l", "x", "$"]
            }
    specialCaption:
    {
                "0-left": ["a", "m", "y",],
                "0-right": ["b", "n", "z"],
                "60-left": ["c", "o", "."],
                "60-right": ["d", "p", "?"],
                "120-left": ["e", "q", "!"],
                "120-right": ["f", "r", ","],
                "180-left": ["g", "s", ";",],
                "180-right": ["h", "t", ":"],
                "240-left": ["i", "u", "'"],
                "240-right": ["j", "v", "("],
                "300-left": ["k", "w", ")"],
                "300-right": ["l", "x", "$"]
            }
}