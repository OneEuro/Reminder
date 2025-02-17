//
//  TimerConfiguration.swift
//  Reminder
//
//  Created by Владимир Малышев on 06.07.2023.
//

import Cocoa


class TimerConfiguration: NSObject {
    var timer: Timer?
    var countdownTimer: Timer?
    private var remainingTime: TimeInterval = 0
    private var timeInterval: TimeInterval = 0
    private var notificationItem: NotificationItem?
    public var  reminderViewController: ReminderViewController?
    
    
    public func updateTimeInterval(with:String)  {
        if let interval = TimeInterval(with) {
            timeInterval = interval
            remainingTime = timeInterval
//            reminderViewController?.updateCountdownLabel(remainingTime: self.timeInterval)
        } else {
            print("Invalid time interval")
            return
        }
    }
    
    public func createNotification() {
        notificationItem = NotificationItem(title: "Reminder", body: "It's time!", sound: .default, categoryIdentifier: "reminderCategory")
        guard let notification = notificationItem else {
            print("faild to init Notification")
            return
        }
        notification.configNotificationCenter()
        notification.timerConfig = self
       
    }
    
    public func createTimer()  {
        timer?.invalidate()
        timer = nil
        self.remainingTime = self.timeInterval
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            self.createNotification()
        }
    }
    
    public func createCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            if let remainingTime = self?.remainingTime, let timeInterval = self?.timeInterval {
                if remainingTime < 1 {
                    self?.remainingTime = timeInterval
                    self?.reminderViewController?.updateCountdownLabel(remainingTime: timeInterval)
                } else {
                    self?.reminderViewController?.updateCountdownLabel(remainingTime: remainingTime)

                }
            }
            self?.remainingTime -= 1
            }
    }
    
}
