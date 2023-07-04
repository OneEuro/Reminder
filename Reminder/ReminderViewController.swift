//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa
import UserNotifications

class ReminderViewController: NSViewController {
    @IBOutlet weak var timeIntervalTextField: NSTextField!
    @IBOutlet weak var countdownLabel: NSTextField!
    var timer: Timer?
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }

    @IBAction func setReminder(_ sender: NSButton) {
        guard let timeInterval = TimeInterval(timeIntervalTextField.stringValue) else {
            print("Invalid time interval")
            return
        }
        
        remainingTime = timeInterval
        updateCountdownLabel()

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            self.remainingTime = timeInterval
            self.updateCountdownLabel()
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "It's time!"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "reminderCategory"
          
            
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
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.remainingTime -= 1
                self.updateCountdownLabel()
            }
    }
    
    func updateCountdownLabel() {
          let minutes = Int(remainingTime) / 60
          let seconds = Int(remainingTime) % 60
          countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
      }
    
}

extension ReminderViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "stopAction" {
            timer?.invalidate()
            countdownTimer?.invalidate()
        }
        print(countdownTimer?.isValid)
        completionHandler()
    }
}
