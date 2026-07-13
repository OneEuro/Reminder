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

    deinit {
    }

    static func createRequestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            }
        }
    }

    func configNotificationCenter() {
        let stopAction = UNNotificationAction(identifier: "stopAction", title: "Stop", options: [])
        let category = UNNotificationCategory(identifier: "reminderCategory", actions: [stopAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

}

protocol TimerHandleDelegate: AnyObject {

}

extension NotificationItem: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "stopAction" {
            timerConfig?.invalidateTimers()
        }
        completionHandler()
    }
}
