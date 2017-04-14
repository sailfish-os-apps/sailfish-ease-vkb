// Copyright (C) 2013 Jolla Ltd.
// Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>

import QtQuick 2.0

Column {
    width: parent ? parent.width : 0

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

    property bool isEase: true

    Component.onCompleted: updateSizes()
    onWidthChanged: updateSizes()
    onPortraitModeChanged: updateSizes()

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

        var i
        var child
        var maxButton = width

        for (i = 0; i < children.length; ++i) {
            child = children[i]
            child.width = width
            if (child.hasOwnProperty("followRowHeight") && child.followRowHeight) {
                child.height = width / 5
            }

            if (child.maximumBasicButtonWidth !== undefined) {
                maxButton = Math.min(child.maximumBasicButtonWidth(width), maxButton)
            }
        }

        for (i = 0; i < children.length; ++i) {
            child = children[i]

            if (child.relayout !== undefined) {
                child.relayout(maxButton)
            }
        }
    }
}
