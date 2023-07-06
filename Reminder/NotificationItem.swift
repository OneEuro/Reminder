//
//  Notification.swift
//  Reminder
//
//  Created by Владимир Малышев on 06.07.2023.
//

import Cocoa
import UserNotifications

class NotificationItem:NSObject {
    let content =  UNMutableNotificationContent()
    public var timerConfig:TimerConfiguration?
    
    init(title:String,body:String,sound:UNNotificationSound,categoryIdentifier:String) {
        super.init()
        self.content.title = title
        self.content.body = body
        self.content.sound = sound
        self.content.categoryIdentifier = categoryIdentifier
        
        UNUserNotificationCenter.current().delegate = self
        print("Notification \(self) is inited")
    }
    
    deinit {
        print("Notification \(self) is deinited")
    }
    
    static func createRequestAuthorization () {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
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

extension NotificationItem:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let timer = timerConfig,response.actionIdentifier == "stopAction" {
            timer.timer?.invalidate()
            timer.countdownTimer?.invalidate()
        }
//        print("coutdowntimer = ",timer.countdownTimer?.isValid)
        completionHandler()
//        let actionIdentifier = response.actionIdentifier
//
//           switch actionIdentifier {
//           case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
//               // Do something
//               completionHandler()
//               print("notif dismissed")
//           case UNNotificationDefaultActionIdentifier: // App was opened from notification
//               // Do something
//               completionHandler()
//               print("notif open app")
//           default:
//               completionHandler()
//           }
    }
    
    
}

