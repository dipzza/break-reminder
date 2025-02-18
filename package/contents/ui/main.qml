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
    property int workTime: 10 * 1000
    property int timeTillBreak: workTime
    property int breakTime: 10 * 1000
    property int timeTillWork: breakTime

    property string formattedTime: {
        var totalSeconds = Math.floor(timeTillBreak / 1000);
        var minutes = Math.floor(totalSeconds / 60);
        var seconds = totalSeconds % 60;
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    switchWidth: Kirigami.Units.gridUnit * 5
    switchHeight: Kirigami.Units.gridUnit * 5
    toolTipMainText: isOnBreak ? "Take a Break!" : "Focus Time"
    toolTipSubText: isOnBreak ? "Rest for at least 05:00" : "Next break in " + formattedTime
    toolTipTextFormat: Text.PlainText
    Plasmoid.icon: isOnBreak ? "kteatime-symbolic" : "alarm-symbolic"

    Timer {
        id: workTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (timeTillBreak > 0) {
                timeTillBreak -= 1000
            } else {
                root.isOnBreak = true
                workTimer.stop()
                breakNotification.sendEvent()

                timeTillWork = breakTime
                breakTimer.start()
            }
        }
    }

    Timer {
        id: breakTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            if (timeTillWork > 0) {
                timeTillWork -= 1000
            } else {
                root.isOnBreak = false
                breakTimer.stop()
                timeTillBreak = workTime
                workTimer.start()
            }
        }
    }

    Notification {
        id: breakNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        title: "Time to take a Break!"
        text: "Remember to stay hydrated."
        iconName: "kde"
        flags: Notification.Persistent
        urgency: Notification.HighUrgency
        onClosed: console.log("Notification closed.")
    }

    fullRepresentation:  Item {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        Layout.preferredWidth: 640
        Layout.preferredHeight: 480

        PlasmaComponents.Label {
            id: label
            anchors.fill: parent
            text: "Hello World!"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}

