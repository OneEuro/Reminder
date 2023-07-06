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
    var remainingTime: TimeInterval = 0
    var timeInterval:TimeInterval = 0
    public var  reminderViewController :ReminderViewController?
    private  var notification:NotificationItem?
    
    
    public func updateTimeInterval(with:String)  {
        if let interval = TimeInterval(with) {
            timeInterval = interval
            remainingTime = timeInterval
            reminderViewController?.updateCountdownLabel(remainingTime: self.timeInterval)
        } else {
            print("Invalid time interval")
            return
        }
    }
    
    public func createNotification() {
         notification = NotificationItem(title: "Reminder", body: "It's time!", sound: .default, categoryIdentifier: "reminderCategory")
        guard notification != nil else {
            print("faild to init Notification")
            return
        }
        notification!.configNotificationCenter()
        notification!.timerConfig = self
       
    }
    
    public func createTimer()  {
        timer?.invalidate()
        self.remainingTime = self.timeInterval
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
           
//            self.reminderViewController?.updateCountdownLabel(remainingTime: self.timeInterval)
            self.createNotification()
        }
        
    }
    
    public func createCountdownTimer() {
        countdownTimer?.invalidate()
//        reminderViewController?.updateCountdownLabel(remainingTime: timeInterval + 1 )
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime < 1 {
                self.remainingTime = self.timeInterval
            }else {
                self.remainingTime -= 1
            }
          
                self.reminderViewController?.updateCountdownLabel(remainingTime: self.remainingTime)
            }
    }
    
}
