import QtQuick
import org.kde.notification

Item {
    id: notificationManager

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

    Notification {
        id: breakNotification
        componentName: "plasma_workspace"
        eventId: "notification"
        title: "Time to take a Break!"
        text: "Remember to stay hydrated."
        iconName: "kteatime-symbolic"
        urgency: Notification.HighUrgency
    }

    function sendBreakNotification() {
        breakNotification.text = tips[Math.floor(Math.random() * tips.length)]
        breakNotification.sendEvent()
    }
}