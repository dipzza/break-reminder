import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.ksvg as KSVG
import org.kde.kirigami as Kirigami
import org.kde.notification

PlasmoidItem {
    id: root

    
    readonly property var statusEnum: ({
        start: 0,
        focus: 1,
        break: 2,
    })

    property int focusSeconds: plasmoid.configuration.focusMinutes * 60
    property int breakSeconds: plasmoid.configuration.breakMinutes * 60
    property int remainingSeconds: focusSeconds
    property int status: statusEnum.start

    property string formattedRemainingSeconds: {
        var minutes = Math.floor(remainingSeconds / 60);
        var seconds = remainingSeconds % 60;
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    preferredRepresentation: root.compactRepresentation
    activationTogglesExpanded: false
    
    toolTipMainText: status == statusEnum.start ? "Stopped" : formattedRemainingSeconds
    toolTipSubText: {
        switch (status) {
            case statusEnum.start: return "Click to start focus session";
            case statusEnum.focus: return "Time to focus!";
            case statusEnum.break: return "Take a break :)";
        }
    }
    Plasmoid.icon: {
        switch (status) {
            case statusEnum.start: return Qt.resolvedUrl("../icons/start.svg");
            case statusEnum.focus: return Qt.resolvedUrl("../icons/in-focus.svg");
            case statusEnum.break: return "kteatime-symbolic";
        }
    }

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
            switch (status) {
                case statusEnum.focus: startBreak();
                case statusEnum.break: status = statusEnum.start;
            }
        }
    }

    Notifications {
        id: notificationManager
    }
    

    function startFocus() {
        status = statusEnum.focus
        remainingSeconds = focusSeconds
        timer.start()
    }

    function startBreak() {
        status = statusEnum.break
        remainingSeconds = breakSeconds
        timer.start()
        notificationManager.sendBreakNotification()
    }

    compactRepresentation: CompactRepresentation{}
    fullRepresentation: Item {}
}

