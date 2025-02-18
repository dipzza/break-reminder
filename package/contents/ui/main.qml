import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.ksvg as KSVG
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root


    switchWidth: Kirigami.Units.gridUnit * 5
    switchHeight: Kirigami.Units.gridUnit * 5
    toolTipMainText: i18n("Break Reminder")
    toolTipSubText: "subtext"
    toolTipTextFormat: Text.PlainText
    icon: "klipper-symbolic"

    fullRepresentation:  Item {
        Layout.minimumWidth: label.implicitWidth
        Layout.minimumHeight: label.implicitHeight
        Layout.preferredWidth: 640 * PlasmaCore.Units.devicePixelRatio
        Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio

        PlasmaComponents.Label {
            id: label
            anchors.fill: parent
            text: "Hello World!"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}

