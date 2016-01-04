import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0

MouseArea {
    id: button

    property bool down: pressed && containsMouse && !DragFilter.canceled
    property bool _showPress: down || pressTimer.running
    property color color: Theme.primaryColor
    property color highlightColor: Theme.highlightColor
    property color highlightBackgroundColor: Theme.highlightBackgroundColor
    property real preferredWidth: Theme.buttonWidthSmall
    property var button_size: Theme.itemSizeExtraSmall

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
    }
    onCanceled: {
        button.DragFilter.end()
        pressTimer.stop()
    }
    onPressed: button.DragFilter.begin(mouse.x, mouse.y)
    onPreventStealingChanged: if (preventStealing) button.DragFilter.end()

    height: button_size
    width: button_size
    implicitWidth: button_size

    Rectangle {
        height: button_size
        width: button_size
        radius: button_size/2
        color: _showPress ? Theme.rgba(button.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                          : Theme.rgba(button.color, 0.2)

        opacity: button.enabled ? 1.0 : 0.4

        Image {
            source: "image://theme/icon-close-vkb"
            anchors.centerIn: parent
            width: 32
            height: 32
        }
    }

    Timer {
        id: pressTimer
        interval: 64
    }
}
