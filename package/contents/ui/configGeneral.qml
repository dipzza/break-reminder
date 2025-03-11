import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_focusMinutes: focusMinutes.value

    QQC2.SpinBox {
        id: focusMinutes
        Kirigami.FormData.label: "Focus:"


        from: 1
        to: 1440
        
        textFromValue: function(value) {
            return i18n("%1 min", value)
        }
        valueFromText: function(text) {
            return parseInt(text) || from
        }
    }
}
