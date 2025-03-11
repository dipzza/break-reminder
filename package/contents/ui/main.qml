import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.ksvg as KSVG
import org.kde.kirigami as Kirigami
import org.kde.notification

PlasmoidItem {
    id: root

    property bool isOnBreak: true
    property int focusSeconds: plasmoid.configuration.focusMinutes * 60
    property int remainingSeconds: focusSeconds
    

    property string formattedRemainingSeconds: {
        var minutes = Math.floor(remainingSeconds / 60);
        var seconds = remainingSeconds % 60;
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    preferredRepresentation: root.compactRepresentation
    activationTogglesExpanded: false

    toolTipMainText: isOnBreak ? "On break :)" : formattedRemainingSeconds
    toolTipSubText: isOnBreak ? "Click to start a focus session" : "Time to focus!"
    Plasmoid.icon: isOnBreak ? Qt.resolvedUrl("../icons/break.svg") : Qt.resolvedUrl("../icons/in-focus.svg")

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            if (remainingSeconds > 0) {
                remainingSeconds -= 1
                return
            }

            timer.stop()
            if (!isOnBreak) {
                startBreak()
            }
        }
    }

    Notifications {
        id: notificationManager
    }
    

    function startFocus() {
        isOnBreak = false
        remainingSeconds = focusSeconds
        timer.start()
    }

    function startBreak() {
        isOnBreak = true
        notificationManager.sendBreakNotification()
    }

    function reset() {
        timer.stop()
        isOnBreak = true
    }

    compactRepresentation: CompactRepresentation{}
    fullRepresentation: Item {}
}

