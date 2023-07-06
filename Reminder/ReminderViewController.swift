//
//  ReminderViewController.swift
//  Reminder
//
//  Created by Владимир Малышев on 03.07.2023.
//

import Cocoa
//import UserNotifications

class ReminderViewController: NSViewController {
    @IBOutlet weak var timeIntervalTextField: NSTextField!
    @IBOutlet weak var countdownLabel: NSTextField!
    
    let timerConfiguration = TimerConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationItem.createRequestAuthorization()
        timerConfiguration.reminderViewController = self

    }

    @IBAction func setReminder(_ sender: NSButton) {
        timerConfiguration.updateTimeInterval(with: timeIntervalTextField.stringValue)
        timerConfiguration.createTimer()
        timerConfiguration.createCountdownTimer()

    }
    
    func updateCountdownLabel(remainingTime:TimeInterval) {
          let minutes = Int(remainingTime) / 60
          let seconds = Int(remainingTime) % 60
          countdownLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
      }
    
}
    
