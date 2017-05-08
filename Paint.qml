import QtQuick 2.6;

Item {
    onPathDataChanged: {
        lastUpdate = Date.now()
        if (toggle) {
            if (!imgBusy2) {
                pathDataCache1 = pathData;
                toggle = false;
            }
        }
        else {
            if (!imgBusy1) {
                pathDataCache2 = pathData;
                toggle = true;
            }
        }
    }

    Timer {
        interval: 50
        repeat: true
        running: true
        onTriggered: {
            var now = Date.now()
            if (now - lastUpdate > 100 && canErase) {
                paint.opacity -= 0.1
            } else {
                paint.opacity = baseOpacity
            }
            if (paint.opacity === 0){
                pathData = ""
                pathDataCache1 = ""
                pathDataCache2 = ""
                canErase = false
            }
        }
    }

    property real baseOpacity: 1
    property bool canErase: false
    property real lastUpdate: Date.now()
    property int    lineSize  : 2;
    property color  lineColor : "blue";

    property string pathData  : "";
    property string pathDataCache1 : "";
    property string pathDataCache2 : "";

    property bool toggle   : false;
    property bool imgBusy1 : false;
    property bool imgBusy2 : false;

    Repeater {
        model: 2;
        delegate: Image {
            source: 'data:image/svg+xml,<?xml version="1.0" encoding="utf-8"?><svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="%1" height="%2"><path d="%3" fill="none" stroke="%4" stroke-width="%5" /></svg>'.arg (width).arg (height).arg (parent ["pathDataCache" + num]).arg (lineColor).arg (lineSize);
            cache: false;
            mipmap: false;
            smooth: true;
            opacity: (toggle
                      ? (model.index ? 0 : 1)
                      : (model.index ? 1 : 0));
            fillMode: Image.Pad;
            antialiasing: true;
            asynchronous: false;
            anchors.fill: parent;
            onStatusChanged: { parent ["imgBusy" + num] = (status === Image.Loading); }

            readonly property string num : (model.index +1).toString ();
        }
    }
}
