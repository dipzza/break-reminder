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

    property bool isOnBreak: false

    property int focusSeconds: plasmoid.configuration.focusMinutes * 60
    property int breakSeconds: plasmoid.configuration.breakMinutes * 60
    property int remainingSeconds: focusSeconds

    property string formattedRemainingSeconds: {
        var minutes = Math.floor(remainingSeconds / 60);
        var seconds = remainingSeconds % 60;
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    preferredRepresentation: root.compactRepresentation
    activationTogglesExpanded: false
    
    toolTipMainText: formattedRemainingSeconds
    toolTipSubText: isOnBreak ? "Take a break :)" : "Time to focus!"
    Plasmoid.icon: isOnBreak ? "kteatime-symbolic" : "alarm-symbolic"

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (remainingSeconds > 0) {
                remainingSeconds -= 1
                return
            }

            if (isOnBreak) {
                isOnBreak = false
                remainingSeconds = focusSeconds
            } else {
                isOnBreak = true
                remainingSeconds = breakSeconds

                breakNotification.text = tips[Math.floor(Math.random() * tips.length)]
                breakNotification.sendEvent()
            }
        }
    }

    Notification {
        id: breakNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        title: "Time to take a Break!"
        text: "Remember to stay hydrated."
        iconName: "kteatime-symbolic"
        urgency: Notification.HighUrgency
    }

    readonly property var tips: [
        "Relax your eyes, focus on distant objects for 20 seconds 👀",
        "Refresh yourself by drinking water 💧",
        "You deserve a healthy snack, eat a fruit or some nuts 🍎🥜",
        "Walk around and keep your body moving 🚶‍➡️",
        "Remember to maintain a good posture, sit up straight and relax your shoulders.",
        "Step outside for fresh air and sunlight ☀️",
        "Stretch your back, arms, and neck to release tension.",
        "Loosen up your wrists and fingers with gentle stretches 👋",
        "Close your eyes, take a deep breath, and relax 😌"
    ]

    compactRepresentation: CompactRepresentation{}
    fullRepresentation: Item {}
}

