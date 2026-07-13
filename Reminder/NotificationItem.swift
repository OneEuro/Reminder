import Cocoa
import UserNotifications

class NotificationItem: NSObject {
    private let content = UNMutableNotificationContent()
    var timerConfig: TimerConfiguration?

    init(title: String, body: String, sound: UNNotificationSound, categoryIdentifier: String) {
        super.init()
        self.content.title = title
        self.content.body = body
        self.content.sound = sound
        self.content.categoryIdentifier = categoryIdentifier

        UNUserNotificationCenter.current().delegate = self
    }

    static func createRequestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            }
        }
    }

    func configNotificationCenter() {
        let stopAction = UNNotificationAction(identifier: "stopAction", title: "Stop", options: [.foreground])
        let category = UNNotificationCategory(identifier: "reminderCategory", actions: [stopAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = "reminder-\(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: self.content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

extension NotificationItem: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "stopAction" {
            self.timerConfig?.invalidateTimers()
        }
        completionHandler()
    }
}
